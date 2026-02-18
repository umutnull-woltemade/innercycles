// ════════════════════════════════════════════════════════════════════════════
// MAIN SHELL SCREEN - 5-Tab BottomNavigationBar Shell
// ════════════════════════════════════════════════════════════════════════════
// Wraps all tabs with a BottomNavigationBar, preserves state across
// tab switches via StatefulShellRoute.
// Tabs: Home | Journal | Insights | Breathe | Profile
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../data/services/ecosystem_analytics_service.dart';
import '../../data/services/premium_service.dart';

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
      bottomNavigationBar: _buildBottomBar(isDark, isEn),
    );
  }

  Widget _buildBottomBar(bool isDark, bool isEn) {
    final currentIndex = widget.navigationShell.currentIndex;

    final bar = Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepSpace : AppColors.lightBackground,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.textMuted.withValues(alpha: 0.15)
                : AppColors.lightTextMuted.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: isDark
              ? AppColors.starGold
              : AppColors.lightStarGold,
          unselectedItemColor: isDark
              ? AppColors.textMuted
              : AppColors.lightTextMuted,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          enableFeedback: false,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: isEn ? 'Home' : 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.book_outlined),
              activeIcon: const Icon(Icons.book),
              label: isEn ? 'Journal' : 'G\u00fcnl\u00fck',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.insights_outlined),
              activeIcon: const Icon(Icons.insights),
              label: isEn ? 'Insights' : '\u0130\u00e7g\u00f6r\u00fc',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.self_improvement_outlined),
              activeIcon: const Icon(Icons.self_improvement),
              label: isEn ? 'Breathe' : 'Nefes',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: isEn ? 'Profile' : 'Profil',
            ),
          ],
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
