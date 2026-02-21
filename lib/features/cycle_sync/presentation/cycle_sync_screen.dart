// ════════════════════════════════════════════════════════════════════════════
// CYCLE SYNC SCREEN - Hormonal × Emotional Pattern Dashboard
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/models/cycle_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

class CycleSyncScreen extends ConsumerStatefulWidget {
  const CycleSyncScreen({super.key});

  @override
  ConsumerState<CycleSyncScreen> createState() => _CycleSyncScreenState();
}

class _CycleSyncScreenState extends ConsumerState<CycleSyncScreen> {
  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cycleSyncAsync = ref.watch(cycleSyncServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: cycleSyncAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Center(
              child: Text(
                isEn ? 'Something went wrong' : 'Bir şeyler ters gitti',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            data: (cycleService) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Cycle Sync' : 'Döngü Senkronu',
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppConstants.spacingLg),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Cycle Day Indicator
                        _buildCycleDayCard(
                          context,
                          cycleService,
                          isDark,
                          isEn,
                        ).glassReveal(context: context),
                        const SizedBox(height: AppConstants.spacingLg),

                        // Phase Info Card
                        _buildPhaseCard(
                          context,
                          cycleService,
                          isDark,
                          isEn,
                        ).glassListItem(context: context, index: 1),
                        const SizedBox(height: AppConstants.spacingLg),

                        // Phase-Aware Prompt
                        if (cycleService.hasData)
                          _buildPhasePromptCard(
                            context,
                            cycleService,
                            isDark,
                            isEn,
                          ).glassListItem(context: context, index: 2),
                        if (cycleService.hasData)
                          const SizedBox(height: AppConstants.spacingLg),

                        // Correlation Insight (if enough data)
                        _buildCorrelationCard(
                          context,
                          isDark,
                          isEn,
                        ).glassListItem(context: context, index: 3),
                        const SizedBox(height: AppConstants.spacingLg),

                        // Phase Timeline
                        _buildPhaseTimeline(
                          context,
                          cycleService,
                          isDark,
                          isEn,
                        ).glassListItem(context: context, index: 4),
                        const SizedBox(height: AppConstants.spacingXl),
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: _buildLogPeriodFab(context, isEn),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // CYCLE DAY INDICATOR
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildCycleDayCard(
    BuildContext context,
    dynamic cycleService,
    bool isDark,
    bool isEn,
  ) {
    final cycleDay = cycleService.getCurrentCycleDay();
    final cycleLength = cycleService.getAverageCycleLength();
    final phase = cycleService.getCurrentPhase();

    if (!cycleService.hasData) {
      return GlassPanel(
        elevation: GlassElevation.g3,
        glowColor: AppColors.amethyst.withValues(alpha: 0.3),
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        child: Column(
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 48,
              color: AppColors.amethyst,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              isEn
                  ? 'Start Tracking Your Cycle'
                  : 'Döngünü Takip Etmeye Başla',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isEn
                  ? 'Log your period to see how your emotional patterns align with your cycle.'
                  : 'Duygusal kalıplarının döngünle nasıl uyumlandığını görmek için adetini kaydet.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final progress = cycleDay != null ? cycleDay / cycleLength : 0.0;
    final phaseColor = _phaseColor(phase);

    return GlassPanel(
      elevation: GlassElevation.g3,
      glowColor: phaseColor.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        children: [
          // Circular progress
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 8,
                    backgroundColor: isDark
                        ? AppColors.surfaceLight.withValues(alpha: 0.2)
                        : AppColors.lightSurfaceVariant,
                    valueColor: AlwaysStoppedAnimation(phaseColor),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEn ? 'Day' : 'Gün',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    Text(
                      '${cycleDay ?? '-'}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: phaseColor,
                      ),
                    ),
                    Text(
                      isEn ? 'of $cycleLength' : '/ $cycleLength',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          if (phase != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: phaseColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isEn ? phase.displayNameEn : phase.displayNameTr,
                style: TextStyle(
                  color: phaseColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          const SizedBox(height: 4),
          if (phase != null)
            Text(
              isEn ? phase.descriptionEn : phase.descriptionTr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PHASE INFO CARD
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildPhaseCard(
    BuildContext context,
    dynamic cycleService,
    bool isDark,
    bool isEn,
  ) {
    final daysUntil = cycleService.getDaysUntilNextPeriod();

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'Cycle Overview' : 'Döngü Özeti',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildInfoRow(
            context,
            Icons.calendar_today_rounded,
            isEn ? 'Cycle length' : 'Döngü süresi',
            isEn
                ? '${cycleService.getAverageCycleLength()} days'
                : '${cycleService.getAverageCycleLength()} gün',
            isDark,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            Icons.water_drop_outlined,
            isEn ? 'Period length' : 'Adet süresi',
            isEn
                ? '${cycleService.getAveragePeriodLength()} days'
                : '${cycleService.getAveragePeriodLength()} gün',
            isDark,
          ),
          if (daysUntil != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.schedule_rounded,
              isEn ? 'Next period' : 'Sonraki adet',
              isEn
                  ? 'in ~$daysUntil days'
                  : '~$daysUntil gün sonra',
              isDark,
            ),
          ],
          if (cycleService.getAllLogs().length >= 2) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.insights_rounded,
              isEn ? 'Cycles logged' : 'Kayıtlı döngü',
              '${cycleService.getAllLogs().length}',
              isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PHASE-AWARE PROMPT
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildPhasePromptCard(
    BuildContext context,
    dynamic cycleService,
    bool isDark,
    bool isEn,
  ) {
    final phase = cycleService.getCurrentPhase();
    if (phase == null) return const SizedBox.shrink();

    final prompt = _getPhasePrompt(phase, isEn);
    final phaseColor = _phaseColor(phase);

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded,
                  size: 18, color: phaseColor),
              const SizedBox(width: 8),
              Text(
                isEn
                    ? '${phase.displayNameEn} Phase Prompt'
                    : '${phase.displayNameTr} Evresi İpucu',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: phaseColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            prompt,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _getPhasePrompt(CyclePhase phase, bool isEn) {
    // Date-rotated prompt
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    final prompts = _phasePrompts[phase]!;
    final index = dayOfYear % prompts.length;
    return isEn ? prompts[index].$1 : prompts[index].$2;
  }

  static const Map<CyclePhase, List<(String, String)>> _phasePrompts = {
    CyclePhase.menstrual: [
      ('What does your body need most right now?',
          'Bedenin şu an en çok neye ihtiyaç duyuyor?'),
      ('What can you release during this rest phase?',
          'Bu dinlenme evresinde nelerden vazgeçebilirsin?'),
      ('How do you feel about slowing down?',
          'Yavaşlamak hakkında ne hissediyorsun?'),
    ],
    CyclePhase.follicular: [
      ('What new idea excites you right now?',
          'Şu an seni heyecanlandıran yeni bir fikir ne?'),
      ('Your energy is rising — what will you channel it toward?',
          'Enerjin yükseliyor — onu neye yönlendireceksin?'),
      ('What creative impulse have you been putting off?',
          'Ertelediğin yaratıcı bir dürtü var mı?'),
    ],
    CyclePhase.ovulatory: [
      ('Who do you want to connect with today?',
          'Bugün kiminle bağlantı kurmak istiyorsun?'),
      ('How will you use your peak social energy?',
          'Zirve sosyal enerjini nasıl kullanacaksın?'),
      ('What conversation have you been avoiding?',
          'Hangi konuşmadan kaçınıyordun?'),
    ],
    CyclePhase.luteal: [
      ('What feelings are surfacing as your energy turns inward?',
          'Enerjin içe dönerken hangi duygular yüzeye çıkıyor?'),
      ('What patterns repeat at this point in your cycle?',
          'Döngünün bu noktasında hangi kalıplar tekrarlanıyor?'),
      ('How can you be gentle with yourself during this phase?',
          'Bu evrede kendine nasıl nazik olabilirsin?'),
    ],
  };

  // ═══════════════════════════════════════════════════════════════════════
  // CORRELATION INSIGHT
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildCorrelationCard(
    BuildContext context,
    bool isDark,
    bool isEn,
  ) {
    final correlationAsync = ref.watch(cycleCorrelationServiceProvider);

    return correlationAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (correlationService) {
        final insight = correlationService.getCurrentPhaseInsight(isEn);
        if (insight == null) {
          return GlassPanel(
            elevation: GlassElevation.g2,
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isEn
                        ? 'Log more entries to unlock cycle-emotion correlations.'
                        : 'Döngü-duygu korelasyonlarını açmak için daha fazla kayıt ekle.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return GlassPanel(
          elevation: GlassElevation.g2,
          glowColor: AppColors.auroraStart.withValues(alpha: 0.2),
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, size: 18, color: AppColors.auroraStart),
                  const SizedBox(width: 8),
                  Text(
                    isEn ? 'Cycle Insight' : 'Döngü İçgörüsü',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.auroraStart,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Text(
                insight,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PHASE TIMELINE
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildPhaseTimeline(
    BuildContext context,
    dynamic cycleService,
    bool isDark,
    bool isEn,
  ) {
    final cycleLength = cycleService.getAverageCycleLength() as int;
    final currentDay = cycleService.getCurrentCycleDay() as int?;

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'Phase Timeline' : 'Evre Zaman Çizelgesi',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          // Phase bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 32,
              child: Row(
                children: CyclePhase.values.map((phase) {
                  final fraction = _phaseFraction(phase, cycleLength,
                      cycleService.getAveragePeriodLength() as int);
                  return Expanded(
                    flex: (fraction * 100).round().clamp(1, 100),
                    child: Container(
                      color: _phaseColor(phase).withValues(alpha: 0.6),
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            isEn
                                ? phase.displayNameEn.substring(0, 3)
                                : phase.displayNameTr.substring(0, 3),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Current day marker
          if (currentDay != null && cycleLength > 0) ...[
            const SizedBox(height: 4),
            LayoutBuilder(
              builder: (context, constraints) {
                final markerX =
                    (currentDay / cycleLength) * constraints.maxWidth;
                return SizedBox(
                  height: 16,
                  child: Stack(
                    children: [
                      Positioned(
                        left: markerX.clamp(0, constraints.maxWidth - 8),
                        child: Icon(
                          Icons.arrow_drop_up_rounded,
                          size: 16,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 8),
          // Phase labels
          ...CyclePhase.values.map((phase) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _phaseColor(phase),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isEn ? phase.displayNameEn : phase.displayNameTr,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  isEn ? phase.descriptionEn : phase.descriptionTr,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  double _phaseFraction(CyclePhase phase, int cycleLength, int periodLength) {
    final follicularEnd = (cycleLength * 0.46).round();
    final ovulatoryEnd = (cycleLength * 0.57).round();

    switch (phase) {
      case CyclePhase.menstrual:
        return periodLength / cycleLength;
      case CyclePhase.follicular:
        return (follicularEnd - periodLength) / cycleLength;
      case CyclePhase.ovulatory:
        return (ovulatoryEnd - follicularEnd) / cycleLength;
      case CyclePhase.luteal:
        return (cycleLength - ovulatoryEnd) / cycleLength;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // LOG PERIOD FAB
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildLogPeriodFab(BuildContext context, bool isEn) {
    return FloatingActionButton.extended(
      onPressed: () => _showLogPeriodSheet(context, isEn),
      backgroundColor: AppColors.amethyst,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.water_drop_rounded),
      label: Text(
        isEn ? 'Log Period' : 'Adet Kaydet',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showLogPeriodSheet(BuildContext context, bool isEn) {
    HapticFeedback.lightImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.deepSpace : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isEn ? 'Log Period Start' : 'Adet Başlangıcı Kaydet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isEn
                    ? 'Mark today as the start of your period.'
                    : 'Bugünü adet başlangıcı olarak işaretle.',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(ctx);
                    final service =
                        await ref.read(cycleSyncServiceProvider.future);
                    await service.logPeriodStart(date: DateTime.now());
                    ref.invalidate(cycleSyncServiceProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amethyst,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMd),
                    ),
                  ),
                  child: Text(
                    isEn ? 'Period Started Today' : 'Adet Bugün Başladı',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  isEn ? 'Cancel' : 'İptal',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════

  Color _phaseColor(CyclePhase? phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return const Color(0xFFE57373); // Soft red
      case CyclePhase.follicular:
        return const Color(0xFF81C784); // Fresh green
      case CyclePhase.ovulatory:
        return AppColors.starGold;
      case CyclePhase.luteal:
        return AppColors.amethyst;
      case null:
        return AppColors.textMuted;
    }
  }
}
