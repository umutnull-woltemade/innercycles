// ════════════════════════════════════════════════════════════════════════════
// SHARE INSIGHT BUTTON - Reusable button to share any insight text
// ════════════════════════════════════════════════════════════════════════════
// Takes an insight text, renders it via patternWisdom share card template,
// and opens ShareCardSheet.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../data/content/share_card_templates.dart';
import '../../data/providers/app_providers.dart';
import '../../data/services/haptic_service.dart';
import 'share_card_sheet.dart';

class ShareInsightButton extends ConsumerWidget {
  final String insightText;
  final double iconSize;

  const ShareInsightButton({
    super.key,
    required this.insightText,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: isEn ? 'Share this insight' : 'Bu içgörüyü paylaş',
      button: true,
      child: GestureDetector(
        onTap: () {
          HapticService.buttonPress();
          final template = ShareCardTemplates.patternWisdom;
          final cardData = ShareCardTemplates.buildData(
            template: template,
            isEn: isEn,
            patternInsightText: insightText,
          );
          ShareCardSheet.show(
            context,
            template: template,
            data: cardData,
            isEn: isEn,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.04),
          ),
          child: Icon(
            Icons.share_rounded,
            size: iconSize,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ),
    );
  }
}
