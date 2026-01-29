class AppConstants {
  AppConstants._();

  static const String appName = 'Venus One';
  static const String appTagline = 'Yıldızların Rehberliğinde Kendini Keşfet';

  // App IDs and Links
  static const String appStoreId = ''; // Add your App Store ID here
  static const String playStoreId =
      'com.venusone'; // Update with your package name
  static const String privacyPolicyUrl = 'https://venusone.com/privacy';
  static const String termsOfServiceUrl = 'https://venusone.com/terms';
  static const String supportEmail = 'support@venusone.com';

  // RevenueCat API Keys
  static const String revenueCatAppleApiKey =
      ''; // Add your RevenueCat Apple API key
  static const String revenueCatGoogleApiKey =
      ''; // Add your RevenueCat Google API key

  // RevenueCat Product IDs
  static const String monthlyProductId = 'venusone_premium_monthly';
  static const String yearlyProductId = 'venusone_premium_yearly';
  static const String entitlementId = 'premium';

  // AdMob IDs (Production) - Replace with your actual IDs
  static const String admobAppIdAndroid =
      'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX';
  static const String admobAppIdIos = 'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX';
  static const String admobBannerIdAndroid =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String admobBannerIdIos =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String admobInterstitialIdAndroid =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String admobInterstitialIdIos =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String admobRewardedIdAndroid =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String admobRewardedIdIos =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

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
