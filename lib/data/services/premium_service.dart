import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ad_service.dart';

/// Premium subscription tiers
enum PremiumTier {
  free,
  monthly,
  yearly,
}

extension PremiumTierExtension on PremiumTier {
  String get displayName {
    switch (this) {
      case PremiumTier.free:
        return 'Ücretsiz';
      case PremiumTier.monthly:
        return 'Aylık Premium';
      case PremiumTier.yearly:
        return 'Yıllık Premium';
    }
  }

  String get price {
    switch (this) {
      case PremiumTier.free:
        return '₺0';
      case PremiumTier.monthly:
        return '₺29/ay';
      case PremiumTier.yearly:
        return '₺79/yıl';
    }
  }

  String get savings {
    switch (this) {
      case PremiumTier.free:
        return '';
      case PremiumTier.monthly:
        return '';
      case PremiumTier.yearly:
        return '%77 tasarruf';
    }
  }

  List<String> get features {
    switch (this) {
      case PremiumTier.free:
        return [
          'Günlük burç fısıltıları',
          'Temel doğum haritası',
          'Günlük tarot kartı',
          'Reklam destekli',
        ];
      case PremiumTier.monthly:
      case PremiumTier.yearly:
        return [
          'Tüm temel özellikler',
          'Saf kozmik deneyim (reklamsız)',
          'Derin gezegen yorumları',
          'Sınırsız tarot seanları',
          'Ruh ikizi uyum analizi',
          'Kabalistik sırlar',
          'Aurik enerji okuması',
          'Gezegen transitleri',
          'Öncelikli kozmik rehberlik',
        ];
    }
  }
}

/// Premium subscription state
class PremiumState {
  final bool isPremium;
  final PremiumTier tier;
  final DateTime? expiryDate;
  final bool isLoading;

  const PremiumState({
    this.isPremium = false,
    this.tier = PremiumTier.free,
    this.expiryDate,
    this.isLoading = false,
  });

  PremiumState copyWith({
    bool? isPremium,
    PremiumTier? tier,
    DateTime? expiryDate,
    bool? isLoading,
  }) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      tier: tier ?? this.tier,
      expiryDate: expiryDate ?? this.expiryDate,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Premium service notifier using Notifier (Riverpod 2.0+)
class PremiumNotifier extends Notifier<PremiumState> {
  @override
  PremiumState build() {
    // Initialize and load premium status
    _loadPremiumStatus();
    return const PremiumState();
  }

  AdService get _adService => ref.read(adServiceProvider);

  Future<void> _loadPremiumStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final isPremium = prefs.getBool('is_premium') ?? false;
      final tierIndex = prefs.getInt('premium_tier') ?? 0;
      final expiryTimestamp = prefs.getInt('premium_expiry');

      DateTime? expiryDate;
      if (expiryTimestamp != null) {
        expiryDate = DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
        // Check if expired
        if (expiryDate.isBefore(DateTime.now())) {
          await _clearPremium();
          return;
        }
      }

      state = PremiumState(
        isPremium: isPremium,
        tier: PremiumTier.values[tierIndex],
        expiryDate: expiryDate,
        isLoading: false,
      );

      // Sync with AdService
      await _adService.setPremiumStatus(isPremium);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading premium status: $e');
      }
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _clearPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium', false);
    await prefs.setInt('premium_tier', 0);
    await prefs.remove('premium_expiry');
    await _adService.setPremiumStatus(false);

    state = const PremiumState(
      isPremium: false,
      tier: PremiumTier.free,
      isLoading: false,
    );
  }

  /// Purchase premium subscription
  /// In production, this would integrate with RevenueCat or in-app purchases
  Future<bool> purchasePremium(PremiumTier tier) async {
    if (tier == PremiumTier.free) return false;

    state = state.copyWith(isLoading: true);

    try {
      // TODO: Integrate with RevenueCat or Apple/Google in-app purchases
      // For now, simulate a successful purchase

      // Calculate expiry date
      final now = DateTime.now();
      DateTime expiryDate;
      if (tier == PremiumTier.monthly) {
        expiryDate = DateTime(now.year, now.month + 1, now.day);
      } else {
        expiryDate = DateTime(now.year + 1, now.month, now.day);
      }

      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_premium', true);
      await prefs.setInt('premium_tier', tier.index);
      await prefs.setInt('premium_expiry', expiryDate.millisecondsSinceEpoch);

      // Update AdService
      await _adService.setPremiumStatus(true);

      state = PremiumState(
        isPremium: true,
        tier: tier,
        expiryDate: expiryDate,
        isLoading: false,
      );

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error purchasing premium: $e');
      }
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: Integrate with RevenueCat or Apple/Google to restore purchases
      // For now, just reload from local storage
      await _loadPremiumStatus();
      return state.isPremium;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error restoring purchases: $e');
      }
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  /// Cancel subscription (for testing)
  Future<void> cancelSubscription() async {
    await _clearPremium();
  }
}

/// Premium state provider
final premiumProvider = NotifierProvider<PremiumNotifier, PremiumState>(() {
  return PremiumNotifier();
});

/// Quick access to premium status
final isPremiumUserProvider = Provider<bool>((ref) {
  return ref.watch(premiumProvider).isPremium;
});
