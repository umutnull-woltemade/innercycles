import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/features/insight/services/insight_routing_service.dart';
import 'package:astrology_app/data/providers/app_providers.dart';

void main() {
  late InsightRoutingService service;

  setUp(() {
    service = InsightRoutingService();
  });

  group('InsightRoutingService', () {
    group('Dream Reflection', () {
      test('classifies dream-related input in English', () {
        expect(
          service.classifyInput('I had a strange dream last night', AppLanguage.en),
          InsightType.dreamReflection,
        );
        expect(
          service.classifyInput('I keep having nightmares', AppLanguage.en),
          InsightType.dreamReflection,
        );
        expect(
          service.classifyInput('When I woke up I felt weird', AppLanguage.en),
          InsightType.dreamReflection,
        );
      });

      test('classifies dream-related input in Turkish', () {
        expect(
          service.classifyInput('Dün gece bir rüya gördüm', AppLanguage.tr),
          InsightType.dreamReflection,
        );
        expect(
          service.classifyInput('Sürekli kabus görüyorum', AppLanguage.tr),
          InsightType.dreamReflection,
        );
      });
    });

    group('Pattern Awareness', () {
      test('classifies pattern-related input in English', () {
        expect(
          service.classifyInput('I keep making the same mistakes', AppLanguage.en),
          InsightType.patternAwareness,
        );
        expect(
          service.classifyInput('I always end up in this cycle', AppLanguage.en),
          InsightType.patternAwareness,
        );
        expect(
          service.classifyInput('I feel stuck in a loop', AppLanguage.en),
          InsightType.patternAwareness,
        );
      });

      test('classifies pattern-related input in Turkish', () {
        expect(
          service.classifyInput('Hep aynı şeyi yapıyorum', AppLanguage.tr),
          InsightType.patternAwareness,
        );
        expect(
          service.classifyInput('Bu döngüden çıkamıyorum', AppLanguage.tr),
          InsightType.patternAwareness,
        );
      });
    });

    group('Emotional Explore', () {
      test('classifies emotion-related input in English', () {
        expect(
          service.classifyInput('I feel so anxious today', AppLanguage.en),
          InsightType.emotionalExplore,
        );
        expect(
          service.classifyInput('I am feeling overwhelmed', AppLanguage.en),
          InsightType.emotionalExplore,
        );
        expect(
          service.classifyInput('I felt lonely and confused', AppLanguage.en),
          InsightType.emotionalExplore,
        );
      });

      test('classifies emotion-related input in Turkish', () {
        expect(
          service.classifyInput('Çok kaygılı hissediyorum', AppLanguage.tr),
          InsightType.emotionalExplore,
        );
        expect(
          service.classifyInput('Yalnız hissediyorum', AppLanguage.tr),
          InsightType.emotionalExplore,
        );
      });
    });

    group('Decision Support', () {
      test('classifies decision-related input in English', () {
        expect(
          service.classifyInput('Should I take this job offer?', AppLanguage.en),
          InsightType.decisionSupport,
        );
        expect(
          service.classifyInput('I can\'t decide what to do', AppLanguage.en),
          InsightType.decisionSupport,
        );
        expect(
          service.classifyInput('Help me choose between options', AppLanguage.en),
          InsightType.decisionSupport,
        );
      });

      test('classifies decision-related input in Turkish', () {
        expect(
          service.classifyInput('Bu işi yapmalı mıyım?', AppLanguage.tr),
          InsightType.decisionSupport,
        );
        expect(
          service.classifyInput('Karar veremiyorum', AppLanguage.tr),
          InsightType.decisionSupport,
        );
      });
    });

    group('Relationship Reflection', () {
      test('classifies relationship-related input in English', () {
        expect(
          service.classifyInput('My relationship is falling apart', AppLanguage.en),
          InsightType.relationshipReflection,
        );
        expect(
          service.classifyInput('I had a fight with my partner', AppLanguage.en),
          InsightType.relationshipReflection,
        );
        expect(
          service.classifyInput('My mother doesn\'t understand me', AppLanguage.en),
          InsightType.relationshipReflection,
        );
      });

      test('classifies relationship-related input in Turkish', () {
        expect(
          service.classifyInput('İlişkim kötüye gidiyor', AppLanguage.tr),
          InsightType.relationshipReflection,
        );
        expect(
          service.classifyInput('Ailemle sorunlar yaşıyorum', AppLanguage.tr),
          InsightType.relationshipReflection,
        );
      });
    });

    group('Self Discovery', () {
      test('classifies self-discovery input in English', () {
        expect(
          service.classifyInput('Who am I really?', AppLanguage.en),
          InsightType.selfDiscovery,
        );
        expect(
          service.classifyInput('I want to understand myself better', AppLanguage.en),
          InsightType.selfDiscovery,
        );
        expect(
          service.classifyInput('What is my purpose in life?', AppLanguage.en),
          InsightType.selfDiscovery,
        );
      });

      test('classifies self-discovery input in Turkish', () {
        expect(
          service.classifyInput('Ben kimim?', AppLanguage.tr),
          InsightType.selfDiscovery,
        );
        expect(
          service.classifyInput('Kendimi anlamak istiyorum', AppLanguage.tr),
          InsightType.selfDiscovery,
        );
      });
    });

    group('General Reflection', () {
      test('classifies generic input as general reflection', () {
        expect(
          service.classifyInput('Hello, how are you?', AppLanguage.en),
          InsightType.generalReflection,
        );
        expect(
          service.classifyInput('What is the weather like?', AppLanguage.en),
          InsightType.generalReflection,
        );
        expect(
          service.classifyInput('Merhaba', AppLanguage.tr),
          InsightType.generalReflection,
        );
      });
    });

    group('Edge Cases', () {
      test('handles empty input', () {
        expect(
          service.classifyInput('', AppLanguage.en),
          InsightType.generalReflection,
        );
      });

      test('handles mixed case input', () {
        expect(
          service.classifyInput('I HAD A DREAM', AppLanguage.en),
          InsightType.dreamReflection,
        );
      });

      test('prioritizes first match in keyword order', () {
        // Dream keywords come before emotion keywords
        expect(
          service.classifyInput('I dreamed I was feeling anxious', AppLanguage.en),
          InsightType.dreamReflection,
        );
      });
    });
  });
}
