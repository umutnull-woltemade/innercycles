import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Google hesabından alınan profil bilgileri
class GoogleUserInfo {
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String id;

  GoogleUserInfo({
    this.displayName,
    this.email,
    this.photoUrl,
    required this.id,
  });
}

/// Google Sign-In servisi (Firebase olmadan - Vercel uyumlu)
class GoogleAuthService {
  // Web için Google Client ID gerekli
  // Google Cloud Console > APIs & Services > Credentials > OAuth 2.0 Client IDs
  // Authorized JavaScript origins: https://astrobobo.com, http://localhost:5000
  // Authorized redirect URIs: https://astrobobo.com, http://localhost:5000
  static const String _webClientId =
      '1010163569875-pi5vv7ejgv9iaa67pgt6r00am7ta27fr.apps.googleusercontent.com';

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: kIsWeb ? (_webClientId.isNotEmpty ? _webClientId : null) : null,
  );

  static GoogleSignInAccount? _currentUser;

  /// Web'de Google Sign-In yapılandırılmış mı?
  static bool get isConfiguredForWeb => kIsWeb && _webClientId.isNotEmpty;

  /// Google ile oturum aç
  /// Başarılı olursa [GoogleUserInfo] döner, başarısız olursa null
  static Future<GoogleUserInfo?> signInWithGoogle() async {
    // Web'de Client ID yoksa hata fırlat
    if (kIsWeb && _webClientId.isEmpty) {
      throw Exception(
        'Google Sign-In henüz yapılandırılmadı. '
        'Lütfen manuel olarak profil bilgilerinizi girin.',
      );
    }

    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        // Kullanıcı iptal etti
        return null;
      }

      _currentUser = account;

      return GoogleUserInfo(
        displayName: account.displayName,
        email: account.email,
        photoUrl: account.photoUrl,
        id: account.id,
      );
    } catch (e) {
      print('Google Sign-In error: $e');
      rethrow;
    }
  }

  /// Sessiz oturum açma (daha önce giriş yapıldıysa)
  static Future<GoogleUserInfo?> signInSilently() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signInSilently();

      if (account == null) {
        return null;
      }

      _currentUser = account;

      return GoogleUserInfo(
        displayName: account.displayName,
        email: account.email,
        photoUrl: account.photoUrl,
        id: account.id,
      );
    } catch (e) {
      print('Silent sign-in error: $e');
      return null;
    }
  }

  /// Mevcut kullanıcıyı al
  static GoogleUserInfo? getCurrentUser() {
    if (_currentUser == null) return null;

    return GoogleUserInfo(
      displayName: _currentUser!.displayName,
      email: _currentUser!.email,
      photoUrl: _currentUser!.photoUrl,
      id: _currentUser!.id,
    );
  }

  /// Oturumu kapat
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  /// Hesap bağlantısını tamamen kes
  static Future<void> disconnect() async {
    await _googleSignIn.disconnect();
    _currentUser = null;
  }

  /// Kullanıcı oturum açmış mı?
  static bool isSignedIn() {
    return _currentUser != null;
  }
}
