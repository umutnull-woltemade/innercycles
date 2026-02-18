// ════════════════════════════════════════════════════════════════════════════
// AFFIRMATION CARD - Daily Affirmation Widget for Home Screen
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/affirmation_service.dart';

class AffirmationCard extends ConsumerStatefulWidget {
  const AffirmationCard({super.key});

  @override
  ConsumerState<AffirmationCard> createState() => _AffirmationCardState();
}

class _AffirmationCardState extends ConsumerState<AffirmationCard> {
  Affirmation? _currentAffirmation;
  bool _isFavorite = false;
  bool _showHeartBurst = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(affirmationServiceProvider);

    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        _currentAffirmation ??= service.getDailyAffirmation();
        final affirmation = _currentAffirmation;
        if (affirmation == null) return const SizedBox.shrink();
        _isFavorite = service.isFavorite(affirmation.id);

        return Semantics(
          label: isEn
              ? 'Daily Affirmation: ${affirmation.textEn}. Tap for next'
              : 'Günün Olumlaması: ${affirmation.textTr}. Sonraki için dokun',
          button: true,
          child: GestureDetector(
          onTap: () => _onTap(service),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.auroraStart.withValues(alpha: 0.2),
                        AppColors.auroraEnd.withValues(alpha: 0.15),
                        AppColors.surfaceDark.withValues(alpha: 0.9),
                      ]
                    : [
                        AppColors.lightAuroraStart.withValues(alpha: 0.08),
                        AppColors.lightAuroraEnd.withValues(alpha: 0.06),
                        AppColors.lightCard,
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.auroraStart.withValues(alpha: 0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.auroraStart.withValues(alpha: isDark ? 0.1 : 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Subtle glow effect in the top right
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.auroraStart.withValues(alpha: isDark ? 0.15 : 0.08),
                          AppColors.auroraStart.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row: icon + title + favorite button
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.auroraStart.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: isDark
                                ? AppColors.auroraStart
                                : AppColors.lightAuroraStart,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isEn ? 'Daily Affirmation' : 'Günün Olumlaması',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        // Favorite toggle
                        Semantics(
                          label: _isFavorite
                              ? (isEn ? 'Remove from favorites' : 'Favorilerden kaldır')
                              : (isEn ? 'Add to favorites' : 'Favorilere ekle'),
                          button: true,
                          toggled: _isFavorite,
                          child: GestureDetector(
                          onTap: () => _toggleFavorite(service, affirmation.id),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              _isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              key: ValueKey(_isFavorite),
                              color: _isFavorite
                                  ? AppColors.sunriseEnd
                                  : (isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted),
                              size: 22,
                            ),
                          ),
                        ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Affirmation text
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.1),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        isEn ? affirmation.textEn : affirmation.textTr,
                        key: ValueKey(affirmation.id),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.2,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Bottom row: category label + tap hint
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _categoryColor(affirmation.category)
                                .withValues(alpha: isDark ? 0.15 : 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _categoryColor(affirmation.category)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _categoryIcon(affirmation.category),
                                size: 12,
                                color: _categoryColor(affirmation.category),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isEn
                                    ? affirmation.category.displayNameEn
                                    : affirmation.category.displayNameTr,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: _categoryColor(affirmation.category),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tap hint
                        Text(
                          isEn ? 'Tap for more' : 'Daha fazlası için dokun',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textMuted.withValues(alpha: 0.6)
                                : AppColors.lightTextMuted.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Heart burst animation overlay
                if (_showHeartBurst)
                  Positioned.fill(
                    child: Center(
                      child: Icon(
                        Icons.favorite_rounded,
                        color: AppColors.sunriseEnd.withValues(alpha: 0.6),
                        size: 48,
                      )
                          .animate()
                          .scale(
                            begin: const Offset(0.5, 0.5),
                            end: const Offset(1.5, 1.5),
                            duration: 400.ms,
                            curve: Curves.easeOut,
                          )
                          .fadeOut(
                            delay: 200.ms,
                            duration: 300.ms,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.08, duration: 500.ms);
      },
    );
  }

  void _onTap(AffirmationService service) {
    HapticFeedback.lightImpact();

    // Cycle through affirmations in the same category
    final current = _currentAffirmation;
    if (current == null) return;
    final categoryAffirmations = service.getAllByCategory(current.category);
    final currentIndex = categoryAffirmations.indexWhere((a) => a.id == current.id);
    final nextIndex = (currentIndex + 1) % categoryAffirmations.length;

    setState(() {
      _currentAffirmation = categoryAffirmations[nextIndex];
    });
  }

  Future<void> _toggleFavorite(AffirmationService service, String id) async {
    HapticFeedback.mediumImpact();
    final newState = await service.toggleFavorite(id);
    if (!mounted) return;
    setState(() {
      _isFavorite = newState;
      if (newState) {
        _showHeartBurst = true;
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) setState(() => _showHeartBurst = false);
        });
      }
    });
  }

  Color _categoryColor(AffirmationCategory category) {
    switch (category) {
      case AffirmationCategory.selfWorth:
        return AppColors.starGold;
      case AffirmationCategory.growth:
        return AppColors.success;
      case AffirmationCategory.resilience:
        return AppColors.sunriseEnd;
      case AffirmationCategory.connection:
        return AppColors.brandPink;
      case AffirmationCategory.calm:
        return AppColors.auroraStart;
      case AffirmationCategory.purpose:
        return AppColors.amethyst;
    }
  }

  IconData _categoryIcon(AffirmationCategory category) {
    switch (category) {
      case AffirmationCategory.selfWorth:
        return Icons.star_rounded;
      case AffirmationCategory.growth:
        return Icons.eco_rounded;
      case AffirmationCategory.resilience:
        return Icons.shield_rounded;
      case AffirmationCategory.connection:
        return Icons.favorite_rounded;
      case AffirmationCategory.calm:
        return Icons.spa_rounded;
      case AffirmationCategory.purpose:
        return Icons.explore_rounded;
    }
  }
}
