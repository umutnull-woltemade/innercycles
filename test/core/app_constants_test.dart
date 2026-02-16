import 'package:flutter_test/flutter_test.dart';
import 'package:inner_cycles/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    group('App Info', () {
      test('appName is InnerCycles', () {
        expect(AppConstants.appName, 'InnerCycles');
      });
    });

    group('URLs', () {
      test('privacyPolicyUrl is valid URL', () {
        expect(
          Uri.tryParse(AppConstants.privacyPolicyUrl)?.hasScheme,
          true,
        );
      });

      test('termsOfServiceUrl is valid URL', () {
        expect(
          Uri.tryParse(AppConstants.termsOfServiceUrl)?.hasScheme,
          true,
        );
      });

      test('supportEmail is valid email format', () {
        expect(AppConstants.supportEmail.contains('@'), true);
      });
    });

    group('RevenueCat', () {
      test('monthlyProductId follows naming convention', () {
        expect(AppConstants.monthlyProductId, contains('monthly'));
      });

      test('yearlyProductId follows naming convention', () {
        expect(AppConstants.yearlyProductId, contains('yearly'));
      });

      test('entitlementId is set', () {
        expect(AppConstants.entitlementId, isNotEmpty);
      });
    });

    group('Storage Keys', () {
      test('userProfileKey is not empty', () {
        expect(AppConstants.userProfileKey, isNotEmpty);
      });

      test('savedChartsKey is not empty', () {
        expect(AppConstants.savedChartsKey, isNotEmpty);
      });

      test('settingsKey is not empty', () {
        expect(AppConstants.settingsKey, isNotEmpty);
      });

      test('onboardingCompleteKey is not empty', () {
        expect(AppConstants.onboardingCompleteKey, isNotEmpty);
      });
    });

    group('Animation Durations', () {
      test('quickAnimation is shortest', () {
        expect(
          AppConstants.quickAnimation.inMilliseconds,
          lessThan(AppConstants.normalAnimation.inMilliseconds),
        );
      });

      test('normalAnimation is in middle', () {
        expect(
          AppConstants.normalAnimation.inMilliseconds,
          lessThan(AppConstants.slowAnimation.inMilliseconds),
        );
        expect(
          AppConstants.normalAnimation.inMilliseconds,
          greaterThan(AppConstants.quickAnimation.inMilliseconds),
        );
      });

      test('slowAnimation is longest', () {
        expect(
          AppConstants.slowAnimation.inMilliseconds,
          greaterThan(AppConstants.normalAnimation.inMilliseconds),
        );
      });
    });

    group('Spacing', () {
      test('spacingXs is smallest', () {
        expect(AppConstants.spacingXs, 4);
      });

      test('spacingSm is 8', () {
        expect(AppConstants.spacingSm, 8);
      });

      test('spacingMd is 12', () {
        expect(AppConstants.spacingMd, 12);
      });

      test('spacingLg is 16', () {
        expect(AppConstants.spacingLg, 16);
      });

      test('spacingXl is 24', () {
        expect(AppConstants.spacingXl, 24);
      });

      test('spacingXxl is 32', () {
        expect(AppConstants.spacingXxl, 32);
      });

      test('spacingHuge is largest', () {
        expect(AppConstants.spacingHuge, 48);
      });

      test('spacing values increase consistently', () {
        expect(AppConstants.spacingXs, lessThan(AppConstants.spacingSm));
        expect(AppConstants.spacingSm, lessThan(AppConstants.spacingMd));
        expect(AppConstants.spacingMd, lessThan(AppConstants.spacingLg));
        expect(AppConstants.spacingLg, lessThan(AppConstants.spacingXl));
        expect(AppConstants.spacingXl, lessThan(AppConstants.spacingXxl));
        expect(AppConstants.spacingXxl, lessThan(AppConstants.spacingHuge));
      });
    });

    group('Border Radius', () {
      test('radiusSm is 8', () {
        expect(AppConstants.radiusSm, 8);
      });

      test('radiusMd is 12', () {
        expect(AppConstants.radiusMd, 12);
      });

      test('radiusLg is 16', () {
        expect(AppConstants.radiusLg, 16);
      });

      test('radiusXl is 24', () {
        expect(AppConstants.radiusXl, 24);
      });

      test('radiusFull is very large', () {
        expect(AppConstants.radiusFull, 999);
      });

      test('radius values increase consistently', () {
        expect(AppConstants.radiusSm, lessThan(AppConstants.radiusMd));
        expect(AppConstants.radiusMd, lessThan(AppConstants.radiusLg));
        expect(AppConstants.radiusLg, lessThan(AppConstants.radiusXl));
        expect(AppConstants.radiusXl, lessThan(AppConstants.radiusFull));
      });
    });
  });
}
