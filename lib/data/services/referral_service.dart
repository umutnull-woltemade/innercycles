// ============================================================================
// REFERRAL SERVICE - Viral growth engine with unique invite codes
// ============================================================================
// Generates unique referral codes, tracks invites, rewards both sides with
// 7 days of premium. Uses SharedPreferences locally + Supabase for tracking.
// ============================================================================

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/app_providers.dart';
import 'notification_service.dart';

// ============================================================================
// MODEL
// ============================================================================

class ReferralInfo {
  final String code;
  final int referralCount;
  final int rewardDaysEarned;
  final DateTime? rewardExpiresAt;

  ReferralInfo({
    required this.code,
    this.referralCount = 0,
    this.rewardDaysEarned = 0,
    this.rewardExpiresAt,
  });

  bool get hasActiveReward =>
      rewardExpiresAt != null && rewardExpiresAt!.isAfter(DateTime.now());

  int get daysRemaining => hasActiveReward
      ? rewardExpiresAt!.difference(DateTime.now()).inDays
      : 0;
}

// ============================================================================
// SERVICE
// ============================================================================

class ReferralService {
  static const String _codeKey = 'ic_referral_code';
  static const String _countKey = 'ic_referral_count';
  static const String _rewardExpiryKey = 'ic_referral_reward_expiry';
  static const String _appliedCodeKey = 'ic_referral_applied_code';
  static const int _rewardDaysPerReferral = 7;

  final SharedPreferences _prefs;

  ReferralService._(this._prefs);

  static Future<ReferralService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final service = ReferralService._(prefs);
    // Ensure the user has a code
    if (service.myCode.isEmpty) {
      service._generateCode();
    }
    return service;
  }

  // =========================================================================
  // CODE GENERATION
  // =========================================================================

  /// Get user's unique referral code
  String get myCode => _prefs.getString(_codeKey) ?? '';

  /// Full shareable link
  String get shareLink =>
      'https://innercycles.app/invite/$myCode';

  /// Full share text
  String shareText({AppLanguage language = AppLanguage.en}) {
    return language == AppLanguage.en
        ? "I've been journaling with InnerCycles and it's changing how I understand myself. "
          'Join me and we both get 7 days of Premium free!\n\n'
          '$shareLink'
        : 'InnerCycles ile günlük tutuyorum ve kendimi anlamam değişti. '
          'Sen de katıl, ikimiz de 7 gün Premium kazanalım!\n\n'
          '$shareLink';
  }

  void _generateCode() {
    // 8 char alphanumeric code
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();
    final code = List.generate(8, (_) => chars[random.nextInt(chars.length)]).join();
    _prefs.setString(_codeKey, code);

    // Try to register on Supabase
    _registerCodeOnSupabase(code);
  }

  // =========================================================================
  // APPLY REFERRAL (invitee side)
  // =========================================================================

  /// Whether this user has already applied a referral code
  bool get hasAppliedCode => _prefs.getString(_appliedCodeKey) != null;

  /// Apply a referral code (invitee gets 7 days premium)
  Future<ReferralResult> applyCode(String code) async {
    final cleanCode = code.trim().toUpperCase();

    // Can't use own code
    if (cleanCode == myCode) {
      return ReferralResult.ownCode;
    }

    // Already used a code
    if (hasAppliedCode) {
      return ReferralResult.alreadyUsed;
    }

    // Validate code exists on server (strict — no offline fallback)
    final valid = await _validateCodeOnSupabase(cleanCode);
    if (!valid) {
      return ReferralResult.invalidCode;
    }

    // Credit inviter on server first — only grant locally if server succeeds
    final credited = await _creditInviterOnSupabase(cleanCode);
    if (!credited) {
      return ReferralResult.invalidCode;
    }

    // Apply: give invitee 7 days (only after server confirmation)
    _prefs.setString(_appliedCodeKey, cleanCode);
    _addRewardDays(_rewardDaysPerReferral);

    return ReferralResult.success;
  }

  // =========================================================================
  // REWARDS
  // =========================================================================

  /// Current referral info
  ReferralInfo get info => ReferralInfo(
    code: myCode,
    referralCount: _prefs.getInt(_countKey) ?? 0,
    rewardDaysEarned: (_prefs.getInt(_countKey) ?? 0) * _rewardDaysPerReferral,
    rewardExpiresAt: _rewardExpiry,
  );

  DateTime? get _rewardExpiry {
    final ms = _prefs.getInt(_rewardExpiryKey);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }

  /// Whether user has active referral premium
  bool get hasReferralPremium {
    final expiry = _rewardExpiry;
    return expiry != null && expiry.isAfter(DateTime.now());
  }

  void _addRewardDays(int days) {
    final now = DateTime.now();
    final currentExpiry = _rewardExpiry;
    final base = (currentExpiry != null && currentExpiry.isAfter(now))
        ? currentExpiry
        : now;
    final newExpiry = base.add(Duration(days: days));
    _prefs.setInt(_rewardExpiryKey, newExpiry.millisecondsSinceEpoch);
  }

  /// Called when someone uses our code (inviter side)
  void recordSuccessfulReferral() {
    final count = (_prefs.getInt(_countKey) ?? 0) + 1;
    _prefs.setInt(_countKey, count);
    _addRewardDays(_rewardDaysPerReferral);

    // Fire a local notification to celebrate
    NotificationService().showReferralRewardNotification(
      totalReferrals: count,
    );
  }

  // =========================================================================
  // MILESTONES
  // =========================================================================

  /// Milestone tiers for gamification
  static const Map<int, String> milestones = {
    3: '3 friends → 1 month free',
    10: '10 friends → Lifetime Premium',
  };

  int get referralCount => _prefs.getInt(_countKey) ?? 0;

  // =========================================================================
  // SUPABASE SYNC
  // =========================================================================

  Future<void> _registerCodeOnSupabase(String code) async {
    try {
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) return;

      await client.from('referral_codes').upsert({
        'user_id': userId,
        'code': code,
        'referral_count': 0,
        'created_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id');
    } catch (e) {
      debugPrint('ReferralService: Failed to register code on Supabase: $e');
    }
  }

  Future<bool> _validateCodeOnSupabase(String code) async {
    try {
      final client = Supabase.instance.client;
      final result = await client
          .from('referral_codes')
          .select('code')
          .eq('code', code)
          .limit(1);
      return result.isNotEmpty;
    } catch (e) {
      debugPrint('ReferralService: Failed to validate code: $e');
      // Require network — don't accept unverified codes offline
      return false;
    }
  }

  Future<bool> _creditInviterOnSupabase(String code) async {
    try {
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;

      // Increment inviter's count
      await client.rpc('increment_referral_count', params: {'referral_code': code});

      // Log the referral event
      await client.from('referral_events').insert({
        'referral_code': code,
        'invitee_user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('ReferralService: Failed to credit inviter: $e');
      return false;
    }
  }

  /// Sync referral count from server (call on app launch if signed in)
  Future<void> syncFromServer() async {
    try {
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) return;

      // Ensure our code is registered
      if (myCode.isNotEmpty) {
        await _registerCodeOnSupabase(myCode);
      }

      // Fetch our referral count
      final result = await client
          .from('referral_codes')
          .select('referral_count')
          .eq('user_id', userId)
          .limit(1);

      if (result.isNotEmpty) {
        final serverCount = result.first['referral_count'] as int? ?? 0;
        final localCount = _prefs.getInt(_countKey) ?? 0;

        if (serverCount > localCount) {
          // Server has more — we got new referrals while offline
          final newReferrals = serverCount - localCount;
          _prefs.setInt(_countKey, serverCount);
          _addRewardDays(newReferrals * _rewardDaysPerReferral);
        }
      }
    } catch (e) {
      debugPrint('ReferralService: Failed to sync from server: $e');
    }
  }
}

// ============================================================================
// RESULT ENUM
// ============================================================================

enum ReferralResult {
  success,
  invalidCode,
  ownCode,
  alreadyUsed,
}

// ============================================================================
// PROVIDER
// ============================================================================

final referralServiceProvider = FutureProvider<ReferralService>((ref) {
  return ReferralService.init();
});
