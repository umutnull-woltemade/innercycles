// ════════════════════════════════════════════════════════════════════════════
// REFERRAL SERVICE - InnerCycles Friend Invite & Reward System
// ════════════════════════════════════════════════════════════════════════════
// Generates unique 8-character referral codes, tracks invites sent,
// successful referrals, and unlocks a 7-day premium trial reward after
// 3 successful referrals. Uses SharedPreferences for local persistence.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_providers.dart';

class ReferralService {
  final SharedPreferences _prefs;

  // ── Storage keys ──────────────────────────────────────────────────────
  static const String _keyMyCode = 'referral_my_code';
  static const String _keyTotalInvitesSent = 'referral_invites_sent';
  static const String _keySuccessfulReferrals = 'referral_successful';
  static const String _keyReferredBy = 'referral_referred_by';
  static const String _keyRewardGranted = 'referral_reward_granted';
  static const String _keyRewardExpiry = 'referral_reward_expiry';

  // ── Config ────────────────────────────────────────────────────────────
  static const int requiredReferrals = 3;
  static const int rewardTrialDays = 7;
  static const int _codeLength = 8;

  /// Unambiguous alphanumeric characters (no 0/O, 1/I/L).
  static const String _codeChars = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

  ReferralService._(this._prefs);

  /// Initialize the referral service (follows project init() factory pattern).
  static Future<ReferralService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ReferralService._(prefs);
  }

  // ════════════════════════════════════════════════════════════════════════
  // REFERRAL CODE
  // ════════════════════════════════════════════════════════════════════════

  /// Get the user's personal referral code. Generates one if none exists.
  String getMyCode() {
    final existing = _prefs.getString(_keyMyCode);
    if (existing != null && existing.length == _codeLength) return existing;
    return _generateAndPersistCode();
  }

  /// Generate a cryptographically-random 8-character referral code.
  String _generateAndPersistCode() {
    final random = Random.secure();
    final code = List.generate(
      _codeLength,
      (_) => _codeChars[random.nextInt(_codeChars.length)],
    ).join();
    _prefs.setString(_keyMyCode, code);
    if (kDebugMode) {
      debugPrint('ReferralService: Generated code $code');
    }
    return code;
  }

  // ════════════════════════════════════════════════════════════════════════
  // TRACKING
  // ════════════════════════════════════════════════════════════════════════

  /// Total invites the user has sent (share actions).
  int get totalInvitesSent => _prefs.getInt(_keyTotalInvitesSent) ?? 0;

  /// Number of friends who successfully used this user's referral code.
  int get successfulReferrals => _prefs.getInt(_keySuccessfulReferrals) ?? 0;

  /// The referral code this user was referred by (null if none).
  String? get referredBy => _prefs.getString(_keyReferredBy);

  /// Whether this user has been referred by someone.
  bool hasBeenReferred() => referredBy != null;

  /// Record that the user shared / sent an invite.
  Future<void> recordInviteSent() async {
    final current = totalInvitesSent;
    await _prefs.setInt(_keyTotalInvitesSent, current + 1);
    if (kDebugMode) {
      debugPrint('ReferralService: Invite sent. Total: ${current + 1}');
    }
  }

  /// Record a successful referral (a friend signed up with our code).
  /// Returns true if this referral triggered the reward unlock.
  Future<bool> recordSuccessfulReferral(String friendCode) async {
    final current = successfulReferrals;
    await _prefs.setInt(_keySuccessfulReferrals, current + 1);

    if (kDebugMode) {
      debugPrint(
        'ReferralService: Successful referral from $friendCode. '
        'Total: ${current + 1}/$requiredReferrals',
      );
    }

    // Check if reward should be unlocked
    if ((current + 1) >= requiredReferrals && !rewardGranted) {
      await _grantReward();
      return true;
    }
    return false;
  }

  /// Store which code referred this user.
  Future<void> setReferredBy(String code) async {
    if (hasBeenReferred()) return; // Only allow once
    await _prefs.setString(_keyReferredBy, code.trim().toUpperCase());
    if (kDebugMode) {
      debugPrint('ReferralService: Referred by $code');
    }
  }

  // ════════════════════════════════════════════════════════════════════════
  // REWARD
  // ════════════════════════════════════════════════════════════════════════

  /// Whether the referral reward has been granted.
  bool get rewardGranted => _prefs.getBool(_keyRewardGranted) ?? false;

  /// Whether the user is eligible for the reward (>= 3 referrals, not yet granted).
  bool isEligibleForReward() =>
      successfulReferrals >= requiredReferrals && !rewardGranted;

  /// Whether the reward trial is currently active (not expired).
  bool get isRewardActive {
    if (!rewardGranted) return false;
    final expiryMs = _prefs.getInt(_keyRewardExpiry);
    if (expiryMs == null) return false;
    return DateTime.fromMillisecondsSinceEpoch(expiryMs)
        .isAfter(DateTime.now());
  }

  /// Reward expiry date (null if no reward).
  DateTime? get rewardExpiry {
    final expiryMs = _prefs.getInt(_keyRewardExpiry);
    if (expiryMs == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(expiryMs);
  }

  /// Days remaining on the reward trial.
  int get rewardDaysRemaining {
    final expiry = rewardExpiry;
    if (expiry == null) return 0;
    final diff = expiry.difference(DateTime.now()).inDays;
    return diff > 0 ? diff + 1 : 0;
  }

  /// Progress toward the reward (0.0 to 1.0).
  double get rewardProgress =>
      (successfulReferrals / requiredReferrals).clamp(0.0, 1.0);

  /// Referrals still needed to unlock the reward.
  int get referralsRemaining =>
      (requiredReferrals - successfulReferrals).clamp(0, requiredReferrals);

  Future<void> _grantReward() async {
    final expiry = DateTime.now().add(const Duration(days: rewardTrialDays));
    await _prefs.setBool(_keyRewardGranted, true);
    await _prefs.setInt(_keyRewardExpiry, expiry.millisecondsSinceEpoch);
    if (kDebugMode) {
      debugPrint(
        'ReferralService: Reward granted! Expires: ${expiry.toIso8601String()}',
      );
    }
  }

  // ════════════════════════════════════════════════════════════════════════
  // STATS (convenience)
  // ════════════════════════════════════════════════════════════════════════

  /// Get all referral stats in one call for the UI.
  ReferralStats getReferralStats() {
    return ReferralStats(
      myCode: getMyCode(),
      totalInvitesSent: totalInvitesSent,
      successfulReferrals: successfulReferrals,
      referredBy: referredBy,
      rewardProgress: rewardProgress,
      referralsRemaining: referralsRemaining,
      rewardGranted: rewardGranted,
      isRewardActive: isRewardActive,
      rewardDaysRemaining: rewardDaysRemaining,
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // UI HELPERS
  // ════════════════════════════════════════════════════════════════════════

  /// Get a UI-friendly status object for the referral card.
  ReferralStatus getStatus(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    final remaining = referralsRemaining;

    if (isRewardActive) {
      return ReferralStatus(
        headline: isEn
            ? 'Pro Trial Active!'
            : 'Pro Deneme Aktif!',
        subtitle: isEn
            ? '$rewardDaysRemaining days remaining'
            : '$rewardDaysRemaining gün kaldı',
        progress: 1.0,
        isUnlocked: true,
        isExpired: false,
      );
    }

    if (rewardGranted && !isRewardActive) {
      return ReferralStatus(
        headline: isEn ? 'Trial Expired' : 'Deneme Süresi Doldu',
        subtitle: isEn
            ? 'Upgrade to Pro for full access'
            : 'Tam erişim için Pro\'ya yükselt',
        progress: 1.0,
        isUnlocked: false,
        isExpired: true,
      );
    }

    return ReferralStatus(
      headline: isEn
          ? 'Share & Earn Pro'
          : 'Paylaş ve Pro Kazan',
      subtitle: isEn
          ? 'Invite $remaining more friends to unlock 7-day Pro trial'
          : '$remaining arkadaş daha davet et, 7 günlük Pro dene',
      progress: rewardProgress,
      isUnlocked: false,
      isExpired: false,
    );
  }

  /// Share the app via system share sheet and record the invite.
  /// Returns true if this share triggered the reward unlock.
  Future<bool> shareApp({required AppLanguage language}) async {
    final isEn = language == AppLanguage.en;
    final code = getMyCode();
    final text = isEn
        ? 'I\'m journaling with InnerCycles and discovering patterns in my daily life. Try it: https://apps.apple.com/app/innercycles (use code $code)'
        : 'InnerCycles ile günlük tutuyorum ve günlük hayatımdaki kalıpları keşfediyorum. Sen de dene: https://apps.apple.com/app/innercycles (kod: $code)';

    await SharePlus.instance.share(ShareParams(text: text));
    await recordInviteSent();

    // Check if we've hit the threshold for a simulated referral
    // In a real app, referrals would be validated server-side
    if (totalInvitesSent >= requiredReferrals && !rewardGranted) {
      await _grantReward();
      return true;
    }
    return false;
  }

  /// Clear all referral data (for testing / reset).
  Future<void> clearAll() async {
    await _prefs.remove(_keyMyCode);
    await _prefs.remove(_keyTotalInvitesSent);
    await _prefs.remove(_keySuccessfulReferrals);
    await _prefs.remove(_keyReferredBy);
    await _prefs.remove(_keyRewardGranted);
    await _prefs.remove(_keyRewardExpiry);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// REFERRAL STATS MODEL
// ════════════════════════════════════════════════════════════════════════════

class ReferralStats {
  final String myCode;
  final int totalInvitesSent;
  final int successfulReferrals;
  final String? referredBy;
  final double rewardProgress;
  final int referralsRemaining;
  final bool rewardGranted;
  final bool isRewardActive;
  final int rewardDaysRemaining;

  const ReferralStats({
    required this.myCode,
    required this.totalInvitesSent,
    required this.successfulReferrals,
    this.referredBy,
    required this.rewardProgress,
    required this.referralsRemaining,
    required this.rewardGranted,
    required this.isRewardActive,
    required this.rewardDaysRemaining,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// REFERRAL STATUS (UI model for referral card)
// ════════════════════════════════════════════════════════════════════════════

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
    required this.isExpired,
  });
}
