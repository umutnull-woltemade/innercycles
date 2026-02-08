import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/data/services/feature_flag_service.dart';

void main() {
  group('FeatureFlag Model', () {
    group('fromJson', () {
      test('parses complete JSON correctly', () {
        final json = {
          'id': 'flag-123',
          'name': 'test_feature',
          'description': 'A test feature flag',
          'is_enabled': true,
          'rollout_percentage': 50,
          'target_platforms': ['ios', 'android'],
          'target_versions': ['1.0.0', '2.0.0'],
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-15T12:30:00.000Z',
        };

        final flag = FeatureFlag.fromJson(json);

        expect(flag.id, equals('flag-123'));
        expect(flag.name, equals('test_feature'));
        expect(flag.description, equals('A test feature flag'));
        expect(flag.isEnabled, isTrue);
        expect(flag.rolloutPercentage, equals(50));
        expect(flag.targetPlatforms, equals(['ios', 'android']));
        expect(flag.targetVersions, equals(['1.0.0', '2.0.0']));
        expect(flag.createdAt, equals(DateTime.utc(2024, 1, 1)));
        expect(flag.updatedAt, equals(DateTime.utc(2024, 1, 15, 12, 30)));
      });

      test('handles minimal JSON with defaults', () {
        final json = {
          'id': 'flag-456',
          'name': 'minimal_flag',
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-01T00:00:00.000Z',
        };

        final flag = FeatureFlag.fromJson(json);

        expect(flag.id, equals('flag-456'));
        expect(flag.name, equals('minimal_flag'));
        expect(flag.description, isNull);
        expect(flag.isEnabled, isFalse); // Default
        expect(flag.rolloutPercentage, equals(100)); // Default
        expect(flag.targetPlatforms, isEmpty);
        expect(flag.targetVersions, isNull);
      });

      test('handles null target_platforms', () {
        final json = {
          'id': 'flag-789',
          'name': 'no_platforms',
          'is_enabled': true,
          'target_platforms': null,
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-01T00:00:00.000Z',
        };

        final flag = FeatureFlag.fromJson(json);
        expect(flag.targetPlatforms, isEmpty);
      });

      test('handles null is_enabled', () {
        final json = {
          'id': 'flag-abc',
          'name': 'null_enabled',
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-01T00:00:00.000Z',
        };

        final flag = FeatureFlag.fromJson(json);
        expect(flag.isEnabled, isFalse);
      });
    });

    group('toJson', () {
      test('serializes all fields correctly', () {
        final flag = FeatureFlag(
          id: 'flag-123',
          name: 'test_feature',
          description: 'Test description',
          isEnabled: true,
          rolloutPercentage: 75,
          targetPlatforms: ['web', 'ios'],
          targetVersions: ['2.0.0'],
          createdAt: DateTime.utc(2024, 1, 1),
          updatedAt: DateTime.utc(2024, 1, 15),
        );

        final json = flag.toJson();

        expect(json['id'], equals('flag-123'));
        expect(json['name'], equals('test_feature'));
        expect(json['description'], equals('Test description'));
        expect(json['is_enabled'], isTrue);
        expect(json['rollout_percentage'], equals(75));
        expect(json['target_platforms'], equals(['web', 'ios']));
        expect(json['target_versions'], equals(['2.0.0']));
        expect(json['created_at'], equals('2024-01-01T00:00:00.000Z'));
        expect(json['updated_at'], equals('2024-01-15T00:00:00.000Z'));
      });

      test('handles null optional fields', () {
        final flag = FeatureFlag(
          id: 'flag-456',
          name: 'minimal',
          isEnabled: false,
          createdAt: DateTime.utc(2024, 1, 1),
          updatedAt: DateTime.utc(2024, 1, 1),
        );

        final json = flag.toJson();

        expect(json['description'], isNull);
        expect(json['target_versions'], isNull);
        expect(json['target_platforms'], isEmpty);
      });
    });

    group('round trip', () {
      test('fromJson and toJson are inverse operations', () {
        final original = FeatureFlag(
          id: 'roundtrip-1',
          name: 'roundtrip_test',
          description: 'Testing round trip',
          isEnabled: true,
          rolloutPercentage: 50,
          targetPlatforms: ['ios', 'android', 'web'],
          targetVersions: ['1.5.0', '2.0.0'],
          createdAt: DateTime.utc(2024, 6, 15, 10, 30),
          updatedAt: DateTime.utc(2024, 6, 20, 14, 45),
        );

        final json = original.toJson();
        final restored = FeatureFlag.fromJson(json);

        expect(restored.id, equals(original.id));
        expect(restored.name, equals(original.name));
        expect(restored.description, equals(original.description));
        expect(restored.isEnabled, equals(original.isEnabled));
        expect(restored.rolloutPercentage, equals(original.rolloutPercentage));
        expect(restored.targetPlatforms, equals(original.targetPlatforms));
        expect(restored.targetVersions, equals(original.targetVersions));
        expect(restored.createdAt, equals(original.createdAt));
        expect(restored.updatedAt, equals(original.updatedAt));
      });
    });
  });

  group('FeatureFlagService Constants', () {
    test('predefined flag names are not empty', () {
      expect(FeatureFlagService.flagDreamJournal, isNotEmpty);
      expect(FeatureFlagService.flagPremiumFeatures, isNotEmpty);
      expect(FeatureFlagService.flagNewOnboarding, isNotEmpty);
      expect(FeatureFlagService.flagAdvancedAstrology, isNotEmpty);
      expect(FeatureFlagService.flagSocialSharing, isNotEmpty);
    });

    test('predefined flag names are unique', () {
      final flags = [
        FeatureFlagService.flagDreamJournal,
        FeatureFlagService.flagPremiumFeatures,
        FeatureFlagService.flagNewOnboarding,
        FeatureFlagService.flagAdvancedAstrology,
        FeatureFlagService.flagSocialSharing,
      ];

      expect(flags.toSet().length, equals(flags.length));
    });
  });
}
