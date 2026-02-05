/// Dream Interpretation Result Widget - 7 Boyutlu Yorum Sonuç Görünümü
/// Kadim bilgelik + Jungian arketipler + Astrolojik zamanlama
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/dream_interpretation_models.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/l10n_service.dart';

/// Ana yorum sonucu widget'ı
class DreamInterpretationResultWidget extends ConsumerWidget {
  final FullDreamInterpretation interpretation;
  final VoidCallback? onExploreLink;

  const DreamInterpretationResultWidget({
    super.key,
    required this.interpretation,
    this.onExploreLink,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mystic.withValues(alpha: 0.15),
            const Color(0xFF1A1A2E).withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.mystic.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mystic.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context, lang),

              // 1. Kadim Giriş
              _buildSection(
                context,
                lang,
                emoji: '📜',
                title: L10nService.get('dreams.result_widget.ancient_wisdom', lang),
                content: interpretation.ancientIntro,
                delay: 100,
              ),

              // 2. Ana Mesaj
              _buildCoreMessage(context, lang),

              // 3. Sembol Analizi
              if (interpretation.symbols.isNotEmpty)
                _buildSymbolsSection(context, lang),

              // 4. Arketip Bağlantısı
              _buildArchetypeSection(context, lang),

              // 5. Duygusal Okuma
              _buildEmotionalSection(context, lang),

              // 6. Astrolojik Zamanlama
              _buildAstroSection(context, lang),

              // 7. Işık/Gölge
              _buildLightShadowSection(context, lang),

              // 8. Pratik Rehberlik
              _buildGuidanceSection(context, lang),

              // 9. Fısıldayan Cümle
              _buildWhisperQuote(context, lang),

              // 10. Paylaşılabilir Kart
              _buildShareCard(context, lang),

              // 11. Keşfet Linkleri
              if (interpretation.explorationLinks.isNotEmpty)
                _buildExplorationLinks(context, lang),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLanguage lang) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.cosmicPurple.withValues(alpha: 0.4),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.mystic.withValues(alpha: 0.6),
                  AppColors.nebulaPurple.withValues(alpha: 0.3),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.mystic.withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text('🔮', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('dreams.result_widget.title_badge', lang),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.starGold,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  L10nService.get('dreams.result_widget.subconscious_message', lang),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          // Ay fazı göstergesi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.mystic.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.mystic.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  interpretation.astroTiming.moonPhase.emoji,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 4),
                Text(
                  interpretation.astroTiming.moonPhase.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildSection(
    BuildContext context,
    AppLanguage lang, {
    required String emoji,
    required String title,
    required String content,
    int delay = 0,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: delay.ms).slideX(begin: -0.05, end: 0);
  }

  Widget _buildCoreMessage(BuildContext context, AppLanguage lang) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.starGold.withValues(alpha: 0.15),
            AppColors.cosmicPurple.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.result_widget.core_message', lang),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            interpretation.coreMessage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  Widget _buildSymbolsSection(BuildContext context, AppLanguage lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔍', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.result_widget.symbol_analysis', lang),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...interpretation.symbols.asMap().entries.map((entry) {
            final index = entry.key;
            final symbol = entry.value;
            return _buildSymbolCard(context, lang, symbol, index);
          }),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 300.ms);
  }

  Widget _buildSymbolCard(BuildContext context, AppLanguage lang, SymbolInterpretation symbol, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.mystic.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.mystic.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(symbol.symbolEmoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  symbol.symbol.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildSymbolDetail(context, '🌍', L10nService.get('dreams.result_widget.universal', lang), symbol.universalMeaning),
          _buildSymbolDetail(context, '👤', L10nService.get('dreams.result_widget.personal', lang), symbol.personalContext),
          _buildSymbolDetail(context, '🌑', L10nService.get('dreams.result_widget.shadow', lang), symbol.shadowAspect),
          _buildSymbolDetail(context, '☀️', L10nService.get('dreams.result_widget.light', lang), symbol.lightAspect),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms, delay: (400 + index * 100).ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildSymbolDetail(BuildContext context, String emoji, String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Expanded(
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary.withValues(alpha: 0.9),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchetypeSection(BuildContext context, AppLanguage lang) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.nebulaPurple.withValues(alpha: 0.3),
            AppColors.cosmicPurple.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.nebulaPurple.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎭', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                '${L10nService.get('dreams.result_widget.archetype', lang)}: ${interpretation.archetypeName.toUpperCase()}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            interpretation.archetypeConnection,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary.withValues(alpha: 0.9),
                  height: 1.5,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 500.ms);
  }

  Widget _buildEmotionalSection(BuildContext context, AppLanguage lang) {
    final emotional = interpretation.emotionalReading;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emotional.dominantEmotion.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                '${L10nService.get('dreams.result_widget.emotional_reading', lang)}: ${emotional.dominantEmotion.label.toUpperCase()}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildEmotionalRow(context, '📍', L10nService.get('dreams.result_widget.surface', lang), emotional.surfaceMessage),
          _buildEmotionalRow(context, '🔮', L10nService.get('dreams.result_widget.depth', lang), emotional.deeperMeaning),
          _buildEmotionalRow(context, '❓', L10nService.get('dreams.result_widget.shadow_question', lang), emotional.shadowQuestion),
          _buildEmotionalRow(context, '🛤️', L10nService.get('dreams.result_widget.integration', lang), emotional.integrationPath),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 600.ms);
  }

  Widget _buildEmotionalRow(BuildContext context, String emoji, String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Expanded(
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstroSection(BuildContext context, AppLanguage lang) {
    final astro = interpretation.astroTiming;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A1A4E).withValues(alpha: 0.5),
            AppColors.cosmicPurple.withValues(alpha: 0.2),
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
              Text(astro.moonPhase.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Text(
                L10nService.get('dreams.result_widget.astro_timing', lang),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              if (astro.isRetrograde)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '℞ Retro',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.orange,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            astro.timingMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.mystic.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Text('🤔', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${L10nService.get('dreams.result_widget.why_now', lang)} ${astro.whyNow}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 700.ms);
  }

  Widget _buildLightShadowSection(BuildContext context, AppLanguage lang) {
    final ls = interpretation.lightShadow;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.amber.withValues(alpha: 0.15),
                    Colors.orange.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.amber.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('☀️', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        L10nService.get('dreams.result_widget.light_label', lang),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ls.lightMessage,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.indigo.withValues(alpha: 0.2),
                    Colors.deepPurple.withValues(alpha: 0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.indigo.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🌑', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        L10nService.get('dreams.result_widget.shadow_label', lang),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.indigo[300],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ls.shadowMessage,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 800.ms);
  }

  Widget _buildGuidanceSection(BuildContext context, AppLanguage lang) {
    final guidance = interpretation.guidance;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.mystic.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mystic.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🧭', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                L10nService.get('dreams.result_widget.practical_guidance', lang),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildGuidanceItem(context, '📅', L10nService.get('dreams.result_widget.today', lang), guidance.todayAction),
          _buildGuidanceItem(context, '📆', L10nService.get('dreams.result_widget.this_week', lang), guidance.weeklyFocus),
          _buildGuidanceItem(context, '🚫', L10nService.get('dreams.result_widget.avoid', lang), guidance.avoidance),
          const Divider(color: AppColors.mystic, height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cosmicPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💭', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L10nService.get('dreams.result_widget.reflection_question', lang),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        guidance.reflectionQuestion,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 900.ms);
  }

  Widget _buildGuidanceItem(BuildContext context, String emoji, String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhisperQuote(BuildContext context, AppLanguage lang) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mystic.withValues(alpha: 0.25),
            AppColors.nebulaPurple.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.mystic.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('🌙', style: TextStyle(fontSize: 28)),
          const SizedBox(height: 12),
          Text(
            '"${interpretation.whisperQuote}"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '— ${L10nService.get('dreams.result_widget.whisper_wisdom', lang)}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 1000.ms)
        .shimmer(duration: 2000.ms, delay: 1200.ms, color: AppColors.starGold.withValues(alpha: 0.3));
  }

  Widget _buildShareCard(BuildContext context, AppLanguage lang) {
    final card = interpretation.shareCard;
    return GestureDetector(
      onTap: () => _shareCard(context, card),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.cosmicPurple,
              AppColors.nebulaPurple,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.cosmicPurple.withValues(alpha: 0.4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.share, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        L10nService.get('dreams.result_widget.share', lang),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '"${card.quote}"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              '— ${L10nService.get('dreams.result_widget.share_footer', lang)}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 1100.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  Widget _buildExplorationLinks(BuildContext context, AppLanguage lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔗', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.result_widget.explore', lang),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interpretation.explorationLinks.map((link) {
              return InkWell(
                onTap: onExploreLink,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.cosmicPurple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.cosmicPurple.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(link.emoji, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        link.title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 10,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 1200.ms);
  }

  void _shareCard(BuildContext context, ShareableCard card) {
    final shareText = card.fullShareText;
    HapticFeedback.mediumImpact();
    Share.share(shareText);
  }
}
