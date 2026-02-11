import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Local Mode service for offline-first functionality
/// Allows app to work without Sign in with Apple for App Store review
class LocalModeService {
  static const _localModeKey = 'local_mode_enabled';
  static const _localModeTimestampKey = 'local_mode_timestamp';

  /// Check if Local Mode is enabled
  static Future<bool> isLocalMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_localModeKey) ?? false;
    } catch (e) {
      debugPrint('LocalModeService: Error checking local mode: $e');
      return false;
    }
  }

  /// Enable Local Mode
  /// Used when user chooses "Continue without signing in"
  /// or when Sign in with Apple fails after retries
  static Future<void> enableLocalMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_localModeKey, true);
      await prefs.setInt(
        _localModeTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      debugPrint('LocalModeService: Local mode enabled');
    } catch (e) {
      debugPrint('LocalModeService: Error enabling local mode: $e');
    }
  }

  /// Disable Local Mode (when user signs in later)
  static Future<void> disableLocalMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_localModeKey, false);
      await prefs.remove(_localModeTimestampKey);
      debugPrint('LocalModeService: Local mode disabled');
    } catch (e) {
      debugPrint('LocalModeService: Error disabling local mode: $e');
    }
  }

  /// Get when Local Mode was enabled
  static Future<DateTime?> getLocalModeStartTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_localModeTimestampKey);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      debugPrint('LocalModeService: Error getting local mode timestamp: $e');
      return null;
    }
  }

  /// Check if user should be prompted to sign in
  /// Returns true if in local mode for more than 7 days
  static Future<bool> shouldPromptSignIn() async {
    final isLocal = await isLocalMode();
    if (!isLocal) return false;

    final startTime = await getLocalModeStartTime();
    if (startTime == null) return false;

    final daysSinceStart = DateTime.now().difference(startTime).inDays;
    return daysSinceStart >= 7;
  }
}
