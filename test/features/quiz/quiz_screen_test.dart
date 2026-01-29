import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/quiz/presentation/quiz_screen.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('QuizScreen renders with defaults', (tester) async {
    await tester.pumpApp(const QuizScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('QuizScreen renders with quizType', (tester) async {
    await tester.pumpApp(
      const QuizScreen(quizType: 'general', sourceContext: 'discover'),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
