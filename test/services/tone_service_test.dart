import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/data/services/tone_service.dart';

void main() {
  group('ToneService', () {
    setUp(() {
      // Reset to US (default) before each test
      ToneService.setRegion(ToneRegion.us);
    });

    group('Region Management', () {
      test('default region is US', () {
        ToneService.setRegion(ToneRegion.us); // Reset
        expect(ToneService.currentRegion, equals(ToneRegion.us));
      });

      test('setRegion changes current region', () {
        ToneService.setRegion(ToneRegion.uk);
        expect(ToneService.currentRegion, equals(ToneRegion.uk));
      });

      test('region can switch back and forth', () {
        ToneService.setRegion(ToneRegion.uk);
        expect(ToneService.currentRegion, equals(ToneRegion.uk));

        ToneService.setRegion(ToneRegion.us);
        expect(ToneService.currentRegion, equals(ToneRegion.us));
      });
    });

    group('getText', () {
      test('returns US text when region is US', () {
        ToneService.setRegion(ToneRegion.us);
        final result = ToneService.getText('color', 'colour');
        expect(result, equals('color'));
      });

      test('returns UK text when region is UK', () {
        ToneService.setRegion(ToneRegion.uk);
        final result = ToneService.getText('color', 'colour');
        expect(result, equals('colour'));
      });

      test('handles empty strings', () {
        ToneService.setRegion(ToneRegion.us);
        expect(ToneService.getText('', 'uk'), equals(''));

        ToneService.setRegion(ToneRegion.uk);
        expect(ToneService.getText('us', ''), equals(''));
      });
    });

    group('applySpelling', () {
      test('returns original text for US region', () {
        ToneService.setRegion(ToneRegion.us);
        final result = ToneService.applySpelling('The color is gray.');
        expect(result, equals('The color is gray.'));
      });

      test('transforms common spellings for UK region', () {
        ToneService.setRegion(ToneRegion.uk);

        // Test individual transformations
        expect(ToneService.applySpelling('color'), equals('colour'));
        expect(ToneService.applySpelling('Color'), equals('Colour'));
        expect(ToneService.applySpelling('favor'), equals('favour'));
        expect(ToneService.applySpelling('honor'), equals('honour'));
        expect(ToneService.applySpelling('behavior'), equals('behaviour'));
        expect(ToneService.applySpelling('personalize'), equals('personalise'));
        expect(ToneService.applySpelling('analyze'), equals('analyse'));
        expect(ToneService.applySpelling('center'), equals('centre'));
        expect(ToneService.applySpelling('theater'), equals('theatre'));
        expect(ToneService.applySpelling('gray'), equals('grey'));
      });

      test('transforms full sentences', () {
        ToneService.setRegion(ToneRegion.uk);
        final result = ToneService.applySpelling(
          'The theater in the center has a gray color scheme.'
        );
        expect(result, equals(
          'The theatre in the centre has a grey colour scheme.'
        ));
      });

      test('preserves case in transformations', () {
        ToneService.setRegion(ToneRegion.uk);

        expect(ToneService.applySpelling('COLOR'), equals('COLOUR'));
        expect(ToneService.applySpelling('Color'), equals('Colour'));
        expect(ToneService.applySpelling('color'), equals('colour'));
      });

      test('transforms multiple occurrences', () {
        ToneService.setRegion(ToneRegion.uk);
        final result = ToneService.applySpelling(
          'The color and the color and the color.'
        );
        expect(result, equals(
          'The colour and the colour and the colour.'
        ));
      });

      test('handles text with no transformations needed', () {
        ToneService.setRegion(ToneRegion.uk);
        final result = ToneService.applySpelling('Hello world!');
        expect(result, equals('Hello world!'));
      });

      test('transforms less common spellings', () {
        ToneService.setRegion(ToneRegion.uk);

        expect(ToneService.applySpelling('jewelry'), equals('jewellery'));
        expect(ToneService.applySpelling('traveling'), equals('travelling'));
        expect(ToneService.applySpelling('canceled'), equals('cancelled'));
        expect(ToneService.applySpelling('dialog'), equals('dialogue'));
        expect(ToneService.applySpelling('catalog'), equals('catalogue'));
        expect(ToneService.applySpelling('pajamas'), equals('pyjamas'));
        expect(ToneService.applySpelling('mom'), equals('mum'));
      });

      test('transforms defense/offense spellings', () {
        ToneService.setRegion(ToneRegion.uk);

        expect(ToneService.applySpelling('defense'), equals('defence'));
        expect(ToneService.applySpelling('offense'), equals('offence'));
        expect(ToneService.applySpelling('license'), equals('licence'));
      });
    });
  });

  group('MarketingCopy', () {
    setUp(() {
      ToneService.setRegion(ToneRegion.us);
    });

    group('CTA Buttons', () {
      test('getStarted varies by region', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.getStarted, equals('Get Started'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.getStarted, equals('Begin Your Journey'));
      });

      test('learnMore varies by region', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.learnMore, equals('Learn More'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.learnMore, equals('Discover More'));
      });

      test('signUp varies by region', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.signUp, equals('Sign Up'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.signUp, equals('Create Account'));
      });
    });

    group('Greetings', () {
      test('hi varies by region', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.hi, equals('Hi'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.hi, equals('Hello'));
      });

      test('greeting with name varies by region', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.greeting('John'), equals('Hey John!'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.greeting('John'), equals('Hello John,'));
      });
    });

    group('Error Messages', () {
      test('somethingWentWrong varies by region', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.somethingWentWrong, equals('Oops! Something went wrong.'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.somethingWentWrong, equals('Apologies, something went wrong.'));
      });

      test('tryAgain varies by region', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.tryAgain, equals('Try again'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.tryAgain, equals('Please try again'));
      });
    });

    group('Success Messages', () {
      test('awesome varies by region', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.awesome, equals('Awesome!'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.awesome, equals('Wonderful!'));
      });

      test('allSet varies by region', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.allSet, equals("You're all set!"));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.allSet, equals("You're all ready!"));
      });
    });

    group('Marketing Headlines', () {
      test('heroSubheadline includes correct spelling', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.heroSubheadline, contains('personalized'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.heroSubheadline, contains('personalised'));
      });

      test('socialProof uses appropriate number format', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.socialProof, contains('500K+'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.socialProof, contains('500,000+'));
      });
    });

    group('Email Subjects', () {
      test('welcomeSubject includes app name', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.welcomeSubject('AstroApp'), contains('AstroApp'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.welcomeSubject('AstroApp'), contains('AstroApp'));
      });

      test('birthdaySubject varies by region', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.birthdaySubject, contains('Happy Birthday!'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.birthdaySubject, contains('Many Happy Returns!'));
      });
    });

    group('Casual Expressions', () {
      test('amazing varies by region', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.amazing, equals('amazing'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.amazing, equals('remarkable'));
      });

      test('superEasy varies by region', () {
        ToneService.setRegion(ToneRegion.us);
        expect(MarketingCopy.superEasy, equals('Super easy'));

        ToneService.setRegion(ToneRegion.uk);
        expect(MarketingCopy.superEasy, equals('Quite simple'));
      });
    });
  });

  group('ToneStringExtension', () {
    test('withTone returns original for US region', () {
      ToneService.setRegion(ToneRegion.us);
      expect('color'.withTone, equals('color'));
    });

    test('withTone transforms for UK region', () {
      ToneService.setRegion(ToneRegion.uk);
      expect('color'.withTone, equals('colour'));
    });

    test('withTone works on sentences', () {
      ToneService.setRegion(ToneRegion.uk);
      expect('I love the gray color.'.withTone, equals('I love the grey colour.'));
    });
  });

  group('ToneRegion enum', () {
    test('has exactly two values', () {
      expect(ToneRegion.values.length, equals(2));
    });

    test('contains us and uk', () {
      expect(ToneRegion.values, contains(ToneRegion.us));
      expect(ToneRegion.values, contains(ToneRegion.uk));
    });
  });
}
