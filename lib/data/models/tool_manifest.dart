// ════════════════════════════════════════════════════════════════════════════
// TOOL MANIFEST - Unified tool registry for InnerCycles ecosystem
// ════════════════════════════════════════════════════════════════════════════
// Each tool has: id, bilingual names, category, intent tags, route,
// templates, next-tool suggestions, empty state, and time-to-value.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import '../../core/constants/routes.dart';

enum ToolCategory { journal, analysis, discovery, support, reference, data }

enum IntentTag { grow, reflect, analyze, heal, track, discover }

enum NextToolCondition {
  always,
  ifOutputEntry,
  ifOutputReport,
  ifOutputScore,
  ifGoalMatch,
}

class ToolTemplate {
  final String id;
  final String labelEn;
  final String labelTr;
  final Map<String, dynamic> prefillData;

  const ToolTemplate({
    required this.id,
    required this.labelEn,
    required this.labelTr,
    this.prefillData = const {},
  });
}

class NextToolSuggestion {
  final String toolId;
  final NextToolCondition condition;
  final String reasonEn;
  final String reasonTr;
  final int priority;

  const NextToolSuggestion({
    required this.toolId,
    required this.condition,
    required this.reasonEn,
    required this.reasonTr,
    this.priority = 50,
  });
}

class ToolEmptyState {
  final String demoTemplateId;
  final String whyUsefulEn;
  final String whyUsefulTr;
  final int requiredEntries;

  const ToolEmptyState({
    required this.demoTemplateId,
    required this.whyUsefulEn,
    required this.whyUsefulTr,
    this.requiredEntries = 0,
  });
}

class ToolManifest {
  final String id;
  final String nameEn;
  final String nameTr;
  final String valuePropositionEn;
  final String valuePropositionTr;
  final String route;
  final String icon;
  final ToolCategory category;
  final List<IntentTag> intentTags;
  final List<String> inputTypes;
  final List<String> outputTypes;
  final List<ToolTemplate> templates;
  final List<NextToolSuggestion> nextTools;
  final List<String> dependencies;
  final int timeToValueSeconds;
  final bool requiresPremium;
  final ToolEmptyState? emptyState;
  final List<String> relatedToolIds;

  const ToolManifest({
    required this.id,
    required this.nameEn,
    required this.nameTr,
    required this.valuePropositionEn,
    required this.valuePropositionTr,
    required this.route,
    this.icon = '',
    required this.category,
    this.intentTags = const [],
    this.inputTypes = const [],
    this.outputTypes = const [],
    this.templates = const [],
    this.nextTools = const [],
    this.dependencies = const [],
    this.timeToValueSeconds = 10,
    this.requiresPremium = false,
    this.emptyState,
    this.relatedToolIds = const [],
  });

  String get labelEn => nameEn;
  String get labelTr => nameTr;
}

// ════════════════════════════════════════════════════════════════════════════
// TOOL MANIFEST REGISTRY - 35 tools (post-surgery)
// ════════════════════════════════════════════════════════════════════════════

class ToolManifestRegistry {
  ToolManifestRegistry._();

  static ToolManifest? findById(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (e) {
      if (kDebugMode) debugPrint('ToolManifest: findById "$id" error: $e');
      return null;
    }
  }

  static List<ToolManifest> getByCategory(ToolCategory category) {
    return all.where((t) => t.category == category).toList();
  }

  static List<ToolManifest> getByIntentTag(IntentTag tag) {
    return all.where((t) => t.intentTags.contains(tag)).toList();
  }

  static List<NextToolSuggestion> getNextTools(String toolId) {
    final tool = findById(toolId);
    if (tool == null) return [];
    return tool.nextTools;
  }

  static const List<ToolManifest> all = [
    // ── 1. Journal ──
    ToolManifest(
      id: 'journal',
      nameEn: 'Journal',
      nameTr: 'G\u00fcnl\u00fck',
      valuePropositionEn: 'Map your inner cycles with a daily journal entry.',
      valuePropositionTr:
          'G\u00fcnl\u00fck kay\u0131t ile i\u00e7 d\u00f6ng\u00fclerini haritaland\u0131r.',
      route: Routes.journal,
      icon: '\u{1F4D3}',
      category: ToolCategory.journal,
      intentTags: [IntentTag.reflect, IntentTag.track],
      outputTypes: ['entry'],
      timeToValueSeconds: 60,
      nextTools: [
        NextToolSuggestion(
          toolId: 'patterns',
          condition: NextToolCondition.ifOutputEntry,
          reasonEn: 'Review patterns from your entries.',
          reasonTr: '\u00d6r\u00fcnt\u00fclerini incele.',
          priority: 90,
        ),
        NextToolSuggestion(
          toolId: 'emotionalCycles',
          condition: NextToolCondition.ifOutputEntry,
          reasonEn: 'See how your emotional cycle is shaping.',
          reasonTr: 'Duygusal d\u00f6ng\u00fcn\u00fc g\u00f6r.',
          priority: 80,
        ),
      ],
      relatedToolIds: ['patterns', 'gratitude', 'moodCheckin'],
      emptyState: ToolEmptyState(
        demoTemplateId: 'journal_quick',
        whyUsefulEn: 'Your first entry starts building personal patterns.',
        whyUsefulTr:
            '\u0130lk kay\u0131t\u0131n ki\u015fisel \u00f6r\u00fcnt\u00fcleri olu\u015fturmaya ba\u015flar.',
        requiredEntries: 0,
      ),
    ),

    // ── 2. Anchor Log ──
    ToolManifest(
      id: 'gratitude',
      nameEn: 'Anchor Log',
      nameTr: 'Çapa Kaydı',
      valuePropositionEn: 'Capture moments of gratitude to shift perspective.',
      valuePropositionTr:
          'Şükran anlarını kaydet, bakış açını değiştir.',
      route: Routes.gratitudeJournal,
      icon: '\u{1F64F}',
      category: ToolCategory.journal,
      intentTags: [IntentTag.reflect, IntentTag.heal],
      outputTypes: ['entry'],
      timeToValueSeconds: 30,
      nextTools: [
        NextToolSuggestion(
          toolId: 'journal',
          condition: NextToolCondition.always,
          reasonEn: 'Continue with a full journal entry.',
          reasonTr: 'Tam bir g\u00fcnl\u00fck kayd\u0131yla devam et.',
          priority: 80,
        ),
      ],
      relatedToolIds: ['journal', 'affirmations'],
      emptyState: ToolEmptyState(
        demoTemplateId: 'gratitude_quick',
        whyUsefulEn: 'Gratitude practice tends to shift perspective over time.',
        whyUsefulTr:
            '\u015e\u00fckran prati\u011fi zamanla bak\u0131\u015f a\u00e7\u0131s\u0131n\u0131 de\u011fi\u015ftirir.',
        requiredEntries: 0,
      ),
    ),

    // ── 3. Dream Interpretation ──
    ToolManifest(
      id: 'dreamInterpretation',
      nameEn: 'Dream Journal',
      nameTr: 'R\u00fcya G\u00fcnl\u00fc\u011f\u00fc',
      valuePropositionEn: 'Record and explore the meaning behind your dreams.',
      valuePropositionTr:
          'R\u00fcyalar\u0131n\u0131 kaydet ve arkas\u0131ndaki anlamlar\u0131 ke\u015ffet.',
      route: Routes.dreamInterpretation,
      icon: '\u{1F319}',
      category: ToolCategory.journal,
      intentTags: [IntentTag.discover, IntentTag.reflect],
      outputTypes: ['dream_entry'],
      timeToValueSeconds: 60,
      nextTools: [
        NextToolSuggestion(
          toolId: 'dreamGlossary',
          condition: NextToolCondition.always,
          reasonEn: 'Look up symbols from your dream.',
          reasonTr: 'R\u00fcyandaki sembolleri ara.',
          priority: 80,
        ),
      ],
      relatedToolIds: ['dreamGlossary', 'journal'],
      emptyState: ToolEmptyState(
        demoTemplateId: 'dream_quick',
        whyUsefulEn:
            'Dreams often surface thoughts you may not notice when awake.',
        whyUsefulTr:
            'R\u00fcyalar uyan\u0131kken fark edemedi\u011fin d\u00fc\u015f\u00fcnceleri g\u00f6sterir.',
        requiredEntries: 0,
      ),
    ),

    // ── 4. Patterns ──
    ToolManifest(
      id: 'patterns',
      nameEn: 'Patterns',
      nameTr: '\u00d6r\u00fcnt\u00fcler',
      valuePropositionEn:
          'Discover recurring themes across your journal entries.',
      valuePropositionTr:
          'G\u00fcnl\u00fck kay\u0131tlar\u0131ndaki tekrarlayan temalar\u0131 ke\u015ffet.',
      route: Routes.journalPatterns,
      icon: '\u{1F50D}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.analyze, IntentTag.discover],
      inputTypes: ['journal_entries'],
      outputTypes: ['pattern_report'],
      timeToValueSeconds: 10,
      requiresPremium: true,
      nextTools: [
        NextToolSuggestion(
          toolId: 'journal',
          condition: NextToolCondition.always,
          reasonEn: 'Add a new entry to refine your patterns.',
          reasonTr:
              '\u00d6r\u00fcnt\u00fclerini iyile\u015ftirmek i\u00e7in yeni kay\u0131t ekle.',
          priority: 80,
        ),
      ],
      relatedToolIds: ['emotionalCycles', 'moodTrends', 'journal'],
      emptyState: ToolEmptyState(
        demoTemplateId: 'patterns_overview',
        whyUsefulEn:
            'Patterns emerge after 5+ entries. Each new entry adds clarity.',
        whyUsefulTr:
            '5+ kay\u0131ttan sonra \u00f6r\u00fcnt\u00fcler ortaya \u00e7\u0131kar.',
        requiredEntries: 5,
      ),
    ),

    // ── 5. Waveform View ──
    ToolManifest(
      id: 'emotionalCycles',
      nameEn: 'Waveform View',
      nameTr: 'Dalga Formu Görünümü',
      valuePropositionEn: 'Visualize how your emotional patterns flow over time.',
      valuePropositionTr:
          'Duygusal kalıplarının zaman içinde nasıl aktığını görselleştir.',
      route: Routes.emotionalCycles,
      icon: '\u{1F30A}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.analyze, IntentTag.track],
      inputTypes: ['journal_entries'],
      outputTypes: ['cycle_chart'],
      timeToValueSeconds: 10,
      requiresPremium: true,
      nextTools: [
        NextToolSuggestion(
          toolId: 'journal',
          condition: NextToolCondition.always,
          reasonEn: 'Track today\'s position in your cycle.',
          reasonTr: 'D\u00f6ng\u00fcndeki bug\u00fcnk\u00fc konumunu izle.',
          priority: 80,
        ),
      ],
      relatedToolIds: ['patterns', 'moodTrends'],
      emptyState: ToolEmptyState(
        demoTemplateId: 'cycles_demo',
        whyUsefulEn:
            'After 7+ entries, emotional cycle patterns start to appear.',
        whyUsefulTr:
            '7+ kay\u0131ttan sonra duygusal d\u00f6ng\u00fc \u00f6r\u00fcnt\u00fcleri g\u00f6r\u00fcn\u00fcr.',
        requiredEntries: 7,
      ),
    ),

    // ── 6. Signal Dashboard ──
    ToolManifest(
      id: 'moodTrends',
      nameEn: 'Signal Dashboard',
      nameTr: 'Sinyal Paneli',
      valuePropositionEn: 'Record observations and surface patterns over days and weeks.',
      valuePropositionTr:
          'G\u00fcnler ve haftalar boyunca g\u00f6zlem kaydet ve kal\u0131plar\u0131 ortaya \u00e7\u0131kar.',
      route: Routes.moodTrends,
      icon: '\u{1F4C8}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.track, IntentTag.analyze],
      timeToValueSeconds: 5,
      relatedToolIds: ['emotionalCycles', 'patterns'],
    ),

    // ── 7. Guided Breathwork ──
    ToolManifest(
      id: 'breathing',
      nameEn: 'Guided Breathwork',
      nameTr: 'Rehberli Nefes Çalışması',
      valuePropositionEn: 'Guided breathing exercises for regulation and focus.',
      valuePropositionTr:
          'Sakinlik ve odak i\u00e7in rehberli nefes egzersizleri.',
      route: Routes.breathing,
      icon: '\u{1F32C}\u{FE0F}',
      category: ToolCategory.support,
      intentTags: [IntentTag.heal],
      outputTypes: ['session_complete'],
      timeToValueSeconds: 120,
      nextTools: [
        NextToolSuggestion(
          toolId: 'journal',
          condition: NextToolCondition.always,
          reasonEn: 'Journal how you feel after breathing.',
          reasonTr: 'Nefes sonras\u0131 nas\u0131l hissetti\u011fini yaz.',
          priority: 70,
        ),
      ],
      relatedToolIds: ['meditation', 'rituals'],
    ),

    // ── 8. Meditation ──
    ToolManifest(
      id: 'meditation',
      nameEn: 'Meditation',
      nameTr: 'Meditasyon',
      valuePropositionEn: 'Short guided meditations for grounding.',
      valuePropositionTr:
          'Topraklanma i\u00e7in k\u0131sa rehberli meditasyonlar.',
      route: Routes.meditation,
      icon: '\u{1F9D8}',
      category: ToolCategory.support,
      intentTags: [IntentTag.heal],
      timeToValueSeconds: 180,
      relatedToolIds: ['breathing', 'rituals'],
    ),

    // ── 9. Reframe Deck ──
    ToolManifest(
      id: 'affirmations',
      nameEn: 'Reframe Deck',
      nameTr: 'Yeniden Çerçeveleme',
      valuePropositionEn: 'Daily reframes to set your intention.',
      valuePropositionTr:
          'Niyetini belirlemek i\u00e7in g\u00fcnl\u00fck olumlamalar.',
      route: Routes.affirmations,
      icon: '\u{2728}',
      category: ToolCategory.support,
      intentTags: [IntentTag.grow, IntentTag.heal],
      timeToValueSeconds: 10,
      relatedToolIds: ['gratitude', 'rituals'],
    ),

    // ── 10. Routine Tracker ──
    ToolManifest(
      id: 'rituals',
      nameEn: 'Routine Tracker',
      nameTr: 'Rutin Takipçisi',
      valuePropositionEn: 'Build and log personal daily routines.',
      valuePropositionTr:
          'Ki\u015fisel g\u00fcnl\u00fck rit\u00fceller olu\u015ftur ve izle.',
      route: Routes.rituals,
      icon: '\u{1F56F}\u{FE0F}',
      category: ToolCategory.support,
      intentTags: [IntentTag.grow, IntentTag.track],
      timeToValueSeconds: 30,
      relatedToolIds: ['breathing', 'meditation'],
    ),

    // ── 11. Sleep Tracking ──
    ToolManifest(
      id: 'sleep',
      nameEn: 'Sleep',
      nameTr: 'Uyku',
      valuePropositionEn: 'Log and analyze your sleep quality.',
      valuePropositionTr: 'Uyku kaliteni kaydet ve analiz et.',
      route: Routes.sleepDetail,
      icon: '\u{1F634}',
      category: ToolCategory.journal,
      intentTags: [IntentTag.track],
      outputTypes: ['sleep_entry'],
      timeToValueSeconds: 30,
      relatedToolIds: ['sleepTrends', 'wellness'],
    ),

    // ── 12. Sleep Trends ──
    ToolManifest(
      id: 'sleepTrends',
      nameEn: 'Sleep Trends',
      nameTr: 'Uyku Trendleri',
      valuePropositionEn: 'See your sleep patterns over time.',
      valuePropositionTr:
          'Zaman i\u00e7indeki uyku \u00f6r\u00fcnt\u00fclerini g\u00f6r.',
      route: Routes.sleepTrends,
      icon: '\u{1F4CA}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.analyze, IntentTag.track],
      timeToValueSeconds: 5,
      requiresPremium: true,
      relatedToolIds: ['sleep', 'wellness'],
    ),

    // ── 13. Consistency Index ──
    ToolManifest(
      id: 'wellness',
      nameEn: 'Consistency Index',
      nameTr: 'Tutarlılık Endeksi',
      valuePropositionEn: 'A composite consistency score from your daily data.',
      valuePropositionTr:
          'G\u00fcnl\u00fck verilerinden b\u00fct\u00fcnsel bir sa\u011fl\u0131k skoru.',
      route: Routes.wellnessDetail,
      icon: '\u{1F49A}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.track],
      outputTypes: ['score'],
      timeToValueSeconds: 5,
      relatedToolIds: ['sleep', 'moodTrends'],
    ),

    // ── 14. Quiz Hub ──
    ToolManifest(
      id: 'quizHub',
      nameEn: 'Quizzes',
      nameTr: 'Testler',
      valuePropositionEn: 'Self-discovery quizzes to learn about yourself.',
      valuePropositionTr: 'Kendini ke\u015ffetmek i\u00e7in testler.',
      route: Routes.quizHub,
      icon: '\u{1F9E9}',
      category: ToolCategory.discovery,
      intentTags: [IntentTag.discover],
      outputTypes: ['quiz_result'],
      timeToValueSeconds: 120,
      relatedToolIds: ['archetype', 'blindSpot'],
    ),

    // ── 16. Archetype ──
    ToolManifest(
      id: 'archetype',
      nameEn: 'Archetype',
      nameTr: 'Arketip',
      valuePropositionEn: 'Discover which archetype resonates with you.',
      valuePropositionTr: 'Hangi arketipin sana uyuyor ke\u015ffet.',
      route: Routes.archetype,
      icon: '\u{1F3AD}',
      category: ToolCategory.discovery,
      intentTags: [IntentTag.discover],
      outputTypes: ['archetype_result'],
      timeToValueSeconds: 60,
      relatedToolIds: ['quizHub', 'journal'],
    ),

    // ── 17. Blind Spot Detector ──
    ToolManifest(
      id: 'blindSpot',
      nameEn: 'Blind Spot Detector',
      nameTr: 'Kör Nokta Dedektörü',
      valuePropositionEn: 'Surface patterns you might not see on your own.',
      valuePropositionTr:
          'Kendi ba\u015f\u0131na g\u00f6remeyece\u011fin \u00f6r\u00fcnt\u00fcleri ke\u015ffet.',
      route: Routes.blindSpot,
      icon: '\u{1F441}\u{FE0F}',
      category: ToolCategory.discovery,
      intentTags: [IntentTag.discover, IntentTag.analyze],
      timeToValueSeconds: 30,
      requiresPremium: true,
      relatedToolIds: ['patterns', 'quizHub'],
    ),

    // ── 18. Insights Discovery ──
    ToolManifest(
      id: 'insightsDiscovery',
      nameEn: 'Insights',
      nameTr: '\u0130\u00e7g\u00f6r\u00fcler',
      valuePropositionEn: 'AI-surfaced insights from your journal data.',
      valuePropositionTr:
          'G\u00fcnl\u00fck verilerinden ke\u015ffedilen i\u00e7g\u00f6r\u00fcler.',
      route: Routes.insightsDiscovery,
      icon: '\u{1F4A1}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.discover, IntentTag.analyze],
      timeToValueSeconds: 10,
      requiresPremium: true,
      relatedToolIds: ['patterns', 'journal'],
    ),

    // ── 19. Heatmap Timeline ──
    ToolManifest(
      id: 'calendarHeatmap',
      nameEn: 'Heatmap Timeline',
      nameTr: 'Isı Haritası Zaman Çizelgesi',
      valuePropositionEn: 'A heatmap view of your journaling activity.',
      valuePropositionTr:
          'G\u00fcnl\u00fck aktiviteni \u0131s\u0131 haritas\u0131 olarak g\u00f6r.',
      route: Routes.calendarHeatmap,
      icon: '\u{1F4C5}',
      category: ToolCategory.data,
      intentTags: [IntentTag.track],
      timeToValueSeconds: 5,
      relatedToolIds: ['streakStats', 'journalArchive'],
    ),

    // ── 20. Growth Dashboard ──
    ToolManifest(
      id: 'growthDashboard',
      nameEn: 'Growth',
      nameTr: 'Geli\u015fim',
      valuePropositionEn: 'Your overall growth score and progress overview.',
      valuePropositionTr: 'Genel geli\u015fim puanin ve ilerleme \u00f6zetin.',
      route: Routes.growthDashboard,
      icon: '\u{1F331}',
      category: ToolCategory.data,
      intentTags: [IntentTag.grow, IntentTag.track],
      timeToValueSeconds: 5,
      requiresPremium: true,
      relatedToolIds: ['challenges', 'milestones', 'streakStats'],
    ),

    // ── 21. Protocol Lab ──
    ToolManifest(
      id: 'challenges',
      nameEn: 'Protocol Lab',
      nameTr: 'Protokol Laboratuvarı',
      valuePropositionEn: 'Weekly and monthly structured protocols.',
      valuePropositionTr:
          'Haftal\u0131k ve ayl\u0131k geli\u015fim g\u00f6revleri.',
      route: Routes.challenges,
      icon: '\u{1F3C6}',
      category: ToolCategory.data,
      intentTags: [IntentTag.grow],
      timeToValueSeconds: 10,
      requiresPremium: true,
      relatedToolIds: ['growthDashboard', 'milestones'],
    ),

    // ── 22. Milestones ──
    ToolManifest(
      id: 'milestones',
      nameEn: 'Milestones',
      nameTr: 'Kilometre Ta\u015flar\u0131',
      valuePropositionEn: 'Celebrate progress with badges and milestones.',
      valuePropositionTr:
          'Rozetler ve kilometre ta\u015flar\u0131 ile ilerlemeyi kutla.',
      route: Routes.milestones,
      icon: '\u{1F3C5}',
      category: ToolCategory.data,
      intentTags: [IntentTag.grow, IntentTag.track],
      timeToValueSeconds: 5,
      relatedToolIds: ['growthDashboard', 'challenges', 'shareCards'],
    ),

    // ── 23. Streak Engine ──
    ToolManifest(
      id: 'streakStats',
      nameEn: 'Streak Engine',
      nameTr: 'Seri Motoru',
      valuePropositionEn: 'See your current and longest recording streaks.',
      valuePropositionTr:
          'Mevcut ve en uzun g\u00fcnl\u00fck serilerini g\u00f6r.',
      route: Routes.streakStats,
      icon: '\u{1F525}',
      category: ToolCategory.data,
      intentTags: [IntentTag.track, IntentTag.grow],
      timeToValueSeconds: 5,
      relatedToolIds: ['calendarHeatmap', 'growthDashboard'],
    ),

    // ── 24. Challenge Sequences ──
    ToolManifest(
      id: 'programs',
      nameEn: 'Challenge Sequences',
      nameTr: 'Görev Dizileri',
      valuePropositionEn: 'Multi-day guided sequences for deeper exploration.',
      valuePropositionTr: 'Çok günlük rehberli diziler.',
      route: Routes.programs,
      icon: '\u{1F4DA}',
      category: ToolCategory.discovery,
      intentTags: [IntentTag.grow, IntentTag.discover],
      timeToValueSeconds: 60,
      requiresPremium: true,
      relatedToolIds: ['journal', 'rituals'],
    ),

    // ── 25. Weekly Debrief ──
    ToolManifest(
      id: 'weeklyDigest',
      nameEn: 'Weekly Debrief',
      nameTr: 'Haftalık Değerlendirme',
      valuePropositionEn: 'A concise summary of your past week.',
      valuePropositionTr: 'Geçen haftanın kısa özeti.',
      route: Routes.weeklyDigest,
      icon: '\u{1F4CB}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.analyze, IntentTag.reflect],
      timeToValueSeconds: 10,
      requiresPremium: true,
      relatedToolIds: ['patterns', 'journal'],
      emptyState: ToolEmptyState(
        demoTemplateId: 'digest_current',
        whyUsefulEn: 'Available after 5 entries in a week.',
        whyUsefulTr: 'Bir haftada 5 kay\u0131ttan sonra kullan\u0131labilir.',
        requiredEntries: 5,
      ),
    ),

    // ── 29. Monthly Report ──
    ToolManifest(
      id: 'monthlyReport',
      nameEn: 'Monthly Report',
      nameTr: 'Ayl\u0131k Rapor',
      valuePropositionEn: 'A comprehensive look at your past month.',
      valuePropositionTr:
          'Ge\u00e7en ay\u0131na kapsaml\u0131 bir bak\u0131\u015f.',
      route: Routes.journalMonthly,
      icon: '\u{1F4C4}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.analyze, IntentTag.reflect],
      timeToValueSeconds: 10,
      requiresPremium: true,
      relatedToolIds: ['patterns', 'growthDashboard'],
    ),

    // ── 30. Year Synthesis ──
    ToolManifest(
      id: 'yearReview',
      nameEn: 'Year Synthesis',
      nameTr: 'Yıl Sentezi',
      valuePropositionEn: 'Look back at your entire year of observations.',
      valuePropositionTr: 'Tüm yılına geri bak.',
      route: Routes.yearReview,
      icon: '\u{1F389}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.analyze, IntentTag.reflect],
      timeToValueSeconds: 15,
      requiresPremium: true,
      relatedToolIds: ['monthlyReport', 'growthDashboard'],
    ),

    // ── 31. Dream Glossary ──
    ToolManifest(
      id: 'dreamGlossary',
      nameEn: 'Dream Glossary',
      nameTr: 'R\u00fcya S\u00f6zl\u00fc\u011f\u00fc',
      valuePropositionEn: 'Look up common dream symbols and meanings.',
      valuePropositionTr:
          'Yayg\u0131n r\u00fcya sembollerini ve anlamlar\u0131n\u0131 ara.',
      route: Routes.dreamGlossary,
      icon: '\u{1F4D6}',
      category: ToolCategory.reference,
      intentTags: [IntentTag.discover],
      timeToValueSeconds: 10,
      requiresPremium: true,
      relatedToolIds: ['dreamInterpretation'],
    ),

    // ── 33. Prompt Engine ──
    ToolManifest(
      id: 'promptLibrary',
      nameEn: 'Prompt Engine',
      nameTr: 'Yönlendirme Motoru',
      valuePropositionEn: 'Curated prompts for deeper reflection.',
      valuePropositionTr:
          'Daha derin yans\u0131ma i\u00e7in se\u00e7ilmi\u015f g\u00fcnl\u00fck y\u00f6nlendirmeleri.',
      route: Routes.promptLibrary,
      icon: '\u{270D}\u{FE0F}',
      category: ToolCategory.support,
      intentTags: [IntentTag.reflect],
      timeToValueSeconds: 10,
      relatedToolIds: ['journal'],
    ),

    // ── 36. Share Cards ──
    ToolManifest(
      id: 'shareCards',
      nameEn: 'Share Cards',
      nameTr: 'Payla\u015f\u0131m Kartlar\u0131',
      valuePropositionEn: 'Turn insights into beautiful shareable images.',
      valuePropositionTr:
          '\u0130\u00e7g\u00f6r\u00fcleri g\u00fczel payla\u015f\u0131labilir g\u00f6rsellere d\u00f6n\u00fc\u015ft\u00fcr.',
      route: Routes.shareCardGallery,
      icon: '\u{1F5BC}\u{FE0F}',
      category: ToolCategory.data,
      intentTags: [IntentTag.reflect],
      timeToValueSeconds: 30,
      relatedToolIds: ['journal', 'milestones'],
    ),

    // ── 37. Archive Vault ──
    ToolManifest(
      id: 'journalArchive',
      nameEn: 'Archive Vault',
      nameTr: 'Arşiv Kasası',
      valuePropositionEn: 'Browse all past entries in one place.',
      valuePropositionTr:
          'Tüm geçmiş kayıtlarını tek yerde gör.',
      route: Routes.journalArchive,
      icon: '\u{1F4DA}',
      category: ToolCategory.data,
      intentTags: [IntentTag.reflect],
      timeToValueSeconds: 5,
      relatedToolIds: ['journal', 'patterns'],
    ),

    // ── 40. Dream Archive ──
    ToolManifest(
      id: 'dreamArchive',
      nameEn: 'Dream Archive',
      nameTr: 'R\u00fcya Ar\u015fivi',
      valuePropositionEn: 'All your recorded dreams in chronological order.',
      valuePropositionTr:
          'T\u00fcm r\u00fcyalar\u0131n kronolojik s\u0131rayla.',
      route: Routes.dreamArchive,
      icon: '\u{1F30C}',
      category: ToolCategory.data,
      intentTags: [IntentTag.reflect],
      timeToValueSeconds: 5,
      relatedToolIds: ['dreamInterpretation', 'dreamGlossary'],
    ),

    // ── 41. Data Portability ──
    ToolManifest(
      id: 'exportData',
      nameEn: 'Data Portability',
      nameTr: 'Veri Taşınabilirliği',
      valuePropositionEn: 'Download all your data. Your data belongs to you.',
      valuePropositionTr: 'Tüm verilerini indir. Verilerin sana ait.',
      route: Routes.exportData,
      icon: '\u{1F4E5}',
      category: ToolCategory.data,
      intentTags: [IntentTag.track],
      timeToValueSeconds: 10,
      relatedToolIds: ['journal'],
    ),

    // ── 42. Insight Chat ──
    ToolManifest(
      id: 'insight',
      nameEn: 'Reflection Chat',
      nameTr: 'Yans\u0131ma Sohbeti',
      valuePropositionEn:
          'Talk through your thoughts with a reflective AI companion.',
      valuePropositionTr:
          'D\u00fc\u015f\u00fcncelerini yans\u0131t\u0131c\u0131 bir AI ile konu\u015f.',
      route: Routes.insight,
      icon: '\u{1F4AC}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.reflect, IntentTag.analyze],
      timeToValueSeconds: 30,
      requiresPremium: true,
      relatedToolIds: ['insightsDiscovery', 'journal', 'dreamInterpretation'],
    ),

    // ── 43. Routine Tracker ──
    ToolManifest(
      id: 'dailyHabits',
      nameEn: 'Routine Tracker',
      nameTr: 'Rutin Takipçisi',
      valuePropositionEn:
          'Log your daily micro-habits and build consistency.',
      valuePropositionTr:
          'Günlük mikro alışkanlıklarını kaydet ve tutarlılık oluştur.',
      route: Routes.dailyHabits,
      icon: '\u2705',
      category: ToolCategory.support,
      intentTags: [IntentTag.track, IntentTag.grow],
      timeToValueSeconds: 10,
      relatedToolIds: ['rituals', 'challenges'],
    ),

    // ── 44. Life Timeline ──
    ToolManifest(
      id: 'lifeTimeline',
      nameEn: 'Life Timeline',
      nameTr: 'Yaşam Zaman Çizelgesi',
      valuePropositionEn:
          'Record and revisit the moments that shape your identity.',
      valuePropositionTr:
          'Kimliğinizi şekillendiren anları kaydedin ve yeniden keşfedin.',
      route: Routes.lifeTimeline,
      icon: '\u{2728}',
      category: ToolCategory.journal,
      intentTags: [IntentTag.reflect, IntentTag.track],
      timeToValueSeconds: 30,
      requiresPremium: true,
      relatedToolIds: ['calendarHeatmap', 'journal', 'yearReview'],
    ),

    // ── 45. Birthday Agenda ──
    ToolManifest(
      id: 'birthdayAgenda',
      nameEn: 'Birthday Agenda',
      nameTr: 'Do\u{011F}um G\u{00FC}n\u{00FC} Ajandas\u{0131}',
      valuePropositionEn:
          'Never miss a birthday. Calendar view with reminders.',
      valuePropositionTr:
          'Hi\u{00E7}bir do\u{011F}um g\u{00FC}n\u{00FC}n\u{00FC} ka\u{00E7}\u{0131}rma. Hat\u{0131}rlat\u{0131}c\u{0131}l\u{0131} takvim g\u{00F6}r\u{00FC}n\u{00FC}m\u{00FC}.',
      route: Routes.birthdayAgenda,
      icon: '\u{1F382}',
      category: ToolCategory.journal,
      intentTags: [IntentTag.track],
      timeToValueSeconds: 30,
      relatedToolIds: ['lifeTimeline', 'calendarHeatmap'],
    ),
  ];
}
