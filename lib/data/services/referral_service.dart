import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_providers.dart';

/// Referral service for "Share App → Unlock Premium Trial" flow.
///
/// Tracks app shares and grants a 7-day premium trial when the user
/// successfully shares the app 3 times. Uses SharedPreferences for
/// local persistence.
class ReferralService {
  final SharedPreferences _prefs;

  static const _keyShareCount = 'referral_share_count';
  static const _keyTrialGranted = 'referral_trial_granted';
  static const _keyTrialExpiry = 'referral_trial_expiry';
  static const _keyLastShareDate = 'referral_last_share_date';

  static const int sharesToUnlock = 3;
  static const int trialDays = 7;

  ReferralService._(this._prefs);

  static Future<ReferralService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ReferralService._(prefs);
  }

  /// Current share count
  int get shareCount => _prefs.getInt(_keyShareCount) ?? 0;

  /// Whether a referral trial has been granted
  bool get trialGranted => _prefs.getBool(_keyTrialGranted) ?? false;

  /// Whether the referral trial is currently active (not expired)
  bool get isTrialActive {
    if (!trialGranted) return false;
    final expiryMs = _prefs.getInt(_keyTrialExpiry);
    if (expiryMs == null) return false;
    return DateTime.fromMillisecondsSinceEpoch(expiryMs)
        .isAfter(DateTime.now());
  }

  /// Trial expiry date (null if no trial)
  DateTime? get trialExpiry {
    final expiryMs = _prefs.getInt(_keyTrialExpiry);
    if (expiryMs == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(expiryMs);
  }

  /// Shares remaining to unlock trial
  int get sharesRemaining =>
      (sharesToUnlock - shareCount).clamp(0, sharesToUnlock);

  /// Whether user has already shared today
  bool get hasSharedToday {
    final lastShare = _prefs.getString(_keyLastShareDate);
    if (lastShare == null) return false;
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return lastShare == todayStr;
  }

  /// Share the app and track progress. Returns true if trial was unlocked.
  Future<bool> shareApp({
    required AppLanguage language,
  }) async {
    final isEn = language == AppLanguage.en;

    final shareText = isEn
        ? 'I\'m discovering my emotional patterns with InnerCycles! Track moods, decode dreams, and see what your inner cycles reveal. Try it free:'
        : 'InnerCycles ile duygusal kalıplarımı keşfediyorum! Ruh halini takip et, rüyalarını çöz ve iç döngülerinin ne anlattığını gör. Ücretsiz dene:';

    const appUrl = 'https://apps.apple.com/app/innercycles/id6758612716';

    await Share.share('$shareText\n\n$appUrl');

    // Count all share attempts (iOS doesn't reliably report actual success)
    {
      await _incrementShareCount();

      if (kDebugMode) {
        debugPrint(
            'ReferralService: Share counted. Total: $shareCount/$sharesToUnlock');
      }

      // Check if trial should be unlocked
      if (shareCount >= sharesToUnlock && !trialGranted) {
        await _grantTrial();
        return true;
      }
    }

    return false;
  }

  Future<void> _incrementShareCount() async {
    final current = shareCount;
    await _prefs.setInt(_keyShareCount, current + 1);

    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await _prefs.setString(_keyLastShareDate, todayStr);
  }

  Future<void> _grantTrial() async {
    final expiry = DateTime.now().add(const Duration(days: trialDays));
    await _prefs.setBool(_keyTrialGranted, true);
    await _prefs.setInt(_keyTrialExpiry, expiry.millisecondsSinceEpoch);

    if (kDebugMode) {
      debugPrint(
          'ReferralService: Trial granted! Expires: ${expiry.toIso8601String()}');
    }
  }

  /// Get referral status for display
  ReferralStatus getStatus(AppLanguage language) {
    final isEn = language == AppLanguage.en;

    if (isTrialActive) {
      final daysLeft = trialExpiry!.difference(DateTime.now()).inDays + 1;
      return ReferralStatus(
        headline: isEn
            ? 'Premium Trial Active!'
            : 'Premium Deneme Aktif!',
        subtitle: isEn
            ? '$daysLeft days remaining'
            : '$daysLeft gün kaldı',
        progress: 1.0,
        isUnlocked: true,
      );
    }

    if (trialGranted && !isTrialActive) {
      return ReferralStatus(
        headline: isEn ? 'Trial Expired' : 'Deneme Süresi Doldu',
        subtitle: isEn
            ? 'Upgrade to keep premium features'
            : 'Premium özellikleri korumak için yükselt',
        progress: 1.0,
        isUnlocked: false,
        isExpired: true,
      );
    }

    return ReferralStatus(
      headline: isEn
          ? 'Share & Unlock Premium Trial'
          : 'Paylaş ve Premium Dene',
      subtitle: isEn
          ? 'Share $sharesRemaining more times to unlock a 7-day free trial. No subscription required — trial ends automatically.'
          : '$sharesRemaining kez daha paylaş, 7 günlük ücretsiz deneme kazan. Abonelik gerektirmez — deneme otomatik sona erer.',
      progress: shareCount / sharesToUnlock,
      isUnlocked: false,
    );
  }
}

/// Referral status for UI display
class ReferralStatus {
  final String headline;
  final String subtitle;
  final double progress;
  final bool isUnlocked;
  final bool isExpired;

  const ReferralStatus({
    required this.headline,
    required this.subtitle,
    required this.progress,
    required this.isUnlocked,
    this.isExpired = false,
  });
}
