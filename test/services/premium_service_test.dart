import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inner_cycles/data/services/premium_service.dart';
import 'package:inner_cycles/data/services/ad_service.dart';
import 'package:inner_cycles/data/services/analytics_service.dart';

/// Mock AdService for testing - avoids Google Mobile Ads plugin calls
class MockAdService extends AdService {
  @override
  Future<void> initialize({AnalyticsService? analytics}) async {
    // No-op for testing
  }

  @override
  Future<void> setPremiumStatus(bool isPremium) async {
    // No-op for testing
  }
}

void main() {
  // Ensure Flutter bindings are initialized for platform channels
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PremiumTier', () {
    test('free tier has correct properties', () {
      const tier = PremiumTier.free;
      // displayName uses i18n with English fallback when not initialized
      expect(tier.displayName, isNotEmpty);
      expect(tier.price, '₺0');
      expect(tier.features, isNotEmpty);
      expect(tier.productId, '');
    });

    test('monthly tier has correct properties', () {
      const tier = PremiumTier.monthly;
      // displayName uses i18n with English fallback when not initialized
      expect(tier.displayName, isNotEmpty);
      expect(tier.price, '₺29/mo');
      expect(tier.features, isNotEmpty);
      expect(tier.productId, 'monthly');
    });

    test('yearly tier has correct properties', () {
      const tier = PremiumTier.yearly;
      // displayName uses i18n with English fallback when not initialized
      expect(tier.displayName, isNotEmpty);
      expect(tier.price, '₺79/yr');
      expect(tier.features, isNotEmpty);
      expect(tier.productId, 'yearly');
    });

    test('premium tiers have more features than free', () {
      expect(
        PremiumTier.monthly.features.length,
        greaterThan(PremiumTier.free.features.length),
      );
      expect(
        PremiumTier.yearly.features.length,
        greaterThan(PremiumTier.free.features.length),
      );
    });
  });

  group('PremiumState', () {
    test('default state is not premium', () {
      const state = PremiumState();
      expect(state.isPremium, false);
      expect(state.tier, PremiumTier.free);
      expect(state.expiryDate, isNull);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
      expect(state.availableProducts, isEmpty);
    });

    test('copyWith creates new state with updated values', () {
      const state = PremiumState();
      final newState = state.copyWith(
        isPremium: true,
        tier: PremiumTier.monthly,
        isLoading: true,
      );

      expect(newState.isPremium, true);
      expect(newState.tier, PremiumTier.monthly);
      expect(newState.isLoading, true);
      expect(newState.expiryDate, isNull); // unchanged
    });

    test('copyWith preserves unchanged values', () {
      final expiryDate = DateTime.now();
      final state = PremiumState(
        isPremium: true,
        tier: PremiumTier.yearly,
        expiryDate: expiryDate,
      );

      final newState = state.copyWith(isLoading: true);

      expect(newState.isPremium, true);
      expect(newState.tier, PremiumTier.yearly);
      expect(newState.expiryDate, expiryDate);
      expect(newState.isLoading, true);
    });
  });

  group('PremiumNotifier', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      // Create container with mock overrides to avoid real plugin calls
      container = ProviderContainer(
        overrides: [
          adServiceProvider.overrideWithValue(MockAdService()),
          // Use the real AnalyticsService singleton (it just logs in debug mode)
          analyticsServiceProvider.overrideWithValue(AnalyticsService()),
        ],
      );
    });

    tearDown(() async {
      // Wait for any pending async operations to complete before disposing
      await Future.delayed(const Duration(milliseconds: 200));
      container.dispose();
    });

    test('initial state is loading', () {
      final state = container.read(premiumProvider);
      expect(state.isLoading, true);
    });

    test('isPremiumUserProvider returns correct value', () async {
      // Wait for initialization to complete
      await Future.delayed(const Duration(milliseconds: 200));

      final isPremium = container.read(isPremiumUserProvider);
      expect(isPremium, false);
    });
  });
}
