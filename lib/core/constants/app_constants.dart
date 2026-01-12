class AppConstants {
  AppConstants._();

  static const String appName = 'Celestial';
  static const String appTagline = 'Gökyüzünün Sırları Seni Bekliyor';

  // Storage keys
  static const String userProfileKey = 'user_profile';
  static const String savedChartsKey = 'saved_charts';
  static const String settingsKey = 'app_settings';
  static const String onboardingCompleteKey = 'onboarding_complete';

  // Animation durations
  static const Duration quickAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Spacing
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 24;
  static const double spacingXxl = 32;
  static const double spacingHuge = 48;

  // Border radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 999;
}
