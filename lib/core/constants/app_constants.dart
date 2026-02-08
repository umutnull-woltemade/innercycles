class AppConstants {
  AppConstants._();

  static const String appName = 'Venus One';
  // REMOVED: Turkish tagline - use L10nService.get('app.tagline', language) instead

  // App IDs and Links
  static const String appStoreId = '6758612716';
  static const String playStoreId = 'com.venusone'; // Update with your package name
  static const String privacyPolicyUrl = 'https://venusone.com/privacy';
  static const String termsOfServiceUrl = 'https://venusone.com/terms';
  static const String supportEmail = 'support@venusone.com';

  // RevenueCat API Keys (Production)
  static const String revenueCatAppleApiKey = 'appl_DaPzIEYbCInFGHwqlzOqcnKZhLY';
  static const String revenueCatGoogleApiKey = 'goog_REPLACE_WITH_PRODUCTION_KEY'; // TODO: Add Google key when ready

  // RevenueCat Product IDs
  static const String monthlyProductId = 'monthly';
  static const String yearlyProductId = 'yearly';
  static const String lifetimeProductId = 'lifetime';
  static const String entitlementId = 'umutnull_pro';

  // Pricing Experiment Product IDs
  static const String monthlyProductId799 = 'monthly_799';
  static const String monthlyProductId999 = 'monthly_999';
  static const String monthlyProductId1199 = 'monthly_1199';

  // Pricing Experiment Values
  static const double priceVariantA = 7.99;
  static const double priceVariantB = 9.99;
  static const double priceVariantC = 11.99;

  // Experiment Traffic Distribution
  static const double timingVariantATraffic = 0.25; // Immediate
  static const double timingVariantBTraffic = 0.50; // First Insight (default)
  static const double timingVariantCTraffic = 0.25; // Delayed

  static const double pricingVariantATraffic = 0.50; // $7.99
  static const double pricingVariantBTraffic = 0.30; // $9.99
  static const double pricingVariantCTraffic = 0.20; // $11.99

  // Churn Defense Thresholds
  static const double churnWarningThreshold = 0.07; // 7%
  static const double churnCriticalThreshold = 0.10; // 10%
  static const double mrrDropWarningThreshold = 0.05; // 5% week-over-week
  static const double refundSurgeThreshold = 0.03; // 3% in 24h

  // Paywall Cooldown (during churn defense)
  static const Duration paywallCooldown = Duration(hours: 48);

  // AdMob IDs (Production)
  static const String admobAppIdAndroid = 'ca-app-pub-REPLACE_WITH_YOUR_APP_ID'; // TODO: Add Android when ready
  static const String admobAppIdIos = 'ca-app-pub-5137678816003178~8037799627';
  static const String admobBannerIdAndroid = 'ca-app-pub-REPLACE/BANNER_UNIT_ID'; // TODO: Add Android when ready
  static const String admobBannerIdIos = 'ca-app-pub-5137678816003178/4989405392';
  static const String admobInterstitialIdAndroid = 'ca-app-pub-REPLACE/INTERSTITIAL_ID'; // TODO: Add Android when ready
  static const String admobInterstitialIdIos = 'ca-app-pub-5137678816003178/4040012155';
  static const String admobRewardedIdAndroid = 'ca-app-pub-REPLACE/REWARDED_ID'; // TODO: Add Android when ready
  static const String admobRewardedIdIos = 'ca-app-pub-5137678816003178/7883054243';

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
