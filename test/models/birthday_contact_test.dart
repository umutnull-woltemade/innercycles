import 'package:flutter_test/flutter_test.dart';
import 'package:inner_cycles/data/models/birthday_contact.dart';

void main() {
  group('BirthdayRelationship', () {
    test('has 6 values', () {
      expect(BirthdayRelationship.values.length, 6);
    });

    test('each has displayNameEn and displayNameTr', () {
      for (final rel in BirthdayRelationship.values) {
        expect(rel.displayNameEn, isNotEmpty);
        expect(rel.displayNameTr, isNotEmpty);
      }
    });

    test('each has an emoji', () {
      for (final rel in BirthdayRelationship.values) {
        expect(rel.emoji, isNotEmpty);
      }
    });
  });

  group('BirthdayContactSource', () {
    test('has 2 values', () {
      expect(BirthdayContactSource.values.length, 2);
      expect(BirthdayContactSource.values, contains(BirthdayContactSource.manual));
      expect(BirthdayContactSource.values, contains(BirthdayContactSource.facebook));
    });

    test('each has display names', () {
      for (final src in BirthdayContactSource.values) {
        expect(src.displayNameEn, isNotEmpty);
        expect(src.displayNameTr, isNotEmpty);
      }
    });
  });

  group('BirthdayContact', () {
    late BirthdayContact contact;

    setUp(() {
      contact = BirthdayContact(
        id: 'bday-1',
        name: 'Jane Doe',
        birthdayMonth: 3,
        birthdayDay: 15,
        birthYear: 1990,
        createdAt: DateTime(2026, 2, 24),
        relationship: BirthdayRelationship.friend,
        note: 'College friend',
        source: BirthdayContactSource.manual,
        notificationsEnabled: true,
        dayBeforeReminder: true,
      );
    });

    test('constructor sets all fields', () {
      expect(contact.id, 'bday-1');
      expect(contact.name, 'Jane Doe');
      expect(contact.birthdayMonth, 3);
      expect(contact.birthdayDay, 15);
      expect(contact.birthYear, 1990);
      expect(contact.relationship, BirthdayRelationship.friend);
      expect(contact.note, 'College friend');
      expect(contact.notificationsEnabled, true);
    });

    test('defaults: friend, manual, notifications on', () {
      final minimal = BirthdayContact(
        id: 'min',
        name: 'John',
        birthdayMonth: 7,
        birthdayDay: 4,
        createdAt: DateTime(2026, 1, 1),
      );
      expect(minimal.relationship, BirthdayRelationship.friend);
      expect(minimal.source, BirthdayContactSource.manual);
      expect(minimal.notificationsEnabled, true);
      expect(minimal.dayBeforeReminder, true);
      expect(minimal.birthYear, isNull);
      expect(minimal.photoPath, isNull);
      expect(minimal.avatarEmoji, isNull);
      expect(minimal.note, isNull);
    });

    test('birthdayDateKey returns MM-dd format', () {
      expect(contact.birthdayDateKey, '03-15');

      final jan = contact.copyWith(birthdayMonth: 1, birthdayDay: 5);
      expect(jan.birthdayDateKey, '01-05');

      final dec = contact.copyWith(birthdayMonth: 12, birthdayDay: 31);
      expect(dec.birthdayDateKey, '12-31');
    });

    test('initials returns first letters of name parts', () {
      expect(contact.initials, 'JD');

      final singleName = contact.copyWith(name: 'Madonna');
      expect(singleName.initials, 'M');

      final threeName = contact.copyWith(name: 'Jean Claude Van');
      expect(threeName.initials, 'JC');
    });

    test('age returns correct age when birthYear present', () {
      // Contact born in 1990, test date is 2026
      // Age depends on whether birthday has passed relative to now
      final age = contact.age;
      expect(age, isNotNull);
      expect(age, greaterThanOrEqualTo(35));
      expect(age, lessThanOrEqualTo(36));
    });

    test('age returns null when birthYear is null', () {
      final noYear = contact.copyWith(birthYear: null);
      expect(noYear.age, isNull);
    });

    test('daysUntilBirthday is between 0 and 365', () {
      expect(contact.daysUntilBirthday, greaterThanOrEqualTo(0));
      expect(contact.daysUntilBirthday, lessThanOrEqualTo(365));
    });

    group('toJson', () {
      test('produces correct map', () {
        final json = contact.toJson();
        expect(json['id'], 'bday-1');
        expect(json['name'], 'Jane Doe');
        expect(json['birthdayMonth'], 3);
        expect(json['birthdayDay'], 15);
        expect(json['birthYear'], 1990);
        expect(json['relationship'], 'friend');
        expect(json['note'], 'College friend');
        expect(json['source'], 'manual');
        expect(json['notificationsEnabled'], true);
        expect(json['dayBeforeReminder'], true);
        expect(json['createdAt'], contains('2026-02-24'));
      });

      test('birthYear null when not provided', () {
        final noYear = BirthdayContact(
          id: 'x',
          name: 'Y',
          birthdayMonth: 1,
          birthdayDay: 1,
          createdAt: DateTime(2026, 1, 1),
        );
        final json = noYear.toJson();
        expect(json['birthYear'], isNull);
      });
    });

    group('fromJson', () {
      test('reconstructs contact correctly', () {
        final json = {
          'id': 'from-1',
          'name': 'Ali Veli',
          'birthdayMonth': 11,
          'birthdayDay': 23,
          'birthYear': 1985,
          'createdAt': '2026-02-20T10:00:00.000',
          'relationship': 'family',
          'note': 'Brother',
          'source': 'facebook',
          'notificationsEnabled': false,
          'dayBeforeReminder': false,
        };
        final restored = BirthdayContact.fromJson(json);
        expect(restored.id, 'from-1');
        expect(restored.name, 'Ali Veli');
        expect(restored.birthdayMonth, 11);
        expect(restored.birthdayDay, 23);
        expect(restored.birthYear, 1985);
        expect(restored.relationship, BirthdayRelationship.family);
        expect(restored.source, BirthdayContactSource.facebook);
        expect(restored.notificationsEnabled, false);
        expect(restored.dayBeforeReminder, false);
      });

      test('handles missing optional fields', () {
        final json = {
          'id': 'min',
          'name': 'Test',
          'birthdayMonth': 6,
          'birthdayDay': 10,
        };
        final restored = BirthdayContact.fromJson(json);
        expect(restored.birthYear, isNull);
        expect(restored.photoPath, isNull);
        expect(restored.avatarEmoji, isNull);
        expect(restored.note, isNull);
        expect(restored.relationship, BirthdayRelationship.friend);
        expect(restored.source, BirthdayContactSource.manual);
        expect(restored.notificationsEnabled, true);
      });

      test('defaults to friend for unknown relationship', () {
        final json = {
          'id': 'x',
          'name': 'Y',
          'birthdayMonth': 1,
          'birthdayDay': 1,
          'relationship': 'alien',
        };
        final restored = BirthdayContact.fromJson(json);
        expect(restored.relationship, BirthdayRelationship.friend);
      });

      test('defaults birthdayMonth to 1 and birthdayDay to 1 when missing', () {
        final json = {
          'id': 'x',
          'name': 'Y',
        };
        final restored = BirthdayContact.fromJson(json);
        expect(restored.birthdayMonth, 1);
        expect(restored.birthdayDay, 1);
      });
    });

    group('round-trip', () {
      test('toJson then fromJson preserves data', () {
        final json = contact.toJson();
        final restored = BirthdayContact.fromJson(json);
        expect(restored.id, contact.id);
        expect(restored.name, contact.name);
        expect(restored.birthdayMonth, contact.birthdayMonth);
        expect(restored.birthdayDay, contact.birthdayDay);
        expect(restored.birthYear, contact.birthYear);
        expect(restored.relationship, contact.relationship);
        expect(restored.note, contact.note);
        expect(restored.source, contact.source);
        expect(restored.notificationsEnabled, contact.notificationsEnabled);
      });

      test('round-trip preserves all relationships', () {
        for (final rel in BirthdayRelationship.values) {
          final c = contact.copyWith(relationship: rel);
          final restored = BirthdayContact.fromJson(c.toJson());
          expect(restored.relationship, rel);
        }
      });

      test('round-trip preserves all sources', () {
        for (final src in BirthdayContactSource.values) {
          final c = contact.copyWith(source: src);
          final restored = BirthdayContact.fromJson(c.toJson());
          expect(restored.source, src);
        }
      });
    });

    group('copyWith', () {
      test('updates specified fields', () {
        final updated = contact.copyWith(
          name: 'Jane Smith',
          relationship: BirthdayRelationship.partner,
          notificationsEnabled: false,
        );
        expect(updated.name, 'Jane Smith');
        expect(updated.relationship, BirthdayRelationship.partner);
        expect(updated.notificationsEnabled, false);
        // Unchanged
        expect(updated.id, contact.id);
        expect(updated.birthdayMonth, contact.birthdayMonth);
        expect(updated.birthdayDay, contact.birthdayDay);
      });
    });
  });
}
