// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Web-specific auth helper using direct URL redirect
class WebAuthHelper {
  static const String _supabaseRef = 'riadutygfuzufzzsvxqh';
  static const String _redirectUrl = 'https://astrobobo.com/%23/onboarding';

  /// Sign in with Apple using Supabase OAuth URL redirect
  static Future<void> signInWithApple() async {
    final authUrl = 'https://$_supabaseRef.supabase.co/auth/v1/authorize'
        '?provider=apple'
        '&redirect_to=$_redirectUrl';
    html.window.location.href = authUrl;
  }

  /// Sign in with Google using Supabase OAuth URL redirect
  static Future<void> signInWithGoogle() async {
    final authUrl = 'https://$_supabaseRef.supabase.co/auth/v1/authorize'
        '?provider=google'
        '&redirect_to=$_redirectUrl';
    html.window.location.href = authUrl;
  }

  /// Sign out - clears any stored tokens
  static Future<void> signOut() async {
    html.window.localStorage.remove('supabase.auth.token');
  }
}
