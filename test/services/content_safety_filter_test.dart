// ════════════════════════════════════════════════════════════════════════════
// CONTENT SAFETY FILTER TESTS
// ════════════════════════════════════════════════════════════════════════════
//
// Tests for App Store 4.3(b) compliance runtime filter.
// Ensures prediction/fortune-telling language is blocked or replaced.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter_test/flutter_test.dart';
import 'package:inner_cycles/data/services/content_safety_filter.dart';

void main() {
  group('ContentSafetyFilter', () {
    group('containsForbiddenContent', () {
      test('detects "will happen" prediction language', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent('This will happen soon'),
          isTrue,
        );
      });

      test('detects "is destined" language', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent('You are destined for greatness'),
          isTrue,
        );
      });

      test('detects "the stars predict" language', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent('The stars predict a change'),
          isTrue,
        );
      });

      test('detects "prophecy" language', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent('This prophecy will come true'),
          isTrue,
        );
      });

      test('detects "fortune telling" language', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent('Fortune telling reveals'),
          isTrue,
        );
      });

      test('detects "definitely will" certainty language', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent('You definitely will succeed'),
          isTrue,
        );
      });

      test('detects "guaranteed to" language', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent('You are guaranteed to find love'),
          isTrue,
        );
      });

      test('detects Turkish "kaderin" prediction language', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent('Kaderin belli'),
          isTrue,
        );
      });

      test('detects Turkish "kehanet" language', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent('Bu kehanet doğru'),
          isTrue,
        );
      });

      test('allows safe reflective language', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent(
            'This pattern might represent growth',
          ),
          isFalse,
        );
      });

      test('allows "could symbolize" language', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent(
            'Water could symbolize emotions',
          ),
          isFalse,
        );
      });

      test('allows "may reflect" language', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent(
            'This may reflect your inner state',
          ),
          isFalse,
        );
      });

      test('allows "often appears" language', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent(
            'This symbol often appears in dreams',
          ),
          isFalse,
        );
      });

      test('returns false for empty string', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent(''),
          isFalse,
        );
      });

      test('is case insensitive', () {
        expect(
          ContentSafetyFilter.containsForbiddenContent('WILL HAPPEN'),
          isTrue,
        );
        expect(
          ContentSafetyFilter.containsForbiddenContent('Will Happen'),
          isTrue,
        );
      });
    });

    group('filterContent', () {
      test('replaces "will happen" with "might unfold"', () {
        final filtered = ContentSafetyFilter.filterContent(
          'This will happen in your life',
        );
        expect(filtered, contains('might unfold'));
        expect(filtered, isNot(contains('will happen')));
      });

      test('replaces "is destined" with "could represent"', () {
        final filtered = ContentSafetyFilter.filterContent(
          'You is destined for success',
        );
        expect(filtered, contains('could represent'));
      });

      test('replaces "your future" with "your personal journey"', () {
        final filtered = ContentSafetyFilter.filterContent(
          'In your future you will see',
        );
        expect(filtered, contains('your personal journey'));
        expect(filtered, isNot(contains('your future')));
      });

      test('replaces "prophecy" with "reflection"', () {
        final filtered = ContentSafetyFilter.filterContent(
          'This prophecy is clear',
        );
        expect(filtered, contains('reflection'));
        expect(filtered, isNot(contains('prophecy')));
      });

      test('replaces Turkish "kaderin" with "yolculuğun"', () {
        final filtered = ContentSafetyFilter.filterContent(
          'Kaderin belli',
        );
        expect(filtered, contains('yolculuğun'));
      });

      test('handles multiple replacements in one string', () {
        final filtered = ContentSafetyFilter.filterContent(
          'Your future will happen as the prophecy says',
        );
        expect(filtered, contains('personal journey'));
        expect(filtered, contains('might unfold'));
        expect(filtered, contains('reflection'));
      });

      test('preserves safe content unchanged', () {
        const safeContent = 'This pattern might represent personal growth';
        final filtered = ContentSafetyFilter.filterContent(safeContent);
        expect(filtered, equals(safeContent));
      });

      test('returns empty string unchanged', () {
        expect(ContentSafetyFilter.filterContent(''), equals(''));
      });
    });

    group('validateAndFilter', () {
      test('returns unchanged content when safe', () {
        const safe = 'Dreams often symbolize inner thoughts';
        expect(
          ContentSafetyFilter.validateAndFilter(safe),
          equals(safe),
        );
      });

      test('filters and returns safe content when forbidden found', () {
        final result = ContentSafetyFilter.validateAndFilter(
          'This will happen soon',
          context: 'TEST',
        );
        expect(result, contains('might unfold'));
      });
    });

    group('detectForbiddenPhrases', () {
      test('returns list of detected phrases', () {
        final detected = ContentSafetyFilter.detectForbiddenPhrases(
          'This will happen and is destined to be',
        );
        expect(detected, isNotEmpty);
        expect(detected.length, greaterThanOrEqualTo(2));
      });

      test('returns empty list for safe content', () {
        final detected = ContentSafetyFilter.detectForbiddenPhrases(
          'This might represent growth',
        );
        expect(detected, isEmpty);
      });
    });

    group('batch operations', () {
      test('filterBatch processes multiple strings', () {
        final results = ContentSafetyFilter.filterBatch([
          'This will happen',
          'Safe content here',
          'Prophecy reveals',
        ]);
        expect(results.length, equals(3));
        expect(results[0], contains('might unfold'));
        expect(results[1], equals('Safe content here'));
        expect(results[2], contains('reflection'));
      });

      test('batchContainsForbidden detects any forbidden content', () {
        expect(
          ContentSafetyFilter.batchContainsForbidden([
            'Safe content',
            'This will happen',
            'More safe content',
          ]),
          isTrue,
        );

        expect(
          ContentSafetyFilter.batchContainsForbidden([
            'Safe content',
            'Also safe',
          ]),
          isFalse,
        );
      });
    });
  });
}
