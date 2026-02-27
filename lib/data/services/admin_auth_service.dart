import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Admin authentication service with PIN-based access and rate limiting
/// PIN is read from environment or defaults to 4848
class AdminAuthService {
  static const String _adminBoxName = 'admin_box';
  static const String _sessionKey = 'admin_session';
  static const String _attemptsKey = 'login_attempts';
  static const String _lockoutKey = 'lockout_until';
  static const String _lastAttemptKey = 'last_attempt';

  // Security constants
  static const int maxAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const Duration sessionDuration = Duration(hours: 24);
  static const Duration attemptResetWindow = Duration(minutes: 5);

  // PIN from compile-time environment only — no hardcoded default
  static const String _envPin = String.fromEnvironment('ADMIN_PIN');

  static Box? _adminBox;

  /// Initialize admin storage (skipped on web to prevent white screen)
  static Future<void> initialize() async {
    // Skip on web - Hive's IndexedDB can hang and cause white screen
    if (kIsWeb) {
      if (kDebugMode) {
        debugPrint('AdminAuthService: Skipping on web');
      }
      return;
    }
    try {
      _adminBox = await Hive.openBox(_adminBoxName);
    } catch (e) {
      if (kDebugMode) debugPrint('AdminAuthService init error: $e');
    }
  }

  /// Whether admin access is available (requires ADMIN_PIN at compile time)
  static bool get isAvailable => _envPin.isNotEmpty;

  /// Get PIN — empty string when not configured (admin disabled)
  static String get _pin => _envPin;

  /// Hash PIN for secure comparison
  static String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    return sha256.convert(bytes).toString();
  }

  /// Check if currently locked out
  static bool get isLockedOut {
    final box = _adminBox;
    if (box == null) return false;

    final lockoutUntil = box.get(_lockoutKey) as int?;
    if (lockoutUntil == null) return false;

    final lockoutTime = DateTime.fromMillisecondsSinceEpoch(lockoutUntil);
    return DateTime.now().isBefore(lockoutTime);
  }

  /// Get remaining lockout time
  static Duration get remainingLockoutTime {
    final box = _adminBox;
    if (box == null) return Duration.zero;

    final lockoutUntil = box.get(_lockoutKey) as int?;
    if (lockoutUntil == null) return Duration.zero;

    final lockoutTime = DateTime.fromMillisecondsSinceEpoch(lockoutUntil);
    final remaining = lockoutTime.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Get current attempt count
  static int get attemptCount {
    final box = _adminBox;
    if (box == null) return 0;

    // Reset attempts if outside the window
    final lastAttempt = box.get(_lastAttemptKey) as int?;
    if (lastAttempt != null) {
      final lastAttemptTime = DateTime.fromMillisecondsSinceEpoch(lastAttempt);
      if (DateTime.now().difference(lastAttemptTime) > attemptResetWindow) {
        box.put(_attemptsKey, 0);
        return 0;
      }
    }

    return box.get(_attemptsKey, defaultValue: 0) as int? ?? 0;
  }

  /// Remaining attempts before lockout
  static int get remainingAttempts => maxAttempts - attemptCount;

  /// Verify PIN and return session token
  static Future<AdminAuthResult> verifyPin(String enteredPin) async {
    if (!isAvailable) {
      return AdminAuthResult.error('Admin access not configured');
    }
    final box = _adminBox;
    if (box == null) {
      return AdminAuthResult.error('Admin service not initialized');
    }

    // Check lockout
    if (isLockedOut) {
      final remaining = remainingLockoutTime;
      return AdminAuthResult.lockedOut(
        'Please wait ${remaining.inMinutes} minutes before trying again.',
      );
    }

    // Update attempt tracking
    final currentAttempts = attemptCount + 1;
    await box.put(_attemptsKey, currentAttempts);
    await box.put(_lastAttemptKey, DateTime.now().millisecondsSinceEpoch);

    // Verify PIN
    if (enteredPin == _pin) {
      // Success - reset attempts and create session
      await box.put(_attemptsKey, 0);
      await box.delete(_lockoutKey);

      final sessionToken = _generateSessionToken();
      final expiresAt = DateTime.now().add(sessionDuration);

      await box.put(
        _sessionKey,
        jsonEncode({
          'token': sessionToken,
          'expiresAt': expiresAt.millisecondsSinceEpoch,
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        }),
      );

      return AdminAuthResult.success(sessionToken);
    }

    // Failed attempt
    if (currentAttempts >= maxAttempts) {
      // Trigger lockout
      final lockoutUntil = DateTime.now().add(lockoutDuration);
      await box.put(_lockoutKey, lockoutUntil.millisecondsSinceEpoch);
      return AdminAuthResult.lockedOut(
        'Account locked for ${lockoutDuration.inMinutes} minutes.',
      );
    }

    return AdminAuthResult.invalid(
      'Incorrect PIN. ${maxAttempts - currentAttempts} attempts remaining.',
    );
  }

  /// Check if current session is valid
  static bool get isAuthenticated {
    final box = _adminBox;
    if (box == null) return false;

    final sessionJson = box.get(_sessionKey) as String?;
    if (sessionJson == null) return false;

    try {
      final session = jsonDecode(sessionJson) as Map<String, dynamic>;
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
        session['expiresAt'] as int,
      );
      return DateTime.now().isBefore(expiresAt);
    } catch (e) {
      if (kDebugMode) debugPrint('AdminAuth: session check error: $e');
      return false;
    }
  }

  /// Get current session info
  static AdminSession? get currentSession {
    final box = _adminBox;
    if (box == null) return null;

    final sessionJson = box.get(_sessionKey) as String?;
    if (sessionJson == null) return null;

    try {
      final session = jsonDecode(sessionJson) as Map<String, dynamic>;
      return AdminSession.fromJson(session);
    } catch (e) {
      if (kDebugMode) debugPrint('AdminAuth: decode session error: $e');
      return null;
    }
  }

  /// Logout and clear session
  static Future<void> logout() async {
    final box = _adminBox;
    if (box == null) return;
    await box.delete(_sessionKey);
  }

  /// Generate secure session token
  static String _generateSessionToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch;
    final raw = '$timestamp-$random-admin';
    return _hashPin(raw).substring(0, 32);
  }

  /// Clear all admin data (for testing/reset)
  static Future<void> clearAll() async {
    final box = _adminBox;
    if (box == null) return;
    await box.clear();
  }
}

/// Result of authentication attempt
class AdminAuthResult {
  final bool success;
  final String? token;
  final String? error;
  final bool lockedOut;

  AdminAuthResult._({
    required this.success,
    this.token,
    this.error,
    this.lockedOut = false,
  });

  factory AdminAuthResult.success(String token) =>
      AdminAuthResult._(success: true, token: token);

  factory AdminAuthResult.invalid(String error) =>
      AdminAuthResult._(success: false, error: error);

  factory AdminAuthResult.lockedOut(String error) =>
      AdminAuthResult._(success: false, error: error, lockedOut: true);

  factory AdminAuthResult.error(String error) =>
      AdminAuthResult._(success: false, error: error);
}

/// Admin session data
class AdminSession {
  final String token;
  final DateTime expiresAt;
  final DateTime createdAt;

  AdminSession({
    required this.token,
    required this.expiresAt,
    required this.createdAt,
  });

  factory AdminSession.fromJson(Map<String, dynamic> json) => AdminSession(
    token: json['token'] as String? ?? '',
    expiresAt: DateTime.fromMillisecondsSinceEpoch(
      json['expiresAt'] as int? ?? 0,
    ),
    createdAt: DateTime.fromMillisecondsSinceEpoch(
      json['createdAt'] as int? ?? 0,
    ),
  );

  bool get isValid => DateTime.now().isBefore(expiresAt);

  Duration get remainingTime {
    final remaining = expiresAt.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
}
