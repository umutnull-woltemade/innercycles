// ════════════════════════════════════════════════════════════════════════════
// VAULT SERVICE - Private Content Management (PIN + Biometric)
// ════════════════════════════════════════════════════════════════════════════
// Manages: PIN setup/verification, biometric auth, private photo album,
// and tracks which journal entries / notes are marked private.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import '../models/vault_photo.dart';

class VaultService {
  static const String _pinHashKey = 'inner_cycles_vault_pin_hash';
  static const String _pinSaltKey = 'inner_cycles_vault_pin_salt';
  static const String _vaultEnabledKey = 'inner_cycles_vault_enabled';
  static const String _biometricEnabledKey = 'inner_cycles_vault_biometric';
  static const String _photosKey = 'inner_cycles_vault_photos';
  static const _uuid = Uuid();

  final SharedPreferences _prefs;
  final LocalAuthentication _localAuth = LocalAuthentication();
  List<VaultPhoto> _photos = [];

  VaultService._(this._prefs) {
    _loadPhotos();
  }

  static Future<VaultService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return VaultService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PIN MANAGEMENT
  // ══════════════════════════════════════════════════════════════════════════

  /// Whether the vault has been set up (PIN exists)
  bool get isVaultSetUp => _prefs.getString(_pinHashKey) != null;

  /// Whether vault is enabled
  bool get isVaultEnabled => _prefs.getBool(_vaultEnabledKey) ?? false;

  /// Whether biometric unlock is enabled for vault
  bool get isBiometricEnabled => _prefs.getBool(_biometricEnabledKey) ?? false;

  /// Generate a random salt for PIN hashing
  String _generateSalt() => _uuid.v4();

  /// Hash a PIN with salt using SHA-256
  String _hashPin(String pin, String salt) {
    final bytes = utf8.encode(salt + pin);
    return sha256.convert(bytes).toString();
  }

  /// Set up the vault PIN (first time or change)
  Future<void> setPin(String pin) async {
    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);
    await _prefs.setString(_pinSaltKey, salt);
    await _prefs.setString(_pinHashKey, hash);
    await _prefs.setBool(_vaultEnabledKey, true);
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
  bool verifyPin(String pin) {
    if (isLockedOut) return false;

    final storedHash = _prefs.getString(_pinHashKey);
    final storedSalt = _prefs.getString(_pinSaltKey);
    if (storedHash == null) return false;

    // Support legacy unsalted hashes (migrate on success)
    final hash = storedSalt != null
        ? _hashPin(pin, storedSalt)
        : sha256.convert(utf8.encode(pin)).toString();

    if (hash == storedHash) {
      // Success — reset attempts
      _prefs.remove(_attemptCountKey);
      _prefs.remove(_lockoutUntilKey);
      // Migrate legacy unsalted hash to salted
      if (storedSalt == null) {
        setPin(pin);
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
    if (!verifyPin(oldPin)) return false;
    await setPin(newPin);
    return true;
  }

  /// Remove vault PIN and disable vault
  Future<void> removeVault() async {
    await _prefs.remove(_pinHashKey);
    await _prefs.remove(_pinSaltKey);
    await _prefs.setBool(_vaultEnabledKey, false);
    await _prefs.setBool(_biometricEnabledKey, false);
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
    String reasonTr = 'Gizli kasana erişmek için kimliğini doğrula',
    bool isEn = true,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: isEn ? reason : reasonTr,
        persistAcrossBackgrounding: true,
        biometricOnly: false,
      );
    } on PlatformException {
      return false;
    }
  }

  /// Full vault unlock flow: biometric first if enabled, then PIN fallback
  /// Returns true if biometric succeeded, false if PIN input needed
  Future<bool> tryBiometricUnlock({bool isEn = true}) async {
    if (!isVaultSetUp) return false;
    if (!isBiometricEnabled) return false;

    final canBio = await canUseBiometrics();
    if (!canBio) return false;

    return authenticateWithBiometrics(isEn: isEn);
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
        debugPrint('VaultService: Failed to delete photo file: $e');
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
        debugPrint('VaultService._loadPhotos: JSON decode failed: $e');
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
        debugPrint('VaultService: Failed to delete photo file: $e');
      }
    }
    _photos.clear();
    await _prefs.remove(_photosKey);
    await removeVault();
  }
}
