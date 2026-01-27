import 'package:flutter/foundation.dart' show kIsWeb;
import 'supabase_auth_web.dart' if (dart.library.io) 'supabase_auth_stub.dart';

/// Supabase Auth Service for Apple/Google Sign In
/// Uses URL redirect on web, stub on mobile
class SupabaseAuthService {
  /// Initialize - no-op for URL-based auth
  static Future<void> initialize() async {
    // No initialization needed for URL-based OAuth
  }

  /// Sign in with Apple
  static Future<void> signInWithApple() async {
    if (kIsWeb) {
      await WebAuthHelper.signInWithApple();
    } else {
      throw UnimplementedError('Apple Sign In not implemented for mobile');
    }
  }

  /// Sign in with Google
  static Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      await WebAuthHelper.signInWithGoogle();
    } else {
      throw UnimplementedError('Google Sign In not implemented for mobile');
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    if (kIsWeb) {
      await WebAuthHelper.signOut();
    }
  }
}

/// User info placeholder
class SupabaseUserInfo {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  SupabaseUserInfo({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
  });
}
