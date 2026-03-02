import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/tap_scale.dart';

class AttachmentQuizBanner extends ConsumerStatefulWidget {
  final bool isEn;
  final bool isDark;

  const AttachmentQuizBanner({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  ConsumerState<AttachmentQuizBanner> createState() =>
      _AttachmentQuizBannerState();
}

class _AttachmentQuizBannerState extends ConsumerState<AttachmentQuizBanner> {
  static const _dismissKey = 'attachment_quiz_banner_dismissed';
  bool _dismissed = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _checkDismissed();
  }

  Future<void> _checkDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _dismissed = prefs.getBool(_dismissKey) ?? false;
        _loaded = true;
      });
    }
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dismissKey, true);
    if (mounted) setState(() => _dismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _dismissed) return const SizedBox.shrink();

    final serviceAsync = ref.watch(attachmentStyleServiceProvider);

    return serviceAsync.maybeWhen(
      data: (service) {
        // Don't show if quiz already completed
        if (service.quizCount > 0) return const SizedBox.shrink();

        // Only show if user has enough entries for context
        final journalAsync = ref.watch(journalServiceProvider);
        return journalAsync.maybeWhen(
          data: (jService) {
            if (jService.entryCount < 10) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.amethyst.withValues(alpha: 0.12),
                      AppColors.auroraStart.withValues(alpha: 0.08),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.amethyst.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('🔗', style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.isEn
                                ? 'Know Your Attachment Style'
                                : 'Bağlanma Stilini Keşfet',
                            style: AppTypography.modernAccent(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: widget.isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        TapScale(
                          onTap: () {
                            HapticService.selectionTap();
                            _dismiss();
                          },
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: widget.isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.isEn
                          ? '2-minute quiz — understand how you connect with others'
                          : '2 dakikalık test — başkalarıyla nasıl bağlandığını anla',
                      style: AppTypography.subtitle(
                        fontSize: 12,
                        color: widget.isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TapScale(
                      onTap: () {
                        HapticService.buttonPress();
                        context.push(Routes.attachmentQuiz);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.amethyst.withValues(alpha: 0.15),
                        ),
                        child: Center(
                          child: Text(
                            widget.isEn ? 'Take the Quiz' : 'Teste Başla',
                            style: AppTypography.modernAccent(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.amethyst,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
