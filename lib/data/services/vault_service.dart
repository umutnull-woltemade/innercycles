// ════════════════════════════════════════════════════════════════════════════
// VAULT SERVICE - Private Content Management (PIN + Biometric)
// ════════════════════════════════════════════════════════════════════════════
// Manages: PIN setup/verification, biometric auth, private photo album,
// and tracks which journal entries / notes are marked private.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import '../models/vault_photo.dart';
import '../providers/app_providers.dart';

class VaultService {
  // Secure storage keys (Keychain on iOS, Keystore on Android)
  static const String _pinHashKey = 'inner_cycles_vault_pin_hash';
  static const String _pinSaltKey = 'inner_cycles_vault_pin_salt';
  static const String _pinVersionKey = 'inner_cycles_vault_pin_version';
  // SharedPreferences keys (non-sensitive)
  static const String _vaultEnabledKey = 'inner_cycles_vault_enabled';
  static const String _biometricEnabledKey = 'inner_cycles_vault_biometric';
  static const String _photosKey = 'inner_cycles_vault_photos';
  static const _uuid = Uuid();

  /// PBKDF2 parameters
  static const int _pbkdf2Iterations = 100000;
  static const int _saltLength = 32;
  static const int _pinVersion = 2; // v1 = SHA-256, v2 = PBKDF2

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth = LocalAuthentication();
  List<VaultPhoto> _photos = [];

  VaultService._(this._prefs, this._secureStorage) {
    _loadPhotos();
  }

  static Future<VaultService> init() async {
    final prefs = await SharedPreferences.getInstance();
    const secureStorage = FlutterSecureStorage(
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    final service = VaultService._(prefs, secureStorage);
    // Migrate legacy PIN from SharedPreferences to secure storage
    await service._migrateLegacyPin();
    return service;
  }

  /// One-time migration: move PIN hash/salt from SharedPreferences to secure storage
  Future<void> _migrateLegacyPin() async {
    final legacyHash = _prefs.getString(_pinHashKey);
    if (legacyHash == null) return; // No legacy data or already migrated

    final legacySalt = _prefs.getString(_pinSaltKey);

    // Copy to secure storage
    await _secureStorage.write(key: _pinHashKey, value: legacyHash);
    if (legacySalt != null) {
      await _secureStorage.write(key: _pinSaltKey, value: legacySalt);
    }
    // Mark as v1 (will be upgraded to v2 on next successful verify)
    await _secureStorage.write(key: _pinVersionKey, value: '1');

    // Remove from SharedPreferences
    await _prefs.remove(_pinHashKey);
    await _prefs.remove(_pinSaltKey);

    if (kDebugMode) {
      debugPrint('VaultService: Migrated PIN from SharedPreferences to secure storage');
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PIN MANAGEMENT
  // ══════════════════════════════════════════════════════════════════════════

  // Cache vault setup state (avoids async check on hot path)
  bool? _isSetUpCache;

  /// Whether the vault has been set up (PIN exists)
  /// Uses cached value after first async check
  bool get isVaultSetUp => _isSetUpCache ?? _prefs.getBool(_vaultEnabledKey) ?? false;

  /// Async check for vault setup (reads from secure storage)
  Future<bool> checkVaultSetUp() async {
    final hash = await _secureStorage.read(key: _pinHashKey);
    _isSetUpCache = hash != null;
    return _isSetUpCache!;
  }

  /// Whether vault is enabled
  bool get isVaultEnabled => _prefs.getBool(_vaultEnabledKey) ?? false;

  /// Whether biometric unlock is enabled for vault
  bool get isBiometricEnabled => _prefs.getBool(_biometricEnabledKey) ?? false;

  /// Generate a cryptographically secure random salt
  String _generateSalt() {
    final random = Random.secure();
    final saltBytes = Uint8List(_saltLength);
    for (int i = 0; i < _saltLength; i++) {
      saltBytes[i] = random.nextInt(256);
    }
    return base64Url.encode(saltBytes);
  }

  /// PBKDF2-HMAC-SHA256 key derivation
  String _pbkdf2Hash(String pin, String salt) {
    final pinBytes = utf8.encode(pin);
    final saltBytes = utf8.encode(salt);

    // PBKDF2 with HMAC-SHA256
    var block = Hmac(sha256, pinBytes).convert(saltBytes + [0, 0, 0, 1]).bytes;
    var result = List<int>.from(block);

    for (int i = 1; i < _pbkdf2Iterations; i++) {
      block = Hmac(sha256, pinBytes).convert(block).bytes;
      for (int j = 0; j < result.length; j++) {
        result[j] ^= block[j];
      }
    }

    return base64Url.encode(result);
  }

  /// Legacy SHA-256 hash (for migration only)
  String _legacyHashPin(String pin, String salt) {
    final bytes = utf8.encode(salt + pin);
    return sha256.convert(bytes).toString();
  }

  /// Set up the vault PIN (first time or change) — uses PBKDF2
  Future<void> setPin(String pin) async {
    final salt = _generateSalt();
    final hash = _pbkdf2Hash(pin, salt);
    await _secureStorage.write(key: _pinSaltKey, value: salt);
    await _secureStorage.write(key: _pinHashKey, value: hash);
    await _secureStorage.write(key: _pinVersionKey, value: _pinVersion.toString());
    await _prefs.setBool(_vaultEnabledKey, true);
    _isSetUpCache = true;
  }

  // Brute-force protection
  static const String _attemptCountKey = 'inner_cycles_vault_attempts';
  static const String _lockoutUntilKey = 'inner_cycles_vault_lockout';
  static const int _maxAttempts = 5;
  static const Duration _lockoutDuration = Duration(minutes: 15);

  /// Whether vault is currently locked out due to failed attempts
  bool get isLockedOut {
    final lockoutMs = _prefs.getInt(_lockoutUntilKey);
    if (lockoutMs == null) return false;
    return DateTime.now().isBefore(
      DateTime.fromMillisecondsSinceEpoch(lockoutMs),
    );
  }

  /// Remaining lockout duration
  Duration get remainingLockoutTime {
    final lockoutMs = _prefs.getInt(_lockoutUntilKey);
    if (lockoutMs == null) return Duration.zero;
    final remaining = DateTime.fromMillisecondsSinceEpoch(lockoutMs)
        .difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Verify a PIN against the stored hash (with brute-force protection)
  /// Now async because it reads from secure storage
  Future<bool> verifyPin(String pin) async {
    if (isLockedOut) return false;

    final storedHash = await _secureStorage.read(key: _pinHashKey);
    final storedSalt = await _secureStorage.read(key: _pinSaltKey);
    final versionStr = await _secureStorage.read(key: _pinVersionKey);
    final version = int.tryParse(versionStr ?? '') ?? 1;

    if (storedHash == null) return false;

    // Compute hash based on version
    String hash;
    if (version >= 2) {
      // PBKDF2 (current)
      hash = _pbkdf2Hash(pin, storedSalt ?? '');
    } else if (storedSalt != null) {
      // v1: SHA-256 with salt
      hash = _legacyHashPin(pin, storedSalt);
    } else {
      // v0: SHA-256 without salt (very old)
      hash = sha256.convert(utf8.encode(pin)).toString();
    }

    if (hash == storedHash) {
      // Success — reset attempts
      _prefs.remove(_attemptCountKey);
      _prefs.remove(_lockoutUntilKey);
      // Auto-upgrade to PBKDF2 if on older version
      if (version < _pinVersion) {
        await setPin(pin);
        if (kDebugMode) debugPrint('VaultService: PIN upgraded to PBKDF2 v$_pinVersion');
      }
      return true;
    }

    // Failed — increment attempts
    final attempts = (_prefs.getInt(_attemptCountKey) ?? 0) + 1;
    _prefs.setInt(_attemptCountKey, attempts);
    if (attempts >= _maxAttempts) {
      final lockoutUntil = DateTime.now().add(_lockoutDuration);
      _prefs.setInt(_lockoutUntilKey, lockoutUntil.millisecondsSinceEpoch);
      _prefs.setInt(_attemptCountKey, 0);
    }
    return false;
  }

  /// Remaining failed attempts before lockout
  int get remainingAttempts {
    if (isLockedOut) return 0;
    return _maxAttempts - (_prefs.getInt(_attemptCountKey) ?? 0);
  }

  /// Change PIN (requires old PIN verification)
  Future<bool> changePin(String oldPin, String newPin) async {
    if (!await verifyPin(oldPin)) return false;
    await setPin(newPin);
    return true;
  }

  /// Remove vault PIN and disable vault
  Future<void> removeVault() async {
    await _secureStorage.delete(key: _pinHashKey);
    await _secureStorage.delete(key: _pinSaltKey);
    await _secureStorage.delete(key: _pinVersionKey);
    await _prefs.setBool(_vaultEnabledKey, false);
    await _prefs.setBool(_biometricEnabledKey, false);
    _isSetUpCache = false;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BIOMETRIC AUTH
  // ══════════════════════════════════════════════════════════════════════════

  /// Enable/disable biometric for vault
  Future<void> setBiometricEnabled(bool enabled) async {
    await _prefs.setBool(_biometricEnabledKey, enabled);
  }

  /// Check if device supports biometrics
  Future<bool> canUseBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      return canCheck && isSupported;
    } on PlatformException {
      return false;
    }
  }

  /// Attempt biometric authentication
  Future<bool> authenticateWithBiometrics({
    String reason = 'Authenticate to access your private vault',
    String reasonTr = 'Gizli kasana erismek icin kimligini dogrula',
    AppLanguage language = AppLanguage.en,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: language == AppLanguage.en ? reason : reasonTr,
        persistAcrossBackgrounding: true,
        biometricOnly: false,
      );
    } on PlatformException {
      return false;
    }
  }

  /// Full vault unlock flow: biometric first if enabled, then PIN fallback
  /// Returns true if biometric succeeded, false if PIN input needed
  Future<bool> tryBiometricUnlock({AppLanguage language = AppLanguage.en}) async {
    if (!isVaultSetUp) return false;
    if (!isBiometricEnabled) return false;

    final canBio = await canUseBiometrics();
    if (!canBio) return false;

    return authenticateWithBiometrics(language: language);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PRIVATE PHOTO ALBUM
  // ══════════════════════════════════════════════════════════════════════════

  /// Get all vault photos sorted by date descending
  List<VaultPhoto> getAllPhotos() {
    final sorted = List<VaultPhoto>.from(_photos)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(sorted);
  }

  int get photoCount => _photos.length;

  /// Add a photo to the vault (copies file to secure directory)
  Future<VaultPhoto> addPhoto({
    required String sourcePath,
    String? caption,
  }) async {
    // Copy to vault directory
    final appDir = await getApplicationSupportDirectory();
    final vaultDir = Directory('${appDir.path}/vault_photos');
    if (!await vaultDir.exists()) {
      await vaultDir.create(recursive: true);
    }
    final ext = p.extension(sourcePath);
    final savedPath =
        '${vaultDir.path}/${DateTime.now().millisecondsSinceEpoch}$ext';
    await File(sourcePath).copy(savedPath);

    final photo = VaultPhoto(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      filePath: savedPath,
      caption: caption,
    );

    _photos.add(photo);
    await _persistPhotos();
    return photo;
  }

  /// Update photo caption
  Future<void> updatePhotoCaption(String photoId, String? caption) async {
    final idx = _photos.indexWhere((p) => p.id == photoId);
    if (idx >= 0) {
      _photos[idx] = _photos[idx].copyWith(caption: caption);
      await _persistPhotos();
    }
  }

  /// Delete a photo from vault
  Future<void> deletePhoto(String photoId) async {
    final idx = _photos.indexWhere((p) => p.id == photoId);
    if (idx >= 0) {
      // Delete physical file
      try {
        final file = File(_photos[idx].filePath);
        if (await file.exists()) await file.delete();
      } catch (e) {
        if (kDebugMode) debugPrint('VaultService: Failed to delete photo file: $e');
      }
      _photos.removeAt(idx);
      await _persistPhotos();
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadPhotos() {
    final jsonString = _prefs.getString(_photosKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _photos = jsonList.map((j) => VaultPhoto.fromJson(j)).toList();
      } catch (e) {
        if (kDebugMode) debugPrint('VaultService._loadPhotos: JSON decode failed: $e');
        _photos = [];
      }
    }
  }

  Future<void> _persistPhotos() async {
    final jsonList = _photos.map((p) => p.toJson()).toList();
    await _prefs.setString(_photosKey, json.encode(jsonList));
  }

  Future<void> clearAll() async {
    // Delete all vault photo files
    for (final photo in _photos) {
      try {
        final file = File(photo.filePath);
        if (await file.exists()) await file.delete();
      } catch (e) {
        if (kDebugMode) debugPrint('VaultService: Failed to delete photo file: $e');
      }
    }
    _photos.clear();
    await _prefs.remove(_photosKey);
    await removeVault();
  }
}
