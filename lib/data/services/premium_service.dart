import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import 'ad_service.dart';
import 'analytics_service.dart';

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
        return 'Ucretsiz';
      case PremiumTier.monthly:
        return 'Aylik Premium';
      case PremiumTier.yearly:
        return 'Yillik Premium';
    }
  }

  String get price {
    switch (this) {
      case PremiumTier.free:
        return '₺0';
      case PremiumTier.monthly:
        return '₺29/ay';
      case PremiumTier.yearly:
        return '₺79/yil';
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
          'Gunluk burc fisiltiilari',
          'Temel dogum haritasi',
          'Gunluk tarot karti',
          'Reklam destekli',
        ];
      case PremiumTier.monthly:
      case PremiumTier.yearly:
        return [
          'Tum temel ozellikler',
          'Saf kozmik deneyim (reklamsiz)',
          'Derin gezegen yorumlari',
          'Sinirsiz tarot seanslari',
          'Ruh ikizi uyum analizi',
          'Kabalistik sirlar',
          'Aurik enerji okumasi',
          'Gezegen transitleri',
          'Oncelikli kozmik rehberlik',
        ];
    }
  }

  String get productId {
    switch (this) {
      case PremiumTier.free:
        return '';
      case PremiumTier.monthly:
        return AppConstants.monthlyProductId;
      case PremiumTier.yearly:
        return AppConstants.yearlyProductId;
    }
  }
}

/// Premium subscription state
class PremiumState {
  final bool isPremium;
  final PremiumTier tier;
  final DateTime? expiryDate;
  final bool isLoading;
  final String? errorMessage;
  final List<StoreProduct> availableProducts;
  final CustomerInfo? customerInfo;

  const PremiumState({
    this.isPremium = false,
    this.tier = PremiumTier.free,
    this.expiryDate,
    this.isLoading = false,
    this.errorMessage,
    this.availableProducts = const [],
    this.customerInfo,
  });

  PremiumState copyWith({
    bool? isPremium,
    PremiumTier? tier,
    DateTime? expiryDate,
    bool? isLoading,
    String? errorMessage,
    List<StoreProduct>? availableProducts,
    CustomerInfo? customerInfo,
  }) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      tier: tier ?? this.tier,
      expiryDate: expiryDate ?? this.expiryDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      availableProducts: availableProducts ?? this.availableProducts,
      customerInfo: customerInfo ?? this.customerInfo,
    );
  }
}

/// Premium service notifier using Notifier (Riverpod 2.0+)
class PremiumNotifier extends Notifier<PremiumState> {
  static bool _isInitialized = false;

  @override
  PremiumState build() {
    _initializeRevenueCat();
    return const PremiumState(isLoading: true);
  }

  AdService get _adService => ref.read(adServiceProvider);
  AnalyticsService get _analytics => ref.read(analyticsServiceProvider);

  /// Initialize RevenueCat SDK
  Future<void> _initializeRevenueCat() async {
    if (_isInitialized) {
      await _checkSubscriptionStatus();
      return;
    }

    try {
      if (kIsWeb) {
        // RevenueCat not supported on web, use local storage fallback
        await _loadLocalPremiumStatus();
        return;
      }

      String apiKey;
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        apiKey = AppConstants.revenueCatAppleApiKey;
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        apiKey = AppConstants.revenueCatGoogleApiKey;
      } else {
        await _loadLocalPremiumStatus();
        return;
      }

      // Skip if no API key configured
      if (apiKey.isEmpty) {
        if (kDebugMode) {
          debugPrint('RevenueCat: No API key configured, using local storage');
        }
        await _loadLocalPremiumStatus();
        return;
      }

      await Purchases.configure(PurchasesConfiguration(apiKey));
      _isInitialized = true;

      // Listen for customer info updates
      Purchases.addCustomerInfoUpdateListener((customerInfo) {
        _handleCustomerInfoUpdate(customerInfo);
      });

      await _checkSubscriptionStatus();
      await _fetchAvailableProducts();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('RevenueCat initialization error: $e');
      }
      await _loadLocalPremiumStatus();
    }
  }

  /// Check current subscription status
  Future<void> _checkSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _handleCustomerInfoUpdate(customerInfo);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error checking subscription: $e');
      }
      state = state.copyWith(isLoading: false);
    }
  }

  /// Handle customer info updates from RevenueCat
  void _handleCustomerInfoUpdate(CustomerInfo customerInfo) {
    final entitlement = customerInfo.entitlements.all[AppConstants.entitlementId];
    final isPremium = entitlement?.isActive ?? false;

    PremiumTier tier = PremiumTier.free;
    DateTime? expiryDate;

    if (isPremium && entitlement != null) {
      // Determine tier based on product
      if (entitlement.productIdentifier == AppConstants.yearlyProductId) {
        tier = PremiumTier.yearly;
      } else {
        tier = PremiumTier.monthly;
      }

      // Get expiry date
      if (entitlement.expirationDate != null) {
        expiryDate = DateTime.parse(entitlement.expirationDate!);
      }
    }

    state = PremiumState(
      isPremium: isPremium,
      tier: tier,
      expiryDate: expiryDate,
      isLoading: false,
      availableProducts: state.availableProducts,
      customerInfo: customerInfo,
    );

    // Sync with AdService
    _adService.setPremiumStatus(isPremium);

    // Save to local storage as backup
    _savePremiumStatusLocally(isPremium, tier, expiryDate);
  }

  /// Fetch available products from store
  Future<void> _fetchAvailableProducts() async {
    try {
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;

      if (currentOffering != null) {
        final products = currentOffering.availablePackages
            .map((p) => p.storeProduct)
            .toList();

        state = state.copyWith(availableProducts: products);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching products: $e');
      }
    }
  }

  /// Purchase premium subscription
  Future<bool> purchasePremium(PremiumTier tier) async {
    if (tier == PremiumTier.free) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      if (kIsWeb || !_isInitialized) {
        // Simulate purchase for web/development
        return await _simulatePurchase(tier);
      }

      // Find the product
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;

      if (currentOffering == null) {
        throw Exception('No offerings available');
      }

      Package? packageToPurchase;
      for (final package in currentOffering.availablePackages) {
        if (package.storeProduct.identifier == tier.productId) {
          packageToPurchase = package;
          break;
        }
      }

      if (packageToPurchase == null) {
        throw Exception('Product not found: ${tier.productId}');
      }

      // Make purchase
      final customerInfo = await Purchases.purchasePackage(packageToPurchase);
      _handleCustomerInfoUpdate(customerInfo);

      // Log analytics
      _analytics.logPurchase(
        productId: tier.productId,
        tier: tier.name,
        success: true,
      );

      return state.isPremium;
    } on PurchasesErrorCode catch (e) {
      String errorMessage;
      switch (e) {
        case PurchasesErrorCode.purchaseCancelledError:
          errorMessage = 'Satin alma iptal edildi';
          break;
        case PurchasesErrorCode.purchaseNotAllowedError:
          errorMessage = 'Satin alma izni yok';
          break;
        case PurchasesErrorCode.purchaseInvalidError:
          errorMessage = 'Gecersiz satin alma';
          break;
        case PurchasesErrorCode.productNotAvailableForPurchaseError:
          errorMessage = 'Urun mevcut degil';
          break;
        case PurchasesErrorCode.networkError:
          errorMessage = 'Ag hatasi. Lutfen tekrar deneyin.';
          break;
        default:
          errorMessage = 'Satin alma basarisiz: $e';
      }

      state = state.copyWith(isLoading: false, errorMessage: errorMessage);

      _analytics.logPurchase(
        productId: tier.productId,
        tier: tier.name,
        success: false,
        error: errorMessage,
      );

      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Purchase error: $e');
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Satin alma basarisiz. Lutfen tekrar deneyin.',
      );

      _analytics.logPurchase(
        productId: tier.productId,
        tier: tier.name,
        success: false,
        error: e.toString(),
      );

      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      if (kIsWeb || !_isInitialized) {
        await _loadLocalPremiumStatus();
        return state.isPremium;
      }

      final customerInfo = await Purchases.restorePurchases();
      _handleCustomerInfoUpdate(customerInfo);

      _analytics.logEvent('restore_purchases', {
        'success': state.isPremium.toString(),
      });

      if (!state.isPremium) {
        state = state.copyWith(
          errorMessage: 'Geri yuklenecek satin alma bulunamadi',
        );
      }

      return state.isPremium;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Restore error: $e');
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Geri yukleme basarisiz. Lutfen tekrar deneyin.',
      );
      return false;
    }
  }

  /// Get product price by tier
  String? getProductPrice(PremiumTier tier) {
    for (final product in state.availableProducts) {
      if (product.identifier == tier.productId) {
        return product.priceString;
      }
    }
    return null;
  }

  /// Cancel subscription (for testing)
  Future<void> cancelSubscription() async {
    await _clearPremium();
  }

  // Private helper methods

  Future<void> _loadLocalPremiumStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isPremium = prefs.getBool('is_premium') ?? false;
      final tierIndex = prefs.getInt('premium_tier') ?? 0;
      final expiryTimestamp = prefs.getInt('premium_expiry');

      DateTime? expiryDate;
      if (expiryTimestamp != null) {
        expiryDate = DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
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

      await _adService.setPremiumStatus(isPremium);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading local premium status: $e');
      }
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _savePremiumStatusLocally(
    bool isPremium,
    PremiumTier tier,
    DateTime? expiryDate,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium', isPremium);
    await prefs.setInt('premium_tier', tier.index);
    if (expiryDate != null) {
      await prefs.setInt('premium_expiry', expiryDate.millisecondsSinceEpoch);
    } else {
      await prefs.remove('premium_expiry');
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

  Future<bool> _simulatePurchase(PremiumTier tier) async {
    // Simulate for development/web
    await Future.delayed(const Duration(seconds: 1));

    final now = DateTime.now();
    DateTime expiryDate;
    if (tier == PremiumTier.monthly) {
      expiryDate = DateTime(now.year, now.month + 1, now.day);
    } else {
      expiryDate = DateTime(now.year + 1, now.month, now.day);
    }

    await _savePremiumStatusLocally(true, tier, expiryDate);
    await _adService.setPremiumStatus(true);

    state = PremiumState(
      isPremium: true,
      tier: tier,
      expiryDate: expiryDate,
      isLoading: false,
    );

    return true;
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
