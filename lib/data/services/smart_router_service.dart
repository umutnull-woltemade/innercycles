// ════════════════════════════════════════════════════════════════════════════
// SMART ROUTER SERVICE - Context-Aware Tool Suggestions
// ════════════════════════════════════════════════════════════════════════════
// Analyzes user context (screen, goals, streaks, outputs) and returns
// prioritized next-action suggestions. Uses safe language patterns only.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tool_manifest.dart';

// ════════════════════════════════════════════════════════════════════════════
// SMART ROUTER CONTEXT
// ════════════════════════════════════════════════════════════════════════════

class SmartRouterContext {
  final String currentScreen;
  final Set<String> userGoals;
  final String? lastOutputType;
  final bool isNewUser;
  final int totalEntries;
  final int currentStreak;
  final int idleSeconds;
  final int toolVisitCount;
  final String? activeChallenge;
  final int timeBudgetMinutes;

  const SmartRouterContext({
    required this.currentScreen,
    this.userGoals = const {},
    this.lastOutputType,
    this.isNewUser = true,
    this.totalEntries = 0,
    this.currentStreak = 0,
    this.idleSeconds = 0,
    this.toolVisitCount = 0,
    this.activeChallenge,
    this.timeBudgetMinutes = 15,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// TOOL SUGGESTION
// ════════════════════════════════════════════════════════════════════════════

class ToolSuggestion {
  final String toolId;
  final String route;
  final String reasonEn;
  final String reasonTr;
  final int priority;
  final String source;

  const ToolSuggestion({
    required this.toolId,
    required this.route,
    required this.reasonEn,
    required this.reasonTr,
    required this.priority,
    required this.source,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// SMART ROUTER SERVICE
// ════════════════════════════════════════════════════════════════════════════

class SmartRouterService {
  static const String _recentToolsKey = 'smart_router_recent_tools';
  static const String _favoriteToolsKey = 'smart_router_favorite_tools';
  static const String _toolVisitCountsKey = 'smart_router_tool_visit_counts';
  static const String _userGoalsKey = 'smart_router_user_goals';
  static const String _timeBudgetKey = 'smart_router_time_budget';
  static const int _maxRecentTools = 20;

  final SharedPreferences _prefs;
  List<String> _recentTools;
  final Set<String> _favoriteTools;
  final Map<String, int> _toolVisitCounts;
  Set<String> _userGoals;
  int _timeBudgetMinutes;

  SmartRouterService._(
    this._prefs, {
    required List<String> recentTools,
    required Set<String> favoriteTools,
    required Map<String, int> toolVisitCounts,
    required Set<String> userGoals,
    required int timeBudgetMinutes,
  })  : _recentTools = recentTools,
        _favoriteTools = favoriteTools,
        _toolVisitCounts = toolVisitCounts,
        _userGoals = userGoals,
        _timeBudgetMinutes = timeBudgetMinutes;

  static Future<SmartRouterService> init() async {
    final prefs = await SharedPreferences.getInstance();

    var recentTools = <String>[];
    var favoriteTools = <String>{};
    var toolVisitCounts = <String, int>{};
    var userGoals = <String>{};
    try {
      final recentJson = prefs.getString(_recentToolsKey);
      if (recentJson != null) {
        recentTools = List<String>.from(jsonDecode(recentJson) as List);
      }
      final favJson = prefs.getString(_favoriteToolsKey);
      if (favJson != null) {
        favoriteTools = Set<String>.from(jsonDecode(favJson) as List);
      }
      final countsJson = prefs.getString(_toolVisitCountsKey);
      if (countsJson != null) {
        toolVisitCounts = Map<String, int>.from(jsonDecode(countsJson) as Map);
      }
      final goalsJson = prefs.getString(_userGoalsKey);
      if (goalsJson != null) {
        userGoals = Set<String>.from(jsonDecode(goalsJson) as List);
      }
    } catch (_) {
      // Reset to defaults on corrupted data
    }

    final timeBudget = prefs.getInt(_timeBudgetKey) ?? 15;

    return SmartRouterService._(
      prefs,
      recentTools: recentTools,
      favoriteTools: favoriteTools,
      toolVisitCounts: toolVisitCounts,
      userGoals: userGoals,
      timeBudgetMinutes: timeBudget,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // NEXT ACTIONS (R1-R12)
  // ══════════════════════════════════════════════════════════════════════════

  List<ToolSuggestion> getNextActions(SmartRouterContext ctx) {
    final suggestions = <ToolSuggestion>[];

    // R1 (100): New user < 1 entry
    if (ctx.totalEntries < 1) {
      suggestions.addAll([
        const ToolSuggestion(toolId: 'journal', route: '/journal', reasonEn: 'Start with a guided template to capture your first entry.', reasonTr: 'Ilk girisini kaydetmek icin rehberli bir sablonla basla.', priority: 100, source: 'R1'),
        const ToolSuggestion(toolId: 'programs', route: '/programs', reasonEn: 'Explore a quick demo to see what you can discover here.', reasonTr: 'Burada neler kesfedebilecegin icin hizli bir demo incele.', priority: 100, source: 'R1'),
      ]);
    }

    // R2 (95): Active challenge
    if (ctx.activeChallenge != null) {
      suggestions.add(ToolSuggestion(toolId: 'challenges', route: '/challenges', reasonEn: 'You have an active challenge. Continue today\'s action.', reasonTr: 'Aktif bir meydan okuman var. Bugunku aksiyonu tamamla.', priority: 95, source: 'R2'));
    }

    // R3 (90): Last output was "entry"
    if (ctx.lastOutputType == 'entry') {
      suggestions.addAll([
        const ToolSuggestion(toolId: 'patterns', route: '/journal/patterns', reasonEn: 'You just wrote an entry. Review your patterns.', reasonTr: 'Az once bir giris yazdin. Kaliplarini incele.', priority: 90, source: 'R3'),
        const ToolSuggestion(toolId: 'emotionalCycles', route: '/emotional-cycles', reasonEn: 'Your new entry may reveal trends in your cycles.', reasonTr: 'Yeni girisin dongulerindeki egilimler hakkinda ipucu verebilir.', priority: 88, source: 'R3'),
      ]);
    }

    // R4 (85): Last output was "report"
    if (ctx.lastOutputType == 'report') {
      suggestions.addAll([
        const ToolSuggestion(toolId: 'journal', route: '/journal', reasonEn: 'Your report is ready. Add a new entry to feed your patterns.', reasonTr: 'Raporun hazir. Kaliplarini beslemek icin yeni bir giris ekle.', priority: 85, source: 'R4'),
        const ToolSuggestion(toolId: 'shareInsight', route: '/share-insight', reasonEn: 'Share your latest insight as a card.', reasonTr: 'Son icgorunu bir kart olarak paylas.', priority: 83, source: 'R4'),
      ]);
    }

    // R5 (80): Last output was "score"
    if (ctx.lastOutputType == 'score') {
      suggestions.addAll([
        const ToolSuggestion(toolId: 'moodTrends', route: '/mood/trends', reasonEn: 'Check your trends to see how your score fits.', reasonTr: 'Egilimlerini kontrol ederek skorunun nasil uyuyor gor.', priority: 80, source: 'R5'),
        const ToolSuggestion(toolId: 'challenges', route: '/challenges', reasonEn: 'Turn your score into action with a challenge.', reasonTr: 'Skorunu bir meydan okumayla aksiyona donustur.', priority: 78, source: 'R5'),
      ]);
    }

    // R6 (75): Idle > 120s
    if (ctx.idleSeconds > 120) {
      suggestions.add(const ToolSuggestion(toolId: 'programs', route: '/programs', reasonEn: 'Feeling stuck? A guided program can help.', reasonTr: 'Takildim mi hissediyorsun? Rehberli bir program yardimci olabilir.', priority: 75, source: 'R6'));
    }

    // R7 (70): Tool visited 3+ times without output
    if (ctx.toolVisitCount >= 3) {
      final alt = _findAlternative(ctx.currentScreen);
      if (alt != null) suggestions.add(alt);
    }

    // R8 (65): Streak == 0 && entries > 5
    if (ctx.currentStreak == 0 && ctx.totalEntries > 5) {
      suggestions.add(const ToolSuggestion(toolId: 'challenges', route: '/challenges', reasonEn: 'Your streak paused. A recovery challenge may help.', reasonTr: 'Serin durdu. Bir toparlanma gorevi yardimci olabilir.', priority: 65, source: 'R8'));
    }

    // R9 (60): Time budget <= 5 min
    if (ctx.timeBudgetMinutes <= 5) {
      suggestions.addAll([
        const ToolSuggestion(toolId: 'gratitude', route: '/gratitude', reasonEn: 'Short on time? A quick gratitude note takes under a minute.', reasonTr: 'Zamanin mi az? Hizli bir sukran notu bir dakikadan kisa surer.', priority: 60, source: 'R9'),
        const ToolSuggestion(toolId: 'breathing', route: '/breathing', reasonEn: 'A 2-minute breathing exercise fits any schedule.', reasonTr: 'Iki dakikalik bir nefes egzersizi her programa sigar.', priority: 59, source: 'R9'),
        const ToolSuggestion(toolId: 'affirmations', route: '/affirmations', reasonEn: 'Read today\'s affirmation in just a few seconds.', reasonTr: 'Bugunku olumlamayi sadece birkac saniyede oku.', priority: 58, source: 'R9'),
      ]);
    }

    // R10 (50): Goal "discover"
    if (ctx.userGoals.contains('discover')) {
      suggestions.add(const ToolSuggestion(toolId: 'insightsDiscovery', route: '/insights-discovery', reasonEn: 'Based on your goal to discover, explore new insights.', reasonTr: 'Kesfetme hedefine gore yeni icgoruleri incele.', priority: 50, source: 'R10'));
    }

    // R11 (50): Goal "habit"
    if (ctx.userGoals.contains('habit')) {
      suggestions.add(const ToolSuggestion(toolId: 'rituals', route: '/rituals', reasonEn: 'Building habits? Your ritual stack helps you stay consistent.', reasonTr: 'Aliskanlik olusturuyorsun? Rituel yiginin tutarli kalmana yardimci olur.', priority: 50, source: 'R11'));
    }

    // R12 (50): Goal "heal"
    if (ctx.userGoals.contains('heal')) {
      suggestions.add(const ToolSuggestion(toolId: 'journal', route: '/journal', reasonEn: 'Journaling can support your healing process.', reasonTr: 'Gunluk tutmak iyilesme surecini destekleyebilir.', priority: 50, source: 'R12'));
    }

    // Deduplicate + sort + cap at 3
    final deduped = _deduplicateByToolId(suggestions);
    deduped.sort((a, b) => b.priority.compareTo(a.priority));
    return deduped.take(3).toList();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // RELATED TOOLS
  // ══════════════════════════════════════════════════════════════════════════

  List<ToolSuggestion> getRelatedTools(String currentToolId) {
    final manifest = ToolManifestRegistry.findById(currentToolId);
    if (manifest == null) return [];

    return manifest.relatedToolIds.map((relatedId) {
      final related = ToolManifestRegistry.findById(relatedId);
      if (related == null) return null;
      return ToolSuggestion(
        toolId: related.id,
        route: related.route,
        reasonEn: 'Related to ${manifest.labelEn}.',
        reasonTr: '${manifest.labelTr} ile iliskili.',
        priority: 40,
        source: 'related',
      );
    }).whereType<ToolSuggestion>().toList();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TOOL VISIT TRACKING
  // ══════════════════════════════════════════════════════════════════════════

  void recordToolVisit(String toolId) {
    _recentTools.remove(toolId);
    _recentTools.insert(0, toolId);
    if (_recentTools.length > _maxRecentTools) {
      _recentTools = _recentTools.sublist(0, _maxRecentTools);
    }
    _toolVisitCounts[toolId] = (_toolVisitCounts[toolId] ?? 0) + 1;
    _persistRecentTools();
    _persistToolVisitCounts();
  }

  void recordOutput(String toolId, String outputType) {
    _toolVisitCounts[toolId] = 0;
    _persistToolVisitCounts();
  }

  List<String> getRecentTools({int limit = 5}) {
    return _recentTools.take(limit).toList();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FAVORITES
  // ══════════════════════════════════════════════════════════════════════════

  Set<String> getFavoriteTools() => Set.unmodifiable(_favoriteTools);

  bool isFavorite(String toolId) => _favoriteTools.contains(toolId);

  bool toggleFavorite(String toolId) {
    if (_favoriteTools.contains(toolId)) {
      _favoriteTools.remove(toolId);
      _persistFavoriteTools();
      return false;
    } else {
      _favoriteTools.add(toolId);
      _persistFavoriteTools();
      return true;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // GOALS & BUDGET
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> setUserGoals(Set<String> goals) async {
    _userGoals = goals;
    await _prefs.setString(_userGoalsKey, jsonEncode(_userGoals.toList()));
  }

  Set<String> getUserGoals() => Set.unmodifiable(_userGoals);

  Future<void> setTimeBudget(int minutes) async {
    _timeBudgetMinutes = minutes;
    await _prefs.setInt(_timeBudgetKey, minutes);
  }

  int getTimeBudget() => _timeBudgetMinutes;

  // ══════════════════════════════════════════════════════════════════════════
  // INTERNAL HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  ToolSuggestion? _findAlternative(String currentRoute) {
    const alternatives = <String, List<String>>{
      '/journal': ['/gratitude', 'gratitude', 'Try gratitude journaling for a different angle.', 'Farkli bir bakis acisi icin sukran gunlugunu dene.'],
      '/gratitude': ['/journal', 'journal', 'Switch to your main journal for deeper reflection.', 'Daha derin yansima icin ana gunlugune gec.'],
      '/breathing': ['/meditation', 'meditation', 'Try a guided meditation for a change of pace.', 'Tempo degisikligi icin rehberli bir meditasyon dene.'],
      '/meditation': ['/breathing', 'breathing', 'A focused breathing exercise might feel better right now.', 'Odakli bir nefes egzersizi simdi daha iyi hissettirebilir.'],
    };
    final alt = alternatives[currentRoute];
    if (alt == null) return null;
    return ToolSuggestion(toolId: alt[1], route: alt[0], reasonEn: alt[2], reasonTr: alt[3], priority: 70, source: 'R7');
  }

  List<ToolSuggestion> _deduplicateByToolId(List<ToolSuggestion> suggestions) {
    final best = <String, ToolSuggestion>{};
    for (final s in suggestions) {
      if (!best.containsKey(s.toolId) || s.priority > best[s.toolId]!.priority) {
        best[s.toolId] = s;
      }
    }
    return best.values.toList();
  }

  Future<void> _persistRecentTools() async {
    await _prefs.setString(_recentToolsKey, jsonEncode(_recentTools));
  }

  Future<void> _persistFavoriteTools() async {
    await _prefs.setString(_favoriteToolsKey, jsonEncode(_favoriteTools.toList()));
  }

  Future<void> _persistToolVisitCounts() async {
    await _prefs.setString(_toolVisitCountsKey, jsonEncode(_toolVisitCounts));
  }

  Future<void> clearAll() async {
    _recentTools.clear();
    _favoriteTools.clear();
    _toolVisitCounts.clear();
    _userGoals.clear();
    _timeBudgetMinutes = 15;
    await _prefs.remove(_recentToolsKey);
    await _prefs.remove(_favoriteToolsKey);
    await _prefs.remove(_toolVisitCountsKey);
    await _prefs.remove(_userGoalsKey);
    await _prefs.remove(_timeBudgetKey);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// RIVERPOD PROVIDER
// ════════════════════════════════════════════════════════════════════════════

final smartRouterServiceProvider = FutureProvider<SmartRouterService>((ref) async {
  return await SmartRouterService.init();
});
