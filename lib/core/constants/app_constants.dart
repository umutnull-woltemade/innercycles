import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'InnerCycles';
  // REMOVED: Turkish tagline - use L10nService.get('app.tagline', language) instead

  // App IDs and Links
  static const String appStoreId = '6758612716';
  static const String playStoreId = 'com.venusone.innercycles';
  static const String privacyPolicyUrl =
      'https://umutnull-woltemade.github.io/innercycles/privacy.html';
  static const String termsOfServiceUrl =
      'https://umutnull-woltemade.github.io/innercycles/terms.html';
  static const String supportEmail = 'support@innercycles.app';

  // RevenueCat API Keys — loaded from .env at runtime
  static String get revenueCatAppleApiKey =>
      dotenv.env['REVENUECAT_APPLE_API_KEY'] ?? '';
  static String get revenueCatGoogleApiKey =>
      dotenv.env['REVENUECAT_GOOGLE_API_KEY'] ?? ''; // iOS-only release

  // RevenueCat Product IDs
  static const String monthlyProductId = 'monthly';
  static const String yearlyProductId = 'yearly';
  static const String lifetimeProductId = 'lifetime';
  static const String entitlementId = 'innercycles_pro';

  // Pricing Experiment Product IDs
  static const String monthlyProductId799 = 'monthly_799';
  static const String monthlyProductId999 = 'monthly_999';
  static const String monthlyProductId1199 = 'monthly_1199';

  // Pricing Experiment Values
  static const double priceVariantA = 7.99;
  static const double priceVariantB = 9.99;
  static const double priceVariantC = 11.99;

  // Experiment Traffic Distribution
  static const double timingVariantATraffic = 0.30; // Immediate
  static const double timingVariantBTraffic = 0.35; // First Insight
  static const double timingVariantCTraffic = 0.35; // Delayed

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

  // AdMob IDs (iOS only)
  static const String admobAppIdAndroid = ''; // iOS-only release
  static const String admobAppIdIos = 'ca-app-pub-5137678816003178~8037799627';
  static const String admobBannerIdAndroid = ''; // iOS-only release
  static const String admobBannerIdIos =
      'ca-app-pub-5137678816003178/4989405392';
  static const String admobInterstitialIdAndroid = ''; // iOS-only release
  static const String admobInterstitialIdIos =
      'ca-app-pub-5137678816003178/4040012155';
  static const String admobRewardedIdAndroid = ''; // iOS-only release
  static const String admobRewardedIdIos =
      'ca-app-pub-5137678816003178/7883054243';

  // Storage keys
  static const String userProfileKey = 'user_profile';

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
