// ════════════════════════════════════════════════════════════════════════════
// BOND INVITE SCREEN - Select bond type, generate code, share
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/bond.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/providers/bond_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import 'widgets/bond_invite_code_display.dart';

class BondInviteScreen extends ConsumerStatefulWidget {
  const BondInviteScreen({super.key});

  @override
  ConsumerState<BondInviteScreen> createState() => _BondInviteScreenState();
}

class _BondInviteScreenState extends ConsumerState<BondInviteScreen> {
  BondType? _selectedType;
  BondInvite? _createdInvite;
  bool _isCreating = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CosmicBackground(
        child: CupertinoScrollbar(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Create Bond' : 'Bag Olustur',
                useGradientTitle: true,
                gradientVariant: GradientTextVariant.amethyst,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _createdInvite != null
                      ? _buildInviteResult(isDark, isEn)
                      : _buildTypeSelection(isDark, isEn),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPE SELECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTypeSelection(bool isDark, bool isEn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        GradientText(
          isEn ? 'Choose Bond Type' : 'Bag Turunu Sec',
          variant: GradientTextVariant.gold,
          style: AppTypography.displayFont.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: 8),
        Text(
          isEn
              ? 'Select how you want to connect with this person.'
              : 'Bu kisiyle nasil baglanmak istedigini sec.',
          style: AppTypography.subtitle(
            fontSize: 14,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        )
            .animate(delay: 50.ms)
            .fadeIn(duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: 24),

        // Bond type cards
        ...BondType.values.asMap().entries.map((entry) {
          final index = entry.key;
          final type = entry.value;
          final isSelected = _selectedType == type;

          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : 12),
            child: _BondTypeCard(
              type: type,
              isSelected: isSelected,
              isDark: isDark,
              isEn: isEn,
              onTap: () {
                HapticService.selectionTap();
                setState(() => _selectedType = type);
              },
            )
                .animate(delay: Duration(milliseconds: 100 + index * 80))
                .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                .slideY(
                    begin: 0.05,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOut),
          );
        }),
        const SizedBox(height: 32),

        // Error message
        if (_errorMessage != null) ...[
          Text(
            _errorMessage!,
            style: AppTypography.subtitle(
              fontSize: 13,
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],

        // Generate code button
        GradientButton.gold(
          label: isEn ? 'Generate Invite Code' : 'Davet Kodu Olustur',
          icon: Icons.link_rounded,
          expanded: true,
          isLoading: _isCreating,
          onPressed: _selectedType == null ? null : _createInvite,
        )
            .animate(delay: 400.ms)
            .fadeIn(duration: 400.ms, curve: Curves.easeOut),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INVITE RESULT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildInviteResult(bool isDark, bool isEn) {
    return Column(
      children: [
        const SizedBox(height: 24),

        // Success illustration
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success.withValues(alpha: 0.12),
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              color: AppColors.success,
              size: 36,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .scale(
              begin: const Offset(0.6, 0.6),
              end: const Offset(1.0, 1.0),
              duration: 500.ms,
              curve: Curves.easeOutBack,
            ),
        const SizedBox(height: 20),

        // Success title
        GradientText(
          isEn ? 'Code Created!' : 'Kod Olusturuldu!',
          variant: GradientTextVariant.gold,
          style: AppTypography.displayFont.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        )
            .animate(delay: 100.ms)
            .fadeIn(duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: 8),

        Text(
          isEn
              ? 'Share this code with your ${_selectedType?.displayNameEn.toLowerCase() ?? 'partner'} to connect.'
              : 'Baglanmak icin bu kodu ${_selectedType?.displayNameTr.toLowerCase() ?? 'partner'}inle paylas.',
          textAlign: TextAlign.center,
          style: AppTypography.subtitle(
            fontSize: 14,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        )
            .animate(delay: 150.ms)
            .fadeIn(duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: 32),

        // Code display widget
        PremiumCard(
          style: PremiumCardStyle.amethyst,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: BondInviteCodeDisplay(
            invite: _createdInvite!,
            isEn: isEn,
          ),
        )
            .animate(delay: 200.ms)
            .fadeIn(duration: 500.ms, curve: Curves.easeOut)
            .slideY(
                begin: 0.06,
                end: 0,
                duration: 500.ms,
                curve: Curves.easeOut),
        const SizedBox(height: 32),

        // Done button
        GradientButton(
          label: isEn ? 'Done' : 'Tamam',
          expanded: true,
          onPressed: () => context.pop(),
        )
            .animate(delay: 350.ms)
            .fadeIn(duration: 400.ms, curve: Curves.easeOut),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _createInvite() async {
    if (_selectedType == null || _isCreating) return;

    setState(() {
      _isCreating = true;
      _errorMessage = null;
    });

    try {
      final bondService = await ref.read(bondServiceProvider.future);
      final invite = await bondService.createInvite(_selectedType!);

      if (!mounted) return;

      if (invite != null) {
        HapticService.success();
        setState(() {
          _createdInvite = invite;
          _isCreating = false;
        });
      } else {
        HapticService.error();
        final language = ref.read(languageProvider);
        final isEn = language == AppLanguage.en;
        setState(() {
          _errorMessage = isEn
              ? 'Could not create invite. Please try again.'
              : 'Davet olusturulamadi. Lutfen tekrar dene.';
          _isCreating = false;
        });
      }
    } catch (_) {
      HapticService.error();
      if (mounted) {
        final language = ref.read(languageProvider);
        final isEn = language == AppLanguage.en;
        setState(() {
          _errorMessage = isEn
              ? 'Something went wrong. Please try again.'
              : 'Bir seyler ters gitti. Lutfen tekrar dene.';
          _isCreating = false;
        });
      }
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BOND TYPE CARD
// ═══════════════════════════════════════════════════════════════════════════

class _BondTypeCard extends StatelessWidget {
  final BondType type;
  final bool isSelected;
  final bool isDark;
  final bool isEn;
  final VoidCallback onTap;

  const _BondTypeCard({
    required this.type,
    required this.isSelected,
    required this.isDark,
    required this.isEn,
    required this.onTap,
  });

  String get _description {
    switch (type) {
      case BondType.partner:
        return isEn
            ? 'Share your emotional world with your romantic partner.'
            : 'Duygusal dunyanizi romantik partnerinizle paylasin.';
      case BondType.bestFriend:
        return isEn
            ? 'Stay emotionally connected with your closest friend.'
            : 'En yakin arkadasinizla duygusal olarak bagli kalin.';
      case BondType.sibling:
        return isEn
            ? 'Strengthen your sibling bond through shared moods.'
            : 'Paylasilmis ruh halleriyle kardes baginizi guclendirin.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.amethyst.withValues(alpha: 0.12)
                  : AppColors.amethyst.withValues(alpha: 0.08))
              : (isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.03)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.amethyst.withValues(alpha: 0.4)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06)),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Emoji avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04),
              ),
              child: Center(
                child: Text(
                  type.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEn ? type.displayNameEn : type.displayNameTr,
                    style: AppTypography.subtitle(
                      fontSize: 16,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _description,
                    style: AppTypography.subtitle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.amethyst
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.amethyst
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.15)),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
