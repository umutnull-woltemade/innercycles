// ════════════════════════════════════════════════════════════════════════════
// BOND DETAIL SCREEN - Partner view with touch button + privacy controls
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
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import 'widgets/bond_touch_button.dart';

class BondDetailScreen extends ConsumerStatefulWidget {
  final String bondId;

  const BondDetailScreen({
    super.key,
    required this.bondId,
  });

  @override
  ConsumerState<BondDetailScreen> createState() => _BondDetailScreenState();
}

class _BondDetailScreenState extends ConsumerState<BondDetailScreen> {
  bool _isSendingTouch = false;
  bool _touchSent = false;
  TouchType _selectedTouchType = TouchType.warm;
  BondPrivacy? _privacy;
  bool _isLoadingPrivacy = true;

  String get _currentUserId =>
      Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  void initState() {
    super.initState();
    _loadPrivacy();
  }

  Future<void> _loadPrivacy() async {
    try {
      final bondService = await ref.read(bondServiceProvider.future);
      final privacy = await bondService.getPrivacy(widget.bondId);
      if (mounted) {
        setState(() {
          _privacy = privacy;
          _isLoadingPrivacy = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingPrivacy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bondsAsync = ref.watch(activeBondsProvider);

    return Scaffold(
      body: CosmicBackground(
        child: bondsAsync.when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, s) => Center(
            child: Text(
              isEn ? 'Could not load bond' : 'Bağ yüklenemedi',
              style: AppTypography.subtitle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          data: (bonds) {
            final bond = bonds.where((b) => b.id == widget.bondId).firstOrNull;
            if (bond == null) {
              return Center(
                child: Text(
                  isEn ? 'Bond not found' : 'Bağ bulunamadı',
                  style: AppTypography.subtitle(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              );
            }
            return _buildContent(bond, isDark, isEn, language);
          },
        ),
      ),
    );
  }

  Widget _buildContent(Bond bond, bool isDark, bool isEn, AppLanguage language) {
    final partnerName = bond.partnerDisplayName(_currentUserId) ??
        (isEn ? 'Partner' : 'Partner');
    final partnerId = bond.partnerId(_currentUserId);

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: partnerName,
            useGradientTitle: true,
            gradientVariant: GradientTextVariant.amethyst,
            actions: [
              // Mood calendar action
              Semantics(
                button: true,
                label: isEn ? 'View mood calendar' : 'Ruh hali takvimini gör',
                child: GestureDetector(
                  onTap: () {
                    HapticService.buttonPress();
                    context.push(Routes.bondMoodCalendar.replaceFirst(':bondId', bond.id));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      CupertinoIcons.calendar,
                      size: 22,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ─── Partner Header ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: _buildPartnerHeader(bond, partnerName, isDark, isEn)
                  .animate()
                  .fadeIn(duration: 400.ms, curve: Curves.easeOut),
            ),
          ),

          // ─── Touch Button (Center Stage) ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              child: _buildTouchSection(bond, partnerId, isDark, isEn)
                  .animate(delay: 180.ms)
                  .fadeIn(duration: 500.ms, curve: Curves.easeOut),
            ),
          ),

          // ─── Privacy Controls ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              child: _buildPrivacySection(isDark, isEn)
                  .animate(delay: 320.ms)
                  .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                  .slideY(
                      begin: 0.05,
                      end: 0,
                      duration: 400.ms,
                      curve: Curves.easeOut),
            ),
          ),

          // ─── Bond Info ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: _buildBondInfo(bond, isDark, isEn, language)
                  .animate(delay: 420.ms)
                  .fadeIn(duration: 400.ms, curve: Curves.easeOut),
            ),
          ),

          // ─── Dissolve Section ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              child: _buildDissolveSection(bond, isDark, isEn)
                  .animate(delay: 500.ms)
                  .fadeIn(duration: 400.ms, curve: Curves.easeOut),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PARTNER HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPartnerHeader(
      Bond bond, String partnerName, bool isDark, bool isEn) {
    return PremiumCard(
      style: PremiumCardStyle.amethyst,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Partner avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.amethyst.withValues(alpha: 0.3),
                  AppColors.amethyst.withValues(alpha: 0.15),
                ],
              ),
            ),
            child: Center(
              child: Text(
                partnerName.isNotEmpty
                    ? partnerName[0].toUpperCase()
                    : '?',
                style: AppTypography.displayFont.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Name
          Text(
            partnerName,
            style: AppTypography.subtitle(
              fontSize: 20,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),

          // Bond type
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                bond.bondType.emoji,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 6),
              Text(
                isEn ? bond.bondType.displayNameEn : bond.bondType.displayNameTr,
                style: AppTypography.subtitle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TOUCH SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTouchSection(
      Bond bond, String partnerId, bool isDark, bool isEn) {
    return Column(
      children: [
        // Section title
        GradientText(
          isEn ? 'Send a Touch' : 'Dokunma Gönder',
          variant: GradientTextVariant.gold,
          style: AppTypography.displayFont.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isEn
              ? 'Let them know you are thinking of them.'
              : 'Onları düşündüğünü bildir.',
          style: AppTypography.subtitle(
            fontSize: 13,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 20),

        // Touch type selector
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 0,
          runSpacing: 8,
          children: TouchType.values.map((type) {
            final isSelected = type == _selectedTouchType;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onTap: () {
                  HapticService.selectionTap();
                  setState(() => _selectedTouchType = type);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.amethyst.withValues(alpha: 0.15)
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.black.withValues(alpha: 0.03)),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.amethyst.withValues(alpha: 0.4)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        type.emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 6),
                        Text(
                          isEn ? type.displayNameEn : type.displayNameTr,
                          style: AppTypography.subtitle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Touch button
        BondTouchButton(
          touchType: _selectedTouchType,
          isThrottled: _touchSent,
          isEn: isEn,
          onSend: (_touchSent || partnerId.isEmpty)
              ? null
              : () => _sendTouch(bond.id, partnerId),
        ),

        // Sent confirmation
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: _touchSent
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isEn ? 'Touch sent!' : 'Dokunma gönderildi!',
                        style: AppTypography.subtitle(
                          fontSize: 13,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1.0, 1.0),
                        duration: 300.ms,
                      ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIVACY CONTROLS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPrivacySection(bool isDark, bool isEn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          isEn ? 'Privacy' : 'Gizlilik',
          variant: GradientTextVariant.gold,
          style: AppTypography.displayFont.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isEn
              ? 'Control what you share with your bond partner.'
              : 'Bağ partnerinle ne paylaşmak istediğini kontrol et.',
          style: AppTypography.subtitle(
            fontSize: 13,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 16),

        if (_isLoadingPrivacy)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CupertinoActivityIndicator(),
            ),
          )
        else ...[
          _PrivacyToggle(
            label: isEn ? 'Share Mood' : 'Ruh Halini Paylaş',
            description: isEn
                ? 'Your daily mood signal will be visible'
                : 'Günlük ruh hali sinyalin görünür olacak',
            value: _privacy?.shareMood ?? true,
            isDark: isDark,
            onChanged: (val) => _updatePrivacyField(shareMood: val),
          ),
          const SizedBox(height: 8),
          _PrivacyToggle(
            label: isEn ? 'Share Signal' : 'Sinyali Paylaş',
            description: isEn
                ? 'Your selected mood signal detail'
                : 'Seçtiğin ruh hali sinyal detayı',
            value: _privacy?.shareSignal ?? true,
            isDark: isDark,
            onChanged: (val) => _updatePrivacyField(shareSignal: val),
          ),
          const SizedBox(height: 8),
          _PrivacyToggle(
            label: isEn ? 'Share Streak' : 'Seriyi Paylaş',
            description: isEn
                ? 'Your journaling streak count'
                : 'Günlük yazma serisi sayısı',
            value: _privacy?.shareStreak ?? false,
            isDark: isDark,
            onChanged: (val) => _updatePrivacyField(shareStreak: val),
          ),
          const SizedBox(height: 8),
          _PrivacyToggle(
            label: isEn ? 'Allow Touches' : 'Dokunuşlara İzin Ver',
            description: isEn
                ? 'Receive touch notifications from partner'
                : 'Partnerden dokunma bildirimleri al',
            value: _privacy?.allowTouches ?? true,
            isDark: isDark,
            onChanged: (val) => _updatePrivacyField(allowTouches: val),
          ),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BOND INFO
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBondInfo(
      Bond bond, bool isDark, bool isEn, AppLanguage language) {
    final createdDate = '${bond.createdAt.day}/${bond.createdAt.month}/${bond.createdAt.year}';
    final daysConnected = DateTime.now().difference(bond.createdAt).inDays;

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _InfoRow(
            label: isEn ? 'Bond Type' : 'Bağ Türü',
            value: bond.bondType.localizedName(language),
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _InfoRow(
            label: isEn ? 'Connected Since' : 'Bağlı Olduğunuz Tarih',
            value: createdDate,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _InfoRow(
            label: isEn ? 'Days Connected' : 'Bağlı Gün',
            value: '$daysConnected',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _InfoRow(
            label: isEn ? 'Status' : 'Durum',
            value: bond.status.localizedName(language),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DISSOLVE SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildDissolveSection(Bond bond, bool isDark, bool isEn) {
    if (bond.status == BondStatus.dissolving) {
      return _buildDissolvingState(bond, isDark, isEn);
    }

    return Center(
      child: GestureDetector(
        onTap: () => _confirmDissolve(bond, isEn),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            isEn ? 'Dissolve this bond' : 'Bu bağı çöz',
            style: AppTypography.subtitle(
              fontSize: 14,
              color: AppColors.error.withValues(alpha: 0.7),
            ).copyWith(decoration: TextDecoration.underline),
          ),
        ),
      ),
    );
  }

  Widget _buildDissolvingState(Bond bond, bool isDark, bool isEn) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                size: 18,
                color: AppColors.warning,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isEn
                      ? 'Dissolving in ${bond.dissolveDaysRemaining} days'
                      : '${bond.dissolveDaysRemaining} gün içinde çözülecek',
                  style: AppTypography.subtitle(
                    fontSize: 14,
                    color: AppColors.warning,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isEn
                ? 'You can cancel the dissolution during the cooling period.'
                : 'Soğuma süresi içinde çözülmeyi iptal edebilirsin.',
            style: AppTypography.subtitle(
              fontSize: 13,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _cancelDissolve(bond),
            child: Text(
              isEn ? 'Cancel Dissolution' : 'Çözülmeyi İptal Et',
              style: AppTypography.subtitle(
                fontSize: 14,
                color: AppColors.success,
              ).copyWith(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _sendTouch(String bondId, String receiverId) async {
    if (_isSendingTouch) return;
    setState(() => _isSendingTouch = true);

    try {
      final touchService = await ref.read(touchServiceProvider.future);
      final touch = await touchService.sendTouch(
        bondId: bondId,
        receiverId: receiverId,
        type: _selectedTouchType,
      );

      if (!mounted) return;

      if (touch != null) {
        setState(() {
          _touchSent = true;
          _isSendingTouch = false;
        });
        // Reset after 5 seconds (matches throttle)
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) setState(() => _touchSent = false);
        });
      } else {
        setState(() => _isSendingTouch = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isSendingTouch = false);
    }
  }

  Future<void> _updatePrivacyField({
    bool? shareMood,
    bool? shareSignal,
    bool? shareStreak,
    bool? allowTouches,
  }) async {
    if (_privacy == null) return;

    final updated = _privacy!.copyWith(
      shareMood: shareMood,
      shareSignal: shareSignal,
      shareStreak: shareStreak,
      allowTouches: allowTouches,
    );

    setState(() => _privacy = updated);
    HapticService.toggleChanged();

    try {
      final bondService = await ref.read(bondServiceProvider.future);
      await bondService.updatePrivacy(updated);
    } catch (_) {
      // Revert on error
      if (mounted) await _loadPrivacy();
    }
  }

  Future<void> _confirmDissolve(Bond bond, bool isEn) async {
    final confirmed = await GlassDialog.confirm(
      context,
      title: isEn ? 'Dissolve Bond' : 'Bağı Çöz',
      message: isEn
          ? 'This will start a 7-day cooling period. After that, the bond will be permanently dissolved. You can cancel anytime during the cooling period.'
          : 'Bu işlem 7 günlük bir soğuma süresi başlatacak. Ardından bağ kalıcı olarak çözülecek. Soğuma süresi içinde iptal edebilirsin.',
      cancelLabel: isEn ? 'Cancel' : 'İptal',
      confirmLabel: isEn ? 'Dissolve' : 'Çöz',
      isDestructive: true,
      gradientVariant: GradientTextVariant.amethyst,
    );

    if (confirmed == true) {
      if (!mounted) return;
      try {
        final bondService = await ref.read(bondServiceProvider.future);
        await bondService.requestDissolve(bond.id);
        if (!mounted) return;
        ref.invalidate(activeBondsProvider);
        HapticService.warning();
      } catch (_) {
        HapticService.error();
      }
    }
  }

  Future<void> _cancelDissolve(Bond bond) async {
    try {
      final bondService = await ref.read(bondServiceProvider.future);
      await bondService.cancelDissolve(bond.id);
      if (!mounted) return;
      ref.invalidate(activeBondsProvider);
      HapticService.success();
    } catch (_) {
      HapticService.error();
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PRIVACY TOGGLE
// ═══════════════════════════════════════════════════════════════════════════

class _PrivacyToggle extends StatelessWidget {
  final String label;
  final String description;
  final bool value;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _PrivacyToggle({
    required this.label,
    required this.description,
    required this.value,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTypography.subtitle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTypography.subtitle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CupertinoSwitch(
            value: value,
            activeTrackColor: AppColors.amethyst,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// INFO ROW
// ═══════════════════════════════════════════════════════════════════════════

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.subtitle(
              fontSize: 13,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: AppTypography.subtitle(
              fontSize: 13,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
