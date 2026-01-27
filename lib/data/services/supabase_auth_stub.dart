/// Stub for non-web platforms
class WebAuthHelper {
  static Future<void> signInWithApple() async {
    throw UnimplementedError('Web auth not available on this platform');
  }

  static Future<void> signInWithGoogle() async {
    throw UnimplementedError('Web auth not available on this platform');
  }

  static Future<void> signOut() async {
    // No-op on non-web platforms
  }
}
