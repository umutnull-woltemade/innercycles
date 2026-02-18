// ════════════════════════════════════════════════════════════════════════════
// MAIN SHELL SCREEN - 5-Tab BottomNavigationBar Shell
// ════════════════════════════════════════════════════════════════════════════
// Wraps all tabs with a BottomNavigationBar, preserves state across
// tab switches via StatefulShellRoute.
// Tabs: Today | Tools | Challenges | Library | Profile
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
              icon: const Icon(Icons.today_outlined),
              activeIcon: const Icon(Icons.today),
              label: isEn ? 'Today' : 'Bug\u00fcn',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.grid_view_outlined),
              activeIcon: const Icon(Icons.grid_view_rounded),
              label: isEn ? 'Tools' : 'Ara\u00e7lar',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.flag_outlined),
              activeIcon: const Icon(Icons.flag_rounded),
              label: isEn ? 'Challenges' : 'G\u00f6revler',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.local_library_outlined),
              activeIcon: const Icon(Icons.local_library),
              label: isEn ? 'Library' : 'K\u00fct\u00fcphane',
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
