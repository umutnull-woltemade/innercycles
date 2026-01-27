import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Auth Service for Apple Sign In (especially on web)
/// Uses Supabase OAuth which handles the Apple Sign In flow properly
class SupabaseAuthService {
  static bool _initialized = false;

  // Supabase credentials
  static const String _supabaseUrl = 'https://riadutygfuzufzzsvxqh.supabase.co';
  // Anon key from Supabase Dashboard > Settings > API Keys > Legacy
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJpYWR1dHlnZnV6dWZ6enN2eHFoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkzNDEwOTgsImV4cCI6MjA4NDkxNzA5OH0.qbhmVgg4OjLOEioHSVz1_g0mlFhZtuhqMFCcBxUUpUs';

  /// Initialize Supabase
  static Future<void> initialize() async {
    if (_initialized) return;

    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
    _initialized = true;
  }

  /// Get Supabase client
  static SupabaseClient get client => Supabase.instance.client;

  /// Get current user
  static User? get currentUser => client.auth.currentUser;

  /// Check if user is signed in
  static bool get isSignedIn => currentUser != null;

  /// Sign in with Apple using Supabase OAuth
  /// This works properly on web unlike the sign_in_with_apple package
  static Future<AuthResponse?> signInWithApple() async {
    try {
      if (!_initialized) {
        await initialize();
      }

      if (kIsWeb) {
        // On web, use OAuth redirect flow
        await client.auth.signInWithOAuth(
          OAuthProvider.apple,
          redirectTo: 'https://astrobobo.com/#/onboarding',
        );
        // This will redirect, so we return null here
        // The auth state will be picked up after redirect
        return null;
      } else {
        // On mobile, use native Apple Sign In flow
        // This requires additional setup with sign_in_with_apple package
        throw UnimplementedError('Native Apple Sign In not implemented yet');
      }
    } catch (e) {
      print('Apple Sign-In error: $e');
      rethrow;
    }
  }

  /// Sign in with Google using Supabase OAuth
  static Future<AuthResponse?> signInWithGoogle() async {
    try {
      if (!_initialized) {
        await initialize();
      }

      if (kIsWeb) {
        await client.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: 'https://astrobobo.com/#/onboarding',
        );
        return null;
      } else {
        throw UnimplementedError('Native Google Sign In not implemented yet');
      }
    } catch (e) {
      print('Google Sign-In error: $e');
      rethrow;
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// Listen to auth state changes
  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  /// Get user info from current session
  static SupabaseUserInfo? getUserInfo() {
    final user = currentUser;
    if (user == null) return null;

    return SupabaseUserInfo(
      id: user.id,
      email: user.email,
      displayName: user.userMetadata?['full_name'] as String? ??
                   user.userMetadata?['name'] as String?,
      photoUrl: user.userMetadata?['avatar_url'] as String? ??
                user.userMetadata?['picture'] as String?,
    );
  }
}

/// User info from Supabase auth
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
