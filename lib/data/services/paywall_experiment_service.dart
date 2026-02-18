import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import 'analytics_service.dart';

/// Pricing variant for the monthly plan A/B test.
enum PricingVariant {
  a(
    price: AppConstants.priceVariantA,
    label: '\$7.99/mo',
    productId: AppConstants.monthlyProductId799,
  ),
  b(
    price: AppConstants.priceVariantB,
    label: '\$9.99/mo',
    productId: AppConstants.monthlyProductId999,
  ),
  c(
    price: AppConstants.priceVariantC,
    label: '\$11.99/mo',
    productId: AppConstants.monthlyProductId1199,
  );

  final double price;
  final String label;
  final String productId;
  const PricingVariant({
    required this.price,
    required this.label,
    required this.productId,
  });

  /// Monthly equivalent for the yearly plan (displayed as savings anchor).
  String get yearlyEquivalent {
    // Yearly is always ~69% off the monthly variant
    final yearly = (price * 12 * 0.31).roundToDouble();
    final monthly = (yearly / 12);
    return '\$${monthly.toStringAsFixed(2)}/mo';
  }

  /// The yearly price for this variant tier.
  double get yearlyPrice => (price * 12 * 0.31).roundToDouble();

  /// Savings percentage vs monthly.
  int get savingsPercent => ((1 - (yearlyPrice / (price * 12))) * 100).round();
}

/// Timing variant controlling when the first paywall appears.
enum TimingVariant {
  /// Show paywall immediately on first session.
  immediate,

  /// Show paywall after first insight/pattern is generated (default).
  firstInsight,

  /// Delay paywall until 3rd session.
  delayed,
}

/// Manages A/B test experiment assignment and tracking.
class PaywallExperimentService {
  static const String _pricingKey = 'ic_experiment_pricing';
  static const String _timingKey = 'ic_experiment_timing';
  static const String _assignedAtKey = 'ic_experiment_assigned_at';
  static const String _sessionCountKey = 'ic_experiment_session_count';

  final SharedPreferences _prefs;
  final AnalyticsService? _analytics;

  late final PricingVariant pricingVariant;
  late final TimingVariant timingVariant;

  PaywallExperimentService._(this._prefs, this._analytics) {
    _loadOrAssign();
  }

  static Future<PaywallExperimentService> init({
    AnalyticsService? analytics,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return PaywallExperimentService._(prefs, analytics);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ASSIGNMENT
  // ═══════════════════════════════════════════════════════════════════════════

  void _loadOrAssign() {
    final existingPricing = _prefs.getString(_pricingKey);
    final existingTiming = _prefs.getString(_timingKey);

    if (existingPricing != null && existingTiming != null) {
      pricingVariant = PricingVariant.values.firstWhere(
        (v) => v.name == existingPricing,
        orElse: () => PricingVariant.a,
      );
      timingVariant = TimingVariant.values.firstWhere(
        (v) => v.name == existingTiming,
        orElse: () => TimingVariant.firstInsight,
      );
      return;
    }

    // First-time assignment using weighted random
    final random = Random();

    // Pricing: A=50%, B=30%, C=20%
    final pricingRoll = random.nextDouble();
    if (pricingRoll < AppConstants.pricingVariantATraffic) {
      pricingVariant = PricingVariant.a;
    } else if (pricingRoll <
        AppConstants.pricingVariantATraffic +
            AppConstants.pricingVariantBTraffic) {
      pricingVariant = PricingVariant.b;
    } else {
      pricingVariant = PricingVariant.c;
    }

    // Timing: A=25%, B=50%, C=25%
    final timingRoll = random.nextDouble();
    if (timingRoll < AppConstants.timingVariantATraffic) {
      timingVariant = TimingVariant.immediate;
    } else if (timingRoll <
        AppConstants.timingVariantATraffic +
            AppConstants.timingVariantBTraffic) {
      timingVariant = TimingVariant.firstInsight;
    } else {
      timingVariant = TimingVariant.delayed;
    }

    // Persist
    _prefs.setString(_pricingKey, pricingVariant.name);
    _prefs.setString(_timingKey, timingVariant.name);
    _prefs.setString(_assignedAtKey, DateTime.now().toIso8601String());

    // Log assignment
    _analytics?.logExperimentAssignment(
      timingVariant: timingVariant.name,
      pricingVariant: pricingVariant.name,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SESSION TRACKING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Increment and return session count. Call once per app launch.
  int incrementSession() {
    final count = (_prefs.getInt(_sessionCountKey) ?? 0) + 1;
    _prefs.setInt(_sessionCountKey, count);
    return count;
  }

  int get sessionCount => _prefs.getInt(_sessionCountKey) ?? 0;

  // ═══════════════════════════════════════════════════════════════════════════
  // TIMING GATE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Whether the paywall should be shown based on the timing variant.
  /// [hasGeneratedInsight] = true if user has completed at least one analysis.
  bool shouldShowPaywall({required bool hasGeneratedInsight}) {
    switch (timingVariant) {
      case TimingVariant.immediate:
        return true;
      case TimingVariant.firstInsight:
        return hasGeneratedInsight;
      case TimingVariant.delayed:
        return sessionCount >= 3;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ANALYTICS HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Log when a paywall is viewed.
  void logPaywallView() {
    _analytics?.logPaywallView(
      timingVariant: timingVariant.name,
      pricingVariant: pricingVariant.name,
      price: pricingVariant.price,
      sessionCount: sessionCount,
    );
  }

  /// Log when a paywall converts to purchase.
  void logPaywallConversion() {
    final assignedAt = _prefs.getString(_assignedAtKey);
    int hoursToConvert = 0;
    if (assignedAt != null) {
      final parsed = DateTime.tryParse(assignedAt);
      if (parsed != null) {
        hoursToConvert = DateTime.now().difference(parsed).inHours;
      }
    }

    _analytics?.logPaywallConversion(
      timingVariant: timingVariant.name,
      pricingVariant: pricingVariant.name,
      price: pricingVariant.price,
      hoursToConvert: hoursToConvert,
    );
  }

  /// Log when a paywall is dismissed.
  void logPaywallDismissal() {
    _analytics?.logPaywallDismissal(
      timingVariant: timingVariant.name,
      pricingVariant: pricingVariant.name,
      sessionCount: sessionCount,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPLAY HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// The monthly price to display (from assigned variant).
  double get monthlyPrice => pricingVariant.price;

  /// The monthly price label (e.g. "$7.99/mo").
  String get monthlyPriceLabel => pricingVariant.label;

  /// The yearly plan's per-month equivalent (e.g. "$2.50/mo").
  String get yearlyMonthlyEquivalent => pricingVariant.yearlyEquivalent;

  /// The savings percentage for yearly vs monthly.
  int get yearlySavingsPercent => pricingVariant.savingsPercent;
}

/// Provider
final paywallExperimentProvider = FutureProvider<PaywallExperimentService>((
  ref,
) async {
  final analytics = ref.watch(analyticsServiceProvider);
  return PaywallExperimentService.init(analytics: analytics);
});
