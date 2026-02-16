import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:inner_cycles/features/dreams/presentation/dream_interpretation_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/dream_oracle_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/dream_glossary_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/canonical/dream_falling_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/canonical/dream_water_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/canonical/dream_recurring_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/canonical/dream_running_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/canonical/dream_flying_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/canonical/dream_losing_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/canonical/dream_darkness_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/canonical/dream_past_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/canonical/dream_searching_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/canonical/dream_voiceless_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/canonical/dream_lost_screen.dart';
import 'package:inner_cycles/features/dreams/presentation/canonical/dream_unable_to_fly_screen.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('Dream Screens', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('DreamInterpretationScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamInterpretationScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamOracleScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamOracleScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamGlossaryScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamGlossaryScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamFallingScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamFallingScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamWaterScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamWaterScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamRecurringScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamRecurringScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamRunningScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamRunningScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamFlyingScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamFlyingScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamLosingScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamLosingScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamDarknessScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamDarknessScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamPastScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamPastScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamSearchingScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamSearchingScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamVoicelessScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamVoicelessScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamLostScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamLostScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('DreamUnableToFlyScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DreamUnableToFlyScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
