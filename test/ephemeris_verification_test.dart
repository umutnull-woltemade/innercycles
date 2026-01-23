import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/data/services/ephemeris_service.dart';
import 'package:astrology_app/data/models/natal_chart.dart';
import 'package:astrology_app/data/models/zodiac_sign.dart';

void main() {
  group('Ephemeris Verification', () {
    test('December 15, 1999 should be Sagittarius', () {
      // December 15, 1999 at 12:00 in Antalya, Turkey
      final birthData = BirthData(
        date: DateTime(1999, 12, 15),
        time: '12:00',
        latitude: 36.8969, // Antalya
        longitude: 30.7133,
        placeName: 'Antalya, Turkey',
      );

      final chart = EphemerisService.calculateNatalChart(birthData);

      // Sun longitude for Dec 15, 1999 should be around 263° (Sagittarius)
      // Sagittarius is 240-270°
      print('Sun longitude: ${chart.sun?.longitude}');
      print('Sun sign: ${chart.sunSign}');
      print('Sun sign name: ${chart.sunSign.nameTr}');
      print('Sun degree: ${chart.sun?.degree}°');

      // Verify the calculation
      expect(chart.sun, isNotNull, reason: 'Sun position should be calculated');
      expect(chart.sun!.longitude, greaterThanOrEqualTo(240),
          reason: 'Sun longitude should be in Sagittarius range (240-270°)');
      expect(chart.sun!.longitude, lessThan(270),
          reason: 'Sun longitude should be in Sagittarius range (240-270°)');
      expect(chart.sunSign, equals(ZodiacSign.sagittarius),
          reason: 'Sun sign should be Sagittarius for Dec 15 birthdate');
    });

    test('June 25, 2000 should be Cancer', () {
      // June 25, 2000 - Cancer period (June 21 - July 22)
      final birthData = BirthData(
        date: DateTime(2000, 6, 25),
        time: '12:00',
        latitude: 36.8969,
        longitude: 30.7133,
        placeName: 'Antalya, Turkey',
      );

      final chart = EphemerisService.calculateNatalChart(birthData);

      print('Sun longitude for June 25: ${chart.sun?.longitude}');
      print('Sun sign: ${chart.sunSign}');

      // Cancer is 90-120°
      expect(chart.sun!.longitude, greaterThanOrEqualTo(90));
      expect(chart.sun!.longitude, lessThan(120));
      expect(chart.sunSign, equals(ZodiacSign.cancer));
    });

    test('Zodiac sign boundaries are correct', () {
      // Test each sign's starting degree
      final signTests = [
        (ZodiacSign.aries, 0.0),
        (ZodiacSign.taurus, 30.0),
        (ZodiacSign.gemini, 60.0),
        (ZodiacSign.cancer, 90.0),
        (ZodiacSign.leo, 120.0),
        (ZodiacSign.virgo, 150.0),
        (ZodiacSign.libra, 180.0),
        (ZodiacSign.scorpio, 210.0),
        (ZodiacSign.sagittarius, 240.0),
        (ZodiacSign.capricorn, 270.0),
        (ZodiacSign.aquarius, 300.0),
        (ZodiacSign.pisces, 330.0),
      ];

      for (final (sign, startDegree) in signTests) {
        final signIndex = (startDegree / 30).floor() % 12;
        expect(ZodiacSign.values[signIndex], equals(sign),
            reason: '$sign should start at ${startDegree}°');
      }
    });
  });
}
