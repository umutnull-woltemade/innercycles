import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrology_app/data/services/ai_content_service.dart';
import 'package:astrology_app/data/models/zodiac_sign.dart';

void main() {
  group('AiContentService', () {
    late AiContentService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      service = AiContentService();
      await service.initialize();
    });

    test('initialize completes without error', () async {
      await expectLater(service.initialize(), completes);
    });

    test('isAiAvailable is false without API keys', () {
      expect(service.isAiAvailable, false);
    });

    test('setApiKeys stores keys', () async {
      await service.setApiKeys(
        openAiKey: 'test-openai-key',
        anthropicKey: 'test-anthropic-key',
      );

      expect(service.isAiAvailable, true);
    });

    test('setApiKeys with null clears keys', () async {
      await service.setApiKeys(openAiKey: 'test-key');
      expect(service.isAiAvailable, true);

      await service.setApiKeys(openAiKey: null);
      expect(service.isAiAvailable, false);
    });

    test('generatePersonalizedHoroscope returns local horoscope when AI unavailable', () async {
      final horoscope = await service.generatePersonalizedHoroscope(
        sunSign: ZodiacSign.aries,
      );

      expect(horoscope.sign, ZodiacSign.aries);
      expect(horoscope.summary, isNotEmpty);
      expect(horoscope.loveAdvice, isNotEmpty);
      expect(horoscope.careerAdvice, isNotEmpty);
      expect(horoscope.healthAdvice, isNotEmpty);
      expect(horoscope.focusNumber, isNotEmpty);
      expect(horoscope.reflectionColor, isNotEmpty);
      expect(horoscope.mood, isNotEmpty);
      expect(horoscope.isAiGenerated, false);
    });

    test('generatePersonalizedHoroscope works for all signs', () async {
      for (final sign in ZodiacSign.values) {
        final horoscope = await service.generatePersonalizedHoroscope(
          sunSign: sign,
        );

        expect(horoscope.sign, sign);
        expect(horoscope.summary, isNotEmpty);
      }
    });

    test('generateCosmicMessage returns message', () async {
      final message = await service.generateCosmicMessage(
        sign: ZodiacSign.taurus,
      );

      expect(message, isNotEmpty);
    });

    test('generatePersonalizedAdvice works for all areas', () async {
      for (final area in AdviceArea.values) {
        final advice = await service.generatePersonalizedAdvice(
          sign: ZodiacSign.gemini,
          area: area,
        );

        expect(advice, isNotEmpty);
      }
    });

    test('generateAffirmation returns affirmation', () async {
      final affirmation = await service.generateAffirmation(
        sign: ZodiacSign.cancer,
      );

      expect(affirmation, isNotEmpty);
    });

    test('clearCache clears cached content', () async {
      // Generate content to cache it
      await service.generatePersonalizedHoroscope(
        sunSign: ZodiacSign.leo,
      );

      // Clear cache
      service.clearCache();

      // No way to verify cache is empty without internal access,
      // but this should not throw
      expect(() => service.clearCache(), returnsNormally);
    });

    test('horoscope caching works', () async {
      final horoscope1 = await service.generatePersonalizedHoroscope(
        sunSign: ZodiacSign.virgo,
      );

      final horoscope2 = await service.generatePersonalizedHoroscope(
        sunSign: ZodiacSign.virgo,
      );

      // Same day, same sign should return same summary (cached)
      expect(horoscope1.summary, horoscope2.summary);
    });
  });

  group('PersonalizedHoroscope', () {
    test('creates instance with all required fields', () {
      final horoscope = PersonalizedHoroscope(
        sign: ZodiacSign.libra,
        summary: 'Test summary',
        loveAdvice: 'Love advice',
        careerAdvice: 'Career advice',
        healthAdvice: 'Health advice',
        focusNumber: '7',
        reflectionColor: 'Gold',
        mood: 'Happy',
      );

      expect(horoscope.sign, ZodiacSign.libra);
      expect(horoscope.summary, 'Test summary');
      expect(horoscope.loveAdvice, 'Love advice');
      expect(horoscope.careerAdvice, 'Career advice');
      expect(horoscope.healthAdvice, 'Health advice');
      expect(horoscope.focusNumber, '7');
      expect(horoscope.reflectionColor, 'Gold');
      expect(horoscope.mood, 'Happy');
      expect(horoscope.isAiGenerated, false);
    });

    test('isAiGenerated defaults to false', () {
      final horoscope = PersonalizedHoroscope(
        sign: ZodiacSign.scorpio,
        summary: 'Test',
        loveAdvice: 'Test',
        careerAdvice: 'Test',
        healthAdvice: 'Test',
        focusNumber: '1',
        reflectionColor: 'Red',
        mood: 'Intense',
      );

      expect(horoscope.isAiGenerated, false);
    });

    test('isAiGenerated can be set to true', () {
      final horoscope = PersonalizedHoroscope(
        sign: ZodiacSign.sagittarius,
        summary: 'AI Test',
        loveAdvice: 'AI Love',
        careerAdvice: 'AI Career',
        healthAdvice: 'AI Health',
        focusNumber: '42',
        reflectionColor: 'Purple',
        mood: 'Adventurous',
        isAiGenerated: true,
      );

      expect(horoscope.isAiGenerated, true);
    });
  });

  group('AdviceArea', () {
    test('has all expected values', () {
      expect(AdviceArea.values, containsAll([
        AdviceArea.love,
        AdviceArea.career,
        AdviceArea.health,
        AdviceArea.money,
        AdviceArea.spiritual,
      ]));
    });

    test('has 5 values', () {
      expect(AdviceArea.values.length, 5);
    });
  });

  group('aiContentServiceProvider', () {
    test('provides AiContentService instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(aiContentServiceProvider);
      expect(service, isA<AiContentService>());
    });
  });
}
