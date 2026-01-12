import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ad unit IDs - Replace with your actual AdMob IDs before release
class AdConfig {
  // Test IDs (for development)
  static const String testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String testRewardedId = 'ca-app-pub-3940256099942544/5224354917';

  // Production IDs - Replace these with your actual AdMob IDs
  static const String prodBannerIdAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String prodBannerIdIos = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String prodInterstitialIdAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String prodInterstitialIdIos = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String prodRewardedIdAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String prodRewardedIdIos = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

  // Use test ads in debug mode
  static bool get isTestMode => kDebugMode;

  static String get bannerId {
    if (isTestMode) return testBannerId;
    if (Platform.isAndroid) return prodBannerIdAndroid;
    if (Platform.isIOS) return prodBannerIdIos;
    return testBannerId;
  }

  static String get interstitialId {
    if (isTestMode) return testInterstitialId;
    if (Platform.isAndroid) return prodInterstitialIdAndroid;
    if (Platform.isIOS) return prodInterstitialIdIos;
    return testInterstitialId;
  }

  static String get rewardedId {
    if (isTestMode) return testRewardedId;
    if (Platform.isAndroid) return prodRewardedIdAndroid;
    if (Platform.isIOS) return prodRewardedIdIos;
    return testRewardedId;
  }
}

/// Ad placement types for tracking
enum AdPlacement {
  horoscopeResult,
  birthChartResult,
  tarotResult,
  numerologyResult,
  compatibilityResult,
  auraResult,
  postAnalysis,
  premiumUnlock,
}

/// AdService manages all ad operations
class AdService {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInterstitialReady = false;
  bool _isRewardedReady = false;
  int _analysisCount = 0;

  // Show interstitial every N analyses
  static const int _interstitialFrequency = 3;

  // Premium status
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  /// Initialize the ad service
  Future<void> initialize() async {
    if (kIsWeb) return; // Ads not supported on web

    await MobileAds.instance.initialize();

    // Load premium status
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool('is_premium') ?? false;

    if (!_isPremium) {
      _loadInterstitialAd();
      _loadRewardedAd();
    }
  }

  /// Set premium status
  Future<void> setPremiumStatus(bool isPremium) async {
    _isPremium = isPremium;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium', isPremium);
  }

  /// Create a banner ad
  BannerAd createBannerAd({
    required AdSize size,
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: AdConfig.bannerId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (ad) => _logAdEvent('banner_opened'),
        onAdClosed: (ad) => _logAdEvent('banner_closed'),
        onAdImpression: (ad) => _logAdEvent('banner_impression'),
      ),
    );
  }

  /// Load interstitial ad
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
          _logAdEvent('interstitial_loaded');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialReady = false;
              _loadInterstitialAd(); // Preload next
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialReady = false;
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _logAdEvent('interstitial_failed: ${error.message}');
          _isInterstitialReady = false;
          // Retry after delay
          Future.delayed(const Duration(seconds: 30), _loadInterstitialAd);
        },
      ),
    );
  }

  /// Load rewarded ad
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdConfig.rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedReady = true;
          _logAdEvent('rewarded_loaded');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isRewardedReady = false;
              _loadRewardedAd(); // Preload next
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isRewardedReady = false;
              _loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _logAdEvent('rewarded_failed: ${error.message}');
          _isRewardedReady = false;
          // Retry after delay
          Future.delayed(const Duration(seconds: 30), _loadRewardedAd);
        },
      ),
    );
  }

  /// Show interstitial ad after analysis (respects frequency)
  Future<bool> showInterstitialAfterAnalysis() async {
    if (_isPremium || kIsWeb) return false;

    _analysisCount++;

    if (_analysisCount >= _interstitialFrequency && _isInterstitialReady) {
      _analysisCount = 0;
      await _interstitialAd?.show();
      _logAdEvent('interstitial_shown');
      return true;
    }

    return false;
  }

  /// Force show interstitial (for specific placements)
  Future<bool> showInterstitial(AdPlacement placement) async {
    if (_isPremium || kIsWeb) return false;

    if (_isInterstitialReady) {
      await _interstitialAd?.show();
      _logAdEvent('interstitial_shown_${placement.name}');
      return true;
    }

    return false;
  }

  /// Show rewarded ad for premium feature unlock
  Future<bool> showRewardedAd({
    required void Function() onRewardEarned,
    AdPlacement placement = AdPlacement.premiumUnlock,
  }) async {
    if (kIsWeb) return false;

    if (_isRewardedReady && _rewardedAd != null) {
      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          _logAdEvent('rewarded_earned_${placement.name}');
          onRewardEarned();
        },
      );
      return true;
    }

    return false;
  }

  /// Check if rewarded ad is available
  bool get isRewardedAdReady => _isRewardedReady && !kIsWeb;

  /// Dispose ads
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }

  void _logAdEvent(String event) {
    if (kDebugMode) {
      debugPrint('AdService: $event');
    }
    // TODO: Add analytics logging here
  }
}

/// AdService provider
final adServiceProvider = Provider<AdService>((ref) {
  final service = AdService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Premium status provider
final isPremiumProvider = Provider<bool>((ref) {
  return ref.watch(adServiceProvider).isPremium;
});
