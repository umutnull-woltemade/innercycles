import 'package:flutter_test/flutter_test.dart';
import 'package:inner_cycles/data/models/life_event.dart';

void main() {
  group('LifeEventType', () {
    test('has 3 values', () {
      expect(LifeEventType.values.length, 3);
      expect(LifeEventType.values, contains(LifeEventType.positive));
      expect(LifeEventType.values, contains(LifeEventType.challenging));
      expect(LifeEventType.values, contains(LifeEventType.custom));
    });

    test('displayNameEn is non-empty', () {
      for (final type in LifeEventType.values) {
        expect(type.displayNameEn, isNotEmpty);
      }
    });

    test('displayNameTr is non-empty', () {
      for (final type in LifeEventType.values) {
        expect(type.displayNameTr, isNotEmpty);
      }
    });
  });

  group('LifeEvent', () {
    late LifeEvent event;

    setUp(() {
      event = LifeEvent(
        id: 'event-1',
        date: DateTime(2026, 2, 14),
        createdAt: DateTime(2026, 2, 14, 10, 0),
        type: LifeEventType.positive,
        eventKey: 'graduation',
        title: 'University Graduation',
        note: 'Finally done!',
        emotionTags: ['joy', 'relief', 'pride'],
        imagePath: '/photos/graduation.jpg',
        intensity: 5,
      );
    });

    test('constructor sets all fields', () {
      expect(event.id, 'event-1');
      expect(event.date, DateTime(2026, 2, 14));
      expect(event.type, LifeEventType.positive);
      expect(event.eventKey, 'graduation');
      expect(event.title, 'University Graduation');
      expect(event.note, 'Finally done!');
      expect(event.emotionTags, ['joy', 'relief', 'pride']);
      expect(event.imagePath, '/photos/graduation.jpg');
      expect(event.intensity, 5);
    });

    test('defaults: empty emotionTags, null optionals, intensity 3', () {
      final minimal = LifeEvent(
        id: 'min',
        date: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
        type: LifeEventType.custom,
        title: 'Something',
      );
      expect(minimal.emotionTags, isEmpty);
      expect(minimal.eventKey, isNull);
      expect(minimal.note, isNull);
      expect(minimal.imagePath, isNull);
      expect(minimal.intensity, 3);
    });

    test('dateKey produces yyyy-MM-dd format', () {
      expect(event.dateKey, '2026-02-14');
    });

    group('toJson', () {
      test('produces correct map', () {
        final json = event.toJson();
        expect(json['id'], 'event-1');
        expect(json['type'], 'positive');
        expect(json['eventKey'], 'graduation');
        expect(json['title'], 'University Graduation');
        expect(json['note'], 'Finally done!');
        expect(json['emotionTags'], ['joy', 'relief', 'pride']);
        expect(json['imagePath'], '/photos/graduation.jpg');
        expect(json['intensity'], 5);
        expect(json['date'], contains('2026-02-14'));
      });
    });

    group('fromJson', () {
      test('reconstructs event correctly', () {
        final json = {
          'id': 'from-1',
          'date': '2026-06-15T00:00:00.000',
          'createdAt': '2026-06-15T10:00:00.000',
          'type': 'challenging',
          'title': 'Job loss',
          'note': 'Unexpected',
          'emotionTags': ['shock', 'anxiety'],
          'intensity': 4,
        };
        final restored = LifeEvent.fromJson(json);
        expect(restored.id, 'from-1');
        expect(restored.type, LifeEventType.challenging);
        expect(restored.title, 'Job loss');
        expect(restored.emotionTags, ['shock', 'anxiety']);
        expect(restored.intensity, 4);
      });

      test('handles missing optional fields', () {
        final json = {
          'id': 'min',
          'date': '2026-01-01',
          'type': 'positive',
          'title': 'Event',
        };
        final restored = LifeEvent.fromJson(json);
        expect(restored.eventKey, isNull);
        expect(restored.note, isNull);
        expect(restored.emotionTags, isEmpty);
        expect(restored.imagePath, isNull);
        expect(restored.intensity, 3);
      });

      test('defaults to custom for unknown type', () {
        final json = {
          'id': 'x',
          'date': '2026-01-01',
          'type': 'unknown_type',
          'title': 'Weird',
        };
        final restored = LifeEvent.fromJson(json);
        expect(restored.type, LifeEventType.custom);
      });

      test('defaults id and title to empty strings when missing', () {
        final json = <String, dynamic>{
          'date': '2026-01-01',
          'type': 'positive',
        };
        final restored = LifeEvent.fromJson(json);
        expect(restored.id, '');
        expect(restored.title, '');
      });
    });

    group('round-trip', () {
      test('toJson then fromJson preserves data', () {
        final json = event.toJson();
        final restored = LifeEvent.fromJson(json);
        expect(restored.id, event.id);
        expect(restored.type, event.type);
        expect(restored.title, event.title);
        expect(restored.note, event.note);
        expect(restored.emotionTags, event.emotionTags);
        expect(restored.intensity, event.intensity);
      });

      test('round-trip preserves all event types', () {
        for (final type in LifeEventType.values) {
          final e = event.copyWith(type: type);
          final restored = LifeEvent.fromJson(e.toJson());
          expect(restored.type, type);
        }
      });
    });

    group('copyWith', () {
      test('updates specified fields', () {
        final updated = event.copyWith(
          title: 'New title',
          intensity: 1,
        );
        expect(updated.title, 'New title');
        expect(updated.intensity, 1);
        expect(updated.id, event.id);
        expect(updated.type, event.type);
      });
    });
  });
}
