// ════════════════════════════════════════════════════════════════════════════
// QUIZ ENGINE SERVICE - InnerCycles Generic Quiz Runner
// ════════════════════════════════════════════════════════════════════════════
// A reusable quiz engine that works with any QuizDefinition.
// Handles scoring (categorical, spectrum, multi-dimension), persistence
// via SharedPreferences, and result history.
//
// Follows the existing service pattern: static init() factory with
// SharedPreferences, matching DreamJournalService / JournalService.
//
// IMPORTANT: All quizzes are self-reflection tools for personal awareness,
// NOT clinical diagnostic instruments.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_models.dart';

class QuizEngineService {
  static const String _storagePrefix = 'inner_cycles_quiz_results_';

  final SharedPreferences _prefs;

  /// In-memory cache of all results keyed by quiz ID
  final Map<String, List<QuizResult>> _resultsCache = {};

  QuizEngineService._(this._prefs);

  /// Initialize the quiz engine service
  static Future<QuizEngineService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return QuizEngineService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SCORING
  // ══════════════════════════════════════════════════════════════════════════

  /// Calculate and persist a quiz result from selected answer indices.
  ///
  /// [definition] — the quiz being taken
  /// [answerIndices] — index of the chosen option per question (0-based)
  QuizResult calculateResult(QuizDefinition definition, List<int> answerIndices) {
    assert(answerIndices.length == definition.questions.length);

    // Accumulate raw scores per dimension
    final scores = <String, int>{};
    for (final dim in definition.dimensions.keys) {
      scores[dim] = 0;
    }

    for (int i = 0; i < answerIndices.length; i++) {
      final chosenIndex = answerIndices[i].clamp(0, definition.questions[i].options.length - 1);
      final option = definition.questions[i].options[chosenIndex];
      for (final entry in option.scores.entries) {
        scores[entry.key] = (scores[entry.key] ?? 0) + entry.value;
      }
    }

    // Calculate percentages and determine winner
    final percentages = <String, double>{};
    String resultType = '';

    switch (definition.scoringType) {
      case QuizScoringType.categorical:
      case QuizScoringType.multiDimension:
        final totalPoints = scores.values.fold<int>(0, (a, b) => a + b);
        int highest = 0;
        for (final entry in scores.entries) {
          percentages[entry.key] = totalPoints > 0 ? entry.value / totalPoints : 0.0;
          if (entry.value > highest) {
            highest = entry.value;
            resultType = entry.key;
          }
        }
        break;

      case QuizScoringType.spectrum:
        // For spectrum scoring, normalize each dimension against the max possible
        final maxPossible = definition.questions.length; // max 1 point per question per dim
        for (final entry in scores.entries) {
          percentages[entry.key] = maxPossible > 0 ? entry.value / maxPossible : 0.0;
        }
        int highest = 0;
        for (final entry in scores.entries) {
          if (entry.value > highest) {
            highest = entry.value;
            resultType = entry.key;
          }
        }
        break;
    }

    final result = QuizResult(
      quizId: definition.id,
      scores: scores,
      percentages: percentages,
      resultType: resultType,
      completedAt: DateTime.now(),
    );

    // Persist
    _getResultsForQuiz(definition.id).add(result);
    unawaited(_persistResults(definition.id));

    return result;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUERIES
  // ══════════════════════════════════════════════════════════════════════════

  /// Get the most recent result for a quiz, or null if never taken
  QuizResult? getLatestResult(String quizId) {
    final results = _getResultsForQuiz(quizId);
    if (results.isEmpty) return null;
    final sorted = List<QuizResult>.from(results)
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return sorted.first;
  }

  /// Get all results for a quiz, sorted most recent first
  List<QuizResult> getAllResults(String quizId) {
    final results = _getResultsForQuiz(quizId);
    final sorted = List<QuizResult>.from(results)
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return sorted;
  }

  /// Check whether a quiz has been completed at least once
  bool hasCompleted(String quizId) {
    return _getResultsForQuiz(quizId).isNotEmpty;
  }

  /// Total number of times a quiz has been taken
  int completionCount(String quizId) {
    return _getResultsForQuiz(quizId).length;
  }

  /// Get a set of all quiz IDs that have at least one result
  Set<String> get completedQuizIds {
    final ids = <String>{};
    // Scan prefs keys for our prefix
    for (final key in _prefs.getKeys()) {
      if (key.startsWith(_storagePrefix)) {
        final quizId = key.substring(_storagePrefix.length);
        final results = _getResultsForQuiz(quizId);
        if (results.isNotEmpty) {
          ids.add(quizId);
        }
      }
    }
    return ids;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  List<QuizResult> _getResultsForQuiz(String quizId) {
    if (_resultsCache.containsKey(quizId)) {
      return _resultsCache[quizId]!;
    }

    // Load from prefs
    final jsonString = _prefs.getString('$_storagePrefix$quizId');
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        final results = jsonList.map((j) => QuizResult.fromJson(j)).toList();
        _resultsCache[quizId] = results;
        return results;
      } catch (_) {
        _resultsCache[quizId] = [];
        return _resultsCache[quizId]!;
      }
    }

    _resultsCache[quizId] = [];
    return _resultsCache[quizId]!;
  }

  Future<void> _persistResults(String quizId) async {
    final results = _resultsCache[quizId] ?? [];
    final jsonList = results.map((r) => r.toJson()).toList();
    await _prefs.setString('$_storagePrefix$quizId', json.encode(jsonList));
  }

  /// Clear all results for a specific quiz
  Future<void> clearQuiz(String quizId) async {
    _resultsCache.remove(quizId);
    await _prefs.remove('$_storagePrefix$quizId');
  }

  /// Clear all quiz data
  Future<void> clearAll() async {
    final keysToRemove = _prefs.getKeys().where((k) => k.startsWith(_storagePrefix)).toList();
    for (final key in keysToRemove) {
      await _prefs.remove(key);
    }
    _resultsCache.clear();
  }
}
