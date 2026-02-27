import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb, debugPrint;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// User information - common for all auth methods
class AuthUserInfo {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final AuthProvider provider;

  AuthUserInfo({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.provider,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'provider': provider.name,
  };

  factory AuthUserInfo.fromSupabaseUser(User user, AuthProvider provider) {
    return AuthUserInfo(
      uid: user.id,
      email: user.email,
      displayName:
          user.userMetadata?['full_name'] as String? ??
          user.userMetadata?['name'] as String?,
      photoUrl:
          user.userMetadata?['avatar_url'] as String? ??
          user.userMetadata?['picture'] as String?,
      provider: provider,
    );
  }
}

enum AuthProvider { apple, email }

/// Apple Sign In error types for localization in UI layer
enum AppleAuthErrorType {
  failed,
  invalidResponse,
  notHandled,
  notInteractive,
  unknown,
  notAvailable,
  tokenFailed,
  supabaseError,
  networkError,
  timeout,
  serverError,
}

/// Custom exception for Apple Sign In errors - localized in UI layer
class AppleAuthException implements Exception {
  final AppleAuthErrorType type;
  final String? originalMessage;

  const AppleAuthException(this.type, [this.originalMessage]);

  @override
  String toString() =>
      'AppleAuthException: $type${originalMessage != null ? ' - $originalMessage' : ''}';
}

/// Unified Authentication Service - Supabase
/// Supports Apple and Email/Password authentication
class AuthService {
  /// Check if Supabase is initialized (safe for testing)
  static bool get isSupabaseInitialized {
    try {
      // ignore: unnecessary_null_comparison
      return Supabase.instance.client != null;
    } catch (e) {
      if (kDebugMode) debugPrint('Auth: Supabase not initialized: $e');
      return false;
    }
  }

  static SupabaseClient get _supabase => Supabase.instance.client;

  // ==================== Current User ====================

  /// Current user
  static User? get currentUser => _supabase.auth.currentUser;

  /// Listen to auth state changes
  static Stream<AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;

  /// Check if Supabase connection is configured
  static bool get _isSupabaseConfigured {
    final url = dotenv.env['SUPABASE_URL'] ?? '';
    return url.isNotEmpty &&
        !url.contains('demo.supabase.co') &&
        !url.contains('placeholder');
  }

  // ==================== Apple Sign In ====================

  /// Sign in with Apple
  /// Uses Supabase OAuth on web, native Apple Sign-In on mobile
  static Future<AuthUserInfo?> signInWithApple() async {
    try {
      if (kDebugMode) {
        debugPrint('🍎 Starting Apple Sign-In...');
        debugPrint('🍎 Platform: ${kIsWeb ? "Web" : "Native"}');
      }

      // Use Supabase OAuth flow on web platform
      if (kIsWeb) {
        return await _signInWithAppleWeb();
      }

      // Use native Apple Sign-In on mobile
      return await _signInWithAppleNative();
    } on SignInWithAppleAuthorizationException catch (e) {
      // User cancellation or Apple error
      if (kDebugMode) {
        debugPrint('🍎 Apple Authorization Error: ${e.code} - ${e.message}');
      }
      if (e.code == AuthorizationErrorCode.canceled) {
        if (kDebugMode) {
          debugPrint('🍎 User canceled sign in');
        }
        return null; // User canceled, don't show error
      }
      // Throw typed exceptions - localized in UI layer
      switch (e.code) {
        case AuthorizationErrorCode.failed:
          throw const AppleAuthException(AppleAuthErrorType.failed);
        case AuthorizationErrorCode.invalidResponse:
          throw const AppleAuthException(AppleAuthErrorType.invalidResponse);
        case AuthorizationErrorCode.notHandled:
          throw const AppleAuthException(AppleAuthErrorType.notHandled);
        case AuthorizationErrorCode.notInteractive:
          throw const AppleAuthException(AppleAuthErrorType.notInteractive);
        case AuthorizationErrorCode.unknown:
        default:
          throw const AppleAuthException(AppleAuthErrorType.unknown);
      }
    } on AuthException catch (e) {
      // Supabase auth error - map to specific types for better localization
      if (kDebugMode) {
        debugPrint('🍎 Supabase Auth Error: ${e.message}');
      }
      final message = e.message.toLowerCase();

      // Map Supabase errors to specific types
      if (message.contains('invalid_grant') || message.contains('expired')) {
        throw const AppleAuthException(
          AppleAuthErrorType.tokenFailed,
          'Your session expired. Please sign in again.',
        );
      }
      if (message.contains('network') ||
          message.contains('connection') ||
          message.contains('socket') ||
          message.contains('timeout')) {
        throw const AppleAuthException(
          AppleAuthErrorType.networkError,
          'Network connection failed.',
        );
      }
      if (message.contains('server') ||
          message.contains('500') ||
          message.contains('502') ||
          message.contains('503')) {
        throw const AppleAuthException(
          AppleAuthErrorType.serverError,
          'Server temporarily unavailable.',
        );
      }
      throw AppleAuthException(AppleAuthErrorType.supabaseError, e.message);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🍎 Apple Sign-In error: $e');
      }
      final errorStr = e.toString().toLowerCase();

      // User cancellation - don't show error
      if (errorStr.contains('canceled') ||
          errorStr.contains('cancelled') ||
          errorStr.contains('user_canceled') ||
          errorStr.contains('user canceled')) {
        return null;
      }

      // Network/connectivity errors
      if (errorStr.contains('network') ||
          errorStr.contains('connection') ||
          errorStr.contains('socket') ||
          errorStr.contains('unreachable') ||
          errorStr.contains('no internet')) {
        throw const AppleAuthException(AppleAuthErrorType.networkError);
      }

      // Timeout errors
      if (errorStr.contains('timeout') || errorStr.contains('timed out')) {
        throw const AppleAuthException(AppleAuthErrorType.timeout);
      }

      // Server errors
      if (errorStr.contains('server') ||
          errorStr.contains('500') ||
          errorStr.contains('internal error')) {
        throw const AppleAuthException(AppleAuthErrorType.serverError);
      }

      // For any other unhandled error, throw as unknown with original message
      // This ensures we never show raw Turkish error messages
      throw AppleAuthException(AppleAuthErrorType.unknown, e.toString());
    }
  }

  /// Supabase OAuth flow for web (Apple)
  static Future<AuthUserInfo?> _signInWithAppleWeb() async {
    if (kDebugMode) {
      debugPrint('🍎 Starting Web OAuth flow...');
    }
    try {
      // Use Supabase OAuth redirect for Apple Sign In on web
      final result = await _supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        authScreenLaunchMode: LaunchMode.platformDefault,
      );

      if (kDebugMode) {
        debugPrint('🍎 OAuth result: $result');
      }
      // Return null because OAuth flow will redirect
      // Auth state listener will catch when user returns
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🍎 Apple OAuth error: $e');
      }
      final errorStr = e.toString();
      // JS interop errors during OAuth redirect are normal on web
      if (errorStr.contains('TypeError') ||
          errorStr.contains('TypeErrorImpl') ||
          errorStr.contains('JSObject') ||
          errorStr.contains('minified')) {
        if (kDebugMode) {
          debugPrint('🍎 JS interop error - OAuth redirect continuing');
        }
        return null;
      }
      rethrow;
    }
  }

  /// Native Apple Sign-In for mobile
  static Future<AuthUserInfo?> _signInWithAppleNative() async {
    if (kDebugMode) {
      debugPrint('🍎 Starting Native Apple Sign-In...');
    }

    // Check if Apple Sign In is available
    final isAvailable = await SignInWithApple.isAvailable();
    if (kDebugMode) {
      debugPrint('🍎 Apple Sign In available: $isAvailable');
    }

    if (!isAvailable) {
      throw const AppleAuthException(AppleAuthErrorType.notAvailable);
    }

    // Generate nonce (for security)
    final rawNonce = _generateNonce();
    final hashedNonce = _sha256ofString(rawNonce);
    if (kDebugMode) {
      debugPrint('🍎 Nonce generated');
    }

    // Start Apple Sign In with timeout protection
    // iPad/slower networks may need more time for the native dialog
    if (kDebugMode) {
      debugPrint('🍎 Requesting Apple credential...');
    }
    final AuthorizationCredentialAppleID appleCredential;
    try {
      appleCredential =
          await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: hashedNonce,
          ).timeout(
            const Duration(
              seconds: 60,
            ), // Generous timeout for iPad/slow networks
            onTimeout: () {
              if (kDebugMode) {
                debugPrint('🍎 Apple Sign-In timed out after 60 seconds');
              }
              throw const AppleAuthException(
                AppleAuthErrorType.timeout,
                'Sign in is taking longer than expected. Please try again.',
              );
            },
          );
    } on TimeoutException {
      if (kDebugMode) {
        debugPrint('🍎 Apple Sign-In timeout exception');
      }
      throw const AppleAuthException(
        AppleAuthErrorType.timeout,
        'Sign in is taking longer than expected. Please try again.',
      );
    } on SocketException catch (e) {
      if (kDebugMode) {
        debugPrint('🍎 Network error during Apple Sign-In: $e');
      }
      throw const AppleAuthException(
        AppleAuthErrorType.networkError,
        'Network connection failed. Please check your internet.',
      );
    }
    if (kDebugMode) {
      debugPrint('🍎 Apple credential received');
    }

    final idToken = appleCredential.identityToken;
    if (idToken == null) {
      throw const AppleAuthException(AppleAuthErrorType.tokenFailed);
    }

    // If Supabase is not configured, return only Apple auth info
    if (!_isSupabaseConfigured) {
      final fullName =
          '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
              .trim();
      return AuthUserInfo(
        uid: appleCredential.userIdentifier ?? 'apple_user',
        email: appleCredential.email,
        displayName: fullName.isNotEmpty ? fullName : null,
        photoUrl: null,
        provider: AuthProvider.apple,
      );
    }

    // Sign in to Supabase with timeout protection
    if (kDebugMode) {
      debugPrint('🍎 Authenticating with Supabase...');
    }
    final AuthResponse response;
    try {
      response = await _supabase.auth
          .signInWithIdToken(
            provider: OAuthProvider.apple,
            idToken: idToken,
            nonce: rawNonce,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              if (kDebugMode) {
                debugPrint('🍎 Supabase auth timed out');
              }
              throw const AppleAuthException(
                AppleAuthErrorType.timeout,
                'Server is taking longer than expected. Please try again.',
              );
            },
          );
    } on TimeoutException {
      throw const AppleAuthException(
        AppleAuthErrorType.timeout,
        'Server is taking longer than expected. Please try again.',
      );
    } on SocketException {
      throw const AppleAuthException(
        AppleAuthErrorType.networkError,
        'Network connection failed. Please check your internet.',
      );
    }
    if (kDebugMode) {
      debugPrint('🍎 Supabase auth successful');
    }

    final user = response.user;
    if (user == null) return null;

    // Apple provides name only on first sign in
    if (appleCredential.givenName != null) {
      final fullName =
          '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
              .trim();
      if (fullName.isNotEmpty) {
        await _supabase.auth.updateUser(
          UserAttributes(data: {'full_name': fullName}),
        );
      }
    }

    return AuthUserInfo.fromSupabaseUser(user, AuthProvider.apple);
  }

  // ==================== Helper Methods ====================

  /// Generate nonce (for Apple Sign In)
  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Generate SHA256 hash
  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
