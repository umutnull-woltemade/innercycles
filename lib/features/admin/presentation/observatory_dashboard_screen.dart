// ════════════════════════════════════════════════════════════════════════════
// OBSERVATORY DASHBOARD SCREEN
// ════════════════════════════════════════════════════════════════════════════
//
// Internal Tech & Content Observatory - Owner-Only Platform Control System
// Provides comprehensive visibility into platform health, content, and safety.
//
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/observatory_models.dart';
import '../../../data/services/admin_auth_service.dart';
import '../../../data/services/observatory_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

class ObservatoryDashboardScreen extends ConsumerStatefulWidget {
  const ObservatoryDashboardScreen({super.key});

  @override
  ConsumerState<ObservatoryDashboardScreen> createState() =>
      _ObservatoryDashboardScreenState();
}

class _ObservatoryDashboardScreenState
    extends ConsumerState<ObservatoryDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
    final summaryAsync = ref.watch(observatorySummaryProvider);

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
            onPressed: () => context.go(Routes.admin),
            icon: Icon(
              Icons.arrow_back_ios_new,
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
            child: const Icon(Icons.insights, color: Colors.white, size: 24),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tech & Content Observatory',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.starGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                summaryAsync.when(
                  data: (summary) => Row(
                    children: [
                      _buildStatusBadge(summary.overallStatus),
                      const SizedBox(width: 8),
                      Text(
                        'Last updated: ${_formatTime(summary.generatedAt)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                  loading: () => Text(
                    'Loading...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  error: (_, _) => Text(
                    'Error loading data',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ref.invalidate(observatorySummaryProvider);
              ref.invalidate(languageCoverageProvider);
              ref.invalidate(contentInventoryProvider);
              ref.invalidate(safetyMetricsProvider);
              ref.invalidate(platformHealthProvider);
            },
            icon: Icon(
              Icons.refresh,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
            tooltip: 'Refresh Data',
          ),
          IconButton(
            onPressed: () => _showExportDialog(context),
            icon: Icon(
              Icons.download,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
            tooltip: 'Export Report',
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildStatusBadge(HealthStatus status) {
    final color = switch (status) {
      HealthStatus.healthy => AppColors.success,
      HealthStatus.warning => AppColors.warning,
      HealthStatus.critical => AppColors.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            status.label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isDark) {
    return Column(
      children: [
        _buildMobileNavigation(context, isDark),
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildSummaryTab(context, isDark),
              _buildLanguageTab(context, isDark),
              _buildContentTab(context, isDark),
              _buildSafetyTab(context, isDark),
              _buildPlatformTab(context, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileNavigation(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildNavChip(context, isDark, 0, 'Summary', Icons.dashboard),
            _buildNavChip(context, isDark, 1, 'Language', Icons.translate),
            _buildNavChip(context, isDark, 2, 'Content', Icons.article),
            _buildNavChip(context, isDark, 3, 'Safety', Icons.shield),
            _buildNavChip(context, isDark, 4, 'Platform', Icons.build),
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.starGold.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            border: isSelected
                ? Border.all(color: AppColors.starGold.withValues(alpha: 0.5))
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? AppColors.starGold
                    : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? AppColors.starGold
                      : (isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isDark) {
    return Row(
      children: [
        Container(
          width: 200,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.5)
                : AppColors.lightSurfaceVariant,
            border: Border(
              right: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            children: [
              _buildSidebarItem(context, isDark, 0, 'Summary', Icons.dashboard),
              _buildSidebarItem(
                context,
                isDark,
                1,
                'Language',
                Icons.translate,
              ),
              _buildSidebarItem(context, isDark, 2, 'Content', Icons.article),
              _buildSidebarItem(context, isDark, 3, 'Safety', Icons.shield),
              _buildSidebarItem(context, isDark, 4, 'Platform', Icons.build),
            ],
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildSummaryTab(context, isDark),
              _buildLanguageTab(context, isDark),
              _buildContentTab(context, isDark),
              _buildSafetyTab(context, isDark),
              _buildPlatformTab(context, isDark),
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
  // TAB: Summary - Overall Health
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildSummaryTab(BuildContext context, bool isDark) {
    final summaryAsync = ref.watch(observatorySummaryProvider);

    return summaryAsync.when(
      data: (summary) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              context,
              isDark,
              'System Status',
              Icons.dashboard,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            _buildStatusGrid(context, isDark, summary),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(
              context,
              isDark,
              'Technology Inventory',
              Icons.memory,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            _buildTechInventory(context, isDark),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('Error: $error', style: TextStyle(color: AppColors.error)),
      ),
    );
  }

  Widget _buildStatusGrid(
    BuildContext context,
    bool isDark,
    ObservatorySummary summary,
  ) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
      crossAxisSpacing: AppConstants.spacingMd,
      mainAxisSpacing: AppConstants.spacingMd,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _StatusCard(
          title: 'Language',
          value:
              '${summary.languageCoverage.averageCompletion.toStringAsFixed(1)}%',
          subtitle: '${summary.languageCoverage.totalStrings} strings',
          status: summary.languageCoverage.status,
          icon: Icons.translate,
          isDark: isDark,
        ),
        _StatusCard(
          title: 'Content',
          value: '${summary.contentInventory.totalItems}',
          subtitle: '+${summary.contentInventory.growth.last7Days} (7d)',
          status: summary.contentInventory.status,
          icon: Icons.article,
          isDark: isDark,
        ),
        _StatusCard(
          title: 'Safety',
          value: '${summary.safetyMetrics.hitRatePercent.toStringAsFixed(2)}%',
          subtitle: '${summary.safetyMetrics.filterHits24h} hits (24h)',
          status: summary.safetyMetrics.status,
          icon: Icons.shield,
          isDark: isDark,
        ),
        _StatusCard(
          title: 'Platform',
          value: summary.platformHealth.webBuild.status.label,
          subtitle: summary.platformHealth.webBuild.buildNumber,
          status: summary.platformHealth.status,
          icon: Icons.build,
          isDark: isDark,
        ),
      ],
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildTechInventory(BuildContext context, bool isDark) {
    final inventory = ref.watch(technologyInventoryProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: inventory.engines.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
        itemBuilder: (context, index) {
          final engine = inventory.engines[index];
          return ExpansionTile(
            leading: Icon(
              engine.isUserFacing ? Icons.person : Icons.settings,
              color: engine.isUserFacing
                  ? AppColors.auroraStart
                  : AppColors.starGold,
              size: 20,
            ),
            title: Text(
              engine.name,
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              engine.purpose,
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 12,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color:
                    (engine.isUserFacing
                            ? AppColors.auroraStart
                            : AppColors.starGold)
                        .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                engine.isUserFacing ? 'USER' : 'INTERNAL',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: engine.isUserFacing
                      ? AppColors.auroraStart
                      : AppColors.starGold,
                ),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Inputs', engine.inputs.join(', '), isDark),
                    _buildDetailRow(
                      'Outputs',
                      engine.outputs.join(', '),
                      isDark,
                    ),
                    _buildDetailRow(
                      'Safety Role',
                      engine.appleSafetyRole,
                      isDark,
                    ),
                    if (engine.filePath != null)
                      _buildDetailRow('File', engine.filePath!, isDark),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // TAB: Language Coverage
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildLanguageTab(BuildContext context, bool isDark) {
    final coverageAsync = ref.watch(languageCoverageProvider);

    return coverageAsync.when(
      data: (coverage) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              context,
              isDark,
              'Translation Coverage',
              Icons.translate,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            _buildCoverageStats(context, isDark, coverage),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(
              context,
              isDark,
              'Per-Locale Breakdown',
              Icons.language,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            _buildLocaleBreakdown(context, isDark, coverage),
            if (coverage.missingTranslations.isNotEmpty) ...[
              const SizedBox(height: AppConstants.spacingXl),
              _buildSectionTitle(
                context,
                isDark,
                'Missing Translations',
                Icons.warning,
              ),
              const SizedBox(height: AppConstants.spacingMd),
              _buildMissingTranslations(context, isDark, coverage),
            ],
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildCoverageStats(
    BuildContext context,
    bool isDark,
    LanguageCoverage coverage,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              context,
              isDark,
              'Total Strings',
              '${coverage.totalStrings}',
              Icons.text_fields,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              isDark,
              'Avg Coverage',
              '${coverage.averageCompletion.toStringAsFixed(1)}%',
              Icons.pie_chart,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              isDark,
              'Hardcoded',
              '${coverage.hardcodedCount}',
              Icons.warning_amber,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              isDark,
              'Missing',
              '${coverage.missingTranslations.length}',
              Icons.error_outline,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildStatItem(
    BuildContext context,
    bool isDark,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppColors.starGold, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.starGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildLocaleBreakdown(
    BuildContext context,
    bool isDark,
    LanguageCoverage coverage,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: coverage.locales.entries.map((entry) {
          final locale = entry.value;
          final color = _getCoverageColor(locale.completionPercent);
          final flag = _getLocaleFlag(locale.locale);

          return Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        locale.displayName,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '${locale.translatedCount}/${locale.totalCount}',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${locale.completionPercent.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: locale.completionPercent / 100,
                    backgroundColor: color.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildMissingTranslations(
    BuildContext context,
    bool isDark,
    LanguageCoverage coverage,
  ) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: coverage.missingTranslations.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
        itemBuilder: (context, index) {
          final missing = coverage.missingTranslations[index];
          return ListTile(
            dense: true,
            leading: const Icon(
              Icons.warning_amber,
              color: AppColors.warning,
              size: 18,
            ),
            title: Text(
              missing.key,
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
            subtitle: Text(
              'Missing: ${missing.missingLocales.join(", ")}',
              style: TextStyle(color: AppColors.warning, fontSize: 11),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.starGold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                missing.namespace,
                style: const TextStyle(fontSize: 10, color: AppColors.starGold),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  // ═══════════════════════════════════════════════════════════════════
  // TAB: Content Stats
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildContentTab(BuildContext context, bool isDark) {
    final contentAsync = ref.watch(contentInventoryProvider);

    return contentAsync.when(
      data: (content) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              context,
              isDark,
              'Content Inventory',
              Icons.article,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            _buildContentStats(context, isDark, content),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(
              context,
              isDark,
              'Category Distribution',
              Icons.category,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            _buildCategoryChart(context, isDark, content),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildContentStats(
    BuildContext context,
    bool isDark,
    ContentInventory content,
  ) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
      crossAxisSpacing: AppConstants.spacingMd,
      mainAxisSpacing: AppConstants.spacingMd,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricCard(
          context,
          isDark,
          'Total Items',
          '${content.totalItems}',
          Icons.inventory_2,
          AppColors.starGold,
        ),
        _buildMetricCard(
          context,
          isDark,
          'AI Generated',
          '${content.aiGeneratedCount}',
          Icons.auto_awesome,
          AppColors.auroraStart,
        ),
        _buildMetricCard(
          context,
          isDark,
          'Static Content',
          '${content.staticCount}',
          Icons.text_snippet,
          AppColors.twilightEnd,
        ),
        _buildMetricCard(
          context,
          isDark,
          'Growth (7d)',
          '+${content.growth.last7Days}',
          Icons.trending_up,
          AppColors.success,
        ),
      ],
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildMetricCard(
    BuildContext context,
    bool isDark,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChart(
    BuildContext context,
    bool isDark,
    ContentInventory content,
  ) {
    final total = content.byCategory.values.fold<int>(0, (sum, c) => sum + c);
    final colors = [
      AppColors.starGold,
      AppColors.auroraStart,
      AppColors.twilightEnd,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
    ];

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: content.byCategory.entries.toList().asMap().entries.map((
          entry,
        ) {
          final index = entry.key;
          final category = entry.value;
          final pct = total > 0 ? (category.value / total * 100) : 0.0;
          final color = colors[index % colors.length];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.key,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${category.value} (${pct.toStringAsFixed(1)}%)',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct / 100,
                    backgroundColor: color.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  // ═══════════════════════════════════════════════════════════════════
  // TAB: Safety Health
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildSafetyTab(BuildContext context, bool isDark) {
    final safetyAsync = ref.watch(safetyMetricsProvider);

    return safetyAsync.when(
      data: (safety) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, isDark, 'Safety Status', Icons.shield),
            const SizedBox(height: AppConstants.spacingMd),
            _buildSafetyOverview(context, isDark, safety),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(
              context,
              isDark,
              'Last 24 Hours',
              Icons.schedule,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            _buildSafety24hMetrics(context, isDark, safety),
            if (safety.topPatterns.isNotEmpty) ...[
              const SizedBox(height: AppConstants.spacingXl),
              _buildSectionTitle(
                context,
                isDark,
                'Top Triggered Patterns',
                Icons.pattern,
              ),
              const SizedBox(height: AppConstants.spacingMd),
              _buildTopPatterns(context, isDark, safety),
            ],
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildSafetyOverview(
    BuildContext context,
    bool isDark,
    SafetyMetrics safety,
  ) {
    final statusColor = switch (safety.status) {
      HealthStatus.healthy => AppColors.success,
      HealthStatus.warning => AppColors.warning,
      HealthStatus.critical => AppColors.error,
    };

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              switch (safety.status) {
                HealthStatus.healthy => Icons.check_circle,
                HealthStatus.warning => Icons.warning,
                HealthStatus.critical => Icons.error,
              },
              color: statusColor,
              size: 32,
            ),
          ),
          const SizedBox(width: AppConstants.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Status: ${safety.status.label.toUpperCase()}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Review Mode: ${safety.reviewMode.mode.label}',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                Text(
                  'Hit Rate: ${safety.hitRatePercent.toStringAsFixed(2)}% | Rewrite Success: ${safety.rewriteSuccessPercent.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildSafety24hMetrics(
    BuildContext context,
    bool isDark,
    SafetyMetrics safety,
  ) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
      crossAxisSpacing: AppConstants.spacingMd,
      mainAxisSpacing: AppConstants.spacingMd,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricCard(
          context,
          isDark,
          'Content Processed',
          '${safety.contentProcessed24h}',
          Icons.article,
          AppColors.starGold,
        ),
        _buildMetricCard(
          context,
          isDark,
          'Filter Hits',
          '${safety.filterHits24h}',
          Icons.warning_amber,
          AppColors.warning,
        ),
        _buildMetricCard(
          context,
          isDark,
          'Auto-Rewrites',
          '${safety.autoRewrites24h}',
          Icons.auto_fix_high,
          AppColors.auroraStart,
        ),
        _buildMetricCard(
          context,
          isDark,
          'Blocks',
          '${safety.runtimeBlocks24h}',
          Icons.block,
          safety.runtimeBlocks24h > 0 ? AppColors.error : AppColors.success,
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildTopPatterns(
    BuildContext context,
    bool isDark,
    SafetyMetrics safety,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: safety.topPatterns.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
        itemBuilder: (context, index) {
          final pattern = safety.topPatterns[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.warning.withValues(alpha: 0.2),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text(
              '"${pattern.pattern}"',
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
                fontFamily: 'monospace',
                fontSize: 13,
              ),
            ),
            trailing: Text(
              '${pattern.hitCount} hits',
              style: const TextStyle(
                color: AppColors.warning,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  // ═══════════════════════════════════════════════════════════════════
  // TAB: Platform Health
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildPlatformTab(BuildContext context, bool isDark) {
    final platformAsync = ref.watch(platformHealthProvider);

    return platformAsync.when(
      data: (platform) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, isDark, 'Build Status', Icons.build),
            const SizedBox(height: AppConstants.spacingMd),
            _buildBuildStatus(context, isDark, platform),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(context, isDark, 'CI Workflows', Icons.sync),
            const SizedBox(height: AppConstants.spacingMd),
            _buildCIWorkflows(context, isDark, platform),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(context, isDark, 'Performance', Icons.speed),
            const SizedBox(height: AppConstants.spacingMd),
            _buildPerformanceMetrics(context, isDark, platform),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildBuildStatus(
    BuildContext context,
    bool isDark,
    PlatformHealth platform,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildBuildCard(context, isDark, 'Web', platform.webBuild),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _buildBuildCard(context, isDark, 'iOS', platform.iosBuild),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildBuildCard(
    BuildContext context,
    bool isDark,
    String label,
    BuildStatus build,
  ) {
    final statusColor = switch (build.status) {
      BuildStatusType.success => AppColors.success,
      BuildStatusType.failed => AppColors.error,
      BuildStatusType.building => AppColors.warning,
      BuildStatusType.warning => AppColors.warning,
      BuildStatusType.unknown => AppColors.textMuted,
    };

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                label == 'Web' ? Icons.web : Icons.phone_iphone,
                color: statusColor,
              ),
              const SizedBox(width: 8),
              Text(
                '$label Platform',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                switch (build.status) {
                  BuildStatusType.success => Icons.check_circle,
                  BuildStatusType.failed => Icons.error,
                  BuildStatusType.building => Icons.refresh,
                  BuildStatusType.warning => Icons.warning,
                  BuildStatusType.unknown => Icons.help_outline,
                },
                color: statusColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                build.status.label.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Build: ${build.buildNumber}',
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              fontSize: 12,
            ),
          ),
          if (build.commitSha != null)
            Text(
              'Commit: ${build.commitSha}',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          if (build.duration != null)
            Text(
              'Duration: ${_formatDuration(build.duration!)}',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCIWorkflows(
    BuildContext context,
    bool isDark,
    PlatformHealth platform,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: platform.ciWorkflows.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
        itemBuilder: (context, index) {
          final workflow = platform.ciWorkflows[index];
          final statusColor = switch (workflow.status) {
            BuildStatusType.success => AppColors.success,
            BuildStatusType.failed => AppColors.error,
            BuildStatusType.building => AppColors.warning,
            BuildStatusType.warning => AppColors.warning,
            BuildStatusType.unknown => AppColors.textMuted,
          };

          return ListTile(
            leading: Icon(switch (workflow.status) {
              BuildStatusType.success => Icons.check_circle,
              BuildStatusType.failed => Icons.error,
              BuildStatusType.building => Icons.refresh,
              BuildStatusType.warning => Icons.warning,
              BuildStatusType.unknown => Icons.help_outline,
            }, color: statusColor),
            title: Text(
              workflow.name,
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            subtitle: workflow.duration != null
                ? Text(
                    _formatDuration(workflow.duration!),
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                      fontSize: 12,
                    ),
                  )
                : null,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                workflow.status.label,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildPerformanceMetrics(
    BuildContext context,
    bool isDark,
    PlatformHealth platform,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildPerfCard(
            context,
            isDark,
            'Web',
            platform.webPerformance,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _buildPerfCard(
            context,
            isDark,
            'iOS',
            platform.iosPerformance,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildPerfCard(
    BuildContext context,
    bool isDark,
    String label,
    PerformanceMetrics perf,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label Performance',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (perf.lighthouseScore > 0)
            _buildPerfRow(
              'Lighthouse',
              '${perf.lighthouseScore}',
              _getLighthouseColor(perf.lighthouseScore),
              isDark,
            ),
          _buildPerfRow(
            'Crash-Free',
            '${perf.crashFreePercent.toStringAsFixed(1)}%',
            _getCrashFreeColor(perf.crashFreePercent),
            isDark,
          ),
          _buildPerfRow(
            'Cold Start',
            '${perf.coldStartMs}ms',
            _getColdStartColor(perf.coldStartMs),
            isDark,
          ),
          _buildPerfRow(
            'Bundle Size',
            '${perf.bundleSizeMb.toStringAsFixed(1)} MB',
            AppColors.starGold,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPerfRow(String label, String value, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════

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

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 1) {
      return '${duration.inSeconds}s';
    }
    return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
  }

  String _getLocaleFlag(String locale) {
    return switch (locale) {
      'en' => '🇺🇸',
      'tr' => '🇹🇷',
      'de' => '🇩🇪',
      'fr' => '🇫🇷',
      _ => '🌐',
    };
  }

  Color _getCoverageColor(double pct) {
    if (pct >= 99) return AppColors.success;
    if (pct >= 95) return AppColors.warning;
    return AppColors.error;
  }

  Color _getLighthouseColor(int score) {
    if (score >= 90) return AppColors.success;
    if (score >= 70) return AppColors.warning;
    return AppColors.error;
  }

  Color _getCrashFreeColor(double pct) {
    if (pct >= 99.5) return AppColors.success;
    if (pct >= 98) return AppColors.warning;
    return AppColors.error;
  }

  Color _getColdStartColor(int ms) {
    if (ms <= 1500) return AppColors.success;
    if (ms <= 3000) return AppColors.warning;
    return AppColors.error;
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('JSON'),
              subtitle: const Text('Machine-readable format'),
              onTap: () async {
                Navigator.pop(context);
                await _exportReport('json');
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('CSV'),
              subtitle: const Text('Spreadsheet format'),
              onTap: () async {
                Navigator.pop(context);
                await _exportReport('csv');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportReport(String format) async {
    final service = ref.read(observatoryServiceProvider);
    String data;

    if (format == 'csv') {
      data = await service.exportLanguageCoverageCSV();
    } else {
      data = 'JSON export not yet implemented';
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export ready: ${data.length} bytes'),
          backgroundColor: AppColors.starGold,
        ),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STATUS CARD WIDGET
// ═══════════════════════════════════════════════════════════════════════════

class _StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final HealthStatus status;
  final IconData icon;
  final bool isDark;

  const _StatusCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.status,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (status) {
      HealthStatus.healthy => AppColors.success,
      HealthStatus.warning => AppColors.warning,
      HealthStatus.critical => AppColors.error,
    };

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: statusColor, size: 20),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              fontSize: 11,
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
