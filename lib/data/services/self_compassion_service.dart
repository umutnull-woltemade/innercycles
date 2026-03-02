// ════════════════════════════════════════════════════════════════════════════
// SELF-COMPASSION SERVICE - Journal language analysis for self-kindness
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math';
import 'journal_service.dart';

class CompassionScore {
  final double score; // 0-100
  final int kindWords;
  final int harshWords;
  final int totalEntries;
  final String? dominantTone; // 'kind', 'neutral', 'harsh'

  const CompassionScore({
    required this.score,
    required this.kindWords,
    required this.harshWords,
    required this.totalEntries,
    this.dominantTone,
  });
}

class SelfCompassionService {
  final JournalService _journalService;

  SelfCompassionService(this._journalService);

  // ── English keyword pools ──
  static const _kindWordsEn = <String>{
    'proud', 'grateful', 'enough', 'learning', 'growing', 'brave',
    'strong', 'resilient', 'trying', 'progress', 'healing', 'gentle',
    'forgiving', 'patient', 'kind', 'compassion', 'love myself',
    'self-care', 'worthy', 'deserve', 'appreciate', 'accept',
    'allow myself', 'good enough', 'doing my best', 'it\'s okay',
    'i forgive', 'i\'m proud', 'i deserve', 'i appreciate',
    'grace', 'courage', 'hopeful', 'thankful', 'blessed',
  };

  static const _harshWordsEn = <String>{
    'stupid', 'failure', 'worthless', 'pathetic', 'useless', 'ugly',
    'hate myself', 'can\'t do anything', 'never good enough', 'always fail',
    'loser', 'disgusting', 'shame', 'embarrassment', 'weak', 'broken',
    'not enough', 'i suck', 'i\'m terrible', 'i should have',
    'why can\'t i', 'what\'s wrong with me', 'i\'m so bad',
    'i\'m the worst', 'hopeless', 'idiot',
  };

  // ── Turkish keyword pools ──
  static const _kindWordsTr = <String>{
    'gurur', 'minnettar', 'yeterli', 'öğreniyorum', 'büyüyorum',
    'cesur', 'güçlü', 'dayanıklı', 'deniyorum', 'ilerleme',
    'iyileşiyorum', 'nazik', 'affediyorum', 'sabırlı', 'şefkat',
    'kendimi seviyorum', 'öz bakım', 'değerliyim', 'hak ediyorum',
    'takdir ediyorum', 'kabul ediyorum', 'elimden geleni yapıyorum',
    'sorun yok', 'kendimi affediyorum',
  };

  static const _harshWordsTr = <String>{
    'aptal', 'başarısız', 'değersiz', 'aciz', 'işe yaramaz',
    'kendimden nefret', 'hiçbir şey yapamıyorum', 'asla yetmiyorum',
    'ezik', 'utanç', 'zayıf', 'kırık', 'yetmiyorum',
    'berbatım', 'yapamıyorum', 'neyim var benim', 'en kötüsüyüm',
    'umutsuz', 'salak', 'beceriksiz',
  };

  /// Compute compassion score for the last N days
  CompassionScore computeScore({int days = 7}) {
    final entries = _journalService.getAllEntries();
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final recent = entries.where((e) => e.date.isAfter(cutoff)).toList();

    if (recent.isEmpty) {
      return const CompassionScore(
        score: 50,
        kindWords: 0,
        harshWords: 0,
        totalEntries: 0,
        dominantTone: 'neutral',
      );
    }

    int kindCount = 0;
    int harshCount = 0;

    for (final entry in recent) {
      final text = (entry.note ?? '').toLowerCase();
      for (final word in _kindWordsEn) {
        if (text.contains(word)) kindCount++;
      }
      for (final word in _harshWordsEn) {
        if (text.contains(word)) harshCount++;
      }
      for (final word in _kindWordsTr) {
        if (text.contains(word)) kindCount++;
      }
      for (final word in _harshWordsTr) {
        if (text.contains(word)) harshCount++;
      }
    }

    final total = kindCount + harshCount;
    double score;
    if (total == 0) {
      score = 50; // neutral
    } else {
      // Score = kindness ratio * 100, with floor of 10
      score = (kindCount / total * 100).clamp(10, 100);
    }

    // Bonus for high-rated entries (self-acceptance signals)
    final avgRating = recent
            .map((e) => e.overallRating)
            .reduce((a, b) => a + b) /
        recent.length;
    if (avgRating >= 7) score = min(100, score + 10);

    String tone;
    if (kindCount > harshCount * 2) {
      tone = 'kind';
    } else if (harshCount > kindCount * 2) {
      tone = 'harsh';
    } else {
      tone = 'neutral';
    }

    return CompassionScore(
      score: score.roundToDouble(),
      kindWords: kindCount,
      harshWords: harshCount,
      totalEntries: recent.length,
      dominantTone: tone,
    );
  }

  /// Get weekly scores for the last N weeks (for sparkline)
  List<double> getWeeklyScores({int weeks = 8}) {
    final scores = <double>[];
    final now = DateTime.now();
    for (int w = weeks - 1; w >= 0; w--) {
      final weekEnd = now.subtract(Duration(days: w * 7));
      final weekStart = weekEnd.subtract(const Duration(days: 7));
      final entries = _journalService.getAllEntries().where(
          (e) => e.date.isAfter(weekStart) && e.date.isBefore(weekEnd));

      if (entries.isEmpty) {
        scores.add(50);
        continue;
      }

      int kind = 0, harsh = 0;
      for (final entry in entries) {
        final text = (entry.note ?? '').toLowerCase();
        for (final word in [..._kindWordsEn, ..._kindWordsTr]) {
          if (text.contains(word)) kind++;
        }
        for (final word in [..._harshWordsEn, ..._harshWordsTr]) {
          if (text.contains(word)) harsh++;
        }
      }
      final total = kind + harsh;
      scores.add(total == 0 ? 50 : (kind / total * 100).clamp(10, 100));
    }
    return scores;
  }
}
