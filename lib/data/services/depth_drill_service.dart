// ════════════════════════════════════════════════════════════════════════════
// DEPTH DRILL SERVICE - Focus-area-specific follow-up questions
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math';
import '../models/journal_entry.dart';

class DepthDrillQuestion {
  final String textEn;
  final String textTr;

  const DepthDrillQuestion({required this.textEn, required this.textTr});

  String text(bool isEn) => isEn ? textEn : textTr;
}

class DepthDrillService {
  static final _random = Random();

  static const _questionsByArea = <FocusArea, List<DepthDrillQuestion>>{
    FocusArea.energy: [
      DepthDrillQuestion(
        textEn: 'What specifically gave you energy today — and what drained it?',
        textTr: 'Bugün sana özellikle ne enerji verdi — ve ne tüketti?',
      ),
      DepthDrillQuestion(
        textEn: 'If you could redesign today for maximum energy, what would you change?',
        textTr: 'Maksimum enerji için bugünü yeniden tasarlasan, neyi değiştirirdin?',
      ),
      DepthDrillQuestion(
        textEn: 'What does your body need right now that you haven\'t given it?',
        textTr: 'Bedenin şu an sana vermediğin neye ihtiyaç duyuyor?',
      ),
    ],
    FocusArea.focus: [
      DepthDrillQuestion(
        textEn: 'What kept pulling your attention away today? What held it?',
        textTr: 'Bugün dikkatini ne çekip aldı? Ne tuttu?',
      ),
      DepthDrillQuestion(
        textEn: 'If you could only focus on one thing tomorrow, what would it be?',
        textTr: 'Yarın sadece bir şeye odaklanabilsen, ne olurdu?',
      ),
      DepthDrillQuestion(
        textEn: 'What are you avoiding that actually deserves your full attention?',
        textTr: 'Aslında tüm dikkatini hak eden ama kaçındığın ne var?',
      ),
    ],
    FocusArea.emotions: [
      DepthDrillQuestion(
        textEn: 'What emotion was loudest today? What was it trying to tell you?',
        textTr: 'Bugün en yüksek sesli duygu hangisiydi? Sana ne söylemeye çalışıyordu?',
      ),
      DepthDrillQuestion(
        textEn: 'If this feeling had a color and a shape, what would it look like?',
        textTr: 'Bu duygunun bir rengi ve şekli olsaydı, nasıl görünürdü?',
      ),
      DepthDrillQuestion(
        textEn: 'What would you say to a friend feeling exactly what you felt today?',
        textTr: 'Bugün senin hissettiğini aynen hisseden bir arkadaşına ne söylerdin?',
      ),
    ],
    FocusArea.decisions: [
      DepthDrillQuestion(
        textEn: 'What decision are you sitting on that you already know the answer to?',
        textTr: 'Cevabını aslında bildiğin ama üzerinde oturduğun bir karar var mı?',
      ),
      DepthDrillQuestion(
        textEn: 'What would the most courageous version of you do next?',
        textTr: 'Senin en cesur versiyonun bir sonraki adımda ne yapardı?',
      ),
      DepthDrillQuestion(
        textEn: 'Which of your values was at stake in today\'s choices?',
        textTr: 'Bugünkü seçimlerinde hangi değerin devredeydi?',
      ),
    ],
    FocusArea.social: [
      DepthDrillQuestion(
        textEn: 'What did you need from others today that you didn\'t ask for?',
        textTr: 'Bugün başkalarından ihtiyacın olup istemediğin ne vardı?',
      ),
      DepthDrillQuestion(
        textEn: 'If the person you interacted with most today could read your mind, what would surprise them?',
        textTr: 'Bugün en çok etkileşimde olduğun kişi aklını okuyabilseydi, onu ne şaşırtırdı?',
      ),
      DepthDrillQuestion(
        textEn: 'What boundary do you wish you had set — or are glad you held?',
        textTr: 'Keşke koymuş olsaydım dediğin — ya da tuttuğuna sevineceğin bir sınır var mı?',
      ),
    ],
  };

  /// Get a random depth drill question for a focus area
  static DepthDrillQuestion getQuestion(FocusArea area) {
    final questions = _questionsByArea[area] ?? _questionsByArea[FocusArea.emotions]!;
    return questions[_random.nextInt(questions.length)];
  }

  /// Get all questions for an area (for display)
  static List<DepthDrillQuestion> getQuestionsForArea(FocusArea area) {
    return _questionsByArea[area] ?? [];
  }
}
