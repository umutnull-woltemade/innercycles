import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/referral_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class ReferralScreen extends ConsumerStatefulWidget {
  final String? initialCode;

  const ReferralScreen({super.key, this.initialCode});

  @override
  ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends ConsumerState<ReferralScreen> {
  final _codeController = TextEditingController();
  bool _isApplying = false;
  String? _applyMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialCode != null && widget.initialCode!.isNotEmpty) {
      _codeController.text = widget.initialCode!;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _applyCode(ReferralService service, bool isEn) async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isApplying = true;
      _applyMessage = null;
    });

    final result = await service.applyCode(code);

    if (!mounted) return;
    setState(() {
      _isApplying = false;
      switch (result) {
        case ReferralResult.success:
          _applyMessage = isEn
              ? 'Code applied! You earned 7 days of Premium.'
              : 'Kod uygulandı! 7 gün Premium kazandın.';
          _codeController.clear();
          HapticService.featureUnlocked();
        case ReferralResult.ownCode:
          _applyMessage = isEn
              ? 'You can\'t use your own code.'
              : 'Kendi kodunu kullanamazsın.';
        case ReferralResult.alreadyUsed:
          _applyMessage = isEn
              ? 'You\'ve already used a referral code.'
              : 'Zaten bir davet kodu kullandın.';
        case ReferralResult.invalidCode:
          _applyMessage = isEn
              ? 'That code didn\'t work. Please double-check and try again.'
              : 'Bu kod çalışmadı. Lütfen kontrol edip tekrar dene.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = ref.watch(languageProvider) == AppLanguage.en;
    final referralAsync = ref.watch(referralServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: CupertinoScrollbar(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Invite Friends' : 'Arkadaşlarını Davet Et',
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                sliver: referralAsync.when(
                  loading: () => const SliverToBoxAdapter(
                    child: Center(child: CupertinoActivityIndicator()),
                  ),
                  error: (_, _) => const SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  ),
                  data: (service) => SliverList(
                    delegate: SliverChildListDelegate([
                      // Hero header
                      _buildHeroHeader(isEn, isDark),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Your code card
                      _buildYourCodeCard(service, isEn, isDark),
                      const SizedBox(height: AppConstants.spacingLg),

                      // Share button
                      _buildShareButton(service, isEn)
                          .glassListItem(context: context, index: 2),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Stats
                      _buildStatsRow(service, isEn, isDark)
                          .glassListItem(context: context, index: 3),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Milestones
                      _buildMilestones(service, isEn, isDark)
                          .glassListItem(context: context, index: 4),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Enter a code
                      _buildEnterCodeSection(service, isEn, isDark)
                          .glassListItem(context: context, index: 5),
                      const SizedBox(height: AppConstants.spacingHuge),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(bool isEn, bool isDark) {
    return Column(
      children: [
        AppSymbol('\u{1F381}', size: AppSymbolSize.xl)
            .animate()
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1, 1),
              duration: 600.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: 300.ms),
        const SizedBox(height: AppConstants.spacingMd),
        GradientText(
          isEn ? 'Give 7 Days, Get 7 Days' : '7 Gün Ver, 7 Gün Kazan',
          variant: GradientTextVariant.gold,
          style: AppTypography.displayFont.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
        const SizedBox(height: 8),
        Text(
          isEn
              ? 'Share your code with friends. When they join,\nyou both get 7 days of Premium free.'
              : 'Kodunu arkadaşlarınla paylaş. Katıldıklarında\nikinizie de 7 gün Premium hediye.',
          textAlign: TextAlign.center,
          style: AppTypography.decorativeScript(
            fontSize: 14,
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
          ),
        ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
      ],
    );
  }

  Widget _buildYourCodeCard(ReferralService service, bool isEn, bool isDark) {
    return PremiumCard(
      style: PremiumCardStyle.gold,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            isEn ? 'Your Invite Code' : 'Davet Kodun',
            style: AppTypography.elegantAccent(
              fontSize: 12,
              letterSpacing: 2,
              color: AppColors.starGold,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: service.myCode));
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isEn ? 'Referral code copied — share it with a friend' : 'Davet kodu kopyalandı — bir arkadaşınla paylaş'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  service.myCode,
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.copy_rounded,
                  size: 20,
                  color: AppColors.starGold.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEn ? 'Tap to copy' : 'Kopyalamak için dokun',
            style: AppTypography.subtitle(
              fontSize: 11,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn(duration: 400.ms).slideY(
          begin: 0.1,
          end: 0,
          duration: 400.ms,
        );
  }

  Widget _buildShareButton(ReferralService service, bool isEn) {
    return GradientButton.gold(
      label: isEn ? 'Share Invite Link' : 'Davet Linkini Paylaş',
      icon: Icons.share_rounded,
      expanded: true,
      onPressed: () {
        HapticFeedback.lightImpact();
        SharePlus.instance.share(
          ShareParams(text: service.shareText(isEn: isEn)),
        );
      },
    );
  }

  Widget _buildStatsRow(ReferralService service, bool isEn, bool isDark) {
    final info = service.info;
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        children: [
          _StatCell(
            value: '${info.referralCount}',
            label: isEn ? 'Friends Invited' : 'Davet Edilen',
            isDark: isDark,
          ),
          _divider(isDark),
          _StatCell(
            value: '${info.rewardDaysEarned}',
            label: isEn ? 'Days Earned' : 'Kazanılan Gün',
            isDark: isDark,
          ),
          _divider(isDark),
          _StatCell(
            value: info.hasActiveReward ? '${info.daysRemaining}d' : '—',
            label: isEn ? 'Days Left' : 'Kalan Gün',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Container(
      width: 0.5,
      height: 32,
      color: (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
          .withValues(alpha: 0.3),
    );
  }

  Widget _buildMilestones(ReferralService service, bool isEn, bool isDark) {
    final count = service.referralCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          isEn ? 'Milestones' : 'Kilometre Taşları',
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        _MilestoneRow(
          emoji: '\u{2B50}',
          title: isEn ? '3 Friends' : '3 Arkadaş',
          subtitle: isEn ? '1 Month Free Premium' : '1 Ay Ücretsiz Premium',
          achieved: count >= 3,
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _MilestoneRow(
          emoji: '\u{1F48E}',
          title: isEn ? '10 Friends' : '10 Arkadaş',
          subtitle: isEn ? 'Lifetime Premium' : 'Ömür Boyu Premium',
          achieved: count >= 10,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildEnterCodeSection(
    ReferralService service,
    bool isEn,
    bool isDark,
  ) {
    if (service.hasAppliedCode) {
      return PremiumCard(
        style: PremiumCardStyle.subtle,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const AppSymbol('\u{2705}', size: AppSymbolSize.sm),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isEn
                    ? 'You\'ve already used a referral code.'
                    : 'Zaten bir davet kodu kullandın.',
                style: AppTypography.subtitle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          isEn ? 'Have a Code?' : 'Kodun Var Mı?',
          variant: GradientTextVariant.amethyst,
          style: AppTypography.elegantAccent(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        PremiumCard(
          style: PremiumCardStyle.subtle,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                maxLength: 8,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: isEn ? 'Paste your referral code' : 'Davet kodunu yapıştır',
                  hintStyle: AppTypography.subtitle(
                    fontSize: 18,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.amethyst.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.amethyst,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GradientButton.gold(
                label: _isApplying
                    ? (isEn ? 'Applying...' : 'Uygulanıyor...')
                    : (isEn ? 'Apply Code' : 'Kodu Uygula'),
                expanded: true,
                onPressed:
                    _isApplying ? null : () => _applyCode(service, isEn),
              ),
              if (_applyMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _applyMessage!,
                  textAlign: TextAlign.center,
                  style: AppTypography.subtitle(
                    fontSize: 13,
                    color: _applyMessage!.contains('!')
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;

  const _StatCell({
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.displayFont.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.starGold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.subtitle(
              fontSize: 11,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool achieved;
  final bool isDark;

  const _MilestoneRow({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.achieved,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: achieved ? PremiumCardStyle.gold : PremiumCardStyle.subtle,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          AppSymbol(emoji, size: AppSymbolSize.md),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.subtitle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: AppTypography.subtitle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (achieved)
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 22,
            )
          else
            Icon(
              Icons.lock_outline_rounded,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              size: 20,
            ),
        ],
      ),
    );
  }
}
