// ════════════════════════════════════════════════════════════════════════════
// LIBRARY HUB SCREEN - All content archives in one place
// ════════════════════════════════════════════════════════════════════════════
// Categories: Journal, Dreams, Gratitude, Analysis, Challenges,
// Quizzes, Export, Favorites
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';

class LibraryHubScreen extends ConsumerWidget {
  const LibraryHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    final categories = [
      _LibraryCategory(
        emoji: '\u{1F4D3}',
        nameEn: 'Journal Archive',
        nameTr: 'G\u00fcnl\u00fck Ar\u015fivi',
        route: Routes.journalArchive,
      ),
      _LibraryCategory(
        emoji: '\u{1F319}',
        nameEn: 'Dream Archive',
        nameTr: 'R\u00fcya Ar\u015fivi',
        route: Routes.dreamArchive,
      ),
      _LibraryCategory(
        emoji: '\u{1F64F}',
        nameEn: 'Gratitude Archive',
        nameTr: '\u015e\u00fckran Ar\u015fivi',
        route: Routes.gratitudeArchive,
      ),
      _LibraryCategory(
        emoji: '\u{1F4CA}',
        nameEn: 'Patterns & Analysis',
        nameTr: 'Analiz & \u00d6r\u00fcnt\u00fc',
        route: Routes.journalPatterns,
      ),
      _LibraryCategory(
        emoji: '\u{1F3C6}',
        nameEn: 'Challenges',
        nameTr: 'G\u00f6revler',
        route: Routes.challenges,
      ),
      _LibraryCategory(
        emoji: '\u{1F9E9}',
        nameEn: 'Quiz Results',
        nameTr: 'Test Sonu\u00e7lar\u0131',
        route: Routes.quizHub,
      ),
      _LibraryCategory(
        emoji: '\u{1F4C5}',
        nameEn: 'Calendar View',
        nameTr: 'Takvim G\u00f6r\u00fcn\u00fcm\u00fc',
        route: Routes.calendarHeatmap,
      ),
      _LibraryCategory(
        emoji: '\u{1F4E5}',
        nameEn: 'Export Data',
        nameTr: 'Veri D\u0131\u015fa Aktar',
        route: Routes.exportData,
      ),
    ];

    return Scaffold(
      body: CosmicBackground(
        child: CupertinoScrollbar(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Library' : 'K\u00fct\u00fcphane',
                showBackButton: false,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Header text
                    Text(
                      isEn
                          ? 'Your personal data vault'
                          : 'Ki\u015fisel veri kasan',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingXl),

                    // Category cards
                    ...categories.asMap().entries.map((entry) {
                      final index = entry.key;
                      final cat = entry.value;
                      return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppConstants.spacingSm,
                            ),
                            child: _CategoryCard(
                              category: cat,
                              isDark: isDark,
                              isEn: isEn,
                            ),
                          )
                          .animate()
                          .fadeIn(
                            delay: Duration(milliseconds: 100 + index * 60),
                            duration: 400.ms,
                          )
                          .slideY(
                            begin: 0.03,
                            end: 0,
                            delay: Duration(milliseconds: 100 + index * 60),
                            duration: 400.ms,
                          );
                    }),

                    ToolEcosystemFooter(
                      currentToolId: 'libraryHub',
                      isEn: isEn,
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppConstants.spacingHuge),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LibraryCategory {
  final String emoji;
  final String nameEn;
  final String nameTr;
  final String route;
  const _LibraryCategory({
    required this.emoji,
    required this.nameEn,
    required this.nameTr,
    required this.route,
  });
}

class _CategoryCard extends StatelessWidget {
  final _LibraryCategory category;
  final bool isDark;
  final bool isEn;
  const _CategoryCard({
    required this.category,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isEn ? category.nameEn : category.nameTr,
      button: true,
      child: GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push(category.route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLg,
          vertical: AppConstants.spacingMd,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.75)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.04),
          ),
        ),
        child: Row(
          children: [
            Text(category.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: AppConstants.spacingLg),
            Expanded(
              child: Text(
                isEn ? category.nameEn : category.nameTr,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark
                  ? AppColors.textSecondary.withValues(alpha: 0.5)
                  : AppColors.lightTextMuted,
              size: 24,
            ),
          ],
        ),
      ),
    ),
    );
  }
}
