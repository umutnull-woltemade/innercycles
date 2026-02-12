import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/admin_providers.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/admin_auth_service.dart';
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _checkAuth();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkAuth() {
    if (!AdminAuthService.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(Routes.adminLogin);
        }
      });
    }
  }

  Future<void> _handleLogout() async {
    final lang = ref.read(languageProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.lightSurface,
        title: Text(L10nService.get('admin.logout', lang)),
        content: Text(L10nService.get('admin.logout_confirm', lang)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(L10nService.get('admin.cancel', lang)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(L10nService.get('admin.logout', lang)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AdminAuthService.logout();
      ref.invalidate(adminAuthProvider);
      if (mounted) {
        context.go(Routes.settings);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark),
              Expanded(
                child: isWideScreen
                    ? _buildDesktopLayout(context, isDark)
                    : _buildMobileLayout(context, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final session = AdminAuthService.currentSession;
    final lang = ref.watch(languageProvider);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.8)
            : AppColors.lightCard,
        border: Border(
          bottom: BorderSide(color: AppColors.starGold.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go(Routes.settings),
            icon: Icon(
              Icons.chevron_left,
              size: 28,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('admin.dashboard_title', lang),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.starGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (session != null)
                  Text(
                    L10nService.get(
                      'admin.session_expires',
                      lang,
                    ).replaceAll('{hours}', '${session.remainingTime.inHours}'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ref.invalidate(adminMetricsProvider),
            icon: Icon(
              Icons.refresh,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
            tooltip: L10nService.get('admin.refresh_data', lang),
          ),
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout, color: AppColors.error),
            tooltip: L10nService.get('admin.logout', lang),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildMobileLayout(BuildContext context, bool isDark) {
    return Column(
      children: [
        _buildMobileNavigation(context, isDark),
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildOverviewTab(context, isDark),
              _buildGrowthTab(context, isDark),
              _buildEventsTab(context, isDark),
              _buildNotesTab(context, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileNavigation(BuildContext context, bool isDark) {
    final lang = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      child: Row(
        children: [
          _buildNavChip(
            context,
            isDark,
            0,
            L10nService.get('admin.overview', lang),
            Icons.dashboard,
          ),
          _buildNavChip(
            context,
            isDark,
            1,
            L10nService.get('admin.growth', lang),
            Icons.trending_up,
          ),
          _buildNavChip(
            context,
            isDark,
            2,
            L10nService.get('admin.events', lang),
            Icons.analytics,
          ),
          _buildNavChip(
            context,
            isDark,
            3,
            L10nService.get('admin.notes', lang),
            Icons.note_alt,
          ),
        ],
      ),
    );
  }

  Widget _buildNavChip(
    BuildContext context,
    bool isDark,
    int index,
    String label,
    IconData icon,
  ) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: GestureDetector(
          onTap: () => setState(() => _selectedIndex = index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.starGold.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              border: isSelected
                  ? Border.all(color: AppColors.starGold.withValues(alpha: 0.5))
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? AppColors.starGold
                      : (isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? AppColors.starGold
                        : (isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted),
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isDark) {
    return Row(
      children: [
        // Sidebar
        Container(
          width: 200,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.5)
                : AppColors.lightSurfaceVariant,
            border: Border(
              right: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
          ),
          child: Builder(
            builder: (context) {
              final lang = ref.watch(languageProvider);
              return ListView(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                children: [
                  _buildSidebarItem(
                    context,
                    isDark,
                    0,
                    L10nService.get('admin.overview', lang),
                    Icons.dashboard,
                  ),
                  _buildSidebarItem(
                    context,
                    isDark,
                    1,
                    L10nService.get('admin.growth', lang),
                    Icons.trending_up,
                  ),
                  _buildSidebarItem(
                    context,
                    isDark,
                    2,
                    L10nService.get('admin.events', lang),
                    Icons.analytics,
                  ),
                  _buildSidebarItem(
                    context,
                    isDark,
                    3,
                    L10nService.get('admin.notes', lang),
                    Icons.note_alt,
                  ),
                ],
              );
            },
          ),
        ),
        // Content
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildOverviewTab(context, isDark),
              _buildGrowthTab(context, isDark),
              _buildEventsTab(context, isDark),
              _buildNotesTab(context, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarItem(
    BuildContext context,
    bool isDark,
    int index,
    String label,
    IconData icon,
  ) {
    final isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? AppColors.starGold
              : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColors.starGold
                : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: AppColors.starGold.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
        onTap: () => setState(() => _selectedIndex = index),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // TAB: Overview - KPI Cards + Quick Stats
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildOverviewTab(BuildContext context, bool isDark) {
    final lang = ref.watch(languageProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            context,
            isDark,
            L10nService.get('admin.key_metrics', lang),
            Icons.analytics,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildKpiGrid(context, isDark),
          const SizedBox(height: AppConstants.spacingXl),
          _buildSectionTitle(
            context,
            isDark,
            L10nService.get('admin.usage_overview', lang),
            Icons.pie_chart,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildUsageChart(context, isDark),
          const SizedBox(height: AppConstants.spacingXl),
          _buildSectionTitle(
            context,
            isDark,
            L10nService.get('admin.quick_actions', lang),
            Icons.flash_on,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildQuickActions(context, isDark),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    bool isDark,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: AppColors.starGold, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiGrid(BuildContext context, bool isDark) {
    final metrics = ref.watch(adminMetricsProvider);
    final lang = ref.watch(languageProvider);

    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
      crossAxisSpacing: AppConstants.spacingMd,
      mainAxisSpacing: AppConstants.spacingMd,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _KpiCard(
          title: L10nService.get('admin.d1_return', lang),
          value: '${metrics.d1Return.toStringAsFixed(1)}%',
          change: metrics.d1Change,
          icon: Icons.replay,
          color: AppColors.success,
          isDark: isDark,
        ),
        _KpiCard(
          title: L10nService.get('admin.d7_return', lang),
          value: '${metrics.d7Return.toStringAsFixed(1)}%',
          change: metrics.d7Change,
          icon: Icons.calendar_today,
          color: AppColors.auroraStart,
          isDark: isDark,
        ),
        _KpiCard(
          title: L10nService.get('admin.avg_session', lang),
          value: metrics.avgSessionDepth.toStringAsFixed(1),
          change: metrics.sessionChange,
          icon: Icons.layers,
          color: AppColors.celestialGold,
          isDark: isDark,
        ),
        _KpiCard(
          title: L10nService.get('admin.reco_ctr', lang),
          value: '${metrics.recoCtr.toStringAsFixed(1)}%',
          change: metrics.ctrChange,
          icon: Icons.touch_app,
          color: AppColors.twilightEnd,
          isDark: isDark,
        ),
      ],
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildUsageChart(BuildContext context, bool isDark) {
    final metrics = ref.watch(adminMetricsProvider);
    final lang = ref.watch(languageProvider);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nService.get('admin.tool_usage_distribution', lang),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          ...metrics.toolUsage.entries.map((entry) {
            return _buildUsageBar(
              context,
              isDark,
              entry.key,
              entry.value,
              _getToolColor(entry.key),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Color _getToolColor(String tool) {
    switch (tool.toLowerCase()) {
      case 'rüya izi':
        return AppColors.auroraStart;
      case 'kozmik izi':
        return AppColors.celestialGold;
      case 'tantra':
        return AppColors.warmCrimson;
      case 'tarot':
        return AppColors.twilightEnd;
      case 'numerology':
        return AppColors.success;
      default:
        return AppColors.starGold;
    }
  }

  Widget _buildUsageBar(
    BuildContext context,
    bool isDark,
    String label,
    double percentage,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDark) {
    final lang = ref.watch(languageProvider);
    return Wrap(
      spacing: AppConstants.spacingMd,
      runSpacing: AppConstants.spacingMd,
      children: [
        _buildActionButton(
          context,
          isDark,
          'Observatory',
          Icons.insights,
          () => _showSnackbar('Observatory archived'),
          isHighlighted: true,
        ),
        _buildActionButton(
          context,
          isDark,
          L10nService.get('admin.export_data', lang),
          Icons.download,
          () =>
              _showSnackbar(L10nService.get('admin.export_coming_soon', lang)),
        ),
        _buildActionButton(
          context,
          isDark,
          L10nService.get('admin.clear_cache', lang),
          Icons.cleaning_services,
          () => _showSnackbar(L10nService.get('admin.cache_cleared', lang)),
        ),
        _buildActionButton(
          context,
          isDark,
          L10nService.get('admin.send_test_push', lang),
          Icons.notifications_active,
          () => _showSnackbar(L10nService.get('admin.test_push_sent', lang)),
        ),
        _buildActionButton(
          context,
          isDark,
          L10nService.get('admin.view_logs', lang),
          Icons.article,
          () => setState(() => _selectedIndex = 2),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildActionButton(
    BuildContext context,
    bool isDark,
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isHighlighted = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppColors.starGold.withValues(alpha: 0.15)
                : (isDark
                      ? AppColors.surfaceLight.withValues(alpha: 0.5)
                      : AppColors.lightSurfaceVariant),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(
              color: isHighlighted
                  ? AppColors.starGold.withValues(alpha: 0.5)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.starGold),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isHighlighted
                      ? AppColors.starGold
                      : (isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary),
                  fontWeight: isHighlighted ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // TAB: Growth - Charts & Trends
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildGrowthTab(BuildContext context, bool isDark) {
    final lang = ref.watch(languageProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            context,
            isDark,
            L10nService.get('admin.retention_trends', lang),
            Icons.trending_up,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildRetentionChart(context, isDark),
          const SizedBox(height: AppConstants.spacingXl),
          _buildSectionTitle(
            context,
            isDark,
            L10nService.get('admin.growth_tasks', lang),
            Icons.task_alt,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildGrowthTasksList(context, isDark),
        ],
      ),
    );
  }

  Widget _buildRetentionChart(BuildContext context, bool isDark) {
    final metrics = ref.watch(adminMetricsProvider);
    final lang = ref.watch(languageProvider);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10nService.get('admin.retention_over_time', lang),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Row(
                children: [
                  _buildLegendItem('D1', AppColors.success),
                  const SizedBox(width: 12),
                  _buildLegendItem('D7', AppColors.auroraStart),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Expanded(
            child: _buildSimpleLineChart(
              context,
              isDark,
              metrics.retentionHistory,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }

  Widget _buildSimpleLineChart(
    BuildContext context,
    bool isDark,
    List<RetentionPoint> data,
  ) {
    final lang = ref.watch(languageProvider);
    if (data.isEmpty) {
      return Center(
        child: Text(
          L10nService.get('admin.no_data_available', lang),
          style: TextStyle(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      );
    }

    return CustomPaint(
      size: Size.infinite,
      painter: _SimpleChartPainter(data: data, isDark: isDark),
    );
  }

  Widget _buildGrowthTasksList(BuildContext context, bool isDark) {
    final tasks = ref.watch(growthTasksProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tasks.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            leading: Icon(
              task.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.isCompleted ? AppColors.success : AppColors.starGold,
            ),
            title: Text(
              task.title,
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            subtitle: Text(
              task.category,
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 12,
              ),
            ),
            trailing: _buildPriorityBadge(task.priority),
            onTap: () {
              ref.read(growthTasksProvider.notifier).toggleTask(task.id);
            },
          );
        },
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildPriorityBadge(String priority) {
    final color = priority == 'high'
        ? AppColors.error
        : priority == 'medium'
        ? AppColors.warning
        : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // TAB: Events - Event Log Table
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildEventsTab(BuildContext context, bool isDark) {
    final lang = ref.watch(languageProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            context,
            isDark,
            L10nService.get('admin.event_log', lang),
            Icons.list_alt,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildEventLogTable(context, isDark),
        ],
      ),
    );
  }

  Widget _buildEventLogTable(BuildContext context, bool isDark) {
    final events = ref.watch(eventLogProvider);
    final lang = ref.watch(languageProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.3)
                  : AppColors.lightSurfaceVariant,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppConstants.radiusMd),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    L10nService.get('admin.event', lang),
                    style: _headerStyle(context, isDark),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    L10nService.get('admin.count', lang),
                    style: _headerStyle(context, isDark),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    L10nService.get('admin.last_fired', lang),
                    style: _headerStyle(context, isDark),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          // Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
            ),
            itemBuilder: (context, index) {
              final event = events[index];
              return Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Icon(
                            _getEventIcon(event.name),
                            size: 16,
                            color: _getEventColor(event.name),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              event.name,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        event.count.toString(),
                        style: TextStyle(
                          color: AppColors.starGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        _formatTime(event.lastFired),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  TextStyle _headerStyle(BuildContext context, bool isDark) {
    return TextStyle(
      color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    );
  }

  IconData _getEventIcon(String eventName) {
    if (eventName.contains('page_view')) return Icons.visibility;
    if (eventName.contains('click')) return Icons.touch_app;
    if (eventName.contains('share')) return Icons.share;
    if (eventName.contains('admin')) return Icons.admin_panel_settings;
    if (eventName.contains('recommendation')) return Icons.recommend;
    return Icons.event;
  }

  Color _getEventColor(String eventName) {
    if (eventName.contains('click')) return AppColors.success;
    if (eventName.contains('share')) return AppColors.auroraStart;
    if (eventName.contains('admin')) return AppColors.starGold;
    if (eventName.contains('fail')) return AppColors.error;
    return AppColors.twilightEnd;
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    final lang = ref.read(languageProvider);

    if (diff.inMinutes < 1) return L10nService.get('admin.just_now', lang);
    if (diff.inMinutes < 60) {
      return L10nService.get(
        'admin.minutes_ago',
        lang,
      ).replaceAll('{count}', '${diff.inMinutes}');
    }
    if (diff.inHours < 24) {
      return L10nService.get(
        'admin.hours_ago',
        lang,
      ).replaceAll('{count}', '${diff.inHours}');
    }
    return L10nService.get(
      'admin.days_ago',
      lang,
    ).replaceAll('{count}', '${diff.inDays}');
  }

  // ═══════════════════════════════════════════════════════════════════
  // TAB: Notes & Snapshots
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildNotesTab(BuildContext context, bool isDark) {
    final lang = ref.watch(languageProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            context,
            isDark,
            L10nService.get('admin.snapshots', lang),
            Icons.camera_alt,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildSnapshotsList(context, isDark),
          const SizedBox(height: AppConstants.spacingXl),
          _buildSectionTitle(
            context,
            isDark,
            L10nService.get('admin.admin_notes', lang),
            Icons.sticky_note_2,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildNotesCard(context, isDark),
        ],
      ),
    );
  }

  Widget _buildSnapshotsList(BuildContext context, bool isDark) {
    final snapshots = ref.watch(snapshotsProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: snapshots.isEmpty
          ? Builder(
              builder: (context) {
                final lang = ref.watch(languageProvider);
                return Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingXl),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 48,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          L10nService.get('admin.no_snapshots_yet', lang),
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshots.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.05),
              ),
              itemBuilder: (context, index) {
                final snapshot = snapshots[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.starGold.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.bookmark,
                      size: 20,
                      color: AppColors.starGold,
                    ),
                  ),
                  title: Text(
                    snapshot.title,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  subtitle: Text(
                    _formatTime(snapshot.createdAt),
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                      fontSize: 12,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.expand_more,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                    onPressed: () => _showSnapshotDetail(snapshot),
                  ),
                );
              },
            ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  void _showSnapshotDetail(AdminSnapshot snapshot) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              snapshot.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.starGold),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              snapshot.content,
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, bool isDark) {
    final lang = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: L10nService.get('admin.add_notes_hint', lang),
              hintStyle: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () =>
                    _showSnackbar(L10nService.get('admin.note_saved', lang)),
                icon: const Icon(Icons.save, size: 18),
                label: Text(L10nService.get('admin.save_note', lang)),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.starGold,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.starGold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// KPI Card Widget
// ═══════════════════════════════════════════════════════════════════

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final double change;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isPositive ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 10,
                      color: isPositive ? AppColors.success : AppColors.error,
                    ),
                    Text(
                      '${change.abs().toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isPositive ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Simple Line Chart Painter
// ═══════════════════════════════════════════════════════════════════

class _SimpleChartPainter extends CustomPainter {
  final List<RetentionPoint> data;
  final bool isDark;

  _SimpleChartPainter({required this.data, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final d1Paint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final d7Paint = Paint()
      ..color = AppColors.auroraStart
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()..style = PaintingStyle.fill;

    final d1Path = Path();
    final d7Path = Path();

    final maxY = data
        .map((p) => [p.d1, p.d7])
        .expand((e) => e)
        .reduce((a, b) => a > b ? a : b);
    final xStep = size.width / (data.length - 1);

    for (var i = 0; i < data.length; i++) {
      final x = i * xStep;
      final d1Y = size.height - (data[i].d1 / maxY) * size.height;
      final d7Y = size.height - (data[i].d7 / maxY) * size.height;

      if (i == 0) {
        d1Path.moveTo(x, d1Y);
        d7Path.moveTo(x, d7Y);
      } else {
        d1Path.lineTo(x, d1Y);
        d7Path.lineTo(x, d7Y);
      }

      // Draw dots
      canvas.drawCircle(Offset(x, d1Y), 3, dotPaint..color = AppColors.success);
      canvas.drawCircle(
        Offset(x, d7Y),
        3,
        dotPaint..color = AppColors.auroraStart,
      );
    }

    canvas.drawPath(d1Path, d1Paint);
    canvas.drawPath(d7Path, d7Paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
