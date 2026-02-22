// ════════════════════════════════════════════════════════════════════════════
// REFERRAL SCREEN - Invite Friends & Earn Premium Rewards
// ════════════════════════════════════════════════════════════════════════════
// Displays the user's unique referral code, share button, invite stats,
// and reward progress toward a 7-day premium trial. Follows the project's
// CosmicBackground + CustomScrollView + GlassSliverAppBar pattern.
// EN/TR bilingual via the isEn pattern.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/referral_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

// ════════════════════════════════════════════════════════════════════════════
// SCREEN
// ════════════════════════════════════════════════════════════════════════════

class ReferralScreen extends ConsumerStatefulWidget {
  /// Optional invite code from a deep link (innercycles://invite/:code).
  /// When provided, the code is automatically applied as the referrer.
  final String? inviteCode;

  const ReferralScreen({super.key, this.inviteCode});

  @override
  ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends ConsumerState<ReferralScreen> {
  // ── State ──────────────────────────────────────────────────────────────
  bool _loading = true;
  ReferralStats? _stats;
  bool _codeCopied = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DATA
  // ══════════════════════════════════════════════════════════════════════════

  Future<ReferralService?> _getService() async {
    final serviceAsync = ref.read(referralServiceProvider);
    return serviceAsync.valueOrNull;
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final service = await _getService();
    if (service != null && mounted) {
      // Auto-apply invite code from deep link
      if (widget.inviteCode != null && widget.inviteCode!.isNotEmpty) {
        await service.setReferredBy(widget.inviteCode!);
      }
      if (!mounted) return;
      setState(() {
        _stats = service.getReferralStats();
        _loading = false;
      });
    } else if (mounted) {
      setState(() => _loading = false);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ACTIONS
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> _copyCode() async {
    if (_stats == null) return;
    await Clipboard.setData(ClipboardData(text: _stats!.myCode));
    HapticFeedback.lightImpact();
    if (!mounted) return;
    setState(() => _codeCopied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _codeCopied = false);
    });
  }

  Future<void> _shareInvite(bool isEn) async {
    final service = await _getService();
    if (service == null) return;

    final code = service.getMyCode();
    const appUrl = 'https://apps.apple.com/app/innercycles/id6758612716';

    final shareText = isEn
        ? 'I\'m tracking my emotional patterns with InnerCycles and it\'s been eye-opening! '
          'Use my invite code $code when you sign up and we both benefit. '
          'Download it free:\n\n$appUrl'
        : 'InnerCycles ile duygusal kalıplarımı takip ediyorum ve çok faydalı! '
          'Kayıt olurken davet kodumu kullan: $code. İkimiz de kazanalım. '
          'Ücretsiz indir:\n\n$appUrl';

    await SharePlus.instance.share(ShareParams(text: shareText));

    // Count the share
    await service.recordInviteSent();
    if (!mounted) return;
    setState(() => _stats = service.getReferralStats());
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // ═══════════════════════════════════════════════════════════
              // APP BAR
              // ═══════════════════════════════════════════════════════════
              GlassSliverAppBar(
                title: isEn ? 'Invite Friends' : 'Arkadaşlarını Davet Et',
              ),

              // ═══════════════════════════════════════════════════════════
              // CONTENT
              // ═══════════════════════════════════════════════════════════
              if (_loading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.starGold,
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // ── Hero ──
                        _buildHeroSection(isEn, isDark),

                        const SizedBox(height: 24),

                        // ── Referral Code Card ──
                        _buildCodeCard(isEn, isDark)
                            .animate()
                            .fadeIn(delay: 100.ms, duration: 400.ms)
                            .slideY(begin: 0.05, end: 0),

                        const SizedBox(height: 16),

                        // ── Share Button ──
                        _buildShareButton(isEn, isDark)
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 400.ms)
                            .slideY(begin: 0.05, end: 0),

                        const SizedBox(height: 24),

                        // ── Stats Card ──
                        _buildStatsCard(isEn, isDark)
                            .animate()
                            .fadeIn(delay: 300.ms, duration: 400.ms)
                            .slideY(begin: 0.05, end: 0),

                        const SizedBox(height: 16),

                        // ── Reward Progress Card ──
                        _buildRewardCard(isEn, isDark)
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 400.ms)
                            .slideY(begin: 0.05, end: 0),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HERO SECTION
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildHeroSection(bool isEn, bool isDark) {
    return Column(
      children: [
        ExcludeSemantics(
          child: Icon(
          Icons.card_giftcard_rounded,
          size: 56,
          color: AppColors.starGold.withValues(alpha: 0.85),
        ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(
              begin: const Offset(0.6, 0.6),
              end: const Offset(1.0, 1.0),
              curve: Curves.elasticOut,
              duration: 800.ms,
            ),
        const SizedBox(height: 12),
        Text(
          isEn
              ? 'Invite Friends, Earn Rewards'
              : 'Arkadaşlarını Davet Et, Ödüller Kazan',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        const SizedBox(height: 8),
        Text(
          isEn
              ? 'Share your referral code with friends. After 3 friends join, '
                'you unlock a free 7-day premium trial!'
              : 'Davet kodunu arkadaşlarınla paylaş. 3 arkadaş katıldıktan sonra '
                '7 günlük ücretsiz premium deneme kazan!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
            height: 1.4,
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REFERRAL CODE CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildCodeCard(bool isEn, bool isDark) {
    final code = _stats?.myCode ?? '--------';

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.vpn_key_rounded,
                color: AppColors.starGold,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                isEn ? 'Your Referral Code' : 'Davet Kodun',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Code display ──
          Center(
            child: GestureDetector(
              onTap: _copyCode,
              child: Semantics(
                button: true,
                label: isEn
                    ? 'Copy referral code $code'
                    : 'Davet kodunu kopyala $code',
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.04),
                    border: Border.all(
                      color: _codeCopied
                          ? AppColors.success.withValues(alpha: 0.6)
                          : AppColors.starGold.withValues(alpha: 0.3),
                      width: _codeCopied ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        code,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                          color: AppColors.starGold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        _codeCopied
                            ? Icons.check_circle_rounded
                            : Icons.copy_rounded,
                        size: 20,
                        color: _codeCopied
                            ? AppColors.success
                            : AppColors.starGold.withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              _codeCopied
                  ? (isEn ? 'Copied!' : 'Kopyalandı!')
                  : (isEn ? 'Tap to copy' : 'Kopyalamak için dokun'),
              style: TextStyle(
                fontSize: 13,
                color: _codeCopied
                    ? AppColors.success
                    : (isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SHARE BUTTON
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildShareButton(bool isEn, bool isDark) {
    return Semantics(
      button: true,
      label: isEn ? 'Share invite link' : 'Davet linkini paylaş',
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          _shareInvite(isEn);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [AppColors.auroraStart, AppColors.auroraEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.auroraStart.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.share_rounded, size: 20, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                isEn ? 'Share Invite Link' : 'Davet Linkini Paylaş',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STATS CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildStatsCard(bool isEn, bool isDark) {
    final stats = _stats;

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart_rounded,
                color: AppColors.auroraStart,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                isEn ? 'Referral Stats' : 'Davet İstatistikleri',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Stat rows ──
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.send_rounded,
                  value: '${stats?.totalInvitesSent ?? 0}',
                  label: isEn ? 'Invites Sent' : 'Gönderilen',
                  color: AppColors.auroraStart,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  icon: Icons.people_rounded,
                  value: '${stats?.successfulReferrals ?? 0}',
                  label: isEn ? 'Joined' : 'Katıldı',
                  color: AppColors.success,
                  isDark: isDark,
                ),
              ),
            ],
          ),

          if (stats?.referredBy != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.success.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isEn
                          ? 'You were referred by: ${stats!.referredBy}'
                          : 'Seni davet eden: ${stats!.referredBy}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REWARD PROGRESS CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildRewardCard(bool isEn, bool isDark) {
    final stats = _stats;
    final progress = stats?.rewardProgress ?? 0.0;
    final isActive = stats?.isRewardActive ?? false;
    final isGranted = stats?.rewardGranted ?? false;
    final daysLeft = stats?.rewardDaysRemaining ?? 0;
    final remaining = stats?.referralsRemaining ?? ReferralService.requiredReferrals;

    return GlassPanel(
      elevation: GlassElevation.g3,
      padding: const EdgeInsets.all(20),
      glowColor: isActive
          ? AppColors.starGold.withValues(alpha: 0.15)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            children: [
              Icon(
                isActive
                    ? Icons.stars_rounded
                    : Icons.emoji_events_rounded,
                color: AppColors.starGold,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _rewardHeadline(isEn, isActive, isGranted),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _rewardSubtitle(isEn, isActive, isGranted, daysLeft, remaining),
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // ── Progress bar ──
          Semantics(
            label: isEn
                ? 'Reward progress: ${stats?.successfulReferrals ?? 0} of ${ReferralService.requiredReferrals} referrals, ${(progress * 100).round()} percent'
                : 'Ödül ilerlemesi: ${ReferralService.requiredReferrals} davetten ${stats?.successfulReferrals ?? 0} tamamlandı, yüzde ${(progress * 100).round()}',
            child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation<Color>(
                isActive ? AppColors.starGold : AppColors.auroraStart,
              ),
            ),
          ),
          ),
          const SizedBox(height: 8),

          // ── Progress label ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${stats?.successfulReferrals ?? 0}/${ReferralService.requiredReferrals}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              if (isActive)
                Semantics(
                  label: isEn
                      ? '$daysLeft days left on trial'
                      : 'Denemede $daysLeft gün kaldı',
                  child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.starGold.withValues(alpha: 0.15),
                    border: Border.all(
                      color: AppColors.starGold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    isEn ? '$daysLeft days left' : '$daysLeft gün kaldı',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.starGold,
                    ),
                  ),
                ),
                ),
            ],
          ),

          // ── Step indicators ──
          if (!isGranted) ...[
            const SizedBox(height: 16),
            _buildStepIndicators(isEn, isDark, stats),
          ],
        ],
      ),
    );
  }

  Widget _buildStepIndicators(bool isEn, bool isDark, ReferralStats? stats) {
    final successful = stats?.successfulReferrals ?? 0;

    return Row(
      children: List.generate(ReferralService.requiredReferrals, (index) {
        final isCompleted = index < successful;
        final isCurrent = index == successful;
        return Expanded(
          child: Semantics(
            label: isEn
                ? 'Friend ${index + 1}: ${isCompleted ? 'completed' : (isCurrent ? 'current step' : 'pending')}'
                : 'Arkadaş ${index + 1}: ${isCompleted ? 'tamamlandı' : (isCurrent ? 'mevcut adım' : 'bekliyor')}',
            child: Padding(
            padding: EdgeInsets.only(
              right: index < ReferralService.requiredReferrals - 1 ? 8 : 0,
            ),
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.success
                        : (isCurrent
                              ? AppColors.auroraStart.withValues(alpha: 0.2)
                              : (isDark
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : Colors.black.withValues(alpha: 0.04))),
                    border: Border.all(
                      color: isCompleted
                          ? AppColors.success
                          : (isCurrent
                                ? AppColors.auroraStart.withValues(alpha: 0.5)
                                : (isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.black.withValues(alpha: 0.08))),
                      width: isCurrent ? 1.5 : 1,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: Colors.white,
                          )
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isCurrent
                                  ? AppColors.auroraStart
                                  : (isDark
                                        ? AppColors.textMuted
                                        : AppColors.lightTextMuted),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEn ? 'Friend ${index + 1}' : 'Arkadaş ${index + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isCompleted
                        ? AppColors.success
                        : (isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted),
                    fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          ),
        );
      }),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TEXT HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  String _rewardHeadline(bool isEn, bool isActive, bool isGranted) {
    if (isActive) {
      return isEn ? 'Premium Trial Active!' : 'Premium Deneme Aktif!';
    }
    if (isGranted) {
      return isEn ? 'Trial Expired' : 'Deneme Süresi Doldu';
    }
    return isEn ? 'Premium Trial Reward' : 'Premium Deneme Ödülü';
  }

  String _rewardSubtitle(
    bool isEn,
    bool isActive,
    bool isGranted,
    int daysLeft,
    int remaining,
  ) {
    if (isActive) {
      return isEn
          ? 'Enjoy all premium features! $daysLeft days remaining on your trial.'
          : 'Tüm premium özelliklerin tadını çıkar! Denemenizde $daysLeft gün kaldı.';
    }
    if (isGranted) {
      return isEn
          ? 'Your trial has ended. Upgrade to keep premium features.'
          : 'Denemeniz sona erdi. Premium özellikleri korumak için yükselt.';
    }
    return isEn
        ? 'Invite $remaining more friends to unlock a free ${ReferralService.rewardTrialDays}-day premium trial. No subscription required.'
        : '$remaining arkadaş daha davet et ve ${ReferralService.rewardTrialDays} günlük ücretsiz premium deneme kazan. Abonelik gerektirmez.';
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STAT TILE (private widget)
// ════════════════════════════════════════════════════════════════════════════

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          ExcludeSemantics(child: Icon(icon, size: 22, color: color)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
