// ════════════════════════════════════════════════════════════════════════════
// ATTACHMENT STYLE SERVICE - InnerCycles Self-Reflection Quiz Engine
// ════════════════════════════════════════════════════════════════════════════
// Manages the attachment style quiz: question bank, scoring, result history.
// Uses SharedPreferences for persistence (follows JournalService pattern).
//
// IMPORTANT: This is a self-reflection tool for personal growth awareness.
// It is NOT a clinical diagnostic instrument. All language is safe, reflective,
// and non-prescriptive - using "you may tend to..." and "you might notice..."
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attachment_style.dart';

// ════════════════════════════════════════════════════════════════════════════
// QUIZ QUESTION MODEL
// ════════════════════════════════════════════════════════════════════════════

/// A single quiz question with four options, one per attachment style
class AttachmentQuizQuestion {
  final String questionEn;
  final String questionTr;
  final Map<AttachmentStyle, String> optionsEn;
  final Map<AttachmentStyle, String> optionsTr;

  const AttachmentQuizQuestion({
    required this.questionEn,
    required this.questionTr,
    required this.optionsEn,
    required this.optionsTr,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// ATTACHMENT STYLE SERVICE
// ════════════════════════════════════════════════════════════════════════════

class AttachmentStyleService {
  static const String _storageKey = 'inner_cycles_attachment_quiz_results';

  final SharedPreferences _prefs;
  List<AttachmentQuizResult> _results = [];

  AttachmentStyleService._(this._prefs) {
    _loadResults();
  }

  /// Initialize the attachment style service
  static Future<AttachmentStyleService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return AttachmentStyleService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUESTION BANK
  // ══════════════════════════════════════════════════════════════════════════

  /// The six self-reflection questions covering relationship patterns,
  /// emotional reactions, closeness comfort, conflict style, trust,
  /// and independence.
  static const List<AttachmentQuizQuestion> questions = [
    // ── Q1: Relationship Patterns ──
    AttachmentQuizQuestion(
      questionEn:
          'When you start getting close to someone new, which of these '
          'feels most familiar?',
      questionTr:
          'Yeni biriyle yakınlaşmaya başladığınızda, aşağıdakilerden '
          'hangisi size en tanıdık geliyor?',
      optionsEn: {
        AttachmentStyle.secure:
            'I enjoy the process of getting to know them and feel fairly '
            'relaxed about where it leads.',
        AttachmentStyle.anxiousPreoccupied:
            'I might notice myself wanting to spend a lot of time together '
            'quickly and checking in often to see how they feel about me.',
        AttachmentStyle.dismissiveAvoidant:
            'I tend to keep a measured pace and may pull back a bit if '
            'things feel like they\'re moving too fast.',
        AttachmentStyle.fearfulAvoidant:
            'I may feel excited about the connection but also catch myself '
            'looking for reasons it might not work out.',
      },
      optionsTr: {
        AttachmentStyle.secure:
            'Onları tanıma sürecinin tadını çıkarırım ve ilişkinin nereye '
            'varacağı konusunda oldukça rahat hissederim.',
        AttachmentStyle.anxiousPreoccupied:
            'Hızla çok zaman geçirmek istediğimi ve benim hakkımda ne '
            'hissettiklerini sık sık kontrol ettiğimi fark edebilirim.',
        AttachmentStyle.dismissiveAvoidant:
            'Ölçülü bir tempo tutma eğilimindeyim ve işler çok hızlı '
            'ilerliyorsa biraz geri çekilebilirim.',
        AttachmentStyle.fearfulAvoidant:
            'Bağlantı konusunda heyecanlanabilirim ama aynı zamanda '
            'işe yaramayacağına dair nedenler aradığımı fark edebilirim.',
      },
    ),

    // ── Q2: Emotional Reactions ──
    AttachmentQuizQuestion(
      questionEn:
          'When someone you care about seems distant or unavailable for '
          'a few days, what do you tend to notice in yourself?',
      questionTr:
          'Önemsediğiniz biri birkaç gün mesafeli ya da ulaşılmaz '
          'göründüğünde, kendinizde ne fark etme eğilimindesiniz?',
      optionsEn: {
        AttachmentStyle.secure:
            'I might wonder what\'s going on for them, but I generally '
            'trust that the connection is still there.',
        AttachmentStyle.anxiousPreoccupied:
            'I may tend to feel uneasy and replay our last interactions, '
            'wondering if I did something wrong.',
        AttachmentStyle.dismissiveAvoidant:
            'I might notice a sense of relief at having more personal '
            'space, and I carry on with my own routines.',
        AttachmentStyle.fearfulAvoidant:
            'I might feel both worried about losing them and relieved '
            'that the emotional intensity has decreased.',
      },
      optionsTr: {
        AttachmentStyle.secure:
            'Onlar için neler olduğunu merak edebilirim ama genel olarak '
            'bağlantının hâlâ orada olduğuna güvenirim.',
        AttachmentStyle.anxiousPreoccupied:
            'Tedirgin hissedip son etkileşimlerimizi tekrar tekrar '
            'düşünebilir, yanlış bir şey yapıp yapmadığımı merak edebilirim.',
        AttachmentStyle.dismissiveAvoidant:
            'Daha fazla kişisel alana sahip olmanın verdiği bir rahatlama '
            'hissedebilir ve kendi rutinlerime devam edebilirim.',
        AttachmentStyle.fearfulAvoidant:
            'Hem onları kaybetme endişesi hem de duygusal yoğunluğun '
            'azalmasından bir rahatlama hissedebilirim.',
      },
    ),

    // ── Q3: Closeness Comfort ──
    AttachmentQuizQuestion(
      questionEn:
          'Imagine someone you\'re close to wants to share something '
          'deeply personal and vulnerable with you. How might you respond '
          'inwardly?',
      questionTr:
          'Size yakın birinin sizinle derinden kişisel ve savunmasız bir '
          'şeyi paylaşmak istediğini düşünün. İçsel tepkiniz nasıl olabilir?',
      optionsEn: {
        AttachmentStyle.secure:
            'I feel honoured that they trust me and I\'m ready to listen '
            'without needing to fix anything.',
        AttachmentStyle.anxiousPreoccupied:
            'I may feel deeply moved and want to reciprocate immediately '
            'by sharing something equally personal of my own.',
        AttachmentStyle.dismissiveAvoidant:
            'I might notice a subtle urge to change the subject or offer '
            'practical advice rather than sitting in the emotion.',
        AttachmentStyle.fearfulAvoidant:
            'I may feel touched but also notice an instinct to protect '
            'myself, as if their vulnerability triggers my own.',
      },
      optionsTr: {
        AttachmentStyle.secure:
            'Bana güvendikleri için onurlandığımı hisseder ve hiçbir '
            'şeyi düzeltmeye gerek duymadan dinlemeye hazır olurum.',
        AttachmentStyle.anxiousPreoccupied:
            'Derinden etkilenebilir ve hemen karşılık olarak kendi '
            'kişisel bir şeyimi paylaşmak isteyebilirim.',
        AttachmentStyle.dismissiveAvoidant:
            'Konuyu değiştirme ya da duygunun içinde oturmak yerine '
            'pratik tavsiye verme dürtüsü fark edebilirim.',
        AttachmentStyle.fearfulAvoidant:
            'Dokunulduğumu hissedebilirim ama aynı zamanda kendimi koruma '
            'içgüdüsü fark edebilirim, sanki onların savunmasızlığı '
            'benimkini tetikliyormuş gibi.',
      },
    ),

    // ── Q4: Conflict Style ──
    AttachmentQuizQuestion(
      questionEn:
          'During a disagreement with someone important to you, which '
          'pattern do you tend to notice in yourself?',
      questionTr:
          'Sizin için önemli biriyle bir anlaşmazlık sırasında, '
          'kendinizde hangi örüntüyü fark etme eğilimindesiniz?',
      optionsEn: {
        AttachmentStyle.secure:
            'I try to understand their perspective and express mine '
            'calmly, even when it\'s uncomfortable.',
        AttachmentStyle.anxiousPreoccupied:
            'I might notice an urgency to resolve things quickly, and '
            'I may tend to pursue the conversation even when they need '
            'space.',
        AttachmentStyle.dismissiveAvoidant:
            'I may tend to shut down emotionally or withdraw until I '
            'feel I can approach things rationally.',
        AttachmentStyle.fearfulAvoidant:
            'I might oscillate between wanting to talk it out and '
            'wanting to walk away entirely, unsure which impulse to follow.',
      },
      optionsTr: {
        AttachmentStyle.secure:
            'Rahatsız olsa bile onların bakış açısını anlamaya ve '
            'benimkini sakin bir şekilde ifade etmeye çalışırım.',
        AttachmentStyle.anxiousPreoccupied:
            'İşleri hızla çözme aciliyeti fark edebilir ve alana ihtiyaç '
            'duydukları zamanlarda bile konuşmayı sürdürme eğiliminde '
            'olabilirim.',
        AttachmentStyle.dismissiveAvoidant:
            'Duygusal olarak kapanma ya da rasyonel yaklaşabileceğimi '
            'hissedene kadar geri çekilme eğiliminde olabilirim.',
        AttachmentStyle.fearfulAvoidant:
            'Konuşmak isteme ile tamamen uzaklaşmak isteme arasında '
            'gidip gelebilir, hangi dürtüyü izleyeceğimden emin '
            'olamayabilirim.',
      },
    ),

    // ── Q5: Trust ──
    AttachmentQuizQuestion(
      questionEn:
          'Think about how you tend to feel when you need to rely on '
          'someone else. Which of these resonates most?',
      questionTr:
          'Başka birine güvenmeniz gerektiğinde nasıl hissetme '
          'eğiliminde olduğunuzu düşünün. Hangisi size en çok uyuyor?',
      optionsEn: {
        AttachmentStyle.secure:
            'I\'m generally comfortable asking for help and trusting '
            'that people will follow through when they can.',
        AttachmentStyle.anxiousPreoccupied:
            'I may tend to want extra confirmation that they\'ll be '
            'there, and I might feel anxious until I receive it.',
        AttachmentStyle.dismissiveAvoidant:
            'I usually prefer handling things on my own - relying on '
            'others can feel like giving up control.',
        AttachmentStyle.fearfulAvoidant:
            'I might want to reach out but hold back, unsure whether '
            'it\'s safe to depend on someone fully.',
      },
      optionsTr: {
        AttachmentStyle.secure:
            'Yardım istemekten ve insanların ellerinden geldiğinde '
            'sözlerini tutacağına güvenmekten genellikle rahatsız olmam.',
        AttachmentStyle.anxiousPreoccupied:
            'Orada olacaklarına dair ek onay isteyebilir ve bunu alana '
            'kadar kaygılı hissedebilirim.',
        AttachmentStyle.dismissiveAvoidant:
            'Genellikle işleri kendi başıma halletmeyi tercih ederim - '
            'başkalarına güvenmek kontrolü bırakmak gibi hissettirebilir.',
        AttachmentStyle.fearfulAvoidant:
            'Ulaşmak isteyebilir ama geri durabilirim, birine tamamen '
            'güvenmenin güvenli olup olmadığından emin olamam.',
      },
    ),

    // ── Q6: Independence ──
    AttachmentQuizQuestion(
      questionEn:
          'When you think about your ideal balance between togetherness '
          'and alone time, which description fits you best?',
      questionTr:
          'Birliktelik ve yalnız zaman arasındaki ideal dengenizi '
          'düşündüğünüzde, hangi tanım size en uygun?',
      optionsEn: {
        AttachmentStyle.secure:
            'I enjoy spending meaningful time together and also value '
            'my own space - both feel nourishing to me.',
        AttachmentStyle.anxiousPreoccupied:
            'I may tend to feel most secure when we\'re spending time '
            'together, and alone time can sometimes bring up worry about '
            'the relationship.',
        AttachmentStyle.dismissiveAvoidant:
            'I tend to need significant alone time to recharge and may '
            'notice that too much togetherness feels draining.',
        AttachmentStyle.fearfulAvoidant:
            'My need for space and closeness might shift unpredictably - '
            'sometimes I crave connection and other times I need to retreat.',
      },
      optionsTr: {
        AttachmentStyle.secure:
            'Anlamlı zaman geçirmekten de kendi alanıma sahip olmaktan '
            'da keyif alırım - ikisi de bana besleyici gelir.',
        AttachmentStyle.anxiousPreoccupied:
            'Birlikte zaman geçirdiğimizde en güvende hissedebilir ve '
            'yalnız zaman bazen ilişki hakkında endişe getirebilir.',
        AttachmentStyle.dismissiveAvoidant:
            'Enerji toplamak için önemli ölçüde yalnız zamana ihtiyaç '
            'duyma eğilimindeyim ve çok fazla birlikteliğin yorucu '
            'geldiğini fark edebilirim.',
        AttachmentStyle.fearfulAvoidant:
            'Alan ve yakınlık ihtiyacım öngörülemez şekilde değişebilir '
            '- bazen bağlantı arzularım, bazen geri çekilmem gerekir.',
      },
    ),
  ];

  // ══════════════════════════════════════════════════════════════════════════
  // SCORING
  // ══════════════════════════════════════════════════════════════════════════

  /// Calculate the quiz result from a list of answer indices (0-3).
  ///
  /// Each answer index maps to the attachment style at that position in the
  /// question's options. The order is always:
  /// 0 = secure, 1 = anxiousPreoccupied,
  /// 2 = dismissiveAvoidant, 3 = fearfulAvoidant
  AttachmentQuizResult calculateResult(List<int> answers) {
    assert(answers.length == questions.length);

    final styleOrder = [
      AttachmentStyle.secure,
      AttachmentStyle.anxiousPreoccupied,
      AttachmentStyle.dismissiveAvoidant,
      AttachmentStyle.fearfulAvoidant,
    ];

    // Count votes per style
    final counts = <AttachmentStyle, int>{};
    for (final style in AttachmentStyle.values) {
      counts[style] = 0;
    }

    for (int i = 0; i < answers.length; i++) {
      final chosenIndex = answers[i].clamp(0, 3);
      final chosenStyle = styleOrder[chosenIndex];
      counts[chosenStyle] = (counts[chosenStyle] ?? 0) + 1;
    }

    // Convert to percentages
    final totalQuestions = questions.length;
    final scores = <AttachmentStyle, double>{};
    for (final style in AttachmentStyle.values) {
      scores[style] = (counts[style] ?? 0) / totalQuestions;
    }

    // Determine dominant style (tie-break: first in enum order)
    AttachmentStyle dominant = AttachmentStyle.secure;
    int highestCount = 0;
    for (final style in AttachmentStyle.values) {
      if ((counts[style] ?? 0) > highestCount) {
        highestCount = counts[style] ?? 0;
        dominant = style;
      }
    }

    final result = AttachmentQuizResult(
      attachmentStyle: dominant,
      scores: scores,
      dateTaken: DateTime.now(),
    );

    _results.add(result);
    unawaited(_persistResults());

    return result;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUERIES
  // ══════════════════════════════════════════════════════════════════════════

  /// Get the most recent quiz result, or null if never taken
  AttachmentQuizResult? getLatestResult() {
    if (_results.isEmpty) return null;
    final sorted = List<AttachmentQuizResult>.from(_results)
      ..sort((a, b) => b.dateTaken.compareTo(a.dateTaken));
    return sorted.first;
  }

  /// Get all quiz results, sorted most recent first
  List<AttachmentQuizResult> getAllResults() {
    final sorted = List<AttachmentQuizResult>.from(_results)
      ..sort((a, b) => b.dateTaken.compareTo(a.dateTaken));
    return sorted;
  }

  /// Check if the user can retake the quiz (monthly re-assessment)
  bool canRetakeQuiz() {
    final latest = getLatestResult();
    if (latest == null) return true;

    final daysSinceLast = DateTime.now().difference(latest.dateTaken).inDays;
    return daysSinceLast >= 30;
  }

  /// Days remaining until the next re-assessment is available
  int daysUntilRetake() {
    final latest = getLatestResult();
    if (latest == null) return 0;

    final daysSinceLast = DateTime.now().difference(latest.dateTaken).inDays;
    final remaining = 30 - daysSinceLast;
    return remaining > 0 ? remaining : 0;
  }

  /// Get evolution data for premium tracker - all results over time
  List<AttachmentQuizResult> getEvolutionData() {
    return getAllResults().reversed.toList(); // chronological order
  }

  /// Total number of quizzes taken
  int get quizCount => _results.length;

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadResults() {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _results = jsonList
            .map((j) => AttachmentQuizResult.fromJson(j))
            .toList();
      } catch (_) {
        _results = [];
      }
    }
  }

  Future<void> _persistResults() async {
    final jsonList = _results.map((r) => r.toJson()).toList();
    await _prefs.setString(_storageKey, json.encode(jsonList));
  }

  /// Clear all quiz data
  Future<void> clearAll() async {
    _results.clear();
    await _prefs.remove(_storageKey);
  }
}
