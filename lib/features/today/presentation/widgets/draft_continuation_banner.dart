import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/tap_scale.dart';

/// Shows a banner when the user has an unsaved journal draft,
/// encouraging them to continue where they left off.
class DraftContinuationBanner extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const DraftContinuationBanner({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  static const _draftKey = 'journal_draft';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if today's entry already exists — if so, draft is stale
    final todayEntry = ref.watch(todayJournalEntryProvider);
    final hasEntryToday = todayEntry.whenOrNull(data: (e) => e != null) ?? false;
    if (hasEntryToday) return const SizedBox.shrink();

    return FutureBuilder<Map<String, dynamic>?>(
      future: _loadDraft(),
      builder: (context, snap) {
        final draft = snap.data;
        if (draft == null) return const SizedBox.shrink();

        final note = draft['note'] as String? ?? '';
        final hasContent = note.trim().isNotEmpty;

        if (!hasContent) return const SizedBox.shrink();

        final preview = note.length > 60 ? '${note.substring(0, 60)}...' : note;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () {
              HapticFeedback.lightImpact();
              context.push(Routes.journal);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.starGold.withValues(alpha: 0.06)
                    : AppColors.starGold.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.starGold.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.starGold.withValues(alpha: 0.12),
                    ),
                    child: Icon(
                      Icons.edit_note_rounded,
                      size: 20,
                      color: AppColors.starGold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn
                              ? 'Continue Your Entry'
                              : 'Girişine Devam Et',
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '"$preview"',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.decorativeScript(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, duration: 300.ms);
      },
    );
  }

  static Future<Map<String, dynamic>?> _loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_draftKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final draft = json.decode(jsonStr) as Map<String, dynamic>;
      return draft;
    } catch (_) {
      return null;
    }
  }
}
