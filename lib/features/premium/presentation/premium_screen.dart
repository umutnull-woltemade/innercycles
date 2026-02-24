import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/paywall_experiment_service.dart';
import '../../../data/services/paywall_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../data/services/url_launcher_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/gradient_text.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  PremiumTier _selectedTier = PremiumTier.yearly;
  bool _useRevenueCatPaywall = true;
  bool _isManagingSubscription = false;

  @override
  Widget build(BuildContext context) {
    final premiumState = ref.watch(premiumProvider);

    if (premiumState.isPremium) {
      return _buildPremiumActiveScreen(context, premiumState);
    }

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: AppConstants.spacingXl),

                  // Paywall toggle (debug only)
                  if (kDebugMode) ...[
                    _buildPaywallToggle(context),
                    const SizedBox(height: AppConstants.spacingMd),
                  ],

                  if (_useRevenueCatPaywall) ...[
                    _buildRevenueCatPaywallButton(context, premiumState),
                  ] else ...[
                    // Top features (reduced from 14 to 6)
                    _buildFeaturesList(context),
                    const SizedBox(height: AppConstants.spacingXl),

                    // Free vs Pro comparison table
                    _buildComparisonTable(context),
                    const SizedBox(height: AppConstants.spacingXl),

                    // Plan selection with anchoring
                    _buildPlanSelection(context),
                    const SizedBox(height: AppConstants.spacingXl),

                    // Purchase button
                    _buildPurchaseButton(context, premiumState),
                  ],

                  const SizedBox(height: AppConstants.spacingMd),

                  // Risk reversal
                  _buildRiskReversal(context),
                  const SizedBox(height: AppConstants.spacingMd),

                  // Restore purchases
                  _buildRestoreButton(context, premiumState),
                  const SizedBox(height: AppConstants.spacingLg),

                  // Terms
                  _buildTerms(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // HEADER — New conversion headline
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildHeader(BuildContext context) {
    final language = ref.watch(languageProvider);
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              tooltip: language == AppLanguage.en ? 'Close' : 'Kapat',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: AppColors.textPrimary),
            ),
            const Spacer(),
          ],
        ),
        Text(
          L10nService.get('app.name', language),
          style: AppTypography.elegantAccent(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.0,
            color: AppColors.starGold.withValues(alpha: 0.7),
          ),
        ).glassReveal(context: context),
        const SizedBox(height: 16),

        // New headline
        Text(
          L10nService.get('premium.paywall.title', language),
          textAlign: TextAlign.center,
          style: AppTypography.displayFont.copyWith(
            fontSize: 28,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: 0.3,
          ),
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 8),

        // New subtitle
        Text(
          L10nService.get('premium.paywall.subtitle', language),
          textAlign: TextAlign.center,
          style: AppTypography.decorativeScript(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // FEATURES LIST — Reduced to top 6
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildFeaturesList(BuildContext context) {
    final language = ref.watch(languageProvider);
    final features = PremiumTier.yearly.localizedFeatures(language);

    return GlassPanel(
      elevation: GlassElevation.g3,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      glowColor: AppColors.starGold.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nService.get('premium.cosmic_powers', language),
            style: AppTypography.elegantAccent(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.starGold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...features.map((feature) => _FeatureItem(feature: feature)),
        ],
      ),
    ).glassListItem(context: context, index: 1);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // COMPARISON TABLE — Free vs Pro
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildComparisonTable(BuildContext context) {
    final language = ref.watch(languageProvider);

    final rows = [
      _ComparisonRow(
        feature: L10nService.get(
          'premium.comparison.feature_journal',
          language,
        ),
        free: L10nService.get(
          'premium.comparison.feature_journal_free',
          language,
        ),
        pro: L10nService.get(
          'premium.comparison.feature_journal_pro',
          language,
        ),
      ),
      _ComparisonRow(
        feature: L10nService.get('premium.comparison.feature_dreams', language),
        free: L10nService.get(
          'premium.comparison.feature_dreams_free',
          language,
        ),
        pro: L10nService.get('premium.comparison.feature_dreams_pro', language),
        isHighlight: true,
      ),
      _ComparisonRow(
        feature: L10nService.get(
          'premium.comparison.feature_patterns',
          language,
        ),
        free: L10nService.get(
          'premium.comparison.feature_patterns_free',
          language,
        ),
        pro: L10nService.get(
          'premium.comparison.feature_patterns_pro',
          language,
        ),
        isHighlight: true,
      ),
      _ComparisonRow(
        feature: L10nService.get(
          'premium.comparison.feature_reports',
          language,
        ),
        free: L10nService.get(
          'premium.comparison.feature_reports_free',
          language,
        ),
        pro: L10nService.get(
          'premium.comparison.feature_reports_pro',
          language,
        ),
        isHighlight: true,
      ),
      _ComparisonRow(
        feature: L10nService.get('premium.comparison.feature_export', language),
        free: L10nService.get(
          'premium.comparison.feature_export_free',
          language,
        ),
        pro: L10nService.get('premium.comparison.feature_export_pro', language),
      ),
      _ComparisonRow(
        feature: L10nService.get('premium.comparison.feature_ads', language),
        free: L10nService.get('premium.comparison.feature_ads_free', language),
        pro: L10nService.get('premium.comparison.feature_ads_pro', language),
      ),
      _ComparisonRow(
        feature: L10nService.get(
          'premium.comparison.feature_programs',
          language,
        ),
        free: L10nService.get(
          'premium.comparison.feature_programs_free',
          language,
        ),
        pro: L10nService.get(
          'premium.comparison.feature_programs_pro',
          language,
        ),
      ),
    ];

    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        children: [
          Text(
            L10nService.get('premium.comparison.title', language),
            style: AppTypography.displayFont.copyWith(
              fontSize: 20,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),

          // Table header
          Row(
            children: [
              const Expanded(flex: 3, child: SizedBox()),
              Expanded(
                flex: 2,
                child: Text(
                  L10nService.get('premium.tiers.free.name', language),
                  textAlign: TextAlign.center,
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.starGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'PRO',
                    textAlign: TextAlign.center,
                    style: AppTypography.elegantAccent(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.starGold,
                      letterSpacing: 3.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Table rows
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      row.feature,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      row.free,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      row.pro,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: row.isHighlight
                            ? AppColors.starGold
                            : AppColors.textPrimary,
                        fontWeight: row.isHighlight
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // PLAN SELECTION — With price anchoring
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildPlanSelection(BuildContext context) {
    return Column(
      children: [
        // Yearly — target plan
        _PlanCard(
          tier: PremiumTier.yearly,
          isSelected: _selectedTier == PremiumTier.yearly,
          onTap: () => setState(() => _selectedTier = PremiumTier.yearly),
          isBestValue: true,
          priceOverride: ref
              .read(premiumProvider.notifier)
              .getProductPrice(PremiumTier.yearly),
        ),
        const SizedBox(height: AppConstants.spacingMd),

        // Monthly — decoy (variant-aware price)
        _PlanCard(
          tier: PremiumTier.monthly,
          isSelected: _selectedTier == PremiumTier.monthly,
          onTap: () => setState(() => _selectedTier = PremiumTier.monthly),
          priceOverride:
              ref
                  .watch(paywallExperimentProvider)
                  .whenOrNull(data: (e) => e.monthlyPriceLabel) ??
              ref
                  .read(premiumProvider.notifier)
                  .getProductPrice(PremiumTier.monthly),
        ),
      ],
    ).glassListItem(context: context, index: 2);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // PURCHASE BUTTON
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildPurchaseButton(BuildContext context, PremiumState premiumState) {
    final language = ref.watch(languageProvider);
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.starGold, AppColors.chartOrange],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AppColors.starGold.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Semantics(
          label: L10nService.get('premium.paywall.continue_pro', language),
          button: true,
          child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: premiumState.isLoading
                ? null
                : () async {
                    HapticFeedback.mediumImpact();
                    final success = await ref
                        .read(premiumProvider.notifier)
                        .purchasePremium(_selectedTier);
                    if (success && mounted) {
                      _showSuccessDialog();
                    }
                  },
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: premiumState.isLoading
                    ? const CosmicLoadingIndicator(size: 24)
                    : Column(
                        children: [
                          Text(
                            L10nService.get(
                              'premium.paywall.continue_pro',
                              language,
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_selectedTier == PremiumTier.yearly)
                            const SizedBox(height: 2),
                          if (_selectedTier == PremiumTier.yearly)
                            Text(
                              ref
                                      .read(premiumProvider.notifier)
                                      .getProductPrice(_selectedTier) ??
                                  _selectedTier.price,
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.6),
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        ),
      ),
    ).glassListItem(context: context, index: 3);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // RISK REVERSAL
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildRiskReversal(BuildContext context) {
    final language = ref.watch(languageProvider);
    return Text(
      L10nService.get('premium.risk_reversal', language),
      textAlign: TextAlign.center,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted, fontSize: 12),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // REVENUCAT PAYWALL (default mode)
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildRevenueCatPaywallButton(
    BuildContext context,
    PremiumState premiumState,
  ) {
    final language = ref.watch(languageProvider);
    return Column(
      children: [
        // Features preview (reduced)
        _buildFeaturesList(context),
        const SizedBox(height: AppConstants.spacingXl),

        // Comparison table
        _buildComparisonTable(context),
        const SizedBox(height: AppConstants.spacingXl),

        // Price anchor display
        _buildPriceAnchor(context),
        const SizedBox(height: AppConstants.spacingLg),

        // Show RevenueCat Paywall button
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.starGold, AppColors.chartOrange],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: AppColors.starGold.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Semantics(
              label: L10nService.get('premium.paywall.continue_pro', language),
              button: true,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: premiumState.isLoading
                      ? null
                      : () async {
                          HapticFeedback.mediumImpact();
                          final experiment = ref
                              .read(paywallExperimentProvider)
                              .whenOrNull(data: (e) => e);
                          experiment?.logPaywallView();

                          final result = await ref
                              .read(paywallServiceProvider)
                              .presentPaywall();
                          if (mounted && result == PaywallResult.purchased) {
                            experiment?.logPaywallConversion();
                            _showSuccessDialog();
                          } else {
                            experiment?.logPaywallDismissal();
                          }
                        },
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: premiumState.isLoading
                          ? const CosmicLoadingIndicator(size: 24)
                          : Text(
                              L10nService.get(
                                'premium.paywall.continue_pro',
                                language,
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ).glassListItem(context: context, index: 3),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // PRICE ANCHOR — crossed-out monthly + yearly equivalent
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildPriceAnchor(BuildContext context) {
    final language = ref.watch(languageProvider);
    final experiment = ref
        .watch(paywallExperimentProvider)
        .whenOrNull(data: (e) => e);

    // Use experiment variant price if available, else fall back to l10n
    final monthlyLabel =
        experiment?.monthlyPriceLabel ??
        L10nService.get('premium.price_monthly_crossed', language);
    final yearlyLabel = experiment != null
        ? '${experiment.yearlyMonthlyEquivalent} — ${L10nService.get('premium.price_anchor', language).split('—').last.trim()}'
        : L10nService.get('premium.price_anchor', language);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          monthlyLabel,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textMuted,
            decoration: TextDecoration.lineThrough,
            decorationColor: AppColors.textMuted,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.starGold.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.starGold.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            yearlyLabel,
            style: AppTypography.elegantAccent(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.starGold,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // PREMIUM ACTIVE SCREEN (for existing subscribers)
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildPremiumActiveScreen(
    BuildContext context,
    PremiumState premiumState,
  ) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const Spacer(),
                _buildPremiumActiveBadge(premiumState),
                const SizedBox(height: AppConstants.spacingXl),
                _buildPremiumStatus(context, premiumState),
                const SizedBox(height: AppConstants.spacingXl),
                _buildManageSubscriptionButton(context),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumActiveBadge(PremiumState premiumState) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.starGold.withValues(alpha: 0.4),
            AppColors.auroraStart.withValues(alpha: 0.4),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.starGold.withValues(alpha: 0.5),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.star_rounded, size: 72, color: AppColors.starGold),
          const SizedBox(height: 8),
          Text(
            premiumState.tier.displayName,
            style: AppTypography.elegantAccent(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.starGold,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    ).glassReveal(context: context);
  }

  Widget _buildPremiumStatus(BuildContext context, PremiumState premiumState) {
    final language = ref.watch(languageProvider);
    return GlassPanel(
      elevation: GlassElevation.g3,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      glowColor: AppColors.starGold.withValues(alpha: 0.2),
      child: Column(
        children: [
          Text(
            L10nService.get('premium.cosmic_powers_active', language),
            style: AppTypography.displayFont.copyWith(
              fontSize: 24,
              color: AppColors.starGold,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          if (premiumState.expiryDate != null)
            Text(
              '${L10nService.get('common.next', language)}: ${_formatDate(premiumState.expiryDate!)}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
        ],
      ),
    ).glassListItem(context: context, index: 1);
  }

  Widget _buildManageSubscriptionButton(BuildContext context) {
    final language = ref.watch(languageProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GradientOutlinedButton(
        label: L10nService.get('premium.manage_subscription', language),
        icon: Icons.settings,
        variant: GradientTextVariant.gold,
        expanded: true,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        onPressed: _isManagingSubscription
            ? null
            : () async {
                setState(() => _isManagingSubscription = true);
                try {
                  await ref
                      .read(paywallServiceProvider)
                      .presentCustomerCenter();
                } finally {
                  if (mounted) setState(() => _isManagingSubscription = false);
                }
              },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // ════════════════════════════════════════════════════════════════════════════
  // DEBUG TOGGLE
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildPaywallToggle(BuildContext context) {
    return GlassPanel(
      elevation: GlassElevation.g1,
      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          const Icon(Icons.science, color: AppColors.streakOrange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'RevenueCat Paywall',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.streakOrange),
            ),
          ),
          Switch(
            value: _useRevenueCatPaywall,
            onChanged: (value) => setState(() => _useRevenueCatPaywall = value),
            activeThumbColor: AppColors.streakOrange,
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // RESTORE + TERMS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildRestoreButton(BuildContext context, PremiumState premiumState) {
    final language = ref.watch(languageProvider);
    return TextButton(
      onPressed: premiumState.isLoading
          ? null
          : () async {
              final restored = await ref
                  .read(premiumProvider.notifier)
                  .restorePurchases();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      restored
                          ? L10nService.get(
                              'premium.purchases_restored',
                              language,
                            )
                          : L10nService.get(
                              'premium.no_purchases_found',
                              language,
                            ),
                    ),
                    backgroundColor: restored
                        ? AppColors.success
                        : AppColors.error,
                  ),
                );
              }
            },
      child: Text(
        L10nService.get('premium.restore_purchases', language),
        style: TextStyle(
          color: AppColors.textSecondary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildTerms(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      child: Column(
        children: [
          Text(
            L10nService.get('premium.terms_text', language),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: isEn ? 'Privacy Policy' : 'Gizlilik Politikası',
                link: true,
                child: GestureDetector(
                  onTap: () =>
                      ref.read(urlLauncherServiceProvider).openPrivacyPolicy(),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 44),
                    child: Center(
                      child: Text(
                        isEn
                            ? 'Privacy Policy'
                            : L10nService.get(
                                'settings.privacy_policy',
                                language,
                              ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.starGold,
                          fontSize: 11,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.starGold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '|',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ),
              Semantics(
                label: isEn ? 'Terms of Service' : 'Kullanım Şartları',
                link: true,
                child: GestureDetector(
                  onTap: () =>
                      ref.read(urlLauncherServiceProvider).openTermsOfService(),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 44),
                    child: Center(
                      child: Text(
                        isEn
                            ? 'Terms of Service'
                            : L10nService.get(
                                'settings.terms_of_service',
                                language,
                              ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.starGold,
                          fontSize: 11,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.starGold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // SUCCESS DIALOG
  // ════════════════════════════════════════════════════════════════════════════

  void _showSuccessDialog() {
    final language = ref.read(languageProvider);
    showDialog(
      context: context,
      builder: (_) => GlassDialog(
        title: L10nService.get('premium.cosmic_door_opened', language),
        content: L10nService.get('premium.success_message', language),
        gradientVariant: GradientTextVariant.gold,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dismiss dialog
              Future.microtask(() {
                if (context.mounted && Navigator.of(context).canPop()) {
                  Navigator.pop(context); // pop premium screen
                }
              });
            },
            child: Text(
              L10nService.get('common.start_journey', language),
              style: const TextStyle(
                color: AppColors.starGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SUPPORTING WIDGETS
// ════════════════════════════════════════════════════════════════════════════

class _ComparisonRow {
  final String feature;
  final String free;
  final String pro;
  final bool isHighlight;

  const _ComparisonRow({
    required this.feature,
    required this.free,
    required this.pro,
    this.isHighlight = false,
  });
}

class _FeatureItem extends StatelessWidget {
  final String feature;

  const _FeatureItem({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.starGold.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: AppColors.starGold, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: AppTypography.decorativeScript(
                fontSize: 15,
                color: AppColors.textPrimary,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final PremiumTier tier;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isBestValue;
  final String? priceOverride;

  const _PlanCard({
    required this.tier,
    required this.isSelected,
    required this.onTap,
    this.isBestValue = false,
    this.priceOverride,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GlassPanel(
          elevation: isSelected ? GlassElevation.g3 : GlassElevation.g2,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          padding: EdgeInsets.zero,
          glowColor: isSelected
              ? AppColors.starGold.withValues(alpha: 0.2)
              : null,
          child: Semantics(
            label: '${tier.displayName}${isSelected ? ' selected' : ''}',
            button: true,
            selected: isSelected,
            child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.starGold
                              : AppColors.textMuted,
                          width: 2,
                        ),
                        color: isSelected
                            ? AppColors.starGold
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.black,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tier.displayName,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: isSelected
                                      ? AppColors.starGold
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (tier.savings.isNotEmpty)
                            Text(
                              tier.savings,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.success),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          priceOverride ?? tier.price,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: isSelected
                                    ? AppColors.starGold
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        // Show monthly equivalent for yearly
                        if (tier == PremiumTier.yearly)
                          Text(
                            tier.monthlyEquivalent,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.starGold.withValues(
                                    alpha: 0.7,
                                  ),
                                  fontSize: 11,
                                ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ),
        ),
        if (isBestValue)
          Positioned(top: -10, right: 16, child: _BestValueBadge()),
      ],
    );
  }
}

class _BestValueBadge extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.starGold, AppColors.chartOrange],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        L10nService.get('premium.best_value', language),
        style: AppTypography.elegantAccent(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

// _LifetimeBadge removed — lifetime tier killed from UI
