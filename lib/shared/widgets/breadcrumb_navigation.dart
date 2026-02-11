import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services/l10n_service.dart';

/// Breadcrumb Navigation Widget
/// SEO-friendly breadcrumb trail for hierarchical navigation
class BreadcrumbNavigation extends ConsumerWidget {
  final List<BreadcrumbItem> items;
  final Color? activeColor;
  final Color? inactiveColor;
  final String? _signName;
  final String? _signSymbol;
  final String? _toolName;
  final String? _parentLabel;
  final String? _parentRoute;
  final String? _currentLabel;
  final _BreadcrumbType _type;

  const BreadcrumbNavigation({
    super.key,
    required this.items,
    this.activeColor,
    this.inactiveColor,
  }) : _signName = null,
       _signSymbol = null,
       _toolName = null,
       _parentLabel = null,
       _parentRoute = null,
       _currentLabel = null,
       _type = _BreadcrumbType.custom;

  /// Creates breadcrumbs for a zodiac sign page
  const BreadcrumbNavigation.zodiacSign(
    String signName,
    String signSymbol, {
    super.key,
  }) : items = const [],
       activeColor = null,
       inactiveColor = null,
       _signName = signName,
       _signSymbol = signSymbol,
       _toolName = null,
       _parentLabel = null,
       _parentRoute = null,
       _currentLabel = null,
       _type = _BreadcrumbType.zodiacSign;

  /// Creates breadcrumbs for a tool page
  const BreadcrumbNavigation.tool(
    String toolName,
    String toolRoute, {
    super.key,
  }) : items = const [],
       activeColor = null,
       inactiveColor = null,
       _signName = null,
       _signSymbol = null,
       _toolName = toolName,
       _parentLabel = null,
       _parentRoute = null,
       _currentLabel = null,
       _type = _BreadcrumbType.tool;

  /// Creates breadcrumbs for horoscope page
  const BreadcrumbNavigation.horoscope({super.key})
    : items = const [],
      activeColor = null,
      inactiveColor = null,
      _signName = null,
      _signSymbol = null,
      _toolName = null,
      _parentLabel = null,
      _parentRoute = null,
      _currentLabel = null,
      _type = _BreadcrumbType.horoscope;

  /// Creates breadcrumbs for any nested page
  const BreadcrumbNavigation.nested({
    super.key,
    required String parentLabel,
    required String parentRoute,
    required String currentLabel,
  }) : items = const [],
       activeColor = null,
       inactiveColor = null,
       _signName = null,
       _signSymbol = null,
       _toolName = null,
       _parentLabel = parentLabel,
       _parentRoute = parentRoute,
       _currentLabel = currentLabel,
       _type = _BreadcrumbType.nested;

  List<BreadcrumbItem> _buildItems(LocalizedL10n l10n) {
    final homeLabel = l10n.get('widgets.breadcrumb_navigation.home');
    final horoscopeLabel = l10n.get(
      'widgets.breadcrumb_navigation.horoscope_interpretations',
    );

    switch (_type) {
      case _BreadcrumbType.zodiacSign:
        return [
          BreadcrumbItem(label: homeLabel, route: '/'),
          BreadcrumbItem(label: horoscopeLabel, route: '/horoscope'),
          BreadcrumbItem(label: '$_signSymbol $_signName', route: null),
        ];
      case _BreadcrumbType.tool:
        return [
          BreadcrumbItem(label: homeLabel, route: '/'),
          BreadcrumbItem(label: _toolName!, route: null),
        ];
      case _BreadcrumbType.horoscope:
        return [
          BreadcrumbItem(label: homeLabel, route: '/'),
          BreadcrumbItem(label: horoscopeLabel, route: null),
        ];
      case _BreadcrumbType.nested:
        return [
          BreadcrumbItem(label: homeLabel, route: '/'),
          BreadcrumbItem(label: _parentLabel!, route: _parentRoute),
          BreadcrumbItem(label: _currentLabel!, route: null),
        ];
      case _BreadcrumbType.custom:
        return items;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nServiceProvider);
    final builtItems = _buildItems(l10n);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultActiveColor = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final defaultInactiveColor = isDark
        ? AppColors.textSecondary.withValues(alpha: 0.7)
        : AppColors.lightTextSecondary.withValues(alpha: 0.8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: builtItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == builtItems.length - 1;
          final isClickable = item.route != null && !isLast;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Breadcrumb item
              GestureDetector(
                onTap: isClickable ? () => context.push(item.route!) : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: isClickable
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.03),
                        )
                      : null,
                  child: Text(
                    item.label,
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      fontWeight: isLast ? FontWeight.w600 : FontWeight.w500,
                      color: isLast
                          ? (activeColor ?? defaultActiveColor)
                          : (inactiveColor ?? defaultInactiveColor),
                      decoration: isClickable ? TextDecoration.none : null,
                    ),
                  ),
                ),
              ),
              // Separator
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: inactiveColor ?? defaultInactiveColor,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// Single breadcrumb item
class BreadcrumbItem {
  final String label;
  final String? route;

  const BreadcrumbItem({required this.label, this.route});
}

/// Compact breadcrumb for mobile views
class BreadcrumbNavigationCompact extends StatelessWidget {
  final String parentLabel;
  final String parentRoute;

  const BreadcrumbNavigationCompact({
    super.key,
    required this.parentLabel,
    required this.parentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push(parentRoute),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark
              ? AppColors.surfaceLight.withValues(alpha: 0.1)
              : AppColors.lightSurfaceVariant,
          border: Border.all(
            color: isDark
                ? AppColors.textMuted.withValues(alpha: 0.1)
                : AppColors.lightTextMuted.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_ios,
              size: 12,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              parentLabel,
              style: GoogleFonts.raleway(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal enum to track breadcrumb type
enum _BreadcrumbType { custom, zodiacSign, tool, horoscope, nested }
