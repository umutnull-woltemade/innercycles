// ════════════════════════════════════════════════════════════════════════════
// SHARE CARD SHEET - Reusable bottom sheet for all share features
// ════════════════════════════════════════════════════════════════════════════
// Renders a ShareCardTemplate + data into a RepaintBoundary, then uses
// InstagramShareService for native share sheet.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../data/models/share_card_models.dart';
import '../../data/content/share_card_templates.dart';
import '../../data/services/instagram_share_service.dart';
import '../../data/services/review_service.dart';
import '../../core/constants/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/app_providers.dart';
import '../../data/services/l10n_service.dart';
import '../../data/services/premium_service.dart';

class ShareCardSheet extends ConsumerStatefulWidget {
  final ShareCardTemplate template;
  final ShareCardData data;
  final AppLanguage language;

  const ShareCardSheet({
    super.key,
    required this.template,
    required this.data,
    required this.language,
  });

  static Future<void> show(
    BuildContext context, {
    required ShareCardTemplate template,
    required ShareCardData data,
    required AppLanguage language,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ShareCardSheet(template: template, data: data, language: language),
    );
  }

  @override
  ConsumerState<ShareCardSheet> createState() => _ShareCardSheetState();
}

class _ShareCardSheetState extends ConsumerState<ShareCardSheet> {
  final _boundaryKey = GlobalKey();
  bool _isSharing = false;
  String? _aiCaption;

  @override
  void initState() {
    super.initState();
    _loadAICaption();
  }

  /// Best-effort: load AI-generated caption in background.
  Future<void> _loadAICaption() async {
    try {
      final client = Supabase.instance.client;
      final response = await client.functions.invoke(
        'share-caption',
        body: {
          'cardType': widget.template.id,
          'headline': widget.data.headline,
          'statValue': widget.data.statValue ?? '',
          'language': widget.language == AppLanguage.en ? 'en' : 'tr',
        },
      ).timeout(const Duration(seconds: 5));

      if (response.status == 200 && mounted) {
        final data = response.data is String
            ? json.decode(response.data as String) as Map<String, dynamic>
            : response.data as Map<String, dynamic>;
        final caption = data['caption'] as String?;
        if (caption != null && caption.isNotEmpty) {
          setState(() => _aiCaption = caption);
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('AI share caption best-effort: $e');
    }
  }

  Future<void> _share() async {
    final language = widget.language;
    setState(() => _isSharing = true);
    try {
      final boundary =
          _boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;

      // Use AI caption if available, otherwise fall back to static template
      final staticText = L10nService.getWithParams('sharing.share_card_text', language, params: {'headline': widget.data.headline, 'appStoreUrl': AppConstants.appStoreUrl});
      final shareText = _aiCaption != null
          ? '$_aiCaption\n\n${AppConstants.appStoreUrl}'
          : staticText;

      await InstagramShareService.shareCosmicContent(
        boundary: boundary,
        shareText: shareText,
        hashtags: L10nService.get('sharing.hashtags_self_reflection', language),
        language: language,
      );

      if (mounted) Navigator.of(context).pop();

      // Trigger review prompt after successful share
      ReviewService.init().then((rs) =>
        rs.checkAndPromptReview(ReviewTrigger.shareCompleted));
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = widget.language;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = ShareCardTemplates.accentColor(widget.template);

    return Semantics(
      label: widget.language == AppLanguage.en
          ? 'Share card: ${widget.data.headline}'
          : 'Paylaşım kartı: ${widget.data.headline}',
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: (isDark ? AppColors.surfaceDark : AppColors.lightSurface)
                  .withValues(alpha: isDark ? 0.85 : 0.92),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border(
                top: BorderSide(
                  color: accent.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent.withValues(alpha: 0.6),
                        accent.withValues(alpha: 0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Preview card
                RepaintBoundary(
                  key: _boundaryKey,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors:
                            widget.data.moodGradientOverride ??
                            widget.template.gradientColors,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.template.badge(widget.language),
                            style: AppTypography.elegantAccent(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white70,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Headline
                        Text(
                          widget.data.headline,
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Subtitle
                        Text(
                          widget.data.subtitle,
                          style: AppTypography.decorativeScript(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        if (widget.data.statValue != null) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                widget.data.statValue!,
                                style: AppTypography.displayFont.copyWith(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: accent,
                                ),
                              ),
                              if (widget.data.statLabel != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  widget.data.statLabel!,
                                  style: AppTypography.elegantAccent(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                        const SizedBox(height: 20),
                        // Watermark — prominent for free, subtle for premium
                        Builder(builder: (_) {
                          final isPremium = ref.watch(isPremiumUserProvider);
                          if (isPremium) {
                            // Premium: minimal watermark
                            return Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 12,
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'InnerCycles',
                                  style: AppTypography.elegantAccent(
                                    fontSize: 10,
                                    color: Colors.white.withValues(alpha: 0.25),
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            );
                          }
                          // Free: prominent viral watermark with URL
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 14,
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'InnerCycles',
                                    style: AppTypography.elegantAccent(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withValues(alpha: 0.5),
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'innercycles.app',
                                style: AppTypography.subtitle(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Share button
                GradientButton(
                  label: L10nService.get('shared.share.share', language),
                  icon: Icons.share_rounded,
                  onPressed: _isSharing ? null : _share,
                  isLoading: _isSharing,
                  expanded: true,
                  gradient: LinearGradient(
                    colors: [accent, accent.withValues(alpha: 0.85)],
                  ),
                  foregroundColor: Colors.black87,
                ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
