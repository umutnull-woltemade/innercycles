import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:astrology_app/features/compatibility/presentation/composite_chart_screen.dart';
import 'package:astrology_app/features/vedic/presentation/vedic_chart_screen.dart';
import 'package:astrology_app/features/predictive/presentation/progressions_screen.dart';
import 'package:astrology_app/features/saturn_return/presentation/saturn_return_screen.dart';
import 'package:astrology_app/features/solar_return/presentation/solar_return_screen.dart';
import 'package:astrology_app/features/year_ahead/presentation/year_ahead_screen.dart';
import 'package:astrology_app/features/timing/presentation/timing_screen.dart';
import 'package:astrology_app/features/timing/presentation/void_of_course_screen.dart';
import 'package:astrology_app/features/synastry/presentation/synastry_screen.dart';
import 'package:astrology_app/features/astrocartography/presentation/astrocartography_screen.dart';
import 'package:astrology_app/features/electional/presentation/electional_screen.dart';
import 'package:astrology_app/features/draconic/presentation/draconic_chart_screen.dart';
import 'package:astrology_app/features/asteroids/presentation/asteroids_screen.dart';
import 'package:astrology_app/features/local_space/presentation/local_space_screen.dart';
import 'package:astrology_app/features/transits/presentation/transit_calendar_screen.dart';
import 'package:astrology_app/features/kabbalah/presentation/kabbalah_screen.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('Advanced Astrology Screens', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('CompositeChartScreen renders scaffold', (tester) async {
    await tester.pumpApp(const CompositeChartScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('VedicChartScreen renders scaffold', (tester) async {
    await tester.pumpApp(const VedicChartScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('ProgressionsScreen renders scaffold', (tester) async {
    await tester.pumpApp(const ProgressionsScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('SaturnReturnScreen renders scaffold', (tester) async {
    await tester.pumpApp(const SaturnReturnScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('SolarReturnScreen renders scaffold', (tester) async {
    await tester.pumpApp(const SolarReturnScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('YearAheadScreen renders scaffold', (tester) async {
    await tester.pumpApp(const YearAheadScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('TimingScreen renders scaffold', (tester) async {
    await tester.pumpApp(const TimingScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('VoidOfCourseScreen renders scaffold', (tester) async {
    await tester.pumpApp(const VoidOfCourseScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('SynastryScreen renders scaffold', (tester) async {
    await tester.pumpApp(const SynastryScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('AstroCartographyScreen renders scaffold', (tester) async {
    await tester.pumpApp(const AstroCartographyScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('ElectionalScreen renders scaffold', (tester) async {
    await tester.pumpApp(const ElectionalScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DraconicChartScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DraconicChartScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('AsteroidsScreen renders scaffold', (tester) async {
    await tester.pumpApp(const AsteroidsScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('LocalSpaceScreen renders scaffold', (tester) async {
    await tester.pumpApp(const LocalSpaceScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('TransitCalendarScreen renders scaffold', (tester) async {
    await tester.pumpApp(const TransitCalendarScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('KabbalahScreen renders scaffold', (tester) async {
    await tester.pumpApp(const KabbalahScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
