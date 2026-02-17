import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLockService {
  static const String _enabledKey = 'inner_cycles_app_lock_enabled';
  static const String _pinKey = 'inner_cycles_app_lock_pin';

  final SharedPreferences _prefs;
  final LocalAuthentication _localAuth = LocalAuthentication();

  AppLockService._(this._prefs);

  static Future<AppLockService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return AppLockService._(prefs);
  }

  /// Whether app lock is enabled
  bool get isEnabled => _prefs.getBool(_enabledKey) ?? false;

  /// Whether a PIN has been set
  bool get hasPin => _prefs.getString(_pinKey) != null;

  /// Get the stored PIN
  String? get storedPin => _prefs.getString(_pinKey);

  /// Enable app lock
  Future<void> setEnabled(bool enabled) async {
    await _prefs.setBool(_enabledKey, enabled);
  }

  /// Save a PIN
  Future<void> setPin(String pin) async {
    await _prefs.setString(_pinKey, pin);
  }

  /// Remove PIN
  Future<void> removePin() async {
    await _prefs.remove(_pinKey);
  }

  /// Verify PIN
  bool verifyPin(String pin) => _prefs.getString(_pinKey) == pin;

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
    String reason = 'Authenticate to access InnerCycles',
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
        biometricOnly: false,
      );
    } on PlatformException {
      return false;
    }
  }

  /// Full unlock flow: try biometrics first, return result
  Future<bool> unlock() async {
    if (!isEnabled) return true;

    final canBio = await canUseBiometrics();
    if (canBio) {
      return authenticateWithBiometrics();
    }

    // Caller should show PIN input if biometrics unavailable
    return false;
  }
}
