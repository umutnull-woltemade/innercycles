import 'package:flutter_test/flutter_test.dart';
import 'package:inner_cycles/core/constants/common_strings.dart';
import 'package:inner_cycles/data/providers/app_providers.dart';

void main() {
  group('CommonStrings month names', () {
    test('monthsShortEn has 12 entries', () {
      expect(CommonStrings.monthsShortEn.length, 12);
      expect(CommonStrings.monthsShortEn.first, 'Jan');
      expect(CommonStrings.monthsShortEn.last, 'Dec');
    });

    test('monthsShortTr has 12 entries', () {
      expect(CommonStrings.monthsShortTr.length, 12);
      expect(CommonStrings.monthsShortTr.first, 'Oca');
      expect(CommonStrings.monthsShortTr.last, 'Ara');
    });

    test('monthsFullEn has 12 entries', () {
      expect(CommonStrings.monthsFullEn.length, 12);
      expect(CommonStrings.monthsFullEn[0], 'January');
      expect(CommonStrings.monthsFullEn[5], 'June');
      expect(CommonStrings.monthsFullEn[11], 'December');
    });

    test('monthsFullTr has 12 entries with correct diacritics', () {
      expect(CommonStrings.monthsFullTr.length, 12);
      expect(CommonStrings.monthsFullTr[0], 'Ocak');
      expect(CommonStrings.monthsFullTr[1], 'Şubat');
      expect(CommonStrings.monthsFullTr[7], 'Ağustos');
      expect(CommonStrings.monthsFullTr[10], 'Kasım');
      expect(CommonStrings.monthsFullTr[11], 'Aralık');
    });

    test('monthsShort returns correct list by language', () {
      expect(
        CommonStrings.monthsShort(AppLanguage.en),
        CommonStrings.monthsShortEn,
      );
      expect(
        CommonStrings.monthsShort(AppLanguage.tr),
        CommonStrings.monthsShortTr,
      );
    });

    test('monthsFull returns correct list by language', () {
      expect(
        CommonStrings.monthsFull(AppLanguage.en),
        CommonStrings.monthsFullEn,
      );
      expect(
        CommonStrings.monthsFull(AppLanguage.tr),
        CommonStrings.monthsFullTr,
      );
    });

    test('monthShort returns correct name for 1-based index', () {
      expect(CommonStrings.monthShort(1, AppLanguage.en), 'Jan');
      expect(CommonStrings.monthShort(6, AppLanguage.en), 'Jun');
      expect(CommonStrings.monthShort(12, AppLanguage.en), 'Dec');
      expect(CommonStrings.monthShort(1, AppLanguage.tr), 'Oca');
      expect(CommonStrings.monthShort(12, AppLanguage.tr), 'Ara');
    });

    test('monthFull returns correct name for 1-based index', () {
      expect(CommonStrings.monthFull(1, AppLanguage.en), 'January');
      expect(CommonStrings.monthFull(7, AppLanguage.en), 'July');
      expect(CommonStrings.monthFull(12, AppLanguage.en), 'December');
      expect(CommonStrings.monthFull(1, AppLanguage.tr), 'Ocak');
      expect(CommonStrings.monthFull(6, AppLanguage.tr), 'Haziran');
    });

    test('monthShort clamps out-of-range index', () {
      // 0 should clamp to index 0 (Jan)
      expect(CommonStrings.monthShort(0, AppLanguage.en), 'Jan');
      // 13 should clamp to index 11 (Dec)
      expect(CommonStrings.monthShort(13, AppLanguage.en), 'Dec');
      // Negative should clamp to index 0
      expect(CommonStrings.monthShort(-1, AppLanguage.en), 'Jan');
    });

    test('monthFull clamps out-of-range index', () {
      expect(CommonStrings.monthFull(0, AppLanguage.en), 'January');
      expect(CommonStrings.monthFull(13, AppLanguage.en), 'December');
    });
  });
}
