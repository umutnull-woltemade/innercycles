// ════════════════════════════════════════════════════════════════════════════
// EXPORT SCREEN - Data Export & Backup
// ════════════════════════════════════════════════════════════════════════════
// Export journal data as Text, CSV, or JSON.
// Free: last 7 days (text only). Premium: full history + all formats.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/export_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  ExportFormat _selectedFormat = ExportFormat.text;
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final isPremium = ref.watch(premiumProvider).isPremium;
    final exportAsync = ref.watch(exportServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Export Data' : 'Verileri Dışa Aktar',
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Info card
                    _InfoCard(isDark: isDark, isEn: isEn, isPremium: isPremium),
                    const SizedBox(height: 24),

                    // Entry count
                    exportAsync.when(
                      data: (service) => Column(
                        children: [
                          _EntryCountCard(
                            count: service.totalEntries,
                            isDark: isDark,
                            isEn: isEn,
                            isPremium: isPremium,
                          ),
                          // Locked entries CTA for free users
                          if (!isPremium && service.totalEntries > 7) ...[
                            const SizedBox(height: 12),
                            _LockedEntriesCta(
                              totalEntries: service.totalEntries,
                              lockedEntries: service.totalEntries - 7,
                              isDark: isDark,
                              isEn: isEn,
                              onUnlock: () => showContextualPaywall(
                                context,
                                ref,
                                paywallContext: PaywallContext.export,
                                entryCount: service.totalEntries,
                              ),
                            ),
                          ],
                        ],
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (e, s) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 24),

                    // Format selector
                    Text(
                      isEn ? 'Export Format' : 'Dışa Aktarma Formatı',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _FormatOption(
                      format: ExportFormat.text,
                      title: isEn ? 'Plain Text' : 'Düz Metin',
                      subtitle: isEn
                          ? 'Human-readable format'
                          : 'Okunabilir format',
                      icon: Icons.text_snippet_outlined,
                      isSelected: _selectedFormat == ExportFormat.text,
                      isLocked: false,
                      isDark: isDark,
                      onTap: () =>
                          setState(() => _selectedFormat = ExportFormat.text),
                    ),
                    const SizedBox(height: 8),

                    _FormatOption(
                      format: ExportFormat.csv,
                      title: 'CSV',
                      subtitle: isEn
                          ? 'Spreadsheet compatible'
                          : 'Tablo uyumlu',
                      icon: Icons.table_chart_outlined,
                      isSelected: _selectedFormat == ExportFormat.csv,
                      isLocked: !isPremium,
                      isDark: isDark,
                      onTap: isPremium
                          ? () => setState(
                              () => _selectedFormat = ExportFormat.csv)
                          : () => showContextualPaywall(
                              context,
                              ref,
                              paywallContext: PaywallContext.export,
                              entryCount: exportAsync.valueOrNull?.totalEntries,
                            ),
                    ),
                    const SizedBox(height: 8),

                    _FormatOption(
                      format: ExportFormat.json,
                      title: 'JSON',
                      subtitle: isEn
                          ? 'Developer-friendly format'
                          : 'Geliştirici dostu format',
                      icon: Icons.data_object_outlined,
                      isSelected: _selectedFormat == ExportFormat.json,
                      isLocked: !isPremium,
                      isDark: isDark,
                      onTap: isPremium
                          ? () => setState(
                              () => _selectedFormat = ExportFormat.json)
                          : () => showContextualPaywall(
                              context,
                              ref,
                              paywallContext: PaywallContext.export,
                              entryCount: exportAsync.valueOrNull?.totalEntries,
                            ),
                    ),

                    const SizedBox(height: 32),

                    // Export button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isExporting
                            ? null
                            : () => _doExport(isPremium, isEn),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.auroraStart,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isExporting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.file_download_outlined,
                                      size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    isEn
                                        ? 'Export & Share'
                                        : 'Dışa Aktar ve Paylaş',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Copy to clipboard button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _isExporting
                            ? null
                            : () => _copyToClipboard(isPremium, isEn),
                        icon: Icon(Icons.copy_outlined,
                            size: 18,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary),
                        label: Text(
                          isEn
                              ? 'Copy to Clipboard'
                              : 'Panoya Kopyala',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.black.withValues(alpha: 0.1),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _doExport(bool isPremium, bool isEn) async {
    // GUARDRAIL: Double-check entitlement with RevenueCat before export
    if (isPremium) {
      final verified =
          await ref.read(premiumProvider.notifier).verifyEntitlementForFeature();
      if (!verified && mounted) {
        await showContextualPaywall(context, ref,
            paywallContext: PaywallContext.general);
        return;
      }
    }

    final service = ref.read(exportServiceProvider).valueOrNull;
    if (service == null) return;

    setState(() => _isExporting = true);

    try {
      final result = service.export(
        format: _selectedFormat,
        isPremium: isPremium,
        isEn: isEn,
      );

      await SharePlus.instance.share(ShareParams(text: result.content, subject: result.fileName));
      HapticFeedback.mediumImpact();
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _copyToClipboard(bool isPremium, bool isEn) async {
    // GUARDRAIL: Double-check entitlement with RevenueCat before clipboard export
    if (isPremium) {
      final verified =
          await ref.read(premiumProvider.notifier).verifyEntitlementForFeature();
      if (!verified && mounted) {
        await showContextualPaywall(context, ref,
            paywallContext: PaywallContext.general);
        return;
      }
    }

    final service = ref.read(exportServiceProvider).valueOrNull;
    if (service == null) return;

    final result = service.export(
      format: _selectedFormat,
      isPremium: isPremium,
      isEn: isEn,
    );

    await Clipboard.setData(ClipboardData(text: result.content));
    HapticFeedback.lightImpact();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEn ? 'Copied to clipboard' : 'Panoya kopyalandı'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

class _InfoCard extends StatelessWidget {
  final bool isDark;
  final bool isEn;
  final bool isPremium;

  const _InfoCard({
    required this.isDark,
    required this.isEn,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.auroraStart.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: AppColors.auroraStart,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isPremium
                  ? (isEn
                      ? 'Export your full journal history in any format'
                      : 'Tüm günlük geçmişinizi herhangi bir formatta dışa aktarın')
                  : (isEn
                      ? 'Free: last 7 days as text. Upgrade for full history & all formats.'
                      : 'Ücretsiz: son 7 gün metin olarak. Tam geçmiş ve tüm formatlar için yükseltin.'),
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _EntryCountCard extends StatelessWidget {
  final int count;
  final bool isDark;
  final bool isEn;
  final bool isPremium;

  const _EntryCountCard({
    required this.count,
    required this.isDark,
    required this.isEn,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.starGold,
                ),
              ),
              Text(
                isEn ? 'Total Entries' : 'Toplam Kayıt',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                isPremium ? '$count' : '${count > 7 ? 7 : count}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.auroraStart,
                ),
              ),
              Text(
                isEn ? 'Will Export' : 'Aktarılacak',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _LockedEntriesCta extends StatelessWidget {
  final int totalEntries;
  final int lockedEntries;
  final bool isDark;
  final bool isEn;
  final VoidCallback onUnlock;

  const _LockedEntriesCta({
    required this.totalEntries,
    required this.lockedEntries,
    required this.isDark,
    required this.isEn,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUnlock,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF66BB6A).withValues(alpha: 0.08),
              const Color(0xFF66BB6A).withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF66BB6A).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF66BB6A).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 20,
                color: Color(0xFF66BB6A),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEn
                        ? '$lockedEntries entries locked'
                        : '$lockedEntries kayit kilitli',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isEn
                        ? 'Upgrade to export all $totalEntries entries'
                        : 'Tum $totalEntries kaydi aktarmak icin yukselt',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                isEn ? 'Unlock' : 'Aç',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }
}

class _FormatOption extends StatelessWidget {
  final ExportFormat format;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final bool isLocked;
  final bool isDark;
  final VoidCallback onTap;

  const _FormatOption({
    required this.format,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.isLocked,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.auroraStart.withValues(alpha: 0.1)
              : (isDark
                  ? AppColors.surfaceDark.withValues(alpha: 0.85)
                  : AppColors.lightCard),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.auroraStart.withValues(alpha: 0.4)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.04)),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? AppColors.auroraStart
                  : (isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isLocked)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.starGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'PRO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.starGold,
                  ),
                ),
              ),
            if (isSelected && !isLocked)
              Icon(
                Icons.check_circle,
                size: 22,
                color: AppColors.auroraStart,
              ),
          ],
        ),
      ),
    );
  }
}
