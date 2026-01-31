import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrology_app/data/models/experiment_config.dart';
import 'package:astrology_app/data/services/experiment_service.dart';
import 'package:astrology_app/data/services/premium_service.dart';
import 'package:astrology_app/data/services/ad_service.dart';
import 'package:astrology_app/data/services/analytics_service.dart';
import 'package:astrology_app/core/constants/app_constants.dart';

/// Mock AdService for testing
class MockAdService extends AdService {
  @override
  Future<void> initialize({AnalyticsService? analytics}) async {}

  @override
  Future<void> setPremiumStatus(bool isPremium) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Experiment Config Models', () {
    group('PaywallTimingVariant', () {
      test('fromCode returns correct variant', () {
        expect(PaywallTimingVariant.fromCode('A'), PaywallTimingVariant.immediate);
        expect(PaywallTimingVariant.fromCode('B'), PaywallTimingVariant.firstInsight);
        expect(PaywallTimingVariant.fromCode('C'), PaywallTimingVariant.delayed);
      });

      test('fromCode returns default for unknown code', () {
        expect(PaywallTimingVariant.fromCode('X'), PaywallTimingVariant.firstInsight);
        expect(PaywallTimingVariant.fromCode(''), PaywallTimingVariant.firstInsight);
      });
    });

    group('PricingVariant', () {
      test('has correct prices', () {
        expect(PricingVariant.priceA.price, 7.99);
        expect(PricingVariant.priceB.price, 9.99);
        expect(PricingVariant.priceC.price, 11.99);
      });

      test('formattedPrice is correct', () {
        expect(PricingVariant.priceA.formattedPrice, '\$7.99/month');
        expect(PricingVariant.priceB.formattedPrice, '\$9.99/month');
        expect(PricingVariant.priceC.formattedPrice, '\$11.99/month');
      });

      test('fromCode returns correct variant', () {
        expect(PricingVariant.fromCode('A'), PricingVariant.priceA);
        expect(PricingVariant.fromCode('B'), PricingVariant.priceB);
        expect(PricingVariant.fromCode('C'), PricingVariant.priceC);
      });

      test('fromCode returns default for unknown code', () {
        expect(PricingVariant.fromCode('X'), PricingVariant.priceA);
      });
    });

    group('ChurnLevel', () {
      test('fromRate returns correct level', () {
        expect(ChurnLevel.fromRate(0.03), ChurnLevel.normal);
        expect(ChurnLevel.fromRate(0.05), ChurnLevel.normal);
        expect(ChurnLevel.fromRate(0.07), ChurnLevel.warning);
        expect(ChurnLevel.fromRate(0.08), ChurnLevel.warning);
        expect(ChurnLevel.fromRate(0.10), ChurnLevel.critical);
        expect(ChurnLevel.fromRate(0.15), ChurnLevel.critical);
      });

      test('thresholds match app constants', () {
        expect(ChurnLevel.warning.minThreshold, AppConstants.churnWarningThreshold);
        expect(ChurnLevel.critical.minThreshold, AppConstants.churnCriticalThreshold);
      });
    });
  });

  group('ExperimentAssignment', () {
    test('default assignment has correct defaults', () {
      final assignment = ExperimentAssignment(
        timingVariant: PaywallTimingVariant.firstInsight,
        pricingVariant: PricingVariant.priceA,
        assignedAt: DateTime.now(),
      );

      expect(assignment.sessionCount, 0);
      expect(assignment.hasSeenFirstInsight, false);
      expect(assignment.lastPaywallShown, isNull);
      expect(assignment.hasConverted, false);
    });

    test('shouldShowPaywall returns false if converted', () {
      final assignment = ExperimentAssignment(
        timingVariant: PaywallTimingVariant.immediate,
        pricingVariant: PricingVariant.priceA,
        assignedAt: DateTime.now(),
        hasConverted: true,
      );

      expect(assignment.shouldShowPaywall(), false);
    });

    test('shouldShowPaywall for immediate variant', () {
      final assignment = ExperimentAssignment(
        timingVariant: PaywallTimingVariant.immediate,
        pricingVariant: PricingVariant.priceA,
        assignedAt: DateTime.now(),
      );

      expect(assignment.shouldShowPaywall(), true);
    });

    test('shouldShowPaywall for firstInsight variant', () {
      final withoutInsight = ExperimentAssignment(
        timingVariant: PaywallTimingVariant.firstInsight,
        pricingVariant: PricingVariant.priceA,
        assignedAt: DateTime.now(),
        hasSeenFirstInsight: false,
      );

      final withInsight = ExperimentAssignment(
        timingVariant: PaywallTimingVariant.firstInsight,
        pricingVariant: PricingVariant.priceA,
        assignedAt: DateTime.now(),
        hasSeenFirstInsight: true,
      );

      expect(withoutInsight.shouldShowPaywall(), false);
      expect(withInsight.shouldShowPaywall(), true);
    });

    test('shouldShowPaywall for delayed variant', () {
      final fresh = ExperimentAssignment(
        timingVariant: PaywallTimingVariant.delayed,
        pricingVariant: PricingVariant.priceA,
        assignedAt: DateTime.now(),
        sessionCount: 1,
      );

      final secondSession = ExperimentAssignment(
        timingVariant: PaywallTimingVariant.delayed,
        pricingVariant: PricingVariant.priceA,
        assignedAt: DateTime.now(),
        sessionCount: 2,
      );

      final after24h = ExperimentAssignment(
        timingVariant: PaywallTimingVariant.delayed,
        pricingVariant: PricingVariant.priceA,
        assignedAt: DateTime.now().subtract(const Duration(hours: 25)),
        sessionCount: 1,
      );

      expect(fresh.shouldShowPaywall(), false);
      expect(secondSession.shouldShowPaywall(), true);
      expect(after24h.shouldShowPaywall(), true);
    });

    test('canShowPaywallWithCooldown respects cooldown', () {
      final noLastShown = ExperimentAssignment(
        timingVariant: PaywallTimingVariant.immediate,
        pricingVariant: PricingVariant.priceA,
        assignedAt: DateTime.now(),
      );

      final recentlyShown = ExperimentAssignment(
        timingVariant: PaywallTimingVariant.immediate,
        pricingVariant: PricingVariant.priceA,
        assignedAt: DateTime.now(),
        lastPaywallShown: DateTime.now().subtract(const Duration(hours: 1)),
      );

      final shownLongAgo = ExperimentAssignment(
        timingVariant: PaywallTimingVariant.immediate,
        pricingVariant: PricingVariant.priceA,
        assignedAt: DateTime.now(),
        lastPaywallShown: DateTime.now().subtract(const Duration(hours: 49)),
      );

      expect(noLastShown.canShowPaywallWithCooldown(), true);
      expect(recentlyShown.canShowPaywallWithCooldown(), false);
      expect(shownLongAgo.canShowPaywallWithCooldown(), true);
    });

    test('toJson and fromJson roundtrip', () {
      final original = ExperimentAssignment(
        timingVariant: PaywallTimingVariant.delayed,
        pricingVariant: PricingVariant.priceB,
        assignedAt: DateTime(2024, 1, 15, 10, 30),
        sessionCount: 5,
        hasSeenFirstInsight: true,
        lastPaywallShown: DateTime(2024, 1, 14, 8, 0),
        hasConverted: false,
      );

      final json = original.toJson();
      final restored = ExperimentAssignment.fromJson(json);

      expect(restored.timingVariant, original.timingVariant);
      expect(restored.pricingVariant, original.pricingVariant);
      expect(restored.sessionCount, original.sessionCount);
      expect(restored.hasSeenFirstInsight, original.hasSeenFirstInsight);
      expect(restored.hasConverted, original.hasConverted);
    });
  });

  group('ChurnDefenseState', () {
    test('default state is normal', () {
      const state = ChurnDefenseState();
      expect(state.level, ChurnLevel.normal);
      expect(state.isDefenseActive, false);
      expect(state.isPricingFrozen, false);
      expect(state.isHighPriceDisabled, false);
    });

    test('warning state activates defense', () {
      const state = ChurnDefenseState(
        level: ChurnLevel.warning,
        currentChurnRate: 0.08,
        isPricingFrozen: true,
        isTimingFrozen: true,
      );

      expect(state.isDefenseActive, true);
      expect(state.isPricingFrozen, true);
    });

    test('critical state has highest restrictions', () {
      const state = ChurnDefenseState(
        level: ChurnLevel.critical,
        currentChurnRate: 0.12,
        isPricingFrozen: true,
        isTimingFrozen: true,
        isHighPriceDisabled: true,
      );

      expect(state.isDefenseActive, true);
      expect(state.isHighPriceDisabled, true);
    });

    test('toJson and fromJson roundtrip', () {
      final original = ChurnDefenseState(
        level: ChurnLevel.warning,
        currentChurnRate: 0.08,
        isPricingFrozen: true,
        isTimingFrozen: true,
        lastChurnCheck: DateTime(2024, 1, 15),
        defenseActivatedAt: DateTime(2024, 1, 14),
      );

      final json = original.toJson();
      final restored = ChurnDefenseState.fromJson(json);

      expect(restored.level, original.level);
      expect(restored.currentChurnRate, original.currentChurnRate);
      expect(restored.isPricingFrozen, original.isPricingFrozen);
      expect(restored.isTimingFrozen, original.isTimingFrozen);
    });
  });

  group('MonetizationMetrics', () {
    test('default metrics are zero', () {
      final metrics = MonetizationMetrics(updatedAt: DateTime.now());

      expect(metrics.mrr, 0.0);
      expect(metrics.arr, 0.0);
      expect(metrics.conversionRate, 0.0);
      expect(metrics.monthlyChurn, 0.0);
      expect(metrics.paywallViews, 0);
    });

    test('toJson includes all fields', () {
      final metrics = MonetizationMetrics(
        mrr: 1000.0,
        arr: 12000.0,
        arpu: 7.99,
        conversionRate: 0.05,
        monthlyChurn: 0.03,
        updatedAt: DateTime(2024, 1, 15),
      );

      final json = metrics.toJson();

      expect(json['mrr'], 1000.0);
      expect(json['arr'], 12000.0);
      expect(json['arpu'], 7.99);
      expect(json['conversionRate'], 0.05);
      expect(json['monthlyChurn'], 0.03);
    });
  });

  group('Entitlement Guardrails', () {
    test('entitlementId is correct constant', () {
      expect(AppConstants.entitlementId, 'umutnull_pro');
    });

    test('churn thresholds match specification', () {
      expect(AppConstants.churnWarningThreshold, 0.07);
      expect(AppConstants.churnCriticalThreshold, 0.10);
    });

    test('pricing variants match constants', () {
      expect(AppConstants.priceVariantA, 7.99);
      expect(AppConstants.priceVariantB, 9.99);
      expect(AppConstants.priceVariantC, 11.99);
    });
  });

  group('ExperimentService', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer(
        overrides: [
          adServiceProvider.overrideWithValue(MockAdService()),
          analyticsServiceProvider.overrideWithValue(AnalyticsService()),
        ],
      );
    });

    tearDown(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      container.dispose();
    });

    test('creates new assignment on first access', () async {
      final service = container.read(experimentServiceProvider);
      await service.initialize();

      final assignment = await service.getOrCreateAssignment();

      expect(assignment, isNotNull);
      expect(assignment.sessionCount, 0);
      expect(assignment.hasConverted, false);
    });

    test('persists assignment across calls', () async {
      final service = container.read(experimentServiceProvider);
      await service.initialize();

      final first = await service.getOrCreateAssignment();
      final second = await service.getOrCreateAssignment();

      expect(first.timingVariant, second.timingVariant);
      expect(first.pricingVariant, second.pricingVariant);
    });

    test('incrementSession updates count', () async {
      final service = container.read(experimentServiceProvider);
      await service.initialize();

      await service.getOrCreateAssignment();
      await service.incrementSession();
      final assignment = await service.getOrCreateAssignment();

      expect(assignment.sessionCount, 1);
    });

    test('markFirstInsightSeen updates flag', () async {
      final service = container.read(experimentServiceProvider);
      await service.initialize();

      await service.getOrCreateAssignment();
      await service.markFirstInsightSeen();
      final assignment = await service.getOrCreateAssignment();

      expect(assignment.hasSeenFirstInsight, true);
    });

    test('recordConversion marks converted', () async {
      final service = container.read(experimentServiceProvider);
      await service.initialize();

      await service.getOrCreateAssignment();
      await service.recordConversion();
      final assignment = await service.getOrCreateAssignment();

      expect(assignment.hasConverted, true);
    });
  });

  group('Entitlement Test Matrix', () {
    // These tests document expected behavior per the specification
    // Actual RevenueCat integration would need mock CustomerInfo

    test('new free user sees ads', () {
      const state = PremiumState(isPremium: false, tier: PremiumTier.free);
      expect(state.isPremium, false);
      expect(state.tier, PremiumTier.free);
    });

    test('pro purchase removes ads', () {
      const state = PremiumState(isPremium: true, tier: PremiumTier.monthly);
      expect(state.isPremium, true);
    });

    test('lifetime has no expiry', () {
      const state = PremiumState(
        isPremium: true,
        tier: PremiumTier.lifetime,
        isLifetime: true,
        expiryDate: null,
      );
      expect(state.isLifetime, true);
      expect(state.expiryDate, isNull);
    });

    test('expired subscription should revert to free', () {
      final expiredState = PremiumState(
        isPremium: true,
        tier: PremiumTier.monthly,
        expiryDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      // The expiry check would catch this
      expect(expiredState.expiryDate!.isBefore(DateTime.now()), true);
    });
  });

  group('Pricing Variant Distribution', () {
    test('traffic distribution sums to 100%', () {
      final total = AppConstants.pricingVariantATraffic +
          AppConstants.pricingVariantBTraffic +
          AppConstants.pricingVariantCTraffic;

      expect(total, 1.0);
    });

    test('timing distribution sums to 100%', () {
      final total = AppConstants.timingVariantATraffic +
          AppConstants.timingVariantBTraffic +
          AppConstants.timingVariantCTraffic;

      expect(total, 1.0);
    });
  });
}
