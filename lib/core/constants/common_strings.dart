import '../../data/providers/app_providers.dart';
import '../../data/services/l10n_service.dart';

/// Centralized common UI strings that were previously duplicated
/// across 20+ screens as inline `isEn ? '...' : '...'` ternaries.
///
/// All keys resolve through [L10nService] so DE/FR are also covered.
/// Usage:
///   CommonStrings.somethingWentWrong(language)
abstract final class CommonStrings {
  static String somethingWentWrong(AppLanguage lang) =>
      L10nService.get('common.something_went_wrong', lang);

  static String errorLoading(AppLanguage lang) =>
      L10nService.get('common.error_loading', lang);

  static String noEntriesYet(AppLanguage lang) =>
      L10nService.get('common.no_entries_yet', lang);

  static String tryAgain(AppLanguage lang) =>
      L10nService.get('common.try_again', lang);

  static String couldNotShareTryAgain(AppLanguage lang) =>
      L10nService.get('common.could_not_share_try_again', lang);

  static String errorLoadingProgram(AppLanguage lang) =>
      L10nService.get('common.error_loading_program', lang);

  // ═══════════════════════════════════════════════════════════════════════
  // MONTH NAMES
  // ═══════════════════════════════════════════════════════════════════════

  static const monthsShortEn = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const monthsShortTr = [
    'Oca',
    'Şub',
    'Mar',
    'Nis',
    'May',
    'Haz',
    'Tem',
    'Ağu',
    'Eyl',
    'Eki',
    'Kas',
    'Ara',
  ];

  static const monthsFullEn = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const monthsFullTr = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  /// Get short month names for the given language.
  static List<String> monthsShort(AppLanguage lang) =>
      lang == AppLanguage.en ? monthsShortEn : monthsShortTr;

  /// Get full month names for the given language.
  static List<String> monthsFull(AppLanguage lang) =>
      lang == AppLanguage.en ? monthsFullEn : monthsFullTr;

  /// Get short month name by 1-based month index.
  static String monthShort(int month, AppLanguage lang) =>
      monthsShort(lang)[(month - 1).clamp(0, 11)];

  /// Get full month name by 1-based month index.
  static String monthFull(int month, AppLanguage lang) =>
      monthsFull(lang)[(month - 1).clamp(0, 11)];
}
