import 'package:flutter_test/flutter_test.dart';
import 'package:inner_cycles/data/services/dream_journal_service.dart';
import 'package:inner_cycles/data/models/dream_interpretation_models.dart';

void main() {
  group('EmotionalTone', () {
    test('has 8 values', () {
      expect(EmotionalTone.values.length, 8);
    });

    test('each value has non-empty label and emoji', () {
      for (final tone in EmotionalTone.values) {
        expect(tone.label, isNotEmpty);
        expect(tone.emoji, isNotEmpty);
      }
    });
  });

  group('MoonPhase', () {
    test('has 6 values', () {
      expect(MoonPhase.values.length, 6);
    });

    test('each value has non-empty label and emoji', () {
      for (final phase in MoonPhase.values) {
        expect(phase.label, isNotEmpty);
        expect(phase.emoji, isNotEmpty);
      }
    });
  });

  group('DreamRole', () {
    test('has expected values', () {
      expect(DreamRole.values.length, 7);
    });

    test('each role has label and emoji', () {
      for (final role in DreamRole.values) {
        expect(role.label, isNotEmpty);
        expect(role.emoji, isNotEmpty);
      }
    });
  });

  group('TimeLayer', () {
    test('has 4 values', () {
      expect(TimeLayer.values.length, 4);
    });

    test('each layer has label and emoji', () {
      for (final layer in TimeLayer.values) {
        expect(layer.label, isNotEmpty);
        expect(layer.emoji, isNotEmpty);
      }
    });
  });

  group('DreamEntry', () {
    late DreamEntry entry;

    setUp(() {
      entry = DreamEntry(
        id: 'dream-1',
        dreamDate: DateTime(2026, 2, 24),
        recordedAt: DateTime(2026, 2, 24, 8, 30),
        title: 'Flying over mountains',
        content: 'I was soaring above snow-covered peaks',
        detectedSymbols: ['mountain', 'flying', 'snow'],
        userTags: ['lucid', 'vivid'],
        dominantEmotion: EmotionalTone.heyecan,
        emotionalIntensity: 8,
        isRecurring: false,
        isLucid: true,
        isNightmare: false,
        moonPhase: MoonPhase.dolunay,
        characters: ['a stranger', 'my mother'],
        locations: ['mountain top', 'clouds'],
        clarity: 9,
        sleepQuality: 'good',
      );
    });

    test('constructor sets all fields', () {
      expect(entry.id, 'dream-1');
      expect(entry.title, 'Flying over mountains');
      expect(entry.content, contains('soaring'));
      expect(entry.detectedSymbols, ['mountain', 'flying', 'snow']);
      expect(entry.userTags, ['lucid', 'vivid']);
      expect(entry.dominantEmotion, EmotionalTone.heyecan);
      expect(entry.emotionalIntensity, 8);
      expect(entry.isLucid, true);
      expect(entry.isNightmare, false);
      expect(entry.moonPhase, MoonPhase.dolunay);
      expect(entry.characters, ['a stranger', 'my mother']);
      expect(entry.locations, ['mountain top', 'clouds']);
      expect(entry.clarity, 9);
      expect(entry.sleepQuality, 'good');
    });

    test('defaults: empty lists and null optionals', () {
      final minimal = DreamEntry(
        id: 'min-1',
        dreamDate: DateTime(2026, 1, 1),
        recordedAt: DateTime(2026, 1, 1),
        title: 'Simple dream',
        content: 'Nothing special',
        dominantEmotion: EmotionalTone.merak,
        moonPhase: MoonPhase.yeniay,
      );
      expect(minimal.detectedSymbols, isEmpty);
      expect(minimal.userTags, isEmpty);
      expect(minimal.emotionalIntensity, 5);
      expect(minimal.isRecurring, false);
      expect(minimal.isLucid, false);
      expect(minimal.isNightmare, false);
      expect(minimal.interpretation, isNull);
      expect(minimal.voiceRecordingPath, isNull);
      expect(minimal.imageUrls, isNull);
      expect(minimal.metadata, isNull);
      expect(minimal.characters, isNull);
      expect(minimal.locations, isNull);
      expect(minimal.clarity, isNull);
      expect(minimal.sleepQuality, isNull);
      expect(minimal.sleepDuration, isNull);
    });

    group('toJson', () {
      test('produces correct map with all fields', () {
        final json = entry.toJson();
        expect(json['id'], 'dream-1');
        expect(json['title'], 'Flying over mountains');
        expect(json['dominantEmotion'], 'heyecan');
        expect(json['emotionalIntensity'], 8);
        expect(json['isLucid'], true);
        expect(json['isNightmare'], false);
        expect(json['moonPhase'], 'dolunay');
        expect(json['detectedSymbols'], ['mountain', 'flying', 'snow']);
        expect(json['userTags'], ['lucid', 'vivid']);
        expect(json['characters'], ['a stranger', 'my mother']);
        expect(json['locations'], ['mountain top', 'clouds']);
        expect(json['clarity'], 9);
        expect(json['sleepQuality'], 'good');
        expect(json['dreamDate'], contains('2026-02-24'));
        expect(json['recordedAt'], contains('2026-02-24'));
      });

      test('null optionals appear as null in JSON', () {
        final minimal = DreamEntry(
          id: 'min',
          dreamDate: DateTime(2026, 1, 1),
          recordedAt: DateTime(2026, 1, 1),
          title: 't',
          content: 'c',
          dominantEmotion: EmotionalTone.merak,
          moonPhase: MoonPhase.yeniay,
        );
        final json = minimal.toJson();
        expect(json['interpretation'], isNull);
        expect(json['voiceRecordingPath'], isNull);
        expect(json['characters'], isNull);
        expect(json['locations'], isNull);
        expect(json['clarity'], isNull);
        expect(json['sleepQuality'], isNull);
        expect(json['sleepDuration'], isNull);
      });

      test('sleepDuration serializes as minutes', () {
        final withSleep = entry.copyWith(
          sleepDuration: const Duration(hours: 7, minutes: 30),
        );
        final json = withSleep.toJson();
        expect(json['sleepDuration'], 450); // 7*60 + 30
      });
    });

    group('fromJson', () {
      test('reconstructs entry from full JSON', () {
        final json = {
          'id': 'restored-1',
          'dreamDate': '2026-03-10T00:00:00.000',
          'recordedAt': '2026-03-10T07:15:00.000',
          'title': 'Ocean dream',
          'content': 'I was swimming in deep water',
          'detectedSymbols': ['ocean', 'water'],
          'userTags': ['recurring'],
          'dominantEmotion': 'huzur',
          'emotionalIntensity': 7,
          'isRecurring': true,
          'isLucid': false,
          'isNightmare': false,
          'moonPhase': 'hilal',
          'clarity': 6,
          'sleepQuality': 'excellent',
          'characters': ['fish'],
          'locations': ['deep ocean'],
        };

        final restored = DreamEntry.fromJson(json);
        expect(restored.id, 'restored-1');
        expect(restored.title, 'Ocean dream');
        expect(restored.dominantEmotion, EmotionalTone.huzur);
        expect(restored.moonPhase, MoonPhase.hilal);
        expect(restored.isRecurring, true);
        expect(restored.emotionalIntensity, 7);
        expect(restored.detectedSymbols, ['ocean', 'water']);
        expect(restored.clarity, 6);
        expect(restored.characters, ['fish']);
        expect(restored.locations, ['deep ocean']);
      });

      test('handles missing optional fields', () {
        final json = {
          'id': 'minimal',
          'dreamDate': '2026-01-01',
          'recordedAt': '2026-01-01',
          'title': 'Short',
          'content': 'Brief',
          'dominantEmotion': 'korku',
          'moonPhase': 'yeniay',
        };
        final restored = DreamEntry.fromJson(json);
        expect(restored.detectedSymbols, isEmpty);
        expect(restored.userTags, isEmpty);
        expect(restored.emotionalIntensity, 5);
        expect(restored.interpretation, isNull);
        expect(restored.characters, isNull);
        expect(restored.locations, isNull);
      });

      test('defaults to merak for unknown emotion', () {
        final json = {
          'id': 'x',
          'dreamDate': '2026-01-01',
          'recordedAt': '2026-01-01',
          'title': 't',
          'content': 'c',
          'dominantEmotion': 'nonexistent_emotion',
          'moonPhase': 'yeniay',
        };
        final restored = DreamEntry.fromJson(json);
        expect(restored.dominantEmotion, EmotionalTone.merak);
      });

      test('handles sleepDuration from minutes', () {
        final json = {
          'id': 'sleep-1',
          'dreamDate': '2026-01-01',
          'recordedAt': '2026-01-01',
          'title': 't',
          'content': 'c',
          'dominantEmotion': 'huzur',
          'moonPhase': 'dolunay',
          'sleepDuration': 480, // 8 hours
        };
        final restored = DreamEntry.fromJson(json);
        expect(restored.sleepDuration, const Duration(minutes: 480));
      });

      test('defaults to empty strings for missing id/title/content', () {
        final json = <String, dynamic>{
          'dreamDate': '2026-01-01',
          'recordedAt': '2026-01-01',
          'dominantEmotion': 'merak',
          'moonPhase': 'yeniay',
        };
        final restored = DreamEntry.fromJson(json);
        expect(restored.id, '');
        expect(restored.title, '');
        expect(restored.content, '');
      });
    });

    group('round-trip', () {
      test('toJson then fromJson preserves key data', () {
        final json = entry.toJson();
        final restored = DreamEntry.fromJson(json);

        expect(restored.id, entry.id);
        expect(restored.title, entry.title);
        expect(restored.content, entry.content);
        expect(restored.dominantEmotion, entry.dominantEmotion);
        expect(restored.emotionalIntensity, entry.emotionalIntensity);
        expect(restored.isLucid, entry.isLucid);
        expect(restored.isNightmare, entry.isNightmare);
        expect(restored.moonPhase, entry.moonPhase);
        expect(restored.detectedSymbols, entry.detectedSymbols);
        expect(restored.characters, entry.characters);
        expect(restored.locations, entry.locations);
        expect(restored.clarity, entry.clarity);
        expect(restored.sleepQuality, entry.sleepQuality);
      });

      test('round-trip preserves all emotions', () {
        for (final emotion in EmotionalTone.values) {
          final e = entry.copyWith(dominantEmotion: emotion);
          final restored = DreamEntry.fromJson(e.toJson());
          expect(restored.dominantEmotion, emotion);
        }
      });

      test('round-trip preserves all moon phases', () {
        for (final phase in MoonPhase.values) {
          final e = entry.copyWith(moonPhase: phase);
          final restored = DreamEntry.fromJson(e.toJson());
          expect(restored.moonPhase, phase);
        }
      });
    });

    group('copyWith', () {
      test('updates specified fields only', () {
        final updated = entry.copyWith(
          title: 'New title',
          isNightmare: true,
          emotionalIntensity: 10,
        );
        expect(updated.title, 'New title');
        expect(updated.isNightmare, true);
        expect(updated.emotionalIntensity, 10);
        // Unchanged
        expect(updated.id, entry.id);
        expect(updated.dominantEmotion, entry.dominantEmotion);
        expect(updated.content, entry.content);
      });
    });
  });
}
