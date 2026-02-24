import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers/app_providers.dart' show AppLanguage;
import '../../data/services/l10n_service.dart';

/// Global error fallback widget that prevents white screens.
/// Must NOT depend on ProviderScope or MaterialApp — it can render
/// anywhere in the tree when ErrorWidget.builder fires.
class AppErrorWidget extends StatelessWidget {
  final FlutterErrorDetails details;

  const AppErrorWidget({super.key, required this.details});

  /// Safely fetch an L10n string, falling back to [fallback] if
  /// L10nService hasn't been initialized yet.
  String _safeL10n(String key, String fallback) {
    try {
      final value = L10nService.get(key, AppLanguage.en);
      // L10nService returns [$key] when the key is missing
      if (value.startsWith('[') && value.endsWith(']')) return fallback;
      return value;
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint(
        'AppErrorWidget: Rendering error fallback for: ${details.exception}',
      );
    }

    final title = _safeL10n(
      'widgets.app_error.title',
      'Something went wrong',
    );
    final subtitle = _safeL10n(
      'widgets.app_error.subtitle',
      'Don\'t worry, your data is safe. Try going back to the home screen.',
    );
    final buttonText = _safeL10n(
      'widgets.app_error.back_to_home',
      'Back to Home',
    );

    return Container(
      color: AppColors.deepSpace,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon — premium gold circle (no Material ancestor needed)
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.starGold,
                        AppColors.celestialGold,
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepSpace,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Debug info (only in debug mode)
                if (kDebugMode) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      details.exception.toString().length > 200
                          ? '${details.exception.toString().substring(0, 200)}...'
                          : details.exception.toString(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontFamily: 'monospace',
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Back-to-home button — uses GestureDetector + Container
                // instead of ElevatedButton to avoid requiring Material ancestor.
                Semantics(
                  label: buttonText,
                  button: true,
                  child: GestureDetector(
                    onTap: () {
                      try {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        }
                      } catch (e) {
                        if (kDebugMode) {
                          debugPrint('Navigation failed in error widget: $e');
                        }
                      }
                    },
                    child: Container(
                      width: 200,
                      height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.starGold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: AppColors.deepSpace,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                ),

                const SizedBox(height: 16),

                // Secondary action - reload page (web only)
                if (kIsWeb)
                  Semantics(
                    label: 'Reload Page',
                    button: true,
                    child: GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        debugPrint(
                          'User requested page reload from error widget',
                        );
                      }
                    },
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 44),
                      child: Center(
                        child: Text(
                          _safeL10n(
                            'widgets.app_error.reload_page',
                            'Reload Page',
                          ),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
