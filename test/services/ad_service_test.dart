import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/data/services/ad_service.dart';
import 'package:astrology_app/core/constants/app_constants.dart';

void main() {
  group('AdConfig', () {
    test('provides test banner ID', () {
      expect(AdConfig.testBannerId, 'ca-app-pub-3940256099942544/6300978111');
    });

    test('provides test interstitial ID', () {
      expect(AdConfig.testInterstitialId, 'ca-app-pub-3940256099942544/1033173712');
    });

    test('provides test rewarded ID', () {
      expect(AdConfig.testRewardedId, 'ca-app-pub-3940256099942544/5224354917');
    });

    test('isTestMode returns boolean', () {
      expect(AdConfig.isTestMode, isA<bool>());
    });
  });

  group('AdPlacement', () {
    test('has all expected values', () {
      expect(AdPlacement.values, containsAll([
        AdPlacement.horoscopeResult,
        AdPlacement.birthChartResult,
        AdPlacement.tarotResult,
        AdPlacement.numerologyResult,
        AdPlacement.compatibilityResult,
        AdPlacement.auraResult,
        AdPlacement.postAnalysis,
        AdPlacement.premiumUnlock,
        AdPlacement.homeScreen,
        AdPlacement.settingsScreen,
      ]));
    });

    test('has 10 values', () {
      expect(AdPlacement.values.length, 10);
    });

    test('values have correct names', () {
      expect(AdPlacement.horoscopeResult.name, 'horoscopeResult');
      expect(AdPlacement.homeScreen.name, 'homeScreen');
    });
  });

  group('AdService', () {
    late AdService service;

    setUp(() {
      service = AdService();
    });

    test('isPremium defaults to false', () {
      expect(service.isPremium, false);
    });

    test('isRewardedAdReady defaults to false', () {
      expect(service.isRewardedAdReady, false);
    });

    test('isInterstitialReady defaults to false', () {
      expect(service.isInterstitialReady, false);
    });

    test('analysesUntilInterstitial returns positive number', () {
      expect(service.analysesUntilInterstitial, greaterThan(0));
    });

    test('dispose does not throw', () {
      expect(() => service.dispose(), returnsNormally);
    });

    test('showInterstitialAfterAnalysis returns false on web', () async {
      // In test environment (web-like), should return false
      final result = await service.showInterstitialAfterAnalysis();
      expect(result, false);
    });

    test('showInterstitial returns false when not ready', () async {
      final result = await service.showInterstitial(AdPlacement.homeScreen);
      expect(result, false);
    });

    test('showRewardedAd returns false when not ready', () async {
      bool rewardEarned = false;
      final result = await service.showRewardedAd(
        onRewardEarned: () => rewardEarned = true,
      );
      expect(result, false);
      expect(rewardEarned, false);
    });
  });

  group('AppConstants AdMob IDs', () {
    test('Android banner ID is placeholder', () {
      expect(
        AppConstants.admobBannerIdAndroid.contains('XXXXXXXX'),
        true,
      );
    });

    test('iOS banner ID is placeholder', () {
      expect(
        AppConstants.admobBannerIdIos.contains('XXXXXXXX'),
        true,
      );
    });

    test('Android interstitial ID is placeholder', () {
      expect(
        AppConstants.admobInterstitialIdAndroid.contains('XXXXXXXX'),
        true,
      );
    });

    test('iOS interstitial ID is placeholder', () {
      expect(
        AppConstants.admobInterstitialIdIos.contains('XXXXXXXX'),
        true,
      );
    });

    test('Android rewarded ID is placeholder', () {
      expect(
        AppConstants.admobRewardedIdAndroid.contains('XXXXXXXX'),
        true,
      );
    });

    test('iOS rewarded ID is placeholder', () {
      expect(
        AppConstants.admobRewardedIdIos.contains('XXXXXXXX'),
        true,
      );
    });
  });
}
