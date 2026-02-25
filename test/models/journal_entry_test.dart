import 'package:flutter_test/flutter_test.dart';
import 'package:inner_cycles/data/models/journal_entry.dart';

void main() {
  group('FocusArea', () {
    test('has 5 values', () {
      expect(FocusArea.values.length, 5);
    });

    test('displayNameEn returns correct names', () {
      expect(FocusArea.energy.displayNameEn, 'Spark');
      expect(FocusArea.focus.displayNameEn, 'Lens');
      expect(FocusArea.emotions.displayNameEn, 'Tides');
      expect(FocusArea.decisions.displayNameEn, 'Compass');
      expect(FocusArea.social.displayNameEn, 'Orbit');
    });

    test('displayNameTr returns correct names with diacritics', () {
      expect(FocusArea.energy.displayNameTr, 'Kıvılcım');
      expect(FocusArea.focus.displayNameTr, 'Mercek');
      expect(FocusArea.emotions.displayNameTr, 'Gelgit');
      expect(FocusArea.decisions.displayNameTr, 'Pusula');
      expect(FocusArea.social.displayNameTr, 'Yörünge');
    });

    test('subRatingKeys returns 3 keys per area', () {
      for (final area in FocusArea.values) {
        expect(area.subRatingKeys.length, 3);
      }
    });

    test('subRatingNamesEn keys match subRatingKeys', () {
      for (final area in FocusArea.values) {
        expect(
          area.subRatingNamesEn.keys.toSet(),
          area.subRatingKeys.toSet(),
        );
      }
    });

    test('subRatingNamesTr keys match subRatingKeys', () {
      for (final area in FocusArea.values) {
        expect(
          area.subRatingNamesTr.keys.toSet(),
          area.subRatingKeys.toSet(),
        );
      }
    });
  });

  group('JournalEntry', () {
    late JournalEntry entry;

    setUp(() {
      entry = JournalEntry(
        id: 'test-1',
        date: DateTime(2026, 2, 24),
        createdAt: DateTime(2026, 2, 24, 10, 30),
        focusArea: FocusArea.energy,
        overallRating: 4,
        subRatings: {'physical': 5, 'mental': 3, 'motivation': 4},
        note: 'Felt great today',
        imagePath: '/photos/day1.jpg',
      );
    });

    test('constructor sets all fields', () {
      expect(entry.id, 'test-1');
      expect(entry.date, DateTime(2026, 2, 24));
      expect(entry.focusArea, FocusArea.energy);
      expect(entry.overallRating, 4);
      expect(entry.subRatings['physical'], 5);
      expect(entry.note, 'Felt great today');
      expect(entry.imagePath, '/photos/day1.jpg');
    });

    test('defaults: subRatings empty, note null, imagePath null', () {
      final minimal = JournalEntry(
        id: 'min-1',
        date: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
        focusArea: FocusArea.focus,
        overallRating: 3,
      );
      expect(minimal.subRatings, isEmpty);
      expect(minimal.note, isNull);
      expect(minimal.imagePath, isNull);
    });

    test('dateKey produces yyyy-MM-dd format', () {
      expect(entry.dateKey, '2026-02-24');

      final janEntry = entry.copyWith(date: DateTime(2026, 1, 5));
      expect(janEntry.dateKey, '2026-01-05');
    });

    group('toJson', () {
      test('produces correct map', () {
        final json = entry.toJson();
        expect(json['id'], 'test-1');
        expect(json['focusArea'], 'energy');
        expect(json['overallRating'], 4);
        expect(json['subRatings'], {'physical': 5, 'mental': 3, 'motivation': 4});
        expect(json['note'], 'Felt great today');
        expect(json['imagePath'], '/photos/day1.jpg');
        expect(json['date'], contains('2026-02-24'));
        expect(json['createdAt'], contains('2026-02-24'));
      });

      test('includes null optional fields', () {
        final noNote = entry.copyWith(note: null);
        // copyWith doesn't clear note since it uses ?? operator
        // Creating fresh entry without note
        final fresh = JournalEntry(
          id: 'x',
          date: DateTime(2026, 1, 1),
          createdAt: DateTime(2026, 1, 1),
          focusArea: FocusArea.focus,
          overallRating: 3,
        );
        final json = fresh.toJson();
        expect(json['note'], isNull);
        expect(json['imagePath'], isNull);
      });
    });

    group('fromJson', () {
      test('reconstructs entry correctly', () {
        final json = {
          'id': 'from-json-1',
          'date': '2026-03-15T00:00:00.000',
          'createdAt': '2026-03-15T09:00:00.000',
          'focusArea': 'emotions',
          'overallRating': 5,
          'subRatings': {'mood': 4, 'stress': 2, 'calm': 5},
          'note': 'Peaceful day',
          'imagePath': null,
        };

        final restored = JournalEntry.fromJson(json);
        expect(restored.id, 'from-json-1');
        expect(restored.date.month, 3);
        expect(restored.date.day, 15);
        expect(restored.focusArea, FocusArea.emotions);
        expect(restored.overallRating, 5);
        expect(restored.subRatings['mood'], 4);
        expect(restored.note, 'Peaceful day');
        expect(restored.imagePath, isNull);
      });

      test('handles missing optional fields', () {
        final json = {
          'id': 'min-json',
          'date': '2026-01-01',
          'focusArea': 'focus',
          'overallRating': 3,
        };
        final restored = JournalEntry.fromJson(json);
        expect(restored.subRatings, isEmpty);
        expect(restored.note, isNull);
        expect(restored.imagePath, isNull);
      });

      test('defaults to energy for unknown focusArea', () {
        final json = {
          'id': 'bad-area',
          'date': '2026-01-01',
          'focusArea': 'nonexistent_area',
          'overallRating': 3,
        };
        final restored = JournalEntry.fromJson(json);
        expect(restored.focusArea, FocusArea.energy);
      });

      test('defaults overallRating to 3 when missing', () {
        final json = {
          'id': 'no-rating',
          'date': '2026-01-01',
          'focusArea': 'energy',
        };
        final restored = JournalEntry.fromJson(json);
        expect(restored.overallRating, 3);
      });

      test('handles subRatings with non-int values', () {
        final json = {
          'id': 'mixed-types',
          'date': '2026-01-01',
          'focusArea': 'energy',
          'overallRating': 4,
          'subRatings': {'physical': 5.0, 'mental': 3, 'motivation': 'not_a_number'},
        };
        final restored = JournalEntry.fromJson(json);
        expect(restored.subRatings['physical'], 5);
        expect(restored.subRatings['mental'], 3);
        expect(restored.subRatings['motivation'], 0);
      });

      test('defaults id to empty string when missing', () {
        final json = {
          'date': '2026-01-01',
          'focusArea': 'energy',
          'overallRating': 3,
        };
        final restored = JournalEntry.fromJson(json);
        expect(restored.id, '');
      });
    });

    group('round-trip', () {
      test('toJson then fromJson preserves data', () {
        final json = entry.toJson();
        final restored = JournalEntry.fromJson(json);

        expect(restored.id, entry.id);
        expect(restored.focusArea, entry.focusArea);
        expect(restored.overallRating, entry.overallRating);
        expect(restored.subRatings, entry.subRatings);
        expect(restored.note, entry.note);
        expect(restored.imagePath, entry.imagePath);
      });

      test('round-trip preserves all 5 focus areas', () {
        for (final area in FocusArea.values) {
          final e = entry.copyWith(focusArea: area);
          final restored = JournalEntry.fromJson(e.toJson());
          expect(restored.focusArea, area);
        }
      });
    });

    group('copyWith', () {
      test('creates new instance with changed fields', () {
        final updated = entry.copyWith(
          overallRating: 2,
          note: 'Updated note',
        );
        expect(updated.overallRating, 2);
        expect(updated.note, 'Updated note');
        // Unchanged fields preserved
        expect(updated.id, entry.id);
        expect(updated.focusArea, entry.focusArea);
        expect(updated.date, entry.date);
      });

      test('preserves original when no fields specified', () {
        final copy = entry.copyWith();
        expect(copy.id, entry.id);
        expect(copy.overallRating, entry.overallRating);
        expect(copy.note, entry.note);
      });
    });
  });
}
