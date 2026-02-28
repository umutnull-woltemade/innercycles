// ════════════════════════════════════════════════════════════════════════════
// TOOL ECOSYSTEM FOOTER - Related tools strip for tool screens
// ════════════════════════════════════════════════════════════════════════════
// Displays a horizontal strip of related tools at the bottom of tool screens.
// Uses ToolManifestRegistry for tool data. Lightweight, no async providers.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_typography.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/tool_manifest.dart';
import '../../data/services/ecosystem_analytics_service.dart';
import '../../data/services/smart_router_service.dart';
import '../../data/services/l10n_service.dart';
import '../../data/providers/app_providers.dart';

class ToolEcosystemFooter extends ConsumerWidget {
  final String currentToolId;
  final bool isEn;
  final bool isDark;

  const ToolEcosystemFooter({
    super.key,
    required this.currentToolId,
    required this.isEn,
    required this.isDark,
  });

  static const _categoryColors = <ToolCategory, Color>{
    ToolCategory.journal: AppColors.auroraStart,
    ToolCategory.analysis: AppColors.amethyst,
    ToolCategory.discovery: AppColors.brandPink,
    ToolCategory.support: AppColors.success,
    ToolCategory.reference: AppColors.starGold,
    ToolCategory.data: AppColors.auroraEnd,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manifest = ToolManifestRegistry.findById(currentToolId);
    if (manifest == null) return const SizedBox.shrink();

    final relatedTools = manifest.relatedToolIds
        .map((id) => ToolManifestRegistry.findById(id))
        .whereType<ToolManifest>()
        .take(5)
        .toList();

    if (relatedTools.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.spacingXl),
        Divider(
          color: isDark
              ? AppColors.textMuted.withValues(alpha: 0.15)
              : AppColors.lightTextMuted.withValues(alpha: 0.15),
          height: 1,
        ),
        const SizedBox(height: AppConstants.spacingLg),
        Text(
          L10nService.get('shared.tool_ecosystem_footer.related_tools', isEn ? AppLanguage.en : AppLanguage.tr),
          style: AppTypography.displayFont.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: relatedTools.length,
            itemBuilder: (context, index) {
              final tool = relatedTools[index];
              final color =
                  _categoryColors[tool.category] ?? AppColors.auroraStart;
              return Padding(
                    padding: EdgeInsets.only(
                      right: index < relatedTools.length - 1 ? 10 : 0,
                    ),
                    child: Semantics(
                      button: true,
                      label: isEn ? tool.nameEn : tool.nameTr,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          ref
                              .read(ecosystemAnalyticsServiceProvider)
                              .whenData(
                                (s) => s.trackNextToolTap(
                                  currentToolId,
                                  tool.id,
                                  'footer',
                                ),
                              );
                          ref
                              .read(smartRouterServiceProvider)
                              .whenData((s) => s.recordToolVisit(tool.id));
                          context.push(tool.route);
                        },
                        child: Container(
                          width: 120,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? color.withValues(alpha: 0.08)
                                : color.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusMd,
                            ),
                            border: Border.all(
                              color: color.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tool.icon,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const Spacer(),
                              Text(
                                isEn ? tool.nameEn : tool.nameTr,
                                style: AppTypography.modernAccent(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .animate(delay: Duration(milliseconds: 50 * index))
                  .fadeIn(duration: 300.ms);
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
  }
}
