// ════════════════════════════════════════════════════════════════════════════
// TOOL MANIFEST - Unified tool registry for InnerCycles ecosystem
// ════════════════════════════════════════════════════════════════════════════
// Each tool has: id, bilingual names, category, intent tags, route,
// templates, next-tool suggestions, empty state, and time-to-value.
// ════════════════════════════════════════════════════════════════════════════

import '../../core/constants/routes.dart';

enum ToolCategory { journal, analysis, discovery, support, reference, data }

enum IntentTag { grow, reflect, analyze, heal, track, discover }

enum NextToolCondition { always, ifOutputEntry, ifOutputReport, ifOutputScore, ifGoalMatch }

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
// TOOL MANIFEST REGISTRY - All 41 tools
// ════════════════════════════════════════════════════════════════════════════

class ToolManifestRegistry {
  ToolManifestRegistry._();

  static ToolManifest? findById(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
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
      valuePropositionTr: 'G\u00fcnl\u00fck kay\u0131t ile i\u00e7 d\u00f6ng\u00fclerini haritaland\u0131r.',
      route: Routes.journal,
      icon: '\u{1F4D3}',
      category: ToolCategory.journal,
      intentTags: [IntentTag.reflect, IntentTag.track],
      outputTypes: ['entry'],
      timeToValueSeconds: 60,
      nextTools: [
        NextToolSuggestion(toolId: 'patterns', condition: NextToolCondition.ifOutputEntry, reasonEn: 'Review patterns from your entries.', reasonTr: '\u00d6r\u00fcnt\u00fclerini incele.', priority: 90),
        NextToolSuggestion(toolId: 'emotionalCycles', condition: NextToolCondition.ifOutputEntry, reasonEn: 'See how your emotional cycle is shaping.', reasonTr: 'Duygusal d\u00f6ng\u00fcn\u00fc g\u00f6r.', priority: 80),
      ],
      relatedToolIds: ['patterns', 'gratitude', 'moodCheckin'],
      emptyState: ToolEmptyState(demoTemplateId: 'journal_quick', whyUsefulEn: 'Your first entry starts building personal patterns.', whyUsefulTr: '\u0130lk kay\u0131t\u0131n ki\u015fisel \u00f6r\u00fcnt\u00fcleri olu\u015fturmaya ba\u015flar.', requiredEntries: 0),
    ),

    // ── 2. Gratitude ──
    ToolManifest(
      id: 'gratitude',
      nameEn: 'Gratitude',
      nameTr: '\u015e\u00fckran',
      valuePropositionEn: 'Capture moments of gratitude to shift perspective.',
      valuePropositionTr: '\u015e\u00fckran anlar\u0131n\u0131 kaydet, bak\u0131\u015f a\u00e7\u0131n\u0131 de\u011fi\u015ftir.',
      route: Routes.gratitudeJournal,
      icon: '\u{1F64F}',
      category: ToolCategory.journal,
      intentTags: [IntentTag.reflect, IntentTag.heal],
      outputTypes: ['entry'],
      timeToValueSeconds: 30,
      nextTools: [
        NextToolSuggestion(toolId: 'journal', condition: NextToolCondition.always, reasonEn: 'Continue with a full journal entry.', reasonTr: 'Tam bir g\u00fcnl\u00fck kayd\u0131yla devam et.', priority: 80),
      ],
      relatedToolIds: ['journal', 'affirmations'],
      emptyState: ToolEmptyState(demoTemplateId: 'gratitude_quick', whyUsefulEn: 'Gratitude practice tends to shift perspective over time.', whyUsefulTr: '\u015e\u00fckran prati\u011fi zamanla bak\u0131\u015f a\u00e7\u0131s\u0131n\u0131 de\u011fi\u015ftirir.', requiredEntries: 0),
    ),

    // ── 3. Dream Interpretation ──
    ToolManifest(
      id: 'dreamInterpretation',
      nameEn: 'Dream Journal',
      nameTr: 'R\u00fcya G\u00fcnl\u00fc\u011f\u00fc',
      valuePropositionEn: 'Record and explore the meaning behind your dreams.',
      valuePropositionTr: 'R\u00fcyalar\u0131n\u0131 kaydet ve arkas\u0131ndaki anlamlar\u0131 ke\u015ffet.',
      route: Routes.dreamInterpretation,
      icon: '\u{1F319}',
      category: ToolCategory.journal,
      intentTags: [IntentTag.discover, IntentTag.reflect],
      outputTypes: ['dream_entry'],
      timeToValueSeconds: 60,
      nextTools: [
        NextToolSuggestion(toolId: 'dreamGlossary', condition: NextToolCondition.always, reasonEn: 'Look up symbols from your dream.', reasonTr: 'R\u00fcyandaki sembolleri ara.', priority: 80),
      ],
      relatedToolIds: ['dreamGlossary', 'journal'],
      emptyState: ToolEmptyState(demoTemplateId: 'dream_quick', whyUsefulEn: 'Dreams often surface thoughts you may not notice when awake.', whyUsefulTr: 'R\u00fcyalar uyan\u0131kken fark edemedi\u011fin d\u00fc\u015f\u00fcnceleri g\u00f6sterir.', requiredEntries: 0),
    ),

    // ── 4. Patterns ──
    ToolManifest(
      id: 'patterns',
      nameEn: 'Patterns',
      nameTr: '\u00d6r\u00fcnt\u00fcler',
      valuePropositionEn: 'Discover recurring themes across your journal entries.',
      valuePropositionTr: 'G\u00fcnl\u00fck kay\u0131tlar\u0131ndaki tekrarlayan temalar\u0131 ke\u015ffet.',
      route: Routes.journalPatterns,
      icon: '\u{1F50D}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.analyze, IntentTag.discover],
      inputTypes: ['journal_entries'],
      outputTypes: ['pattern_report'],
      timeToValueSeconds: 10,
      nextTools: [
        NextToolSuggestion(toolId: 'journal', condition: NextToolCondition.always, reasonEn: 'Add a new entry to refine your patterns.', reasonTr: '\u00d6r\u00fcnt\u00fclerini iyile\u015ftirmek i\u00e7in yeni kay\u0131t ekle.', priority: 80),
      ],
      relatedToolIds: ['emotionalCycles', 'moodTrends', 'journal'],
      emptyState: ToolEmptyState(demoTemplateId: 'patterns_overview', whyUsefulEn: 'Patterns emerge after 5+ entries. Each new entry adds clarity.', whyUsefulTr: '5+ kay\u0131ttan sonra \u00f6r\u00fcnt\u00fcler ortaya \u00e7\u0131kar.', requiredEntries: 5),
    ),

    // ── 5. Emotional Cycles ──
    ToolManifest(
      id: 'emotionalCycles',
      nameEn: 'Emotional Cycles',
      nameTr: 'Duygusal D\u00f6ng\u00fcler',
      valuePropositionEn: 'Visualize how your emotions flow over time.',
      valuePropositionTr: 'Duygular\u0131n\u0131n zaman i\u00e7inde nas\u0131l akt\u0131\u011f\u0131n\u0131 g\u00f6rselle\u015ftir.',
      route: Routes.emotionalCycles,
      icon: '\u{1F30A}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.analyze, IntentTag.track],
      inputTypes: ['journal_entries'],
      outputTypes: ['cycle_chart'],
      timeToValueSeconds: 10,
      nextTools: [
        NextToolSuggestion(toolId: 'journal', condition: NextToolCondition.always, reasonEn: 'Track today\'s position in your cycle.', reasonTr: 'D\u00f6ng\u00fcndeki bug\u00fcnk\u00fc konumunu izle.', priority: 80),
      ],
      relatedToolIds: ['patterns', 'moodTrends'],
      emptyState: ToolEmptyState(demoTemplateId: 'cycles_demo', whyUsefulEn: 'After 7+ entries, emotional cycle patterns start to appear.', whyUsefulTr: '7+ kay\u0131ttan sonra duygusal d\u00f6ng\u00fc \u00f6r\u00fcnt\u00fcleri g\u00f6r\u00fcn\u00fcr.', requiredEntries: 7),
    ),

    // ── 6. Mood Trends ──
    ToolManifest(
      id: 'moodTrends',
      nameEn: 'Mood Trends',
      nameTr: 'Ruh Hali Trendleri',
      valuePropositionEn: 'Track your mood direction over days and weeks.',
      valuePropositionTr: 'G\u00fcnler ve haftalar boyunca ruh hali y\u00f6n\u00fcn\u00fc izle.',
      route: Routes.moodTrends,
      icon: '\u{1F4C8}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.track, IntentTag.analyze],
      timeToValueSeconds: 5,
      relatedToolIds: ['emotionalCycles', 'patterns'],
    ),

    // ── 7. Breathing ──
    ToolManifest(
      id: 'breathing',
      nameEn: 'Breathing',
      nameTr: 'Nefes',
      valuePropositionEn: 'Guided breathing exercises for calm and focus.',
      valuePropositionTr: 'Sakinlik ve odak i\u00e7in rehberli nefes egzersizleri.',
      route: Routes.breathing,
      icon: '\u{1F32C}\u{FE0F}',
      category: ToolCategory.support,
      intentTags: [IntentTag.heal],
      outputTypes: ['session_complete'],
      timeToValueSeconds: 120,
      nextTools: [
        NextToolSuggestion(toolId: 'journal', condition: NextToolCondition.always, reasonEn: 'Journal how you feel after breathing.', reasonTr: 'Nefes sonras\u0131 nas\u0131l hissetti\u011fini yaz.', priority: 70),
      ],
      relatedToolIds: ['meditation', 'rituals'],
    ),

    // ── 8. Meditation ──
    ToolManifest(
      id: 'meditation',
      nameEn: 'Meditation',
      nameTr: 'Meditasyon',
      valuePropositionEn: 'Short guided meditations for grounding.',
      valuePropositionTr: 'Topraklanma i\u00e7in k\u0131sa rehberli meditasyonlar.',
      route: Routes.meditation,
      icon: '\u{1F9D8}',
      category: ToolCategory.support,
      intentTags: [IntentTag.heal],
      timeToValueSeconds: 180,
      relatedToolIds: ['breathing', 'rituals'],
    ),

    // ── 9. Affirmations ──
    ToolManifest(
      id: 'affirmations',
      nameEn: 'Affirmations',
      nameTr: 'Olumlamalar',
      valuePropositionEn: 'Daily affirmations to set your intention.',
      valuePropositionTr: 'Niyetini belirlemek i\u00e7in g\u00fcnl\u00fck olumlamalar.',
      route: Routes.affirmations,
      icon: '\u{2728}',
      category: ToolCategory.support,
      intentTags: [IntentTag.grow, IntentTag.heal],
      timeToValueSeconds: 10,
      relatedToolIds: ['gratitude', 'rituals'],
    ),

    // ── 10. Rituals ──
    ToolManifest(
      id: 'rituals',
      nameEn: 'Rituals',
      nameTr: 'Rit\u00fceller',
      valuePropositionEn: 'Build and track personal daily rituals.',
      valuePropositionTr: 'Ki\u015fisel g\u00fcnl\u00fck rit\u00fceller olu\u015ftur ve izle.',
      route: Routes.rituals,
      icon: '\u{1F56F}\u{FE0F}',
      category: ToolCategory.support,
      intentTags: [IntentTag.grow, IntentTag.track],
      timeToValueSeconds: 30,
      relatedToolIds: ['breathing', 'meditation', 'habitSuggestions'],
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
      valuePropositionTr: 'Zaman i\u00e7indeki uyku \u00f6r\u00fcnt\u00fclerini g\u00f6r.',
      route: Routes.sleepTrends,
      icon: '\u{1F4CA}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.analyze, IntentTag.track],
      timeToValueSeconds: 5,
      relatedToolIds: ['sleep', 'wellness'],
    ),

    // ── 13. Wellness Score ──
    ToolManifest(
      id: 'wellness',
      nameEn: 'Wellness',
      nameTr: 'Sa\u011fl\u0131k',
      valuePropositionEn: 'A holistic wellness score from your daily data.',
      valuePropositionTr: 'G\u00fcnl\u00fck verilerinden b\u00fct\u00fcnsel bir sa\u011fl\u0131k skoru.',
      route: Routes.wellnessDetail,
      icon: '\u{1F49A}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.track],
      outputTypes: ['score'],
      timeToValueSeconds: 5,
      relatedToolIds: ['sleep', 'moodTrends', 'energyMap'],
    ),

    // ── 14. Energy Map ──
    ToolManifest(
      id: 'energyMap',
      nameEn: 'Energy Map',
      nameTr: 'Enerji Haritas\u0131',
      valuePropositionEn: 'Visualize your daily energy fluctuations.',
      valuePropositionTr: 'G\u00fcnl\u00fck enerji dalgalanmalar\u0131n\u0131 g\u00f6rselle\u015ftir.',
      route: Routes.energyMap,
      icon: '\u{26A1}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.track, IntentTag.analyze],
      timeToValueSeconds: 10,
      relatedToolIds: ['wellness', 'moodTrends'],
    ),

    // ── 15. Quiz Hub ──
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

    // ── 17. Blind Spot ──
    ToolManifest(
      id: 'blindSpot',
      nameEn: 'Blind Spots',
      nameTr: 'K\u00f6r Noktalar',
      valuePropositionEn: 'Uncover patterns you might not see on your own.',
      valuePropositionTr: 'Kendi ba\u015f\u0131na g\u00f6remeyece\u011fin \u00f6r\u00fcnt\u00fcleri ke\u015ffet.',
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
      valuePropositionTr: 'G\u00fcnl\u00fck verilerinden ke\u015ffedilen i\u00e7g\u00f6r\u00fcler.',
      route: Routes.insightsDiscovery,
      icon: '\u{1F4A1}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.discover, IntentTag.analyze],
      timeToValueSeconds: 10,
      relatedToolIds: ['patterns', 'journal'],
    ),

    // ── 19. Calendar Heatmap ──
    ToolManifest(
      id: 'calendarHeatmap',
      nameEn: 'Calendar',
      nameTr: 'Takvim',
      valuePropositionEn: 'A heatmap view of your journaling activity.',
      valuePropositionTr: 'G\u00fcnl\u00fck aktiviteni \u0131s\u0131 haritas\u0131 olarak g\u00f6r.',
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
      relatedToolIds: ['challenges', 'milestones', 'streakStats'],
    ),

    // ── 21. Challenges ──
    ToolManifest(
      id: 'challenges',
      nameEn: 'Challenges',
      nameTr: 'G\u00f6revler',
      valuePropositionEn: 'Weekly and monthly growth challenges.',
      valuePropositionTr: 'Haftal\u0131k ve ayl\u0131k geli\u015fim g\u00f6revleri.',
      route: Routes.challenges,
      icon: '\u{1F3C6}',
      category: ToolCategory.data,
      intentTags: [IntentTag.grow],
      timeToValueSeconds: 10,
      relatedToolIds: ['growthDashboard', 'milestones'],
    ),

    // ── 22. Milestones ──
    ToolManifest(
      id: 'milestones',
      nameEn: 'Milestones',
      nameTr: 'Kilometre Ta\u015flar\u0131',
      valuePropositionEn: 'Celebrate progress with badges and milestones.',
      valuePropositionTr: 'Rozetler ve kilometre ta\u015flar\u0131 ile ilerlemeyi kutla.',
      route: Routes.milestones,
      icon: '\u{1F3C5}',
      category: ToolCategory.data,
      intentTags: [IntentTag.grow, IntentTag.track],
      timeToValueSeconds: 5,
      relatedToolIds: ['growthDashboard', 'challenges', 'shareCards'],
    ),

    // ── 23. Streak Stats ──
    ToolManifest(
      id: 'streakStats',
      nameEn: 'Streak Stats',
      nameTr: 'Seri \u0130statistikleri',
      valuePropositionEn: 'See your current and longest journaling streaks.',
      valuePropositionTr: 'Mevcut ve en uzun g\u00fcnl\u00fck serilerini g\u00f6r.',
      route: Routes.streakStats,
      icon: '\u{1F525}',
      category: ToolCategory.data,
      intentTags: [IntentTag.track, IntentTag.grow],
      timeToValueSeconds: 5,
      relatedToolIds: ['calendarHeatmap', 'growthDashboard'],
    ),

    // ── 24. Programs ──
    ToolManifest(
      id: 'programs',
      nameEn: 'Programs',
      nameTr: 'Programlar',
      valuePropositionEn: 'Multi-day guided programs for deeper exploration.',
      valuePropositionTr: '\u00c7ok g\u00fcnl\u00fck rehberli programlar.',
      route: Routes.programs,
      icon: '\u{1F4DA}',
      category: ToolCategory.discovery,
      intentTags: [IntentTag.grow, IntentTag.discover],
      timeToValueSeconds: 60,
      requiresPremium: true,
      relatedToolIds: ['journal', 'rituals'],
    ),

    // ── 25. Seasonal Reflection ──
    ToolManifest(
      id: 'seasonal',
      nameEn: 'Seasonal',
      nameTr: 'Mevsimsel',
      valuePropositionEn: 'Reflect on how seasons influence your inner state.',
      valuePropositionTr: 'Mevsimlerin i\u00e7 d\u00fcnyan\u0131 nas\u0131l etkiledi\u011fini yans\u0131t.',
      route: Routes.seasonal,
      icon: '\u{1F343}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.reflect, IntentTag.discover],
      timeToValueSeconds: 15,
      relatedToolIds: ['journal', 'rituals'],
    ),

    // ── 26. Moon Calendar ──
    ToolManifest(
      id: 'moonCalendar',
      nameEn: 'Moon Calendar',
      nameTr: 'Ay Takvimi',
      valuePropositionEn: 'Track lunar phases alongside your journal.',
      valuePropositionTr: 'Ay evrelerini g\u00fcnl\u00fc\u011f\u00fcnle birlikte izle.',
      route: Routes.moonCalendar,
      icon: '\u{1F31D}',
      category: ToolCategory.reference,
      intentTags: [IntentTag.track, IntentTag.discover],
      timeToValueSeconds: 10,
      relatedToolIds: ['journal', 'emotionalCycles'],
    ),

    // ── 27. Habit Suggestions ──
    ToolManifest(
      id: 'habitSuggestions',
      nameEn: 'Habits',
      nameTr: 'Al\u0131\u015fkanl\u0131klar',
      valuePropositionEn: 'Personalized habit suggestions from your data.',
      valuePropositionTr: 'Verilerinden ki\u015fiselle\u015ftirilmi\u015f al\u0131\u015fkanl\u0131k \u00f6nerileri.',
      route: Routes.habitSuggestions,
      icon: '\u{1F4AA}',
      category: ToolCategory.support,
      intentTags: [IntentTag.grow],
      timeToValueSeconds: 15,
      relatedToolIds: ['rituals', 'challenges'],
    ),

    // ── 28. Weekly Digest ──
    ToolManifest(
      id: 'weeklyDigest',
      nameEn: 'Weekly Digest',
      nameTr: 'Haftal\u0131k \u00d6zet',
      valuePropositionEn: 'A concise summary of your past week.',
      valuePropositionTr: 'Ge\u00e7en haftan\u0131n k\u0131sa \u00f6zeti.',
      route: Routes.weeklyDigest,
      icon: '\u{1F4CB}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.analyze, IntentTag.reflect],
      timeToValueSeconds: 10,
      relatedToolIds: ['patterns', 'journal'],
      emptyState: ToolEmptyState(demoTemplateId: 'digest_current', whyUsefulEn: 'Available after 5 entries in a week.', whyUsefulTr: 'Bir haftada 5 kay\u0131ttan sonra kullan\u0131labilir.', requiredEntries: 5),
    ),

    // ── 29. Monthly Report ──
    ToolManifest(
      id: 'monthlyReport',
      nameEn: 'Monthly Report',
      nameTr: 'Ayl\u0131k Rapor',
      valuePropositionEn: 'A comprehensive look at your past month.',
      valuePropositionTr: 'Ge\u00e7en ay\u0131na kapsaml\u0131 bir bak\u0131\u015f.',
      route: Routes.journalMonthly,
      icon: '\u{1F4C4}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.analyze, IntentTag.reflect],
      timeToValueSeconds: 10,
      requiresPremium: true,
      relatedToolIds: ['patterns', 'growthDashboard'],
    ),

    // ── 30. Year Review ──
    ToolManifest(
      id: 'yearReview',
      nameEn: 'Year in Review',
      nameTr: 'Y\u0131l De\u011ferlendirmesi',
      valuePropositionEn: 'Look back at your entire year of growth.',
      valuePropositionTr: 'T\u00fcm y\u0131l\u0131na geri bak.',
      route: Routes.yearReview,
      icon: '\u{1F389}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.analyze, IntentTag.reflect],
      timeToValueSeconds: 15,
      requiresPremium: true,
      relatedToolIds: ['monthlyReport', 'growthDashboard'],
    ),

    // ── 31. Compatibility ──
    ToolManifest(
      id: 'compatibility',
      nameEn: 'Compatibility',
      nameTr: 'Uyumluluk',
      valuePropositionEn: 'Explore how you relate to others.',
      valuePropositionTr: 'Ba\u015fkalar\u0131yla nas\u0131l ili\u015fkilendi\u011fini ke\u015ffet.',
      route: Routes.compatibilityReflection,
      icon: '\u{1F91D}',
      category: ToolCategory.discovery,
      intentTags: [IntentTag.discover],
      timeToValueSeconds: 60,
      requiresPremium: true,
      relatedToolIds: ['archetype', 'quizHub'],
    ),

    // ── 32. Dream Glossary ──
    ToolManifest(
      id: 'dreamGlossary',
      nameEn: 'Dream Glossary',
      nameTr: 'R\u00fcya S\u00f6zl\u00fc\u011f\u00fc',
      valuePropositionEn: 'Look up common dream symbols and meanings.',
      valuePropositionTr: 'Yayg\u0131n r\u00fcya sembollerini ve anlamlar\u0131n\u0131 ara.',
      route: Routes.dreamGlossary,
      icon: '\u{1F4D6}',
      category: ToolCategory.reference,
      intentTags: [IntentTag.discover],
      timeToValueSeconds: 10,
      relatedToolIds: ['dreamInterpretation'],
    ),

    // ── 33. Glossary ──
    ToolManifest(
      id: 'glossary',
      nameEn: 'Glossary',
      nameTr: 'S\u00f6zl\u00fck',
      valuePropositionEn: 'Reference for wellness and journaling terms.',
      valuePropositionTr: 'Sa\u011fl\u0131k ve g\u00fcnl\u00fck terimler i\u00e7in referans.',
      route: Routes.glossary,
      icon: '\u{1F4D6}',
      category: ToolCategory.reference,
      intentTags: [IntentTag.discover],
      timeToValueSeconds: 5,
      relatedToolIds: ['articles'],
    ),

    // ── 34. Articles ──
    ToolManifest(
      id: 'articles',
      nameEn: 'Articles',
      nameTr: 'Makaleler',
      valuePropositionEn: 'Curated wellness articles and guides.',
      valuePropositionTr: 'Se\u00e7ilmi\u015f sa\u011fl\u0131k makaleleri ve k\u0131lavuzlar.',
      route: Routes.articles,
      icon: '\u{1F4F0}',
      category: ToolCategory.reference,
      intentTags: [IntentTag.discover],
      timeToValueSeconds: 120,
      relatedToolIds: ['glossary'],
    ),

    // ── 35. Prompt Library ──
    ToolManifest(
      id: 'promptLibrary',
      nameEn: 'Prompts',
      nameTr: 'Y\u00f6nlendirmeler',
      valuePropositionEn: 'Curated journal prompts for deeper reflection.',
      valuePropositionTr: 'Daha derin yans\u0131ma i\u00e7in se\u00e7ilmi\u015f g\u00fcnl\u00fck y\u00f6nlendirmeleri.',
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
      valuePropositionTr: '\u0130\u00e7g\u00f6r\u00fcleri g\u00fczel payla\u015f\u0131labilir g\u00f6rsellere d\u00f6n\u00fc\u015ft\u00fcr.',
      route: Routes.shareCardGallery,
      icon: '\u{1F5BC}\u{FE0F}',
      category: ToolCategory.data,
      intentTags: [IntentTag.reflect],
      timeToValueSeconds: 30,
      relatedToolIds: ['journal', 'milestones'],
    ),

    // ── 37. Share Insight ──
    ToolManifest(
      id: 'shareInsight',
      nameEn: 'Share Insight',
      nameTr: '\u0130\u00e7g\u00f6r\u00fc Payla\u015f',
      valuePropositionEn: 'Share a meaningful insight with others.',
      valuePropositionTr: 'Anlaml\u0131 bir i\u00e7g\u00f6r\u00fcy\u00fc ba\u015fkalar\u0131yla payla\u015f.',
      route: Routes.shareInsight,
      icon: '\u{1F4E4}',
      category: ToolCategory.data,
      intentTags: [IntentTag.reflect],
      timeToValueSeconds: 15,
      relatedToolIds: ['shareCards'],
    ),

    // ── 38. Emotional Vocabulary ──
    ToolManifest(
      id: 'emotionalVocabulary',
      nameEn: 'Emotion Words',
      nameTr: 'Duygu Kelimeler',
      valuePropositionEn: 'Expand your emotional vocabulary for richer entries.',
      valuePropositionTr: 'Daha zengin kay\u0131tlar i\u00e7in duygusal kelime da\u011farc\u0131\u011f\u0131n\u0131 geni\u015flet.',
      route: Routes.emotionalVocabulary,
      icon: '\u{1F4AC}',
      category: ToolCategory.reference,
      intentTags: [IntentTag.discover],
      timeToValueSeconds: 10,
      relatedToolIds: ['journal'],
    ),

    // ── 39. Journal Archive ──
    ToolManifest(
      id: 'journalArchive',
      nameEn: 'Journal Archive',
      nameTr: 'G\u00fcnl\u00fck Ar\u015fivi',
      valuePropositionEn: 'Browse all past journal entries in one place.',
      valuePropositionTr: 'T\u00fcm ge\u00e7mi\u015f g\u00fcnl\u00fck kay\u0131tlar\u0131n\u0131 tek yerde g\u00f6r.',
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
      valuePropositionTr: 'T\u00fcm r\u00fcyalar\u0131n kronolojik s\u0131rayla.',
      route: Routes.dreamArchive,
      icon: '\u{1F30C}',
      category: ToolCategory.data,
      intentTags: [IntentTag.reflect],
      timeToValueSeconds: 5,
      relatedToolIds: ['dreamInterpretation', 'dreamGlossary'],
    ),

    // ── 41. Export Data ──
    ToolManifest(
      id: 'exportData',
      nameEn: 'Export',
      nameTr: 'D\u0131\u015fa Aktar',
      valuePropositionEn: 'Download all your data. Your data belongs to you.',
      valuePropositionTr: 'T\u00fcm verilerini indir. Verilerin sana ait.',
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
      valuePropositionEn: 'Talk through your thoughts with a reflective AI companion.',
      valuePropositionTr: 'D\u00fc\u015f\u00fcncelerini yans\u0131t\u0131c\u0131 bir AI ile konu\u015f.',
      route: Routes.insight,
      icon: '\u{1F4AC}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.reflect, IntentTag.analyze],
      timeToValueSeconds: 30,
      relatedToolIds: ['insightsDiscovery', 'journal', 'dreamInterpretation'],
    ),

    // ── 43. Daily Habits ──
    ToolManifest(
      id: 'dailyHabits',
      nameEn: 'Daily Habits',
      nameTr: 'G\u00fcnl\u00fck Al\u0131\u015fkanl\u0131klar',
      valuePropositionEn: 'Track your daily micro-habits and build consistency.',
      valuePropositionTr: 'G\u00fcnl\u00fck mikro al\u0131\u015fkanl\u0131klar\u0131n\u0131 takip et.',
      route: Routes.dailyHabits,
      icon: '\u2705',
      category: ToolCategory.support,
      intentTags: [IntentTag.track, IntentTag.grow],
      timeToValueSeconds: 10,
      relatedToolIds: ['habitSuggestions', 'rituals', 'challenges'],
    ),

    // ── 44. Monthly Reflection ──
    ToolManifest(
      id: 'monthlyReflection',
      nameEn: 'Monthly Reflection',
      nameTr: 'Ayl\u0131k Yans\u0131ma',
      valuePropositionEn: 'Review your month with theme-based insights and patterns.',
      valuePropositionTr: 'Ay\u0131n\u0131 tema bazl\u0131 i\u00e7g\u00f6r\u00fc ve kal\u0131plarla de\u011ferlendir.',
      route: Routes.journalMonthly,
      icon: '\u{1F4C6}',
      category: ToolCategory.analysis,
      intentTags: [IntentTag.reflect, IntentTag.analyze],
      timeToValueSeconds: 15,
      relatedToolIds: ['patterns', 'yearReview', 'journal'],
    ),
  ];
}
