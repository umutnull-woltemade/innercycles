// ════════════════════════════════════════════════════════════════════════════
// COSMIC SHARE SCREEN - Personal Reflection Share (App Store 4.3(b) Compliant)
// ════════════════════════════════════════════════════════════════════════════
// This screen allows users to share their personal reflections.
// Astrology-specific content has been removed.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';

/// Personal Reflection Share Screen
/// Optimized for social media sharing
class CosmicShareScreen extends ConsumerStatefulWidget {
  const CosmicShareScreen({super.key});

  @override
  ConsumerState<CosmicShareScreen> createState() => _CosmicShareScreenState();
}

class _CosmicShareScreenState extends ConsumerState<CosmicShareScreen> {
  final GlobalKey _shareCardKey = GlobalKey();
  bool _isCapturing = false;

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnglish = language == AppLanguage.en;

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepSpace : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEnglish ? 'Share Reflection' : L10nService.get('share.title', language),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Share Card Preview
            Expanded(
              child: Center(
                child: RepaintBoundary(
                  key: _shareCardKey,
                  child: _buildShareCard(isDark, isEnglish, language, userProfile?.name),
                ),
              ),
            ),

            // Share Actions
            _buildShareActions(isDark, isEnglish, language),
          ],
        ),
      ),
    );
  }

  Widget _buildShareCard(bool isDark, bool isEnglish, AppLanguage language, String? name) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cosmicPurple.withOpacity(0.8),
            AppColors.deepSpace,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.cosmicPurple.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // App Icon
          const Icon(
            Icons.self_improvement,
            size: 64,
            color: Colors.white,
          ).animate().fadeIn(duration: 600.ms).scale(),

          const SizedBox(height: 24),

          // Title
          Text(
            isEnglish ? 'My Inner Journey' : L10nService.get('share.card_title', language),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

          const SizedBox(height: 16),

          // Quote
          Text(
            isEnglish
                ? '"Every reflection brings new understanding"'
                : L10nService.get('share.quote', language),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

          const SizedBox(height: 32),

          // User Name
          if (name != null && name.isNotEmpty)
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

          const SizedBox(height: 24),

          // App Attribution
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'InnerCycles',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
          ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms);
  }

  Widget _buildShareActions(bool isDark, bool isEnglish, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            isEnglish
                ? 'Take a screenshot to share your reflection'
                : L10nService.get('share.instruction', language),
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black45,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Close Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cosmicPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isEnglish ? 'Done' : L10nService.get('common.done', language),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
