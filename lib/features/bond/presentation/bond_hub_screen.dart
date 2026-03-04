// ════════════════════════════════════════════════════════════════════════════
// BOND HUB SCREEN - Main list of active bonds with FAB to invite
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/routes.dart';
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
import 'widgets/bond_partner_card.dart';

class BondHubScreen extends ConsumerStatefulWidget {
  const BondHubScreen({super.key});

  @override
  ConsumerState<BondHubScreen> createState() => _BondHubScreenState();
}

class _BondHubScreenState extends ConsumerState<BondHubScreen> {
  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bondsAsync = ref.watch(activeBondsProvider);
    final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';

    return Scaffold(
      floatingActionButton: _buildFAB(context, isEn),
      body: CosmicBackground(
        child: RefreshIndicator(
          color: AppColors.starGold,
          backgroundColor: isDark ? AppColors.deepSpace : AppColors.lightSurface,
          onRefresh: () async {
            ref.invalidate(activeBondsProvider);
            await Future.delayed(const Duration(milliseconds: 300));
          },
          child: CupertinoScrollbar(
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Bonds' : 'Bağlar',
                useGradientTitle: true,
                gradientVariant: GradientTextVariant.amethyst,
              ),
              // Header description
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Text(
                    isEn
                        ? 'Share your inner world with the people who matter most.'
                        : 'İç dünyanı seni en çok önemseyen kişilerle paylaş.',
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                      .slideY(
                          begin: 0.05,
                          end: 0,
                          duration: 400.ms,
                          curve: Curves.easeOut),
                ),
              ),

              // Bond list or empty state
              bondsAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(child: CupertinoActivityIndicator()),
                  ),
                ),
                error: (e, s) => SliverToBoxAdapter(
                  child: _buildErrorState(isDark, isEn),
                ),
                data: (bonds) {
                  if (bonds.isEmpty) {
                    return SliverToBoxAdapter(
                      child: _BondEmptyState(
                        isEn: isEn,
                        isDark: isDark,
                        onInvite: () => _navigateToInvite(context),
                      ),
                    );
                  }
                  return _buildBondList(
                    bonds,
                    language,
                    isDark,
                    currentUserId,
                  );
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FAB
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildFAB(BuildContext context, bool isEn) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.starGold, AppColors.celestialGold],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.starGold.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _navigateToInvite(context),
        tooltip: isEn ? 'Create Bond' : 'Bağ Oluştur',
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(
          Icons.person_add_rounded,
          color: AppColors.deepSpace,
        ),
      ),
    );
  }

  void _navigateToInvite(BuildContext context) {
    HapticService.buttonPress();
    context.push(Routes.bondInvite);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BOND LIST
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBondList(
    List<Bond> bonds,
    AppLanguage language,
    bool isDark,
    String currentUserId,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final bond = bonds[index];
            return Padding(
              padding: EdgeInsets.only(top: index == 0 ? 0 : 12),
              child: BondPartnerCard(
                bond: bond,
                language: language,
                currentUserId: currentUserId,
                onTap: () {
                  HapticService.selectionTap();
                  context.push(Routes.bondDetail.replaceFirst(':bondId', bond.id));
                },
              ),
            )
                .animate()
                .fadeIn(
                  delay: Duration(milliseconds: 80 * index),
                  duration: 300.ms,
                )
                .slideY(
                  begin: 0.05,
                  end: 0,
                  delay: Duration(milliseconds: 80 * index),
                  duration: 300.ms,
                  curve: Curves.easeOut,
                );
          },
          childCount: bonds.length,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR STATE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildErrorState(bool isDark, bool isEn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEn
                  ? 'Could not load your bonds'
                  : 'Bağların yüklenemedi',
              textAlign: TextAlign.center,
              style: AppTypography.subtitle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => ref.invalidate(activeBondsProvider),
              icon: Icon(Icons.refresh_rounded,
                  size: 16, color: AppColors.starGold),
              label: Text(
                isEn ? 'Retry' : 'Tekrar Dene',
                style: AppTypography.elegantAccent(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.starGold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BOND EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════

class _BondEmptyState extends StatelessWidget {
  final bool isEn;
  final bool isDark;
  final VoidCallback onInvite;

  const _BondEmptyState({
    required this.isEn,
    required this.isDark,
    required this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Illustration
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.amethyst.withValues(alpha: 0.12)
                  : AppColors.amethyst.withValues(alpha: 0.08),
            ),
            child: const Center(
              child: Text('🫶', style: TextStyle(fontSize: 36)),
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms, curve: Curves.easeOut)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 500.ms,
                curve: Curves.easeOutBack,
              ),
          const SizedBox(height: 24),

          // Title
          GradientText(
            isEn ? 'No Bonds Yet' : 'Henüz Bağ Yok',
            variant: GradientTextVariant.amethyst,
            style: AppTypography.displayFont.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          )
              .animate(delay: 100.ms)
              .fadeIn(duration: 400.ms, curve: Curves.easeOut),
          const SizedBox(height: 12),

          // Description
          Text(
            isEn
                ? 'Create a bond with your partner, best friend, or sibling to share moods and stay connected.'
                : 'Partnerinle, en yakın arkadaşınla veya kardeşinle bağ kurarak ruh halinizi paylaşıp bağlı kalın.',
            textAlign: TextAlign.center,
            style: AppTypography.subtitle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 400.ms, curve: Curves.easeOut),
          const SizedBox(height: 32),

          // CTA
          GradientButton.gold(
            label: isEn ? 'Create Your First Bond' : 'İlk Bağını Oluştur',
            icon: Icons.favorite_rounded,
            expanded: true,
            onPressed: onInvite,
          )
              .animate(delay: 300.ms)
              .fadeIn(duration: 400.ms, curve: Curves.easeOut)
              .slideY(
                  begin: 0.08,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOut),
          const SizedBox(height: 16),

          // Accept code hint
          GestureDetector(
            onTap: () {
              HapticService.buttonPress();
              context.push(Routes.bondAccept);
            },
            child: Text(
              isEn
                  ? 'Have an invite code? Enter it here'
                  : 'Davet kodun mu var? Buraya gir',
              style: AppTypography.subtitle(
                fontSize: 13,
                color: AppColors.amethyst,
              ).copyWith(decoration: TextDecoration.underline),
            ),
          )
              .animate(delay: 400.ms)
              .fadeIn(duration: 400.ms, curve: Curves.easeOut),
        ],
      ),
    );
  }
}
