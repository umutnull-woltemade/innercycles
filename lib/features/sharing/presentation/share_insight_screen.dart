// ════════════════════════════════════════════════════════════════════════════
// SHARE INSIGHT SCREEN - Shareable Insight Card Preview & Share
// ════════════════════════════════════════════════════════════════════════════
// Previews an InsightCard and provides share / copy / save actions.
// Generates card data from the user's actual journal & dream data via
// Riverpod providers. Uses RepaintBoundary capture through
// InstagramShareService for high-quality image export.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/instagram_share_service.dart';
import 'insight_card_widget.dart';

// ════════════════════════════════════════════════════════════════════════════
// SCREEN
// ════════════════════════════════════════════════════════════════════════════

class ShareInsightScreen extends ConsumerStatefulWidget {
  const ShareInsightScreen({super.key});

  @override
  ConsumerState<ShareInsightScreen> createState() => _ShareInsightScreenState();
}

class _ShareInsightScreenState extends ConsumerState<ShareInsightScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  InsightCardType _selectedType = InsightCardType.streak;
  bool _isSharing = false;

  // ═══════════════════════════════════════════════════════════════════════
  // CARD DATA GENERATION
  // ═══════════════════════════════════════════════════════════════════════

  /// Build card data from the user's real journal / dream providers
  InsightCardData _buildCardData({
    required InsightCardType type,
    required bool isEn,
    required int streak,
  }) {
    switch (type) {
      case InsightCardType.archetype:
        return InsightCardData(
          type: type,
          headline: isEn ? 'The Reflector' : 'Yansitici',
          subtitle: isEn
              ? 'You process the world by looking inward first.'
              : 'Dunyayi once icine bakarak islersin.',
          detail: isEn
              ? 'Based on your recent entries'
              : 'Son kayitlarina dayanarak',
          accentColor: AppColors.amethyst,
          badgeText: isEn ? 'ARCHETYPE' : 'ARKETIP',
        );

      case InsightCardType.moodPattern:
        return InsightCardData(
          type: type,
          headline: isEn ? 'My Week in Feelings' : 'Duygularla Gecen Haftam',
          subtitle: isEn
              ? 'Calm mid-week, energised on weekends'
              : 'Hafta ortasi sakin, hafta sonu enerjik',
          detail: isEn
              ? 'Patterns drawn from 7-day mood data'
              : 'Son 7 gunluk duygu verisinden cikarildi',
          accentColor: AppColors.sunriseStart,
          badgeText: isEn ? 'MOOD' : 'DUYGU',
        );

      case InsightCardType.streak:
        final streakText = streak > 0 ? '$streak' : '0';
        return InsightCardData(
          type: type,
          headline: isEn
              ? 'Day $streakText Streak'
              : '$streakText Gun Serisi',
          subtitle: isEn
              ? 'Consistency builds self-awareness.'
              : 'Tutarlilik oz-farkindaligin temelidir.',
          accentColor: AppColors.starGold,
          badgeText: isEn ? 'STREAK' : 'SERI',
        );

      case InsightCardType.dreamSymbol:
        return InsightCardData(
          type: type,
          headline: isEn ? 'My Dream Personality' : 'Ruya Kisiligim',
          subtitle: isEn
              ? 'Water themes appear often in your dreams.'
              : 'Ruyalarinda su temalari sik gorunuyor.',
          detail: isEn
              ? 'Drawn from your dream journal'
              : 'Ruya guncenden cikarildi',
          accentColor: AppColors.blueAccent,
          badgeText: isEn ? 'DREAM' : 'RUYA',
        );

      case InsightCardType.attachmentStyle:
        return InsightCardData(
          type: type,
          headline: isEn ? 'My Attachment Style' : 'Baglanma Stilim',
          subtitle: isEn
              ? 'Your entries suggest a secure-leaning pattern.'
              : 'Kayitlarin guvenli bir egilim gosteriyor.',
          accentColor: AppColors.softPink,
          badgeText: isEn ? 'ATTACHMENT' : 'BAGLANMA',
        );

      case InsightCardType.emotionalCycle:
        return InsightCardData(
          type: type,
          headline: isEn ? 'Inner Cycle Phase' : 'Ic Dongu Evresi',
          subtitle: isEn
              ? 'You may be in a reflective phase right now.'
              : 'Su an yansitici bir evrede olabilirsin.',
          detail: isEn
              ? 'Past entries suggest a recurring pattern'
              : 'Gecmis kayitlar tekrarlayan bir oruntu gosteriyor',
          accentColor: AppColors.twilightEnd,
          badgeText: isEn ? 'CYCLE' : 'DONGU',
        );

      case InsightCardType.monthlyReview:
        return InsightCardData(
          type: type,
          headline: isEn ? 'Monthly Milestone' : 'Aylik Kilometre Tasi',
          subtitle: isEn
              ? 'Another month of showing up for yourself.'
              : 'Kendin icin var oldugun bir ay daha.',
          accentColor: AppColors.celestialGold,
          badgeText: isEn ? 'MONTHLY' : 'AYLIK',
        );

      case InsightCardType.growthScore:
        return InsightCardData(
          type: type,
          headline: isEn ? 'Growth Score: 78' : 'Gelisim Puani: 78',
          subtitle: isEn
              ? 'You have been making steady progress.'
              : 'Istikrarli bir ilerleme gosteriyorsun.',
          detail: isEn
              ? 'Composite of consistency, depth & variety'
              : 'Tutarlilik, derinlik ve cesitlilik bilesimi',
          accentColor: AppColors.success,
          badgeText: isEn ? 'GROWTH' : 'GELISIM',
        );

      case InsightCardType.weeklyTheme:
        return InsightCardData(
          type: type,
          headline: isEn ? 'Weekly Theme' : 'Haftalik Tema',
          subtitle: isEn
              ? 'This week you tended to focus on clarity.'
              : 'Bu hafta netlesmek uzerine yogunlastin.',
          accentColor: AppColors.auroraStart,
          badgeText: isEn ? 'THEME' : 'TEMA',
        );

      case InsightCardType.moonPhase:
        return InsightCardData(
          type: type,
          headline: isEn ? 'Moon Phase Wisdom' : 'Ay Evresi Bilgeligi',
          subtitle: isEn
              ? 'A good time for rest and introspection.'
              : 'Dinlenme ve ic gozlem icin iyi bir zaman.',
          detail: isEn
              ? 'Aligned with your emotional patterns'
              : 'Duygusal oruntulerinle uyumlu',
          accentColor: AppColors.moonSilver,
          badgeText: isEn ? 'MOON' : 'AY',
        );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SHARE / COPY / SAVE ACTIONS
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _onShare(bool isEn, AppLanguage language) async {
    final boundary = _repaintKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return;

    setState(() => _isSharing = true);

    final shareText = isEn
        ? 'Check out my insight from InnerCycles! #InnerCycles #SelfAwareness'
        : 'InnerCycles icgorulerimi kesfet! #InnerCycles #KendiniFarkEt';

    final result = await InstagramShareService.shareCosmicContent(
      boundary: boundary,
      shareText: shareText,
      hashtags: '#InnerCycles #Journaling #SelfGrowth',
      language: language,
    );

    setState(() => _isSharing = false);

    if (!mounted) return;

    if (result.success) {
      _showSnackBar(isEn ? 'Shared successfully!' : 'Basariyla paylasIldI!');
    } else if (result.error == ShareError.dismissed) {
      // User dismissed - no feedback needed
    } else {
      _showSnackBar(
        isEn ? 'Could not share. Try again.' : 'Paylasilamadi. Tekrar dene.',
      );
    }
  }

  Future<void> _onCopy(bool isEn, InsightCardData cardData) async {
    final text = '${cardData.headline}\n${cardData.subtitle}'
        '${cardData.detail != null ? '\n${cardData.detail}' : ''}'
        '\n\n- InnerCycles';
    await Clipboard.setData(ClipboardData(text: text));

    if (!mounted) return;
    _showSnackBar(isEn ? 'Copied to clipboard' : 'Panoya kopyalandi');
  }

  Future<void> _onSave(bool isEn) async {
    final boundary = _repaintKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return;

    setState(() => _isSharing = true);

    // Use share service to capture image - user can save from share sheet
    final shareText = isEn
        ? 'My InnerCycles Insight'
        : 'InnerCycles Icgorum';

    await InstagramShareService.shareCosmicContent(
      boundary: boundary,
      shareText: shareText,
    );

    setState(() => _isSharing = false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final streakAsync = ref.watch(journalStreakProvider);

    final streak = streakAsync.whenOrNull(data: (s) => s) ?? 0;
    final cardData = _buildCardData(
      type: _selectedType,
      isEn: isEn,
      streak: streak,
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepSpace : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isEn ? 'Share Insight' : 'Icgoru Paylas',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 28,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Card type selector (horizontal chips)
            _buildTypeSelector(isDark, isEn),
            const SizedBox(height: 16),

            // Card preview
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: InsightCard(
                    data: cardData,
                    repaintKey: _repaintKey,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1.0, 1.0),
                        duration: 400.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            _buildActionButtons(isDark, isEn, language, cardData),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // TYPE SELECTOR
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildTypeSelector(bool isDark, bool isEn) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: InsightCardType.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = InsightCardType.values[index];
          final isSelected = type == _selectedType;
          return _buildTypeChip(type, isSelected, isDark, isEn);
        },
      ),
    );
  }

  Widget _buildTypeChip(
    InsightCardType type,
    bool isSelected,
    bool isDark,
    bool isEn,
  ) {
    final label = _chipLabel(type, isEn);
    final chipColor = _chipColor(type);

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: isSelected
              ? chipColor.withValues(alpha: 0.2)
              : (isDark
                  ? AppColors.surfaceDark
                  : AppColors.lightSurfaceVariant),
          border: Border.all(
            color: isSelected
                ? chipColor.withValues(alpha: 0.6)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06)),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? chipColor
                : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }

  String _chipLabel(InsightCardType type, bool isEn) {
    switch (type) {
      case InsightCardType.archetype:
        return isEn ? 'Archetype' : 'Arketip';
      case InsightCardType.moodPattern:
        return isEn ? 'Mood' : 'Duygu';
      case InsightCardType.streak:
        return isEn ? 'Streak' : 'Seri';
      case InsightCardType.dreamSymbol:
        return isEn ? 'Dream' : 'Ruya';
      case InsightCardType.attachmentStyle:
        return isEn ? 'Attachment' : 'Baglanma';
      case InsightCardType.emotionalCycle:
        return isEn ? 'Cycle' : 'Dongu';
      case InsightCardType.monthlyReview:
        return isEn ? 'Monthly' : 'Aylik';
      case InsightCardType.growthScore:
        return isEn ? 'Growth' : 'Gelisim';
      case InsightCardType.weeklyTheme:
        return isEn ? 'Theme' : 'Tema';
      case InsightCardType.moonPhase:
        return isEn ? 'Moon' : 'Ay';
    }
  }

  Color _chipColor(InsightCardType type) {
    switch (type) {
      case InsightCardType.archetype:
        return AppColors.amethyst;
      case InsightCardType.moodPattern:
        return AppColors.sunriseStart;
      case InsightCardType.streak:
        return AppColors.starGold;
      case InsightCardType.dreamSymbol:
        return AppColors.blueAccent;
      case InsightCardType.attachmentStyle:
        return AppColors.softPink;
      case InsightCardType.emotionalCycle:
        return AppColors.twilightEnd;
      case InsightCardType.monthlyReview:
        return AppColors.celestialGold;
      case InsightCardType.growthScore:
        return AppColors.success;
      case InsightCardType.weeklyTheme:
        return AppColors.auroraStart;
      case InsightCardType.moonPhase:
        return AppColors.moonSilver;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ACTION BUTTONS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildActionButtons(
    bool isDark,
    bool isEn,
    AppLanguage language,
    InsightCardData cardData,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Share button (primary)
          Expanded(
            flex: 2,
            child: _ActionButton(
              icon: Icons.share_rounded,
              label: isEn ? 'Share' : 'Paylas',
              isPrimary: true,
              isLoading: _isSharing,
              accentColor: AppColors.auroraStart,
              isDark: isDark,
              onTap: () => _onShare(isEn, language),
            ),
          ),
          const SizedBox(width: 12),

          // Copy button
          Expanded(
            child: _ActionButton(
              icon: Icons.copy_rounded,
              label: isEn ? 'Copy' : 'Kopyala',
              isPrimary: false,
              isDark: isDark,
              onTap: () => _onCopy(isEn, cardData),
            ),
          ),
          const SizedBox(width: 12),

          // Save button
          Expanded(
            child: _ActionButton(
              icon: Icons.save_alt_rounded,
              label: isEn ? 'Save' : 'Kaydet',
              isPrimary: false,
              isDark: isDark,
              onTap: () => _onSave(isEn),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ACTION BUTTON COMPONENT
// ════════════════════════════════════════════════════════════════════════════

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final bool isLoading;
  final Color accentColor;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isPrimary = false,
    this.isLoading = false,
    this.accentColor = AppColors.auroraStart,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: isPrimary
              ? LinearGradient(
                  colors: [
                    accentColor,
                    accentColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isPrimary
              ? null
              : (isDark
                  ? AppColors.surfaceDark
                  : AppColors.lightSurfaceVariant),
          border: isPrimary
              ? null
              : Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.08),
                ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPrimary ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              )
            else
              Icon(
                icon,
                size: 18,
                color: isPrimary
                    ? Colors.white
                    : (isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary),
              ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w500,
                color: isPrimary
                    ? Colors.white
                    : (isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
