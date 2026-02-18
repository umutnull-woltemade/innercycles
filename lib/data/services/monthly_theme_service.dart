// ════════════════════════════════════════════════════════════════════════════
// MONTHLY THEME SERVICE - Month-Aware Reflection Theme Engine
// ════════════════════════════════════════════════════════════════════════════
// Provides current month's theme, weekly prompt tracking, and progress.
// ════════════════════════════════════════════════════════════════════════════
library;

import 'package:shared_preferences/shared_preferences.dart';
import '../content/monthly_themes_content.dart';

class MonthlyThemeService {
  static const String _completedPromptsKey = 'monthly_theme_completed_prompts';

  final SharedPreferences _prefs;

  MonthlyThemeService(this._prefs);

  static Future<MonthlyThemeService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return MonthlyThemeService(prefs);
  }

  // ═══════════════════════════════════════════════════════════════
  // CURRENT MONTH
  // ═══════════════════════════════════════════════════════════════

  MonthlyTheme getCurrentTheme() {
    final month = DateTime.now().month;
    return allMonthlyThemes.firstWhere(
      (t) => t.month == month,
      orElse: () => allMonthlyThemes.first,
    );
  }

  int getCurrentWeek() {
    final now = DateTime.now();
    final weekOfMonth = ((now.day - 1) / 7).floor();
    return weekOfMonth.clamp(0, 3);
  }

  String getCurrentWeekPromptEn() {
    final theme = getCurrentTheme();
    final week = getCurrentWeek();
    return theme.weeklyPromptsEn[week];
  }

  String getCurrentWeekPromptTr() {
    final theme = getCurrentTheme();
    final week = getCurrentWeek();
    return theme.weeklyPromptsTr[week];
  }

  MonthlyTheme? getThemeForMonth(int month) {
    return allMonthlyThemes.where((t) => t.month == month).firstOrNull;
  }

  // ═══════════════════════════════════════════════════════════════
  // PROMPT TRACKING
  // ═══════════════════════════════════════════════════════════════

  Future<void> markPromptCompleted(int month, int weekIndex) async {
    final key = '${month}_$weekIndex';
    final completed = _getCompletedPrompts();
    completed.add(key);
    await _prefs.setStringList(_completedPromptsKey, completed.toList());
  }

  bool isPromptCompleted(int month, int weekIndex) {
    final key = '${month}_$weekIndex';
    return _getCompletedPrompts().contains(key);
  }

  int completedPromptsForMonth(int month) {
    final completed = _getCompletedPrompts();
    return List.generate(
      4,
      (i) => '${month}_$i',
    ).where((key) => completed.contains(key)).length;
  }

  double monthProgress(int month) {
    return completedPromptsForMonth(month) / 4.0;
  }

  Set<String> _getCompletedPrompts() {
    final list = _prefs.getStringList(_completedPromptsKey) ?? [];
    return list.toSet();
  }
}
