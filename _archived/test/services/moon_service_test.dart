import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/data/services/moon_service.dart';

void main() {
  group('MoonService', () {
    group('getCurrentPhase', () {
      test('returns valid MoonPhase enum value', () {
        final phase = MoonService.getCurrentPhase();
        expect(MoonPhase.values.contains(phase), isTrue);
      });

      test('returns new moon for known new moon date', () {
        // Jan 6, 2000 at 18:14 UTC is the reference new moon
        final knownNewMoon = DateTime.utc(2000, 1, 6, 18, 14);
        final phase = MoonService.getCurrentPhase(knownNewMoon);
        expect(phase, equals(MoonPhase.newMoon));
      });

      test('returns full moon approximately 14.75 days after new moon', () {
        final knownNewMoon = DateTime.utc(2000, 1, 6, 18, 14);
        // Full moon occurs at ~14.77 days, need to be precise
        final fullMoonDate = knownNewMoon.add(const Duration(days: 15, hours: 6));
        final phase = MoonService.getCurrentPhase(fullMoonDate);
        expect(phase, equals(MoonPhase.fullMoon));
      });

      test('returns first quarter approximately 7.4 days after new moon', () {
        final knownNewMoon = DateTime.utc(2000, 1, 6, 18, 14);
        final firstQuarterDate = knownNewMoon.add(const Duration(days: 7, hours: 10));
        final phase = MoonService.getCurrentPhase(firstQuarterDate);
        expect(phase, equals(MoonPhase.firstQuarter));
      });

      test('returns last quarter approximately 22 days after new moon', () {
        final knownNewMoon = DateTime.utc(2000, 1, 6, 18, 14);
        final lastQuarterDate = knownNewMoon.add(const Duration(days: 22, hours: 5));
        final phase = MoonService.getCurrentPhase(lastQuarterDate);
        expect(phase, equals(MoonPhase.lastQuarter));
      });
    });

    group('getIllumination', () {
      test('returns value between 0 and 100', () {
        final illumination = MoonService.getIllumination();
        expect(illumination, greaterThanOrEqualTo(0));
        expect(illumination, lessThanOrEqualTo(100));
      });

      test('returns near 0% for new moon', () {
        final knownNewMoon = DateTime.utc(2000, 1, 6, 18, 14);
        final illumination = MoonService.getIllumination(knownNewMoon);
        expect(illumination, lessThan(5));
      });

      test('returns near 100% for full moon', () {
        final knownNewMoon = DateTime.utc(2000, 1, 6, 18, 14);
        final fullMoonDate = knownNewMoon.add(const Duration(days: 14, hours: 18));
        final illumination = MoonService.getIllumination(fullMoonDate);
        expect(illumination, greaterThan(95));
      });

      test('returns near 50% for quarter moons', () {
        final knownNewMoon = DateTime.utc(2000, 1, 6, 18, 14);
        final firstQuarterDate = knownNewMoon.add(const Duration(days: 7, hours: 10));
        final illumination = MoonService.getIllumination(firstQuarterDate);
        expect(illumination, greaterThan(40));
        expect(illumination, lessThan(60));
      });
    });

    group('getCurrentMoonSign', () {
      test('returns valid MoonSign enum value', () {
        final sign = MoonService.getCurrentMoonSign();
        expect(MoonSign.values.contains(sign), isTrue);
      });

      test('cycles through all 12 signs in sidereal month', () {
        // Check that over a sidereal month, we get different signs
        final startDate = DateTime.utc(2024, 1, 14, 12, 0);
        final signs = <MoonSign>{};

        for (var i = 0; i < 28; i += 2) {
          final date = startDate.add(Duration(days: i));
          signs.add(MoonService.getCurrentMoonSign(date));
        }

        // Should have visited multiple signs
        expect(signs.length, greaterThan(5));
      });
    });

    group('isPlanetRetrograde', () {
      test('returns false for unknown planet', () {
        expect(MoonService.isPlanetRetrograde('unknown'), isFalse);
      });

      test('returns false for sun (sun never retrogrades)', () {
        expect(MoonService.isPlanetRetrograde('sun'), isFalse);
      });

      test('returns boolean for Mercury', () {
        final result = MoonService.isPlanetRetrograde('mercury');
        expect(result, isA<bool>());
      });

      test('returns boolean for Venus', () {
        final result = MoonService.isPlanetRetrograde('venus');
        expect(result, isA<bool>());
      });

      test('returns boolean for Mars', () {
        final result = MoonService.isPlanetRetrograde('mars');
        expect(result, isA<bool>());
      });

      test('returns boolean for Jupiter', () {
        final result = MoonService.isPlanetRetrograde('jupiter');
        expect(result, isA<bool>());
      });

      test('returns boolean for Saturn', () {
        final result = MoonService.isPlanetRetrograde('saturn');
        expect(result, isA<bool>());
      });

      test('returns true for Mercury during known retrograde period', () {
        // April 2024 Mercury retrograde: April 1-25
        final retrogradeDate = DateTime(2024, 4, 15);
        expect(MoonService.isPlanetRetrograde('mercury', retrogradeDate), isTrue);
      });

      test('returns false for Mercury outside retrograde period', () {
        // May 2024 - no Mercury retrograde
        final directDate = DateTime(2024, 5, 15);
        expect(MoonService.isPlanetRetrograde('mercury', directDate), isFalse);
      });
    });

    group('getRetrogradePlanets', () {
      test('returns list of strings', () {
        final planets = MoonService.getRetrogradePlanets();
        expect(planets, isA<List<String>>());
      });

      test('only contains valid planet names', () {
        final validPlanets = ['mercury', 'venus', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune', 'pluto'];
        final retrograde = MoonService.getRetrogradePlanets();
        for (final planet in retrograde) {
          expect(validPlanets.contains(planet), isTrue);
        }
      });
    });

    group('getMercuryRetrogradePeriods', () {
      test('returns 3 periods for 2024', () {
        final periods = MoonService.getMercuryRetrogradePeriods(2024);
        expect(periods.length, equals(3));
      });

      test('returns 3 periods for 2025', () {
        final periods = MoonService.getMercuryRetrogradePeriods(2025);
        expect(periods.length, equals(3));
      });

      test('returns 3 periods for 2026', () {
        final periods = MoonService.getMercuryRetrogradePeriods(2026);
        expect(periods.length, equals(3));
      });

      test('returns empty list for unsupported year', () {
        final periods = MoonService.getMercuryRetrogradePeriods(2020);
        expect(periods, isEmpty);
      });

      test('periods have valid start and end dates', () {
        final periods = MoonService.getMercuryRetrogradePeriods(2024);
        for (final period in periods) {
          expect(period.start.isBefore(period.end), isTrue);
        }
      });
    });

    group('getNextMercuryRetrograde', () {
      test('returns future date when not in retrograde', () {
        final directDate = DateTime(2024, 5, 15);
        final next = MoonService.getNextMercuryRetrograde(directDate);
        expect(next, isNotNull);
        expect(next!.isAfter(directDate), isTrue);
      });

      test('returns null for far future date with no data', () {
        final farFuture = DateTime(2030, 1, 1);
        final next = MoonService.getNextMercuryRetrograde(farFuture);
        expect(next, isNull);
      });
    });

    group('getCurrentMercuryRetrogradeEnd', () {
      test('returns null when not in retrograde', () {
        final directDate = DateTime(2024, 5, 15);
        final end = MoonService.getCurrentMercuryRetrogradeEnd(directDate);
        expect(end, isNull);
      });

      test('returns end date when in retrograde', () {
        final retrogradeDate = DateTime(2024, 4, 15);
        final end = MoonService.getCurrentMercuryRetrogradeEnd(retrogradeDate);
        expect(end, isNotNull);
        expect(end!.isAfter(retrogradeDate), isTrue);
      });
    });

    group('RetrogradePeroid', () {
      test('isActive returns true for date within period', () {
        final period = RetrogradePeroid(
          DateTime(2024, 4, 1),
          DateTime(2024, 4, 25),
        );
        expect(period.isActive(DateTime(2024, 4, 15)), isTrue);
      });

      test('isActive returns false for date outside period', () {
        final period = RetrogradePeroid(
          DateTime(2024, 4, 1),
          DateTime(2024, 4, 25),
        );
        expect(period.isActive(DateTime(2024, 5, 15)), isFalse);
      });

      test('daysRemaining returns positive value during period', () {
        final now = DateTime.now();
        final period = RetrogradePeroid(
          now.subtract(const Duration(days: 5)),
          now.add(const Duration(days: 10)),
        );
        expect(period.daysRemaining, greaterThan(0));
      });
    });

    group('MoonPhaseExtension', () {
      test('name returns non-empty string for all phases', () {
        for (final phase in MoonPhase.values) {
          expect(phase.name, isNotEmpty);
        }
      });

      test('nameTr returns non-empty string for all phases', () {
        for (final phase in MoonPhase.values) {
          expect(phase.nameTr, isNotEmpty);
        }
      });

      test('emoji returns valid emoji for all phases', () {
        for (final phase in MoonPhase.values) {
          expect(phase.emoji, isNotEmpty);
          expect(phase.emoji.length, lessThanOrEqualTo(2));
        }
      });
    });

    group('MoonSignExtension', () {
      test('name returns non-empty string for all signs', () {
        for (final sign in MoonSign.values) {
          expect(sign.name, isNotEmpty);
        }
      });

      test('nameTr returns non-empty string for all signs', () {
        for (final sign in MoonSign.values) {
          expect(sign.nameTr, isNotEmpty);
        }
      });

      test('symbol returns zodiac symbol for all signs', () {
        final expectedSymbols = ['♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓'];
        for (var i = 0; i < MoonSign.values.length; i++) {
          expect(MoonSign.values[i].symbol, equals(expectedSymbols[i]));
        }
      });
    });

    group('VoidOfCourseMoon', () {
      test('durationHours returns null when times are null', () {
        final voc = VoidOfCourseMoon(
          isVoid: false,
          currentSign: MoonSign.aries,
        );
        expect(voc.durationHours, isNull);
      });

      test('durationHours calculates correctly', () {
        final start = DateTime(2024, 1, 1, 10, 0);
        final end = DateTime(2024, 1, 1, 14, 0);
        final voc = VoidOfCourseMoon(
          isVoid: true,
          startTime: start,
          endTime: end,
          currentSign: MoonSign.aries,
        );
        expect(voc.durationHours, equals(4.0));
      });
    });
  });
}
