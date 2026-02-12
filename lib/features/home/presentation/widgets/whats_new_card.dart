// ════════════════════════════════════════════════════════════════════════════
// WHAT'S NEW CARD - Feature Discovery for Home Screen
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/providers/app_providers.dart';

/// Shows a dismissible "What's New" card highlighting recent features.
/// Dismissed state persisted per version.
class WhatsNewCard extends ConsumerStatefulWidget {
  const WhatsNewCard({super.key});

  @override
  ConsumerState<WhatsNewCard> createState() => _WhatsNewCardState();
}

class _WhatsNewCardState extends ConsumerState<WhatsNewCard> {
  static const String _currentVersion = 'v2.5';
  static const String _prefKey = 'whats_new_dismissed_';
  bool _dismissed = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _checkDismissed();
  }

  Future<void> _checkDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getBool('$_prefKey$_currentVersion') ?? false;
    if (mounted) {
      setState(() {
        _dismissed = dismissed;
        _loaded = true;
      });
    }
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefKey$_currentVersion', true);
    if (mounted) setState(() => _dismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _dismissed) return const SizedBox.shrink();

    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    final features = [
      (Icons.theater_comedy_outlined, isEn ? 'Archetype Tracker' : 'Arketip Takibi', Routes.archetype),
      (Icons.visibility_outlined, isEn ? 'Blind Spot Reveal' : 'Kör Nokta Keşfi', Routes.blindSpot),
      (Icons.air_outlined, isEn ? 'Breathing Exercises' : 'Nefes Egzersizleri', Routes.breathing),
      (Icons.psychology_outlined, isEn ? 'Attachment Quiz' : 'Bağlanma Testi', Routes.attachmentQuiz),
      (Icons.emoji_events_outlined, isEn ? 'Growth Challenges' : 'Büyüme Görevleri', Routes.challenges),
      (Icons.summarize_outlined, isEn ? 'Weekly Digest' : 'Haftalık Özet', Routes.weeklyDigest),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.cosmicPurple.withValues(alpha: 0.3),
                  AppColors.surfaceDark.withValues(alpha: 0.95),
                ]
              : [
                  AppColors.cosmicPurple.withValues(alpha: 0.08),
                  AppColors.lightCard,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cosmicPurple.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isEn ? "What's New" : 'Yenilikler',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _dismiss,
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: features.map((f) {
              final (icon, label, route) = f;
              return GestureDetector(
                onTap: () => context.push(route),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 14,
                        color: AppColors.auroraStart,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }
}
