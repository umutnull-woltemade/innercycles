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
}
