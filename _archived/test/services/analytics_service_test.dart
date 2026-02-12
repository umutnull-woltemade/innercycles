import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/data/services/analytics_service.dart';

void main() {
  group('AnalyticsService', () {
    late AnalyticsService service;

    setUp(() {
      service = AnalyticsService();
    });

    test('initialize completes without error', () async {
      await expectLater(service.initialize(), completes);
    });

    test('logEvent does not throw', () {
      expect(
        () => service.logEvent('test_event'),
        returnsNormally,
      );
    });

    test('logEvent with parameters does not throw', () {
      expect(
        () => service.logEvent('test_event', {'key': 'value'}),
        returnsNormally,
      );
    });

    test('logScreenView does not throw', () {
      expect(
        () => service.logScreenView('TestScreen'),
        returnsNormally,
      );
    });

    test('logScreenView with class does not throw', () {
      expect(
        () => service.logScreenView('TestScreen', screenClass: 'TestClass'),
        returnsNormally,
      );
    });

    test('logPurchase does not throw', () {
      expect(
        () => service.logPurchase(
          productId: 'test_product',
          tier: 'monthly',
          success: true,
        ),
        returnsNormally,
      );
    });

    test('logPurchase with error does not throw', () {
      expect(
        () => service.logPurchase(
          productId: 'test_product',
          tier: 'monthly',
          success: false,
          error: 'Test error',
        ),
        returnsNormally,
      );
    });

    test('logAdEvent does not throw', () {
      expect(
        () => service.logAdEvent('banner', 'loaded'),
        returnsNormally,
      );
    });

    test('logAdEvent with placement does not throw', () {
      expect(
        () => service.logAdEvent('interstitial', 'showed', placement: 'home'),
        returnsNormally,
      );
    });

    test('logFeatureUsage does not throw', () {
      expect(
        () => service.logFeatureUsage('horoscope'),
        returnsNormally,
      );
    });

    test('logHoroscopeView does not throw', () {
      expect(
        () => service.logHoroscopeView('aries', 'daily'),
        returnsNormally,
      );
    });

    test('logChartGeneration does not throw', () {
      expect(
        () => service.logChartGeneration('natal'),
        returnsNormally,
      );
    });

    test('logShare does not throw', () {
      expect(
        () => service.logShare('horoscope', 'instagram'),
        returnsNormally,
      );
    });

    test('logError does not throw', () {
      expect(
        () => service.logError('network', 'Connection failed'),
        returnsNormally,
      );
    });

    test('setUserProperty does not throw', () {
      expect(
        () => service.setUserProperty('sign', 'aries'),
        returnsNormally,
      );
    });

    test('setUserId does not throw', () {
      expect(
        () => service.setUserId('user123'),
        returnsNormally,
      );
    });

    test('setUserId with null does not throw', () {
      expect(
        () => service.setUserId(null),
        returnsNormally,
      );
    });
  });

  group('analyticsServiceProvider', () {
    test('provides AnalyticsService instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(analyticsServiceProvider);
      expect(service, isA<AnalyticsService>());
    });
  });
}
