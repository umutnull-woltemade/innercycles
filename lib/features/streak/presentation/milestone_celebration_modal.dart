import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/streak_service.dart';
import '../../../data/services/instagram_share_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/providers/app_providers.dart';

/// Full-screen celebration modal for streak milestones (D3, D7, D14, etc.)
class MilestoneCelebrationModal extends StatefulWidget {
  final int streakDays;
  final bool isEn;

  const MilestoneCelebrationModal({
    super.key,
    required this.streakDays,
    required this.isEn,
  });

  /// Show the celebration modal. Call after saving an entry.
  static void show(BuildContext context, int days, bool isEn) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (_) => MilestoneCelebrationModal(
        streakDays: days,
        isEn: isEn,
      ),
    );
  }

  @override
  State<MilestoneCelebrationModal> createState() =>
      _MilestoneCelebrationModalState();
}

class _MilestoneCelebrationModalState extends State<MilestoneCelebrationModal> {
  final _boundaryKey = GlobalKey();
  bool _isSharing = false;

  int get streakDays => widget.streakDays;
  bool get isEn => widget.isEn;

  Future<void> _shareCard() async {
    setState(() => _isSharing = true);
    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      await InstagramShareService.shareCosmicContent(
        boundary: boundary,
        shareText: isEn
            ? '$streakDays-day journaling streak! \u{1F525} — InnerCycles\n\nDiscover your patterns: ${AppConstants.appStoreUrl}'
            : '$streakDays günlük yazma serisi! \u{1F525} — InnerCycles\n\nÖrüntülerini keşfet: ${AppConstants.appStoreUrl}',
        hashtags: '#InnerCycles #JournalingStreak',
        language: isEn ? AppLanguage.en : AppLanguage.tr,
      );
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  String get _emoji {
    switch (streakDays) {
      case 3: return '\u{1F525}'; // fire
      case 7: return '\u{26A1}';  // lightning
      case 14: return '\u{1F31F}'; // star
      case 30: return '\u{1F3C6}'; // trophy
      case 60: return '\u{1F48E}'; // gem
      case 90: return '\u{1F451}'; // crown
      case 180: return '\u{1F30D}'; // globe
      case 365: return '\u{2728}'; // sparkles
      default: return '\u{1F525}';
    }
  }

  String get _title {
    if (isEn) {
      switch (streakDays) {
        case 3: return '3-Day Streak';
        case 7: return 'One Full Week';
        case 14: return 'Two Weeks Strong';
        case 30: return '30-Day Practice';
        case 60: return '60 Days Deep';
        case 90: return 'Quarter Year';
        case 180: return 'Half Year';
        case 365: return 'One Full Year';
        default: return '$streakDays Days';
      }
    } else {
      switch (streakDays) {
        case 3: return '3 Günlük Seri';
        case 7: return 'Tam Bir Hafta';
        case 14: return 'İki Hafta Güçlü';
        case 30: return '30 Günlük Pratik';
        case 60: return '60 Gün Derinlikte';
        case 90: return 'Çeyrek Yıl';
        case 180: return 'Yarım Yıl';
        case 365: return 'Tam Bir Yıl';
        default: return '$streakDays Gün';
      }
    }
  }

  String get _message => isEn
      ? StreakService.getMilestoneMessageEn(streakDays)
      : StreakService.getMilestoneMessageTr(streakDays);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: isEn
          ? '$streakDays day streak milestone celebration'
          : '$streakDays günlük seri kutlaması',
      child: Dialog(
      backgroundColor:
          isDark ? AppColors.surfaceDark : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        child: RepaintBoundary(
          key: _boundaryKey,
          child: Container(
            color: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated emoji badge
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.starGold.withValues(alpha: 0.25),
                        AppColors.auroraStart.withValues(alpha: 0.15),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.starGold.withValues(alpha: 0.5),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.starGold.withValues(alpha: 0.3),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _emoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.3, 0.3),
                      end: const Offset(1, 1),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 300.ms),

                const SizedBox(height: 24),

                // Streak count
                Text(
                  _title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                )
                    .animate(delay: 200.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.3, end: 0, duration: 400.ms),

                const SizedBox(height: 12),

                // Message
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: isDark
                        ? Colors.white70
                        : AppColors.textDark.withValues(alpha: 0.7),
                  ),
                )
                    .animate(delay: 350.ms)
                    .fadeIn(duration: 400.ms),

                // InnerCycles watermark
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 12,
                      color: isDark
                          ? Colors.white24
                          : AppColors.textDark.withValues(alpha: 0.3),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'InnerCycles',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white24
                            : AppColors.textDark.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Buttons row: Share + Keep Going
                Row(
                  children: [
                    // Share button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isSharing ? null : _shareCard,
                        icon: _isSharing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.share_rounded, size: 18),
                        label: Text(
                          isEn ? 'Share' : 'Paylaş',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.starGold,
                          side: BorderSide(
                            color: AppColors.starGold.withValues(alpha: 0.5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Keep Going button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.starGold,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isEn ? 'Keep Going' : 'Devam Et',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    .animate(delay: 500.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.2, end: 0, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
