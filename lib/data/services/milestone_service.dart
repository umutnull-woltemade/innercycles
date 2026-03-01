// ════════════════════════════════════════════════════════════════════════════
// MILESTONE SERVICE - InnerCycles Gamification & Badge System
// ════════════════════════════════════════════════════════════════════════════
// Tracks 30 milestones across 6 categories: streak, entries, exploration,
// depth, social, and growth. Persists earned badges with timestamps via
// SharedPreferences. Uses the standard init() factory pattern.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_providers.dart';

// ════════════════════════════════════════════════════════════════════════════
// MODELS
// ════════════════════════════════════════════════════════════════════════════

/// The six achievement categories
enum MilestoneCategory {
  streak,
  entries,
  exploration,
  depth,
  social,
  growth;

  String get displayNameEn {
    switch (this) {
      case MilestoneCategory.streak:
        return 'Streak';
      case MilestoneCategory.entries:
        return 'Entries';
      case MilestoneCategory.exploration:
        return 'Exploration';
      case MilestoneCategory.depth:
        return 'Depth';
      case MilestoneCategory.social:
        return 'Social';
      case MilestoneCategory.growth:
        return 'Growth';
    }
  }

  String get displayNameTr {
    switch (this) {
      case MilestoneCategory.streak:
        return 'Seri';
      case MilestoneCategory.entries:
        return 'Kayıtlar';
      case MilestoneCategory.exploration:
        return 'Keşif';
      case MilestoneCategory.depth:
        return 'Derinlik';
      case MilestoneCategory.social:
        return 'Sosyal';
      case MilestoneCategory.growth:
        return 'Gelişim';
    }
  }

  String localizedName(AppLanguage language) => language == AppLanguage.en ? displayNameEn : displayNameTr;

  String displayName(AppLanguage language) =>
      language == AppLanguage.en ? displayNameEn : displayNameTr;
}

/// A single milestone definition
class Milestone {
  final String id;
  final String nameEn;
  final String nameTr;
  final String descriptionEn;
  final String descriptionTr;
  final String emoji;
  final MilestoneCategory category;
  final String requirement;

  const Milestone({
    required this.id,
    required this.nameEn,
    required this.nameTr,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.emoji,
    required this.category,
    required this.requirement,
  });

  String localizedName(AppLanguage language) =>
      language == AppLanguage.en ? nameEn : nameTr;

  String localizedDescription(AppLanguage language) =>
      language == AppLanguage.en ? descriptionEn : descriptionTr;
}

/// An earned milestone with the date it was unlocked
class EarnedMilestone {
  final Milestone milestone;
  final DateTime earnedAt;

  const EarnedMilestone({required this.milestone, required this.earnedAt});

  Map<String, dynamic> toJson() => {
    'milestoneId': milestone.id,
    'earnedAt': earnedAt.toIso8601String(),
  };
}

/// Parameters that the caller passes so the service can evaluate which
/// milestones have been reached.
class MilestoneCheckParams {
  final int journalCount;
  final int streakDays;
  final int longestStreak;
  final Set<String> focusAreasUsed;
  final bool completedQuiz;
  final bool triedBreathing;
  final bool wroteDream;
  final int deepEntryCount;
  final bool completedMonthlyReflection;
  final bool usedPatternScreen;
  final bool sharedInsight;
  final bool completedCompatibility;
  final bool completedSeasonalPrompts;
  final bool filledEnergyMap;
  final double wellnessScore;

  const MilestoneCheckParams({
    this.journalCount = 0,
    this.streakDays = 0,
    this.longestStreak = 0,
    this.focusAreasUsed = const {},
    this.completedQuiz = false,
    this.triedBreathing = false,
    this.wroteDream = false,
    this.deepEntryCount = 0,
    this.completedMonthlyReflection = false,
    this.usedPatternScreen = false,
    this.sharedInsight = false,
    this.completedCompatibility = false,
    this.completedSeasonalPrompts = false,
    this.filledEnergyMap = false,
    this.wellnessScore = 0,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// MILESTONE DEFINITIONS (30 total)
// ════════════════════════════════════════════════════════════════════════════

const List<Milestone> _allMilestones = [
  // ── Streak (5) ──────────────────────────────────────────────────────────
  Milestone(
    id: 'streak_3',
    nameEn: 'Spark',
    nameTr: 'Kıvılcım',
    descriptionEn: 'Maintained a 3-day journaling streak.',
    descriptionTr: '3 günlük bir kayıt serisi oluşturdun.',
    emoji: '\u{1F525}',
    category: MilestoneCategory.streak,
    requirement: 'streak >= 3',
  ),
  Milestone(
    id: 'streak_7',
    nameEn: '7-Day Observer',
    nameTr: '7 Günlük Gözlemci',
    descriptionEn: 'Kept a full 7-day journaling streak.',
    descriptionTr: '7 günlük bir kayıt serisi oluşturdun.',
    emoji: '\u{26A1}',
    category: MilestoneCategory.streak,
    requirement: 'streak >= 7',
  ),
  Milestone(
    id: 'streak_14',
    nameEn: 'Fortnight Flow',
    nameTr: 'İki Haftalık Akış',
    descriptionEn: 'Achieved a 14-day journaling streak.',
    descriptionTr: '14 günlük bir kayıt serisi oluşturdun.',
    emoji: '\u{1F30A}',
    category: MilestoneCategory.streak,
    requirement: 'streak >= 14',
  ),
  Milestone(
    id: 'streak_30',
    nameEn: '30-Day Streak',
    nameTr: '30 Günlük Seri',
    descriptionEn: 'Completed an incredible 30-day journaling streak.',
    descriptionTr: '30 günlük bir kayıt serisi oluşturdun.',
    emoji: '\u{1F451}',
    category: MilestoneCategory.streak,
    requirement: 'streak >= 30',
  ),
  Milestone(
    id: 'streak_60',
    nameEn: 'Eternal Flame',
    nameTr: 'Sonsuz Alev',
    descriptionEn: 'Sustained a legendary 60-day journaling streak.',
    descriptionTr: '60 günlük bir kayıt serisi oluşturdun.',
    emoji: '\u{1F31F}',
    category: MilestoneCategory.streak,
    requirement: 'streak >= 60',
  ),

  // ── Entries (5) ─────────────────────────────────────────────────────────
  Milestone(
    id: 'entries_1',
    nameEn: 'First Step',
    nameTr: 'İlk Adım',
    descriptionEn: 'Created your very first journal entry.',
    descriptionTr: 'İlk kaydını oluşturdun.',
    emoji: '\u{270F}\u{FE0F}',
    category: MilestoneCategory.entries,
    requirement: 'entries >= 1',
  ),
  Milestone(
    id: 'entries_10',
    nameEn: 'Getting Started',
    nameTr: 'Yola Çıkış',
    descriptionEn: 'Reached 10 journal entries.',
    descriptionTr: '10 kayda ulaştın.',
    emoji: '\u{1F4D3}',
    category: MilestoneCategory.entries,
    requirement: 'entries >= 10',
  ),
  Milestone(
    id: 'entries_25',
    nameEn: 'Quarter Century',
    nameTr: 'Çeyrek Yüzyıl',
    descriptionEn: 'Reached 25 journal entries.',
    descriptionTr: '25 kayda ulaştın.',
    emoji: '\u{1F4DA}',
    category: MilestoneCategory.entries,
    requirement: 'entries >= 25',
  ),
  Milestone(
    id: 'entries_50',
    nameEn: 'Chronicler',
    nameTr: 'Tarihçi',
    descriptionEn: 'Reached 50 journal entries.',
    descriptionTr: '50 kayda ulaştın.',
    emoji: '\u{1F4DC}',
    category: MilestoneCategory.entries,
    requirement: 'entries >= 50',
  ),
  Milestone(
    id: 'entries_100',
    nameEn: 'Centurion',
    nameTr: 'Yüzbaşı',
    descriptionEn: 'Reached 100 journal entries. True dedication.',
    descriptionTr: '100 kayda ulaştın. Gerçek bir bağlılık.',
    emoji: '\u{1F3C6}',
    category: MilestoneCategory.entries,
    requirement: 'entries >= 100',
  ),

  // ── Exploration (5) ─────────────────────────────────────────────────────
  Milestone(
    id: 'explore_all_focus',
    nameEn: 'Well-Rounded',
    nameTr: 'Çok Yönlü',
    descriptionEn: 'Used all 5 focus areas at least once.',
    descriptionTr: '5 odak alanının hepsini en az bir kez kullandın.',
    emoji: '\u{1F308}',
    category: MilestoneCategory.exploration,
    requirement: 'focusAreas == 5',
  ),
  Milestone(
    id: 'explore_quiz',
    nameEn: 'Quiz Taker',
    nameTr: 'Test Meraklısı',
    descriptionEn: 'Completed your first pattern-detection quiz.',
    descriptionTr: 'İlk örüntü tespit testini tamamladın.',
    emoji: '\u{1F9E0}',
    category: MilestoneCategory.exploration,
    requirement: 'completedQuiz',
  ),
  Milestone(
    id: 'explore_breathing',
    nameEn: 'Deep Breath',
    nameTr: 'Derin Nefes',
    descriptionEn: 'Tried a guided breathing exercise.',
    descriptionTr: 'Rehberli bir nefes egzersizi denedin.',
    emoji: '\u{1F32C}\u{FE0F}',
    category: MilestoneCategory.exploration,
    requirement: 'triedBreathing',
  ),
  Milestone(
    id: 'explore_dream',
    nameEn: 'Dream Catcher',
    nameTr: 'Rüya Avcısı',
    descriptionEn: 'Recorded your first dream in the journal.',
    descriptionTr: 'İlk rüyanı kaydettin.',
    emoji: '\u{1F319}',
    category: MilestoneCategory.exploration,
    requirement: 'wroteDream',
  ),
  Milestone(
    id: 'explore_multi_focus',
    nameEn: 'Focus Hopper',
    nameTr: 'Odak Gezgini',
    descriptionEn: 'Used at least 3 different focus areas.',
    descriptionTr: 'En az 3 farklı odak alanı kullandın.',
    emoji: '\u{1F50D}',
    category: MilestoneCategory.exploration,
    requirement: 'focusAreas >= 3',
  ),

  // ── Depth (5) ───────────────────────────────────────────────────────────
  Milestone(
    id: 'depth_deep_5',
    nameEn: 'Deep Diver',
    nameTr: 'Derin Dalıcı',
    descriptionEn: 'Wrote 5 deep entries with a rating of 8 or higher.',
    descriptionTr: '8 ve üzeri puanla 5 derin kayıt yazdın.',
    emoji: '\u{1F30A}',
    category: MilestoneCategory.depth,
    requirement: 'deepEntries >= 5',
  ),
  Milestone(
    id: 'depth_monthly',
    nameEn: 'Reflector',
    nameTr: 'Yansıtıcı',
    descriptionEn: 'Completed a monthly reflection.',
    descriptionTr: 'Bir aylık yansıtma tamamladın.',
    emoji: '\u{1FA9E}',
    category: MilestoneCategory.depth,
    requirement: 'completedMonthlyReflection',
  ),
  Milestone(
    id: 'depth_patterns',
    nameEn: 'Pattern Seeker',
    nameTr: 'Kalıp Arayıcı',
    descriptionEn: 'Visited the patterns screen to explore trends.',
    descriptionTr: 'Trendleri keşfetmek için kalıplar ekranını ziyaret ettin.',
    emoji: '\u{1F52E}',
    category: MilestoneCategory.depth,
    requirement: 'usedPatternScreen',
  ),
  Milestone(
    id: 'depth_deep_1',
    nameEn: 'First Depth',
    nameTr: 'İlk Derinlik',
    descriptionEn: 'Wrote your first deep entry (rating 8+).',
    descriptionTr: 'İlk derin kaydını yazdın (puan 8+).',
    emoji: '\u{1F4A7}',
    category: MilestoneCategory.depth,
    requirement: 'deepEntries >= 1',
  ),
  Milestone(
    id: 'depth_consistent_notes',
    nameEn: 'Thoughtful Writer',
    nameTr: 'Düşünce Yazarı',
    descriptionEn: 'Wrote notes in at least 10 entries.',
    descriptionTr: 'En az 10 kayda not yazdın.',
    emoji: '\u{1F58A}\u{FE0F}',
    category: MilestoneCategory.depth,
    requirement: 'entries >= 10 with notes',
  ),

  // ── Social (5) ──────────────────────────────────────────────────────────
  Milestone(
    id: 'social_share',
    nameEn: 'Story Teller',
    nameTr: 'Hikaye Anlatıcısı',
    descriptionEn: 'Shared an insight card with others.',
    descriptionTr: 'Bir içerik kartını başkalarıyla paylaştın.',
    emoji: '\u{1F4E4}',
    category: MilestoneCategory.social,
    requirement: 'sharedInsight',
  ),
  Milestone(
    id: 'social_compatibility',
    nameEn: 'Connection Seeker',
    nameTr: 'Bağlantı Arayıcı',
    descriptionEn: 'Completed a compatibility reflection.',
    descriptionTr: 'Bir uyumluluk yansıtması tamamladın.',
    emoji: '\u{1F91D}',
    category: MilestoneCategory.social,
    requirement: 'completedCompatibility',
  ),
  Milestone(
    id: 'social_streak_share',
    nameEn: 'Proud Streak',
    nameTr: 'Gurur Serisi',
    descriptionEn: 'Shared your streak progress with a friend.',
    descriptionTr: 'Seri ilerlemeni bir arkadaşınla paylaştın.',
    emoji: '\u{1F4AA}',
    category: MilestoneCategory.social,
    requirement: 'sharedInsight && streak >= 3',
  ),
  Milestone(
    id: 'social_profile_duo',
    nameEn: 'Dynamic Duo',
    nameTr: 'Dinamik İkili',
    descriptionEn: 'Added a second profile for comparison.',
    descriptionTr: 'Karşılaştırma için ikinci bir profil ekledin.',
    emoji: '\u{1F46B}',
    category: MilestoneCategory.social,
    requirement: 'completedCompatibility',
  ),
  Milestone(
    id: 'social_community',
    nameEn: 'Community Voice',
    nameTr: 'Topluluk Sesi',
    descriptionEn: 'Shared your growth progress externally.',
    descriptionTr: 'Gelişim sürecini dış dünyayla paylaştın.',
    emoji: '\u{1F4E3}',
    category: MilestoneCategory.social,
    requirement: 'sharedInsight',
  ),

  // ── Growth (5) ──────────────────────────────────────────────────────────
  Milestone(
    id: 'growth_seasonal',
    nameEn: 'Season Keeper',
    nameTr: 'Mevsim Koruyucusu',
    descriptionEn: 'Completed all seasonal reflection prompts.',
    descriptionTr: 'Tüm mevsimsel yansıtma sorularını tamamladın.',
    emoji: '\u{1F343}',
    category: MilestoneCategory.growth,
    requirement: 'completedSeasonalPrompts',
  ),
  Milestone(
    id: 'growth_energy_map',
    nameEn: 'Energy Profiler',
    nameTr: 'Enerji Profilcisi',
    descriptionEn: 'Filled in your personal energy profile.',
    descriptionTr: 'Kişisel enerji profilini doldurdun.',
    emoji: '\u{1F5FA}\u{FE0F}',
    category: MilestoneCategory.growth,
    requirement: 'filledEnergyMap',
  ),
  Milestone(
    id: 'growth_wellness_80',
    nameEn: 'Wellness Star',
    nameTr: 'Sağlık Yıldızı',
    descriptionEn: 'Reached a wellness score of 80 or higher.',
    descriptionTr: '80 ve üzeri sağlık puanına ulaştın.',
    emoji: '\u{1F3AF}',
    category: MilestoneCategory.growth,
    requirement: 'wellnessScore >= 80',
  ),
  Milestone(
    id: 'growth_all_milestones',
    nameEn: 'Completionist',
    nameTr: 'Tamamlayıcı',
    descriptionEn: 'Earned 25 other milestones. Incredible!',
    descriptionTr: '25 diğer rozeti kazandın. İnanılmaz!',
    emoji: '\u{1F48E}',
    category: MilestoneCategory.growth,
    requirement: 'earned >= 25 other milestones',
  ),
  Milestone(
    id: 'growth_half',
    nameEn: 'Halfway There',
    nameTr: 'Yarıdayız',
    descriptionEn: 'Earned 15 milestones. Keep going!',
    descriptionTr: '15 rozet kazandın. Devam et!',
    emoji: '\u{2B50}',
    category: MilestoneCategory.growth,
    requirement: 'earned >= 15 milestones',
  ),
];

// ════════════════════════════════════════════════════════════════════════════
// MILESTONE SERVICE
// ════════════════════════════════════════════════════════════════════════════

class MilestoneService {
  static const String _storageKey = 'inner_cycles_milestones';

  final SharedPreferences _prefs;

  /// In-memory map: milestoneId -> earnedAt timestamp ISO string
  Map<String, String> _earned = {};

  MilestoneService._(this._prefs) {
    _loadEarned();
  }

  /// Standard async factory matching project convention.
  static Future<MilestoneService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return MilestoneService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadEarned() {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> decoded = json.decode(jsonString);
        _earned = decoded.map((k, v) => MapEntry(k, v as String));
      } catch (_) {
        _earned = {};
      }
    }
  }

  Future<void> _persistEarned() async {
    await _prefs.setString(_storageKey, json.encode(_earned));
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ══════════════════════════════════════════════════════════════════════════

  /// Evaluate all milestones against the current app state and award any
  /// that are newly earned. Returns the list of freshly unlocked milestones.
  Future<List<Milestone>> checkAndAward(MilestoneCheckParams params) async {
    final newlyEarned = <Milestone>[];
    final now = DateTime.now().toIso8601String();
    final effectiveStreak = params.longestStreak > params.streakDays
        ? params.longestStreak
        : params.streakDays;

    for (final m in _allMilestones) {
      if (_earned.containsKey(m.id)) continue;

      final unlocked = _evaluate(m, params, effectiveStreak);
      if (unlocked) {
        _earned[m.id] = now;
        newlyEarned.add(m);
      }
    }

    // Meta-milestones that depend on how many we have earned so far
    if (!_earned.containsKey('growth_half') && _earned.length >= 15) {
      final m = _allMilestones
          .where((ms) => ms.id == 'growth_half')
          .firstOrNull;
      if (m != null) {
        _earned[m.id] = now;
        newlyEarned.add(m);
      }
    }
    if (!_earned.containsKey('growth_all_milestones') && _earned.length >= 26) {
      // 25 *other* milestones + this one itself would be 26
      final m = _allMilestones
          .where((ms) => ms.id == 'growth_all_milestones')
          .firstOrNull;
      if (m != null) {
        _earned[m.id] = now;
        newlyEarned.add(m);
      }
    }

    if (newlyEarned.isNotEmpty) {
      await _persistEarned();
    }

    return newlyEarned;
  }

  /// Get all earned milestones with their timestamps, sorted newest first.
  List<EarnedMilestone> getEarnedMilestones() {
    final milestoneMap = <String, Milestone>{};
    for (final m in _allMilestones) {
      milestoneMap[m.id] = m;
    }

    final result = <EarnedMilestone>[];
    for (final entry in _earned.entries) {
      final milestone = milestoneMap[entry.key];
      if (milestone != null) {
        final parsed = DateTime.tryParse(entry.value);
        if (parsed != null) {
          result.add(EarnedMilestone(milestone: milestone, earnedAt: parsed));
        }
      }
    }

    result.sort((a, b) => b.earnedAt.compareTo(a.earnedAt));
    return result;
  }

  /// Get the full list of all 30 milestone definitions.
  List<Milestone> getAllMilestones() => List.unmodifiable(_allMilestones);

  /// Overall progress as a 0.0 - 1.0 fraction.
  double getProgress() {
    if (_allMilestones.isEmpty) return 0;
    return _earned.length / _allMilestones.length;
  }

  /// Number of earned milestones.
  int get earnedCount => _earned.length;

  /// Total milestones available.
  int get totalCount => _allMilestones.length;

  /// Whether a specific milestone has been earned.
  bool isEarned(String milestoneId) => _earned.containsKey(milestoneId);

  /// The timestamp when a specific milestone was earned, or null.
  DateTime? earnedAt(String milestoneId) {
    final ts = _earned[milestoneId];
    if (ts == null) return null;
    return DateTime.tryParse(ts);
  }

  /// Returns a list of milestones the user is closest to earning, ordered by
  /// estimated proximity. Useful for showing "up next" badges.
  List<Milestone> getNextMilestones({int limit = 3}) {
    final unearned = _allMilestones
        .where((m) => !_earned.containsKey(m.id))
        .toList();

    // Prioritise by category order as a simple heuristic, keeping the
    // order in which they were defined (lower thresholds come first).
    return unearned.take(limit).toList();
  }

  /// Get all milestones for a specific category.
  List<Milestone> getMilestonesByCategory(MilestoneCategory category) {
    return _allMilestones.where((m) => m.category == category).toList();
  }

  /// Clear all earned milestones (useful for testing / reset).
  Future<void> clearAll() async {
    _earned.clear();
    await _prefs.remove(_storageKey);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PRIVATE EVALUATION
  // ══════════════════════════════════════════════════════════════════════════

  bool _evaluate(Milestone m, MilestoneCheckParams p, int effectiveStreak) {
    switch (m.id) {
      // Streak
      case 'streak_3':
        return effectiveStreak >= 3;
      case 'streak_7':
        return effectiveStreak >= 7;
      case 'streak_14':
        return effectiveStreak >= 14;
      case 'streak_30':
        return effectiveStreak >= 30;
      case 'streak_60':
        return effectiveStreak >= 60;

      // Entries
      case 'entries_1':
        return p.journalCount >= 1;
      case 'entries_10':
        return p.journalCount >= 10;
      case 'entries_25':
        return p.journalCount >= 25;
      case 'entries_50':
        return p.journalCount >= 50;
      case 'entries_100':
        return p.journalCount >= 100;

      // Exploration
      case 'explore_all_focus':
        return p.focusAreasUsed.length >= 5;
      case 'explore_quiz':
        return p.completedQuiz;
      case 'explore_breathing':
        return p.triedBreathing;
      case 'explore_dream':
        return p.wroteDream;
      case 'explore_multi_focus':
        return p.focusAreasUsed.length >= 3;

      // Depth
      case 'depth_deep_5':
        return p.deepEntryCount >= 5;
      case 'depth_monthly':
        return p.completedMonthlyReflection;
      case 'depth_patterns':
        return p.usedPatternScreen;
      case 'depth_deep_1':
        return p.deepEntryCount >= 1;
      case 'depth_consistent_notes':
        return p.journalCount >= 10; // approximation: entries with notes

      // Social
      case 'social_share':
        return p.sharedInsight;
      case 'social_compatibility':
        return p.completedCompatibility;
      case 'social_streak_share':
        return p.sharedInsight && effectiveStreak >= 3;
      case 'social_profile_duo':
        return p.completedCompatibility;
      case 'social_community':
        return p.sharedInsight;

      // Growth
      case 'growth_seasonal':
        return p.completedSeasonalPrompts;
      case 'growth_energy_map':
        return p.filledEnergyMap;
      case 'growth_wellness_80':
        return p.wellnessScore >= 80;

      // Meta milestones handled separately in checkAndAward
      case 'growth_all_milestones':
      case 'growth_half':
        return false;

      default:
        return false;
    }
  }
}
