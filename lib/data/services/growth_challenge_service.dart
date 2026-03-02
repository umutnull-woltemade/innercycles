// ════════════════════════════════════════════════════════════════════════════
// GROWTH CHALLENGE SERVICE - InnerCycles Weekly/Monthly Challenges
// ════════════════════════════════════════════════════════════════════════════
// Gamified challenges to boost engagement and retention.
// Free: 3 active. Premium: all challenges + completion badges.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_providers.dart';

enum ChallengeDuration { daily, weekly, monthly }

class GrowthChallenge {
  final String id;
  final String titleEn;
  final String titleTr;
  final String descriptionEn;
  final String descriptionTr;
  final String emoji;
  final ChallengeDuration duration;
  final int targetCount;
  final bool isPremium;

  const GrowthChallenge({
    required this.id,
    required this.titleEn,
    required this.titleTr,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.emoji,
    required this.duration,
    required this.targetCount,
    this.isPremium = false,
  });

  String localizedTitle(AppLanguage language) =>
      language == AppLanguage.en ? titleEn : titleTr;

  String localizedDescription(AppLanguage language) =>
      language == AppLanguage.en ? descriptionEn : descriptionTr;
}

class ChallengeProgress {
  final String challengeId;
  final DateTime startedAt;
  int currentCount;
  final int targetCount;
  bool isCompleted;

  ChallengeProgress({
    required this.challengeId,
    required this.startedAt,
    this.currentCount = 0,
    required this.targetCount,
    this.isCompleted = false,
  });

  double get percent =>
      targetCount > 0 ? (currentCount / targetCount).clamp(0, 1) : 0;

  Map<String, dynamic> toJson() => {
    'challengeId': challengeId,
    'startedAt': startedAt.toIso8601String(),
    'currentCount': currentCount,
    'targetCount': targetCount,
    'isCompleted': isCompleted,
  };

  factory ChallengeProgress.fromJson(Map<String, dynamic> json) =>
      ChallengeProgress(
        challengeId: json['challengeId'] as String? ?? '',
        startedAt:
            DateTime.tryParse(json['startedAt']?.toString() ?? '') ??
            DateTime.now(),
        currentCount: json['currentCount'] as int? ?? 0,
        targetCount: json['targetCount'] as int? ?? 1,
        isCompleted: json['isCompleted'] as bool? ?? false,
      );
}

class GrowthChallengeService {
  static const String _progressKey = 'inner_cycles_challenge_progress';
  static const String _completedKey = 'inner_cycles_completed_challenges';

  final SharedPreferences _prefs;
  Map<String, ChallengeProgress> _activeProgress = {};
  Set<String> _completedIds = {};

  GrowthChallengeService._(this._prefs) {
    _loadProgress();
    _loadCompleted();
  }

  static Future<GrowthChallengeService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return GrowthChallengeService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CHALLENGE CATALOG
  // ══════════════════════════════════════════════════════════════════════════

  static const List<GrowthChallenge> allChallenges = [
    GrowthChallenge(
      id: 'journal_7day',
      titleEn: '7-Day Streak',
      titleTr: '7 Günlük Seri',
      descriptionEn: 'Journal every day for 7 days straight',
      descriptionTr: '7 gün üst üste günlük yaz',
      emoji: '🔥',
      duration: ChallengeDuration.weekly,
      targetCount: 7,
    ),
    GrowthChallenge(
      id: 'all_areas',
      titleEn: 'Explorer',
      titleTr: 'Kaşif',
      descriptionEn: 'Log entries in all 5 focus areas',
      descriptionTr: '5 odak alanının hepsinde kayıt oluştur',
      emoji: '🧭',
      duration: ChallengeDuration.weekly,
      targetCount: 5,
    ),
    GrowthChallenge(
      id: 'gratitude_5',
      titleEn: 'Gratitude Week',
      titleTr: 'Şükran Haftası',
      descriptionEn: 'Write gratitude entries for 5 days',
      descriptionTr: '5 gün şükran girişi yaz',
      emoji: '🙏',
      duration: ChallengeDuration.weekly,
      targetCount: 5,
    ),
    GrowthChallenge(
      id: 'morning_ritual',
      titleEn: 'Morning Person',
      titleTr: 'Sabah İnsanı',
      descriptionEn: 'Complete your morning ritual 7 days in a row',
      descriptionTr: '7 gün üst üste sabah ritüelini tamamla',
      emoji: '🌅',
      duration: ChallengeDuration.weekly,
      targetCount: 7,
    ),
    GrowthChallenge(
      id: 'sleep_week',
      titleEn: 'Sleep Tracker',
      titleTr: 'Uyku Takipçisi',
      descriptionEn: 'Log your sleep quality for 7 nights',
      descriptionTr: '7 gece uyku kaliteni kaydet',
      emoji: '😴',
      duration: ChallengeDuration.weekly,
      targetCount: 7,
    ),
    GrowthChallenge(
      id: 'notes_master',
      titleEn: 'Deep Diver',
      titleTr: 'Derin Dalışçı',
      descriptionEn: 'Write detailed notes on 5 entries',
      descriptionTr: '5 girişte detaylı not yaz',
      emoji: '📝',
      duration: ChallengeDuration.weekly,
      targetCount: 5,
    ),
    GrowthChallenge(
      id: 'monthly_30',
      titleEn: '30-Day Streak',
      titleTr: '30 Gün Serisi',
      descriptionEn: 'Journal for 30 days in a month',
      descriptionTr: 'Bir ayda 30 gün günlük yaz',
      emoji: '⚔️',
      duration: ChallengeDuration.monthly,
      targetCount: 30,
      isPremium: true,
    ),
    GrowthChallenge(
      id: 'pattern_seeker',
      titleEn: 'Pattern Seeker',
      titleTr: 'Kalıp Arayıcısı',
      descriptionEn: 'Check your patterns screen 7 times',
      descriptionTr: 'Kalıplar ekranını 7 kez kontrol et',
      emoji: '🔍',
      duration: ChallengeDuration.weekly,
      targetCount: 7,
    ),
    GrowthChallenge(
      id: 'dream_week',
      titleEn: 'Dream Keeper',
      titleTr: 'Rüya Koruyucusu',
      descriptionEn: 'Record dreams for 5 nights',
      descriptionTr: '5 gece rüya kaydet',
      emoji: '🌙',
      duration: ChallengeDuration.weekly,
      targetCount: 5,
      isPremium: true,
    ),
    GrowthChallenge(
      id: 'wellness_high',
      titleEn: 'Peak Wellness',
      titleTr: 'Doruk Sağlık',
      descriptionEn: 'Achieve a wellness score of 80+ for 3 days',
      descriptionTr: '3 gün 80+ sağlık skoru elde et',
      emoji: '💎',
      duration: ChallengeDuration.weekly,
      targetCount: 3,
      isPremium: true,
    ),
    GrowthChallenge(
      id: 'breathing_5',
      titleEn: 'Breath Pro',
      titleTr: 'Nefes Uzmanı',
      descriptionEn: 'Complete 5 breathing sessions',
      descriptionTr: '5 nefes egzersizi tamamla',
      emoji: '🌬️',
      duration: ChallengeDuration.weekly,
      targetCount: 5,
    ),
    GrowthChallenge(
      id: 'share_3',
      titleEn: 'Social Butterfly',
      titleTr: 'Sosyal Kelebek',
      descriptionEn: 'Share 3 insight cards',
      descriptionTr: '3 içgörü kartı paylaş',
      emoji: '🦋',
      duration: ChallengeDuration.monthly,
      targetCount: 3,
      isPremium: true,
    ),
  ];

  List<GrowthChallenge> getAvailable({bool isPremium = false}) {
    if (isPremium) return allChallenges;
    return allChallenges.where((c) => !c.isPremium).toList();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROGRESS MANAGEMENT
  // ══════════════════════════════════════════════════════════════════════════

  Future<ChallengeProgress> startChallenge(String challengeId) async {
    final challenge = allChallenges
        .where((c) => c.id == challengeId)
        .firstOrNull;
    if (challenge == null) {
      return ChallengeProgress(
        challengeId: challengeId,
        startedAt: DateTime.now(),
        targetCount: 7,
      );
    }
    final progress = ChallengeProgress(
      challengeId: challengeId,
      startedAt: DateTime.now(),
      targetCount: challenge.targetCount,
    );
    _activeProgress[challengeId] = progress;
    await _persistProgress();
    return progress;
  }

  /// Increments challenge progress. Returns true if the challenge was
  /// just completed (transition from incomplete → complete).
  Future<bool> incrementProgress(String challengeId) async {
    final progress = _activeProgress[challengeId];
    if (progress == null || progress.isCompleted) return false;

    progress.currentCount++;
    if (progress.currentCount >= progress.targetCount) {
      progress.isCompleted = true;
      _completedIds.add(challengeId);
      await _persistCompleted();
      await _persistProgress();
      return true;
    }
    await _persistProgress();
    return false;
  }

  ChallengeProgress? getProgress(String challengeId) {
    return _activeProgress[challengeId];
  }

  bool isCompleted(String challengeId) {
    return _completedIds.contains(challengeId);
  }

  int get activeChallengeCount =>
      _activeProgress.values.where((p) => !p.isCompleted).length;

  int get completedChallengeCount => _completedIds.length;

  Future<void> abandonChallenge(String challengeId) async {
    _activeProgress.remove(challengeId);
    await _persistProgress();
  }

  // Persistence
  void _loadProgress() {
    final jsonString = _prefs.getString(_progressKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        _activeProgress = jsonMap.map(
          (k, v) => MapEntry(k, ChallengeProgress.fromJson(v)),
        );
      } catch (_) {
        _activeProgress = {};
      }
    }
  }

  void _loadCompleted() {
    final jsonString = _prefs.getString(_completedKey);
    if (jsonString != null) {
      try {
        final List<dynamic> list = json.decode(jsonString);
        _completedIds = list.whereType<String>().toSet();
      } catch (_) {
        _completedIds = {};
      }
    }
  }

  Future<void> _persistProgress() async {
    final jsonMap = _activeProgress.map((k, v) => MapEntry(k, v.toJson()));
    await _prefs.setString(_progressKey, json.encode(jsonMap));
  }

  Future<void> _persistCompleted() async {
    await _prefs.setString(_completedKey, json.encode(_completedIds.toList()));
  }

  // ══════════════════════════════════════════════════════════════════════════
  // WEEKLY COMMUNITY CHALLENGE — Shared challenge everyone participates in
  // ══════════════════════════════════════════════════════════════════════════

  static const List<CommunityChallengeTemplate> _communityTemplates = [
    CommunityChallengeTemplate(
      titleEn: 'Gratitude Week',
      titleTr: 'Şükran Haftası',
      descEn: 'The community is practicing gratitude this week. Write 3 gratitude entries.',
      descTr: 'Bu hafta topluluk şükran pratiği yapıyor. 3 şükran girişi yaz.',
      emoji: '🙏',
      targetCount: 3,
    ),
    CommunityChallengeTemplate(
      titleEn: 'Energy Awareness',
      titleTr: 'Enerji Farkındalığı',
      descEn: 'This week we\'re tracking energy patterns together. Log 5 entries focused on energy.',
      descTr: 'Bu hafta birlikte enerji örüntülerini takip ediyoruz. 5 enerji odaklı kayıt gir.',
      emoji: '⚡',
      targetCount: 5,
    ),
    CommunityChallengeTemplate(
      titleEn: 'Dream Explorer',
      titleTr: 'Rüya Kaşifi',
      descEn: 'The community is exploring dreams this week. Record 3 dreams.',
      descTr: 'Bu hafta topluluk rüyaları keşfediyor. 3 rüya kaydet.',
      emoji: '🌙',
      targetCount: 3,
    ),
    CommunityChallengeTemplate(
      titleEn: 'Mindful Mornings',
      titleTr: 'Bilinçli Sabahlar',
      descEn: 'Start your mornings with intention. Journal before noon for 4 days.',
      descTr: 'Sabahlarını niyetle başlat. 4 gün öğleden önce günlük yaz.',
      emoji: '🌅',
      targetCount: 4,
    ),
    CommunityChallengeTemplate(
      titleEn: 'Deep Reflection',
      titleTr: 'Derin Yansıma',
      descEn: 'We\'re going deeper this week. Write 3 entries over 200 words.',
      descTr: 'Bu hafta derinlere iniyoruz. 200 kelimeyi aşan 3 kayıt yaz.',
      emoji: '🧘',
      targetCount: 3,
    ),
    CommunityChallengeTemplate(
      titleEn: 'Social Connections',
      titleTr: 'Sosyal Bağlar',
      descEn: 'Focus on relationships this week. Journal about social interactions 4 times.',
      descTr: 'Bu hafta ilişkilere odaklan. 4 kez sosyal etkileşimler hakkında yaz.',
      emoji: '🤝',
      targetCount: 4,
    ),
    CommunityChallengeTemplate(
      titleEn: 'Mood Mastery',
      titleTr: 'Ruh Hali Ustalığı',
      descEn: 'Check in with your mood every day this week. Log 5 mood check-ins.',
      descTr: 'Bu hafta her gün ruh halini kontrol et. 5 ruh hali kaydı gir.',
      emoji: '🎭',
      targetCount: 5,
    ),
  ];

  /// Returns the current week's community challenge (rotates weekly)
  CommunityChallengeTemplate getCurrentCommunityChallenge() {
    final now = DateTime.now();
    final weekOfYear = _weekOfYear(now);
    return _communityTemplates[weekOfYear % _communityTemplates.length];
  }

  /// Get user's progress in the current community challenge
  CommunityChallenge getCommunityStatus() {
    final template = getCurrentCommunityChallenge();
    final weekKey = _communityWeekKey();
    final progressKey = 'community_challenge_$weekKey';
    final currentCount = _prefs.getInt(progressKey) ?? 0;

    // Estimated participants (deterministic per week)
    final weekHash = weekKey.hashCode.abs();
    final participants = 80 + (weekHash % 120); // 80-200

    return CommunityChallenge(
      template: template,
      currentCount: currentCount,
      participants: participants,
      weekKey: weekKey,
    );
  }

  /// Increment community challenge progress
  Future<bool> incrementCommunityProgress() async {
    final status = getCommunityStatus();
    if (status.isCompleted) return false;

    final key = 'community_challenge_${status.weekKey}';
    final newCount = status.currentCount + 1;
    await _prefs.setInt(key, newCount);
    return newCount >= status.template.targetCount;
  }

  String _communityWeekKey() {
    final now = DateTime.now();
    return '${now.year}-w${_weekOfYear(now)}';
  }

  static int _weekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysDiff = date.difference(firstDayOfYear).inDays;
    return (daysDiff / 7).floor();
  }
}

class CommunityChallengeTemplate {
  final String titleEn;
  final String titleTr;
  final String descEn;
  final String descTr;
  final String emoji;
  final int targetCount;

  const CommunityChallengeTemplate({
    required this.titleEn,
    required this.titleTr,
    required this.descEn,
    required this.descTr,
    required this.emoji,
    required this.targetCount,
  });

  String localizedTitle(AppLanguage language) =>
      language == AppLanguage.en ? titleEn : titleTr;

  String localizedDesc(AppLanguage language) =>
      language == AppLanguage.en ? descEn : descTr;
}

class CommunityChallenge {
  final CommunityChallengeTemplate template;
  final int currentCount;
  final int participants;
  final String weekKey;

  const CommunityChallenge({
    required this.template,
    required this.currentCount,
    required this.participants,
    required this.weekKey,
  });

  bool get isCompleted => currentCount >= template.targetCount;
  double get percent =>
      template.targetCount > 0
          ? (currentCount / template.targetCount).clamp(0, 1)
          : 0;
}
