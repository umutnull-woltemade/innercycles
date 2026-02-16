import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inner_cycles/data/services/dream_journal_service.dart';
import 'package:inner_cycles/data/models/dream_interpretation_models.dart';

void main() {
  late DreamJournalService service;

  setUp(() async {
    // Initialize mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    service = DreamJournalService(prefs);
  });

  group('DreamJournalService', () {
    group('CRUD Operations', () {
      test('saveDream saves a new dream entry', () async {
        final dream = DreamEntry(
          id: 'test-dream-1',
          dreamDate: DateTime.now(),
          recordedAt: DateTime.now(),
          title: 'Flying Dream',
          content: 'I was flying over mountains',
          dominantEmotion: EmotionalTone.huzur,
          moonPhase: MoonPhase.dolunay,
        );

        final saved = await service.saveDream(dream);

        expect(saved.id, 'test-dream-1');
        expect(saved.title, 'Flying Dream');
      });

      test('getDream retrieves a saved dream by ID', () async {
        final dream = DreamEntry(
          id: 'test-dream-2',
          dreamDate: DateTime.now(),
          recordedAt: DateTime.now(),
          title: 'Water Dream',
          content: 'I was swimming in the ocean',
          dominantEmotion: EmotionalTone.huzur,
          moonPhase: MoonPhase.yeniay,
        );

        await service.saveDream(dream);
        final retrieved = await service.getDream('test-dream-2');

        expect(retrieved, isNotNull);
        expect(retrieved!.title, 'Water Dream');
      });

      test('getDream returns null for non-existent ID', () async {
        final retrieved = await service.getDream('non-existent');
        expect(retrieved, isNull);
      });

      test('getAllDreams returns all saved dreams', () async {
        final dream1 = DreamEntry(
          id: 'dream-1',
          dreamDate: DateTime.now(),
          recordedAt: DateTime.now(),
          title: 'Dream 1',
          content: 'Content 1',
          dominantEmotion: EmotionalTone.merak,
          moonPhase: MoonPhase.ilkDordun,
        );

        final dream2 = DreamEntry(
          id: 'dream-2',
          dreamDate: DateTime.now(),
          recordedAt: DateTime.now(),
          title: 'Dream 2',
          content: 'Content 2',
          dominantEmotion: EmotionalTone.korku,
          moonPhase: MoonPhase.sonDordun,
        );

        await service.saveDream(dream1);
        await service.saveDream(dream2);

        final allDreams = await service.getAllDreams();
        expect(allDreams.length, 2);
      });

      test('saveDream updates existing dream with same ID', () async {
        final dream = DreamEntry(
          id: 'update-test',
          dreamDate: DateTime.now(),
          recordedAt: DateTime.now(),
          title: 'Original Title',
          content: 'Original content',
          dominantEmotion: EmotionalTone.merak,
          moonPhase: MoonPhase.dolunay,
        );

        await service.saveDream(dream);

        final updatedDream = DreamEntry(
          id: 'update-test',
          dreamDate: DateTime.now(),
          recordedAt: DateTime.now(),
          title: 'Updated Title',
          content: 'Updated content',
          dominantEmotion: EmotionalTone.huzur,
          moonPhase: MoonPhase.dolunay,
        );

        await service.saveDream(updatedDream);

        final allDreams = await service.getAllDreams();
        expect(allDreams.length, 1);
        expect(allDreams.first.title, 'Updated Title');
      });

      test('deleteDream removes a dream', () async {
        final dream = DreamEntry(
          id: 'delete-test',
          dreamDate: DateTime.now(),
          recordedAt: DateTime.now(),
          title: 'To Delete',
          content: 'Will be deleted',
          dominantEmotion: EmotionalTone.merak,
          moonPhase: MoonPhase.yeniay,
        );

        await service.saveDream(dream);
        await service.deleteDream('delete-test');

        final retrieved = await service.getDream('delete-test');
        expect(retrieved, isNull);
      });
    });

    group('Date Range Queries', () {
      test('getRecentDreams returns dreams from last N days', () async {
        final recentDream = DreamEntry(
          id: 'recent',
          dreamDate: DateTime.now().subtract(const Duration(days: 2)),
          recordedAt: DateTime.now(),
          title: 'Recent Dream',
          content: 'Recent content',
          dominantEmotion: EmotionalTone.merak,
          moonPhase: MoonPhase.dolunay,
        );

        final oldDream = DreamEntry(
          id: 'old',
          dreamDate: DateTime.now().subtract(const Duration(days: 30)),
          recordedAt: DateTime.now(),
          title: 'Old Dream',
          content: 'Old content',
          dominantEmotion: EmotionalTone.merak,
          moonPhase: MoonPhase.yeniay,
        );

        await service.saveDream(recentDream);
        await service.saveDream(oldDream);

        final recentDreams = await service.getRecentDreams(days: 7);
        expect(recentDreams.length, 1);
        expect(recentDreams.first.id, 'recent');
      });

      test('getDreamsByDateRange returns dreams within range', () async {
        final inRangeDream = DreamEntry(
          id: 'in-range',
          dreamDate: DateTime(2024, 1, 15),
          recordedAt: DateTime.now(),
          title: 'In Range',
          content: 'Content',
          dominantEmotion: EmotionalTone.merak,
          moonPhase: MoonPhase.dolunay,
        );

        final outOfRangeDream = DreamEntry(
          id: 'out-of-range',
          dreamDate: DateTime(2024, 2, 15),
          recordedAt: DateTime.now(),
          title: 'Out of Range',
          content: 'Content',
          dominantEmotion: EmotionalTone.merak,
          moonPhase: MoonPhase.yeniay,
        );

        await service.saveDream(inRangeDream);
        await service.saveDream(outOfRangeDream);

        final rangedDreams = await service.getDreamsByDateRange(
          DateTime(2024, 1, 1),
          DateTime(2024, 1, 31),
        );

        expect(rangedDreams.length, 1);
        expect(rangedDreams.first.id, 'in-range');
      });
    });

    group('DreamEntry Model', () {
      test('DreamEntry serializes to JSON correctly', () {
        final dream = DreamEntry(
          id: 'json-test',
          dreamDate: DateTime(2024, 1, 15, 3, 30),
          recordedAt: DateTime(2024, 1, 15, 8, 0),
          title: 'JSON Test Dream',
          content: 'Test content for JSON',
          detectedSymbols: ['water', 'flying'],
          userTags: ['recurring', 'vivid'],
          dominantEmotion: EmotionalTone.huzur,
          emotionalIntensity: 7,
          isRecurring: true,
          isLucid: false,
          isNightmare: false,
          moonPhase: MoonPhase.dolunay,
        );

        final json = dream.toJson();

        expect(json['id'], 'json-test');
        expect(json['title'], 'JSON Test Dream');
        expect(json['detectedSymbols'], ['water', 'flying']);
        expect(json['emotionalIntensity'], 7);
        expect(json['isRecurring'], true);
      });

      test('DreamEntry deserializes from JSON correctly', () {
        final json = {
          'id': 'deserialize-test',
          'dreamDate': '2024-01-15T03:30:00.000',
          'recordedAt': '2024-01-15T08:00:00.000',
          'title': 'Deserialized Dream',
          'content': 'Content from JSON',
          'detectedSymbols': ['moon', 'stars'],
          'userTags': [],
          'dominantEmotion': 'mutluluk',
          'emotionalIntensity': 8,
          'isRecurring': false,
          'isLucid': true,
          'isNightmare': false,
          'moonPhase': 'newMoon',
        };

        final dream = DreamEntry.fromJson(json);

        expect(dream.id, 'deserialize-test');
        expect(dream.title, 'Deserialized Dream');
        expect(dream.isLucid, true);
        expect(dream.emotionalIntensity, 8);
      });
    });
  });
}
