import 'package:flutter_test/flutter_test.dart';
import 'package:inner_cycles/data/services/mood_checkin_service.dart';

void main() {
  group('MoodEntry', () {
    test('constructor sets all fields', () {
      final entry = MoodEntry(
        id: 'mood-1',
        date: DateTime(2026, 2, 24),
        mood: 4,
        emoji: '😊',
      );
      expect(entry.id, 'mood-1');
      expect(entry.date, DateTime(2026, 2, 24));
      expect(entry.mood, 4);
      expect(entry.emoji, '😊');
    });

    group('toJson', () {
      test('produces correct map', () {
        final entry = MoodEntry(
          id: 'mood-2',
          date: DateTime(2026, 2, 24),
          mood: 5,
          emoji: '🤩',
        );
        final json = entry.toJson();
        expect(json['id'], 'mood-2');
        expect(json['mood'], 5);
        expect(json['emoji'], '🤩');
        expect(json['date'], contains('2026-02-24'));
      });
    });

    group('fromJson', () {
      test('reconstructs entry correctly', () {
        final json = {
          'id': 'from-1',
          'date': '2026-02-24T00:00:00.000',
          'mood': 3,
          'emoji': '🙂',
        };
        final entry = MoodEntry.fromJson(json);
        expect(entry.id, 'from-1');
        expect(entry.date.year, 2026);
        expect(entry.date.month, 2);
        expect(entry.date.day, 24);
        expect(entry.mood, 3);
        expect(entry.emoji, '🙂');
      });

      test('generates UUID when id is missing (backward compat)', () {
        final json = {
          'date': '2026-01-15T00:00:00.000',
          'mood': 4,
          'emoji': '😊',
        };
        final entry = MoodEntry.fromJson(json);
        expect(entry.id, isNotEmpty);
        expect(entry.id.length, greaterThan(8)); // UUID format
      });

      test('defaults mood to 3 when missing', () {
        final json = {
          'id': 'no-mood',
          'date': '2026-01-01',
          'emoji': '🙂',
        };
        final entry = MoodEntry.fromJson(json);
        expect(entry.mood, 3);
      });

      test('defaults emoji to empty string when missing', () {
        final json = {
          'id': 'no-emoji',
          'date': '2026-01-01',
          'mood': 4,
        };
        final entry = MoodEntry.fromJson(json);
        expect(entry.emoji, '');
      });

      test('handles invalid date gracefully', () {
        final json = {
          'id': 'bad-date',
          'date': 'not-a-date',
          'mood': 3,
          'emoji': '🙂',
        };
        final entry = MoodEntry.fromJson(json);
        // Falls back to DateTime.now() — just verify it doesn't crash
        expect(entry.date, isNotNull);
      });

      test('handles null date gracefully', () {
        final json = {
          'id': 'null-date',
          'date': null,
          'mood': 3,
          'emoji': '🙂',
        };
        final entry = MoodEntry.fromJson(json);
        expect(entry.date, isNotNull);
      });
    });

    group('round-trip', () {
      test('toJson then fromJson preserves data', () {
        final original = MoodEntry(
          id: 'rt-1',
          date: DateTime(2026, 2, 24),
          mood: 5,
          emoji: '🤩',
        );
        final restored = MoodEntry.fromJson(original.toJson());
        expect(restored.id, original.id);
        expect(restored.mood, original.mood);
        expect(restored.emoji, original.emoji);
      });

      test('round-trip preserves all mood values 1-5', () {
        for (int m = 1; m <= 5; m++) {
          final entry = MoodEntry(
            id: 'mood-$m',
            date: DateTime(2026, 1, m),
            mood: m,
            emoji: MoodCheckinService.moodOptions[m - 1].$2,
          );
          final restored = MoodEntry.fromJson(entry.toJson());
          expect(restored.mood, m);
        }
      });
    });
  });

  group('MoodCheckinService static', () {
    test('moodOptions has 5 entries', () {
      expect(MoodCheckinService.moodOptions.length, 5);
    });

    test('moodOptions has correct mood values 1-5', () {
      for (int i = 0; i < 5; i++) {
        expect(MoodCheckinService.moodOptions[i].$1, i + 1);
      }
    });

    test('moodOptions emojis are non-empty', () {
      for (final option in MoodCheckinService.moodOptions) {
        expect(option.$2, isNotEmpty);
      }
    });

    test('moodOptions has EN and TR labels', () {
      for (final option in MoodCheckinService.moodOptions) {
        expect(option.$3, isNotEmpty); // EN
        expect(option.$4, isNotEmpty); // TR
      }
    });
  });
}
