// ════════════════════════════════════════════════════════════════════════════
// MAIN SHELL SCREEN - 5-Tab Premium Bottom Navigation Shell
// ════════════════════════════════════════════════════════════════════════════
// Wraps all tabs with a custom glass-morphism bottom bar, preserves state
// across tab switches via StatefulShellRoute.
// Tabs: Home | Journal | Insights | Notes | Profile
// ════════════════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_typography.dart';

import '../../core/theme/app_colors.dart';
import '../../data/services/haptic_service.dart';
import '../../data/providers/app_providers.dart';
import '../../data/services/l10n_service.dart';
import '../../data/services/ecosystem_analytics_service.dart';
import '../../data/services/premium_service.dart';
import '../../features/whats_new/presentation/whats_new_modal.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen>
    with WidgetsBindingObserver {
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _hasAnimated = true);

      // Show "What's New" modal on first launch after app update
      // Delayed slightly so the shell animation finishes first
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        final language = ref.read(languageProvider);
        final isEn = language == AppLanguage.en;
        WhatsNewModal.showIfNeeded(context, isEn);
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final notifier = ref.read(premiumProvider.notifier);
      notifier.onAppResumed();
      notifier.checkAndHandleExpiry();
    }
  }

  void _onTabTapped(int index) {
    HapticService.tabChanged();
    final from = widget.navigationShell.currentIndex;
    if (from != index) {
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData((s) => s.trackTabSwitch(from, index));
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;

    return Scaffold(
      body: widget.navigationShell,
      extendBody: true,
      bottomNavigationBar: _buildBottomBar(isDark, isEn),
    );
  }

  Widget _buildBottomBar(bool isDark, bool isEn) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    final currentIndex = widget.navigationShell.currentIndex;

    final tabs = [
      _TabItem(
        icon: CupertinoIcons.house,
        activeIcon: CupertinoIcons.house_fill,
        label: L10nService.get('shared.main_shell.home', language),
      ),
      _TabItem(
        icon: CupertinoIcons.book,
        activeIcon: CupertinoIcons.book_fill,
        label: L10nService.get('shared.main_shell.journal', language),
      ),
      _TabItem(
        icon: CupertinoIcons.chart_bar,
        activeIcon: CupertinoIcons.chart_bar_fill,
        label: L10nService.get('shared.main_shell.insights', language),
      ),
      _TabItem(
        icon: CupertinoIcons.doc_text,
        activeIcon: CupertinoIcons.doc_text_fill,
        label: L10nService.get('shared.main_shell.notes', language),
      ),
      _TabItem(
        icon: CupertinoIcons.person,
        activeIcon: CupertinoIcons.person_fill,
        label: L10nService.get('shared.main_shell.profile', language),
      ),
    ];

    final bar = Container(
      padding: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        // Glass-morphism top edge
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.starGold.withValues(alpha: 0.08)
                : AppColors.lightTextMuted.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            color: isDark
                ? AppColors.deepSpace.withValues(alpha: 0.85)
                : AppColors.lightBackground.withValues(alpha: 0.88),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Row(
                  children: List.generate(tabs.length, (i) {
                    final isSelected = i == currentIndex;
                    return Expanded(
                      child: _NavTab(
                        item: tabs[i],
                        isSelected: isSelected,
                        isDark: isDark,
                        onTap: () => _onTabTapped(i),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (!_hasAnimated) return bar;

    return bar
        .animate()
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TAB ITEM DATA
// ═══════════════════════════════════════════════════════════════════════════

class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// SINGLE NAV TAB — Animated icon + label + glow indicator
// ═══════════════════════════════════════════════════════════════════════════

class _NavTab extends StatelessWidget {
  final _TabItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _NavTab({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? AppColors.starGold : AppColors.lightStarGold;
    final inactiveColor = isDark
        ? AppColors.textMuted.withValues(alpha: 0.6)
        : AppColors.lightTextMuted.withValues(alpha: 0.7);
    final color = isSelected ? activeColor : inactiveColor;

    return Semantics(
      label: item.label,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Glow dot indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                width: isSelected ? 16 : 0,
                height: 2.5,
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: isSelected ? activeColor : Colors.transparent,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),

              // Icon with subtle background for selected state
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 14 : 10,
                  vertical: isSelected ? 6 : 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? activeColor.withValues(alpha: isDark ? 0.1 : 0.08)
                      : Colors.transparent,
                ),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: 22,
                  color: color,
                ),
              ),

              const SizedBox(height: 3),

              // Label
              Text(
                item.label,
                style: isSelected
                    ? AppTypography.elegantAccent(
                        fontSize: 10,
                        color: color,
                        letterSpacing: 0.2,
                      )
                    : AppTypography.elegantAccent(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: color,
                      ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
