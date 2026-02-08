// ════════════════════════════════════════════════════════════════════════════
// INTERNAL TECH & CONTENT OBSERVATORY
// ════════════════════════════════════════════════════════════════════════════
//
// Owner-only dashboard for platform visibility and compliance monitoring.
// NOT user-facing - internal control layer only.
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

class ObservatoryScreen extends ConsumerStatefulWidget {
  const ObservatoryScreen({super.key});

  @override
  ConsumerState<ObservatoryScreen> createState() => _ObservatoryScreenState();
}

class _ObservatoryScreenState extends ConsumerState<ObservatoryScreen>
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
    final summaryAsync = ref.watch(observatorySummaryProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark, summaryAsync),
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

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    AsyncValue<ObservatorySummary> summaryAsync,
  ) {
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
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.starGold, AppColors.celestialGold],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.insights,
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
                        'Updated ${_formatTimeAgo(summary.generatedAt)}',
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ref.invalidate(observatorySummaryProvider);
              ref.invalidate(languageCoverageProvider);
              ref.invalidate(safetyMetricsProvider);
              ref.invalidate(platformHealthProvider);
            },
            icon: Icon(
              Icons.refresh,
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            ),
            tooltip: 'Refresh Data',
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildStatusBadge(HealthStatus status) {
    final color = status == HealthStatus.healthy
        ? AppColors.success
        : status == HealthStatus.warning
            ? AppColors.warning
            : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      child: Row(
        children: [
          _buildNavChip(context, isDark, 0, 'Summary', Icons.dashboard),
          _buildNavChip(context, isDark, 1, 'Language', Icons.translate),
          _buildNavChip(context, isDark, 2, 'Content', Icons.library_books),
          _buildNavChip(context, isDark, 3, 'Safety', Icons.security),
          _buildNavChip(context, isDark, 4, 'Platform', Icons.devices),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? AppColors.starGold
                      : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
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
          width: 220,
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
              _buildSidebarItem(context, isDark, 1, 'Language', Icons.translate),
              _buildSidebarItem(context, isDark, 2, 'Content', Icons.library_books),
              _buildSidebarItem(context, isDark, 3, 'Safety', Icons.security),
              _buildSidebarItem(context, isDark, 4, 'Platform', Icons.devices),
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

  // ══════════════════════════════════════════════════════════════════════════
  // TAB: Summary
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildSummaryTab(BuildContext context, bool isDark) {
    final summaryAsync = ref.watch(observatorySummaryProvider);

    return summaryAsync.when(
      data: (summary) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, isDark, 'Quick Metrics', Icons.speed),
            const SizedBox(height: AppConstants.spacingMd),
            _buildQuickMetricsGrid(context, isDark, summary),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(context, isDark, 'Technology Inventory', Icons.memory),
            const SizedBox(height: AppConstants.spacingMd),
            _buildTechnologyList(context, isDark),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildQuickMetricsGrid(
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
        _MetricCard(
          title: 'Language Coverage',
          value: '${summary.languageCoverage.averageCompletion.toStringAsFixed(1)}%',
          subtitle: '4 languages',
          status: summary.languageCoverage.status,
          icon: Icons.translate,
          isDark: isDark,
        ),
        _MetricCard(
          title: 'Content Items',
          value: _formatNumber(summary.contentInventory.totalItems),
          subtitle: '${summary.contentInventory.aiGeneratedPercent.toStringAsFixed(0)}% AI-generated',
          status: summary.contentInventory.status,
          icon: Icons.library_books,
          isDark: isDark,
        ),
        _MetricCard(
          title: 'Safety Hit Rate',
          value: '${summary.safetyMetrics.hitRatePercent.toStringAsFixed(2)}%',
          subtitle: '${summary.safetyMetrics.autoRewrites24h} auto-fixes',
          status: summary.safetyMetrics.status,
          icon: Icons.security,
          isDark: isDark,
        ),
        _MetricCard(
          title: 'Platform Status',
          value: summary.platformHealth.webBuild.status == BuildStatusType.success
              ? 'All Green'
              : 'Issues',
          subtitle: 'Web + iOS',
          status: summary.platformHealth.status,
          icon: Icons.devices,
          isDark: isDark,
        ),
      ],
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildTechnologyList(BuildContext context, bool isDark) {
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
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
        itemBuilder: (context, index) {
          final engine = inventory.engines[index];
          return ExpansionTile(
            leading: Icon(
              engine.isUserFacing ? Icons.person : Icons.settings,
              color: AppColors.starGold,
              size: 20,
            ),
            title: Text(
              engine.name,
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              engine.purpose,
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 12,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Inputs', engine.inputs.join(', '), isDark),
                    _buildDetailRow('Outputs', engine.outputs.join(', '), isDark),
                    _buildDetailRow('Apple Safety', engine.appleSafetyRole, isDark),
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
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB: Language
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildLanguageTab(BuildContext context, bool isDark) {
    final coverageAsync = ref.watch(languageCoverageProvider);

    return coverageAsync.when(
      data: (coverage) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, isDark, 'Coverage Overview', Icons.pie_chart),
            const SizedBox(height: AppConstants.spacingMd),
            _buildCoverageOverview(context, isDark, coverage),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(context, isDark, 'Per-Language Status', Icons.language),
            const SizedBox(height: AppConstants.spacingMd),
            _buildLocaleGrid(context, isDark, coverage),
            if (coverage.missingTranslations.isNotEmpty) ...[
              const SizedBox(height: AppConstants.spacingXl),
              _buildSectionTitle(
                context,
                isDark,
                'Missing Translations (${coverage.missingTranslations.length})',
                Icons.warning_amber,
              ),
              const SizedBox(height: AppConstants.spacingMd),
              _buildMissingTranslationsList(context, isDark, coverage.missingTranslations),
            ],
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildCoverageOverview(
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn(
            context,
            isDark,
            'Total Strings',
            _formatNumber(coverage.totalStrings),
            Icons.text_fields,
          ),
          _buildStatColumn(
            context,
            isDark,
            'Avg Coverage',
            '${coverage.averageCompletion.toStringAsFixed(1)}%',
            Icons.check_circle,
          ),
          _buildStatColumn(
            context,
            isDark,
            'Hardcoded',
            coverage.hardcodedCount.toString(),
            Icons.error_outline,
          ),
          _buildStatColumn(
            context,
            isDark,
            'Missing',
            coverage.missingTranslations.length.toString(),
            Icons.warning,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildStatColumn(
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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
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

  Widget _buildLocaleGrid(
    BuildContext context,
    bool isDark,
    LanguageCoverage coverage,
  ) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
      crossAxisSpacing: AppConstants.spacingMd,
      mainAxisSpacing: AppConstants.spacingMd,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: coverage.locales.values.map((locale) {
        return _LocaleCard(locale: locale, isDark: isDark);
      }).toList(),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildMissingTranslationsList(
    BuildContext context,
    bool isDark,
    List<MissingTranslation> missing,
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
        itemCount: missing.length.clamp(0, 20),
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
        itemBuilder: (context, index) {
          final item = missing[index];
          return ListTile(
            dense: true,
            leading: Icon(
              Icons.warning_amber,
              color: AppColors.warning,
              size: 18,
            ),
            title: Text(
              item.key,
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
            subtitle: Text(
              'Missing: ${item.missingLocales.join(", ")}',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 11,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.starGold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.namespace,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.starGold,
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB: Content
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildContentTab(BuildContext context, bool isDark) {
    final inventoryAsync = ref.watch(contentInventoryProvider);

    return inventoryAsync.when(
      data: (inventory) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, isDark, 'Content Overview', Icons.analytics),
            const SizedBox(height: AppConstants.spacingMd),
            _buildContentOverview(context, isDark, inventory),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(context, isDark, 'By Category', Icons.category),
            const SizedBox(height: AppConstants.spacingMd),
            _buildCategoryBreakdown(context, isDark, inventory),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(context, isDark, 'Growth Trend', Icons.trending_up),
            const SizedBox(height: AppConstants.spacingMd),
            _buildGrowthTrend(context, isDark, inventory),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildContentOverview(
    BuildContext context,
    bool isDark,
    ContentInventory inventory,
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
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Content Items',
                      style: TextStyle(
                        color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _formatNumber(inventory.totalItems),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.starGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.spacingLg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Static: ${inventory.staticCount}',
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.auroraStart,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'AI: ${inventory.aiGeneratedCount}',
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                Expanded(
                  flex: (100 - inventory.aiGeneratedPercent).round(),
                  child: Container(
                    height: 8,
                    color: AppColors.success,
                  ),
                ),
                Expanded(
                  flex: inventory.aiGeneratedPercent.round(),
                  child: Container(
                    height: 8,
                    color: AppColors.auroraStart,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildCategoryBreakdown(
    BuildContext context,
    bool isDark,
    ContentInventory inventory,
  ) {
    final colors = [
      AppColors.starGold,
      AppColors.auroraStart,
      AppColors.twilightEnd,
      AppColors.success,
      AppColors.celestialGold,
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
        children: inventory.byCategory.entries.toList().asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          final total = inventory.totalItems;
          final percent = total > 0 ? (category.value / total) * 100 : 0.0;

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
                        color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${_formatNumber(category.value)} (${percent.toStringAsFixed(0)}%)',
                      style: TextStyle(
                        color: colors[index % colors.length],
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
                    value: percent / 100,
                    backgroundColor: colors[index % colors.length].withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation(colors[index % colors.length]),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildGrowthTrend(
    BuildContext context,
    bool isDark,
    ContentInventory inventory,
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '+${inventory.growth.last7Days}',
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Last 7 days',
                    style: TextStyle(
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
              Column(
                children: [
                  Text(
                    '+${inventory.growth.last30Days}',
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Last 30 days',
                    style: TextStyle(
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB: Safety
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildSafetyTab(BuildContext context, bool isDark) {
    final safetyAsync = ref.watch(safetyMetricsProvider);

    return safetyAsync.when(
      data: (safety) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSafetyHeader(context, isDark, safety),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(context, isDark, 'Last 24 Hours', Icons.schedule),
            const SizedBox(height: AppConstants.spacingMd),
            _buildSafetyMetricsGrid(context, isDark, safety),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(context, isDark, 'Top Triggered Patterns', Icons.pattern),
            const SizedBox(height: AppConstants.spacingMd),
            _buildPatternsList(context, isDark, safety.topPatterns),
            if (safety.recentEvents.isNotEmpty) ...[
              const SizedBox(height: AppConstants.spacingXl),
              _buildSectionTitle(context, isDark, 'Recent Events', Icons.history),
              const SizedBox(height: AppConstants.spacingMd),
              _buildRecentEventsList(context, isDark, safety.recentEvents),
            ],
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildSafetyHeader(
    BuildContext context,
    bool isDark,
    SafetyMetrics safety,
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
          _buildStatusBadge(safety.status),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Status: ${safety.status.label}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Review Mode: ${safety.reviewMode.mode.label}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              // Toggle review-safe mode
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Review-Safe mode toggle coming soon')),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.starGold,
              side: BorderSide(color: AppColors.starGold.withValues(alpha: 0.5)),
            ),
            child: const Text('Activate Review-Safe'),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildSafetyMetricsGrid(
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
        _SafetyMetricCard(
          title: 'Content Processed',
          value: _formatNumber(safety.contentProcessed24h),
          isDark: isDark,
          color: AppColors.starGold,
        ),
        _SafetyMetricCard(
          title: 'Filter Hits',
          value: safety.filterHits24h.toString(),
          subtitle: '${safety.hitRatePercent.toStringAsFixed(2)}%',
          isDark: isDark,
          color: safety.filterHits24h > 50 ? AppColors.warning : AppColors.success,
        ),
        _SafetyMetricCard(
          title: 'Auto-Rewrites',
          value: safety.autoRewrites24h.toString(),
          subtitle: '${safety.rewriteSuccessPercent.toStringAsFixed(0)}% success',
          isDark: isDark,
          color: AppColors.success,
        ),
        _SafetyMetricCard(
          title: 'Blocks',
          value: safety.runtimeBlocks24h.toString(),
          isDark: isDark,
          color: safety.runtimeBlocks24h > 0 ? AppColors.error : AppColors.success,
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildPatternsList(
    BuildContext context,
    bool isDark,
    List<PatternHit> patterns,
  ) {
    if (patterns.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.7)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        child: Center(
          child: Text(
            'No patterns triggered recently',
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ),
      );
    }

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
        itemCount: patterns.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
        itemBuilder: (context, index) {
          final pattern = patterns[index];
          return ListTile(
            dense: true,
            leading: Icon(
              Icons.pattern,
              color: AppColors.warning,
              size: 18,
            ),
            title: Text(
              '"${pattern.pattern}"',
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
            subtitle: Text(
              'Last hit: ${_formatTimeAgo(pattern.lastHit)}',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 11,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${pattern.hitCount} hits',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warning,
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildRecentEventsList(
    BuildContext context,
    bool isDark,
    List<SafetyEvent> events,
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
        itemCount: events.length.clamp(0, 10),
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
        itemBuilder: (context, index) {
          final event = events[index];
          final color = event.type == SafetyEventType.block
              ? AppColors.error
              : event.type == SafetyEventType.rewrite
                  ? AppColors.success
                  : AppColors.warning;

          return ListTile(
            dense: true,
            leading: Icon(
              event.type == SafetyEventType.block
                  ? Icons.block
                  : event.type == SafetyEventType.rewrite
                      ? Icons.autorenew
                      : Icons.warning,
              color: color,
              size: 18,
            ),
            title: Text(
              event.type.label,
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                fontSize: 13,
              ),
            ),
            subtitle: Text(
              event.patternMatched ?? event.context,
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 11,
              ),
            ),
            trailing: Text(
              _formatTimeAgo(event.timestamp),
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 11,
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB: Platform
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildPlatformTab(BuildContext context, bool isDark) {
    final platformAsync = ref.watch(platformHealthProvider);

    return platformAsync.when(
      data: (platform) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, isDark, 'Platform Status', Icons.devices),
            const SizedBox(height: AppConstants.spacingMd),
            _buildPlatformStatusGrid(context, isDark, platform),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(context, isDark, 'CI Pipelines', Icons.account_tree),
            const SizedBox(height: AppConstants.spacingMd),
            _buildCIPipelinesList(context, isDark, platform.ciWorkflows),
            const SizedBox(height: AppConstants.spacingXl),
            _buildSectionTitle(context, isDark, 'Build History', Icons.history),
            const SizedBox(height: AppConstants.spacingMd),
            _buildBuildHistory(context, isDark, platform.buildHistory),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildPlatformStatusGrid(
    BuildContext context,
    bool isDark,
    PlatformHealth platform,
  ) {
    return Row(
      children: [
        Expanded(
          child: _PlatformCard(
            title: 'Web',
            buildStatus: platform.webBuild,
            performance: platform.webPerformance,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _PlatformCard(
            title: 'iOS',
            buildStatus: platform.iosBuild,
            performance: platform.iosPerformance,
            isDark: isDark,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildCIPipelinesList(
    BuildContext context,
    bool isDark,
    List<CIWorkflow> workflows,
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
        itemCount: workflows.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
        itemBuilder: (context, index) {
          final workflow = workflows[index];
          final statusColor = workflow.status == BuildStatusType.success
              ? AppColors.success
              : workflow.status == BuildStatusType.failed
                  ? AppColors.error
                  : AppColors.warning;

          return ListTile(
            leading: Icon(
              workflow.status == BuildStatusType.success
                  ? Icons.check_circle
                  : workflow.status == BuildStatusType.failed
                      ? Icons.error
                      : Icons.warning,
              color: statusColor,
              size: 20,
            ),
            title: Text(
              workflow.name,
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                fontSize: 13,
              ),
            ),
            subtitle: workflow.completedAt != null
                ? Text(
                    _formatTimeAgo(workflow.completedAt!),
                    style: TextStyle(
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      fontSize: 11,
                    ),
                  )
                : null,
            trailing: workflow.duration != null
                ? Text(
                    _formatDuration(workflow.duration!),
                    style: TextStyle(
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      fontSize: 11,
                    ),
                  )
                : null,
          );
        },
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildBuildHistory(
    BuildContext context,
    bool isDark,
    List<BuildHistoryEntry> history,
  ) {
    // Group by platform
    final webBuilds = history.where((b) => b.platform == 'web').take(21).toList();
    final iosBuilds = history.where((b) => b.platform == 'ios').take(8).toList();

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
            'Web (${webBuilds.length} builds)',
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: webBuilds.map((build) {
              return Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: build.status == BuildStatusType.success
                      ? AppColors.success
                      : build.status == BuildStatusType.warning
                          ? AppColors.warning
                          : AppColors.error,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'iOS (${iosBuilds.length} builds)',
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: iosBuilds.map((build) {
              return Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: build.status == BuildStatusType.success
                      ? AppColors.success
                      : build.status == BuildStatusType.warning
                          ? AppColors.warning
                          : AppColors.error,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

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

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}

// ════════════════════════════════════════════════════════════════════════════
// WIDGET: Metric Card
// ════════════════════════════════════════════════════════════════════════════

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final HealthStatus status;
  final IconData icon;
  final bool isDark;

  const _MetricCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.status,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = status == HealthStatus.healthy
        ? AppColors.success
        : status == HealthStatus.warning
            ? AppColors.warning
            : AppColors.error;

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
                width: 8,
                height: 8,
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
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 10,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// WIDGET: Locale Card
// ════════════════════════════════════════════════════════════════════════════

class _LocaleCard extends StatelessWidget {
  final LocaleCoverage locale;
  final bool isDark;

  const _LocaleCard({required this.locale, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final statusColor = locale.status == HealthStatus.healthy
        ? AppColors.success
        : locale.status == HealthStatus.warning
            ? AppColors.warning
            : AppColors.error;

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.displayName,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                locale.locale.toUpperCase(),
                style: TextStyle(
                  color: AppColors.starGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '${locale.completionPercent.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: locale.completionPercent / 100,
              backgroundColor: statusColor.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation(statusColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${locale.translatedCount} / ${locale.totalCount}',
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// WIDGET: Safety Metric Card
// ════════════════════════════════════════════════════════════════════════════

class _SafetyMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final bool isDark;
  final Color color;

  const _SafetyMetricCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.isDark,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 10,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// WIDGET: Platform Card
// ════════════════════════════════════════════════════════════════════════════

class _PlatformCard extends StatelessWidget {
  final String title;
  final BuildStatus buildStatus;
  final PerformanceMetrics performance;
  final bool isDark;

  const _PlatformCard({
    required this.title,
    required this.buildStatus,
    required this.performance,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = buildStatus.status == BuildStatusType.success
        ? AppColors.success
        : buildStatus.status == BuildStatusType.failed
            ? AppColors.error
            : AppColors.warning;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  buildStatus.status.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'Build: ${buildStatus.buildNumber}',
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              fontSize: 12,
            ),
          ),
          if (buildStatus.completedAt != null)
            Text(
              'Completed: ${_formatTimeAgo(buildStatus.completedAt!)}',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 11,
              ),
            ),
          const Divider(height: 24),
          if (title == 'Web' && performance.lighthouseScore > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lighthouse',
                  style: TextStyle(
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    fontSize: 11,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${performance.lighthouseScore}',
                      style: TextStyle(
                        color: performance.lighthouseScore >= 90
                            ? AppColors.success
                            : AppColors.warning,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    if (performance.scoreChange != null && performance.scoreChange != 0)
                      Text(
                        ' (${performance.scoreChange! > 0 ? '+' : ''}${performance.scoreChange})',
                        style: TextStyle(
                          color: performance.scoreChange! > 0
                              ? AppColors.success
                              : AppColors.error,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Crash-Free',
                style: TextStyle(
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  fontSize: 11,
                ),
              ),
              Text(
                '${performance.crashFreePercent}%',
                style: TextStyle(
                  color: performance.crashFreePercent >= 99.5
                      ? AppColors.success
                      : AppColors.warning,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cold Start',
                style: TextStyle(
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  fontSize: 11,
                ),
              ),
              Text(
                '${(performance.coldStartMs / 1000).toStringAsFixed(1)}s',
                style: TextStyle(
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
