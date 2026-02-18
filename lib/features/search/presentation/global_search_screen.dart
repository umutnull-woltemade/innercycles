// ════════════════════════════════════════════════════════════════════════════
// GLOBAL SEARCH / COMMAND PALETTE - Search across all tools
// ════════════════════════════════════════════════════════════════════════════
// Quick access to any tool, recent entries, and smart suggestions.
// Triggered from Today feed search chip or via dedicated route.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/tool_manifest.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';

class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<ToolManifest> _getResults() {
    if (_query.isEmpty) return [];
    final q = _query.toLowerCase();
    return ToolManifestRegistry.all.where((tool) {
      return tool.nameEn.toLowerCase().contains(q) ||
          tool.nameTr.toLowerCase().contains(q) ||
          tool.valuePropositionEn.toLowerCase().contains(q) ||
          tool.valuePropositionTr.toLowerCase().contains(q);
    }).toList();
  }

  List<ToolManifest> _getQuickActions() {
    // Show popular tools when no query
    const quickIds = ['journal', 'gratitude', 'breathing', 'dreamInterpretation', 'patterns', 'quizHub', 'challenges', 'wellness'];
    return quickIds.map((id) => ToolManifestRegistry.findById(id)).whereType<ToolManifest>().toList();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    final results = _getResults();
    final quickActions = _getQuickActions();

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepSpace : AppColors.lightBackground,
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
          children: [
            // Search bar + close button
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                        color: isDark ? AppColors.surfaceDark.withValues(alpha: 0.6) : AppColors.lightSurfaceVariant,
                        border: Border.all(color: isDark ? AppColors.surfaceLight.withValues(alpha: 0.3) : AppColors.lightSurfaceVariant),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: (v) => setState(() => _query = v.trim()),
                        style: GoogleFonts.inter(color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                        decoration: InputDecoration(
                          hintText: isEn ? 'Search tools, entries...' : 'Ara\u00e7, kay\u0131t ara...',
                          hintStyle: TextStyle(color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                          prefixIcon: Icon(Icons.search_rounded, color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg, vertical: AppConstants.spacingMd),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.05, end: 0, duration: 300.ms),
                  const SizedBox(width: AppConstants.spacingSm),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_rounded, color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),

            // Results or Quick Actions
            Expanded(
              child: _query.isEmpty
                  ? _buildQuickActions(quickActions, isDark, isEn)
                  : results.isEmpty
                      ? _buildNoResults(isDark, isEn)
                      : _buildResults(results, isDark, isEn),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildQuickActions(List<ToolManifest> tools, bool isDark, bool isEn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isEn ? 'Quick Actions' : 'H\u0131zl\u0131 Eri\u015fim', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary))
              .animate().fadeIn(delay: 100.ms, duration: 300.ms),
          const SizedBox(height: AppConstants.spacingMd),
          Expanded(
            child: ListView.separated(
              itemCount: tools.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final tool = tools[index];
                return _SearchResultTile(tool: tool, isDark: isDark, isEn: isEn)
                    .animate().fadeIn(delay: Duration(milliseconds: 150 + index * 40), duration: 300.ms);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(List<ToolManifest> results, bool isDark, bool isEn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? '${results.length} result${results.length != 1 ? 's' : ''}' : '${results.length} sonu\u00e7',
            style: GoogleFonts.inter(fontSize: 13, color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
          ).animate().fadeIn(duration: 200.ms),
          const SizedBox(height: AppConstants.spacingSm),
          Expanded(
            child: ListView.separated(
              itemCount: results.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                return _SearchResultTile(tool: results[index], isDark: isDark, isEn: isEn)
                    .animate().fadeIn(delay: Duration(milliseconds: index * 30), duration: 300.ms);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(bool isDark, bool isEn) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: isDark ? AppColors.textMuted.withValues(alpha: 0.4) : AppColors.lightTextMuted.withValues(alpha: 0.4)),
          const SizedBox(height: AppConstants.spacingLg),
          Text(isEn ? 'No results found' : 'Sonu\u00e7 bulunamad\u0131', style: GoogleFonts.inter(fontSize: 16, color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _SearchResultTile extends StatelessWidget {
  final ToolManifest tool;
  final bool isDark;
  final bool isEn;
  const _SearchResultTile({required this.tool, required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        context.push(tool.route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg, vertical: AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark.withValues(alpha: 0.5) : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        child: Row(
          children: [
            Text(tool.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isEn ? tool.nameEn : tool.nameTr, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)),
                  Text(isEn ? tool.valuePropositionEn : tool.valuePropositionTr, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textMuted : AppColors.lightTextMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
          ],
        ),
      ),
    );
  }
}
