// ════════════════════════════════════════════════════════════════════════════
// PARTNER SYNC SCREEN - InnerCycles Partner Cycle Sharing (Local-First MVP)
// ════════════════════════════════════════════════════════════════════════════
// Invite-based partner linking with three states:
//   1. Not linked  — generate / enter invite code
//   2. Linking      — enter partner's code + display name
//   3. Linked       — partner info, shared mood indicator, unlink
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/partner_sync_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

// ════════════════════════════════════════════════════════════════════════════
// SCREEN (provider lives in app_providers.dart — partnerSyncServiceProvider)
// ════════════════════════════════════════════════════════════════════════════

class PartnerSyncScreen extends ConsumerStatefulWidget {
  const PartnerSyncScreen({super.key});

  @override
  ConsumerState<PartnerSyncScreen> createState() => _PartnerSyncScreenState();
}

class _PartnerSyncScreenState extends ConsumerState<PartnerSyncScreen> {
  // ── State ──────────────────────────────────────────────────────
  bool _loading = true;
  bool _isLinking = false; // true when entering partner code + name
  PartnerProfile? _partner;
  String _myInviteCode = '';

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _codeFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DATA
  // ══════════════════════════════════════════════════════════════════════════

  Future<PartnerSyncService?> _getService() async {
    final serviceAsync = ref.read(partnerSyncServiceProvider);
    return serviceAsync.valueOrNull;
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final service = await _getService();
    if (service != null && mounted) {
      setState(() {
        _partner = service.getPartnerData();
        _myInviteCode = service.getInviteCode();
        _loading = false;
      });
    } else if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _regenerateCode() async {
    final service = await _getService();
    if (service == null) return;
    final newCode = service.generateInviteCode();
    HapticFeedback.lightImpact();
    if (!mounted) return;
    setState(() => _myInviteCode = newCode);
  }

  Future<void> _linkPartner() async {
    final code = _codeController.text.trim();
    final name = _nameController.text.trim();

    if (code.length != 6) {
      _showSnackBar(
        _isEnglish
            ? 'Please enter a valid 6-character code'
            : 'Lutfen gecerli 6 haneli bir kod girin',
      );
      return;
    }
    if (name.isEmpty) {
      _showSnackBar(
        _isEnglish
            ? 'Please enter your partner\'s name'
            : 'Lutfen partnerinizin adini girin',
      );
      return;
    }

    final service = await _getService();
    if (service == null) return;

    final success = await service.linkPartner(code, name);
    if (!mounted) return;

    if (success) {
      HapticFeedback.mediumImpact();
      setState(() {
        _partner = service.getPartnerData();
        _isLinking = false;
        _codeController.clear();
        _nameController.clear();
      });
    } else {
      _showSnackBar(
        _isEnglish
            ? 'Could not link partner. Check the code and try again.'
            : 'Partner bağlanılamadı. Kodu kontrol edip tekrar deneyin.',
      );
    }
  }

  Future<void> _unlinkPartner() async {
    final service = await _getService();
    if (service == null) return;

    await service.unlinkPartner();
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    setState(() {
      _partner = null;
      _isLinking = false;
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  bool get _isEnglish {
    final language = ref.read(languageProvider);
    return language == AppLanguage.en;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // ═══════════════════════════════════════════════════════════
              // APP BAR
              // ═══════════════════════════════════════════════════════════
              GlassSliverAppBar(
                title: isEn ? 'Partner Sync' : 'Partner Senkronizasyonu',
              ),

              // ═══════════════════════════════════════════════════════════
              // CONTENT
              // ═══════════════════════════════════════════════════════════
              if (_loading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.starGold),
                  ),
                )
              else if (_partner != null)
                _buildLinkedState(isEn, isDark)
              else if (_isLinking)
                _buildLinkingState(isEn, isDark)
              else
                _buildNotLinkedState(isEn, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STATE 1: NOT LINKED — Show invite code + enter partner code option
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildNotLinkedState(bool isEn, bool isDark) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ── Hero illustration ──
            _buildHeroSection(isEn, isDark),

            const SizedBox(height: 24),

            // ── Your invite code ──
            _buildMyCodeCard(isEn, isDark)
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms)
                .slideY(begin: 0.05, end: 0),

            const SizedBox(height: 16),

            // ── Enter partner's code ──
            _buildEnterCodeButton(isEn, isDark)
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .slideY(begin: 0.05, end: 0),

            const SizedBox(height: 24),

            // ── How it works ──
            _buildHowItWorksCard(isEn, isDark)
                .animate()
                .fadeIn(delay: 300.ms, duration: 400.ms)
                .slideY(begin: 0.05, end: 0),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isEn, bool isDark) {
    return Column(
      children: [
        ExcludeSemantics(
              child: Icon(
                Icons.favorite_rounded,
                size: 56,
                color: AppColors.sunriseStart.withValues(alpha: 0.8),
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(
              begin: const Offset(0.6, 0.6),
              end: const Offset(1.0, 1.0),
              curve: Curves.elasticOut,
              duration: 800.ms,
            ),
        const SizedBox(height: 12),
        Text(
          isEn
              ? 'Share Your Cycle with a Partner'
              : 'Dongunuzu Partnerinizle Paylasin',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        const SizedBox(height: 8),
        Text(
          isEn
              ? 'Invite your partner to see where you are in your emotional cycle. Build mutual understanding.'
              : 'Partnerinizi duygusal döngünüzün neresinde olduğunuzu görmeye davet edin. Karşılıklı anlayış oluşturun.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
            height: 1.4,
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildMyCodeCard(bool isEn, bool isDark) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.qr_code_rounded,
                  color: AppColors.starGold,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                isEn ? 'Your Invite Code' : 'Davet Kodunuz',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Code display ──
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04),
                border: Border.all(
                  color: AppColors.starGold.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: SelectableText(
                _myInviteCode,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 6,
                  color: AppColors.starGold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Action buttons ──
          Row(
            children: [
              Expanded(
                child: _buildSmallButton(
                  icon: Icons.copy_rounded,
                  label: isEn ? 'Copy' : 'Kopyala',
                  isDark: isDark,
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: _myInviteCode));
                    HapticFeedback.lightImpact();
                    _showSnackBar(
                      isEn
                          ? 'Code copied to clipboard'
                          : 'Kod panoya kopyalandi',
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSmallButton(
                  icon: Icons.refresh_rounded,
                  label: isEn ? 'New Code' : 'Yeni Kod',
                  isDark: isDark,
                  onTap: _regenerateCode,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            isEn
                ? 'Share this code with your partner so they can link with you.'
                : 'Bu kodu partnerinizle paylaşın, sizinle bağlanabilsinler.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnterCodeButton(bool isEn, bool isDark) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() => _isLinking = true);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.auroraStart.withValues(alpha: 0.3),
                        AppColors.auroraEnd.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.link_rounded,
                    color: AppColors.auroraStart,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEn
                            ? 'I Have a Partner\'s Code'
                            : 'Partnerin Kodu Bende',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isEn
                            ? 'Enter their invite code to link'
                            : 'Bağlanmak için davet kodunu girin',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHowItWorksCard(bool isEn, bool isDark) {
    final steps = isEn
        ? [
            'Share your invite code with your partner',
            'Your partner enters your code in their app',
            'You both see each other\'s emotional cycle position',
          ]
        : [
            'Davet kodunuzu partnerinizle paylaşın',
            'Partneriniz kodu kendi uygulamasına girsin',
            'Her ikiniz birbirinizin duygusal döngü konumunu görün',
          ];

    return GlassPanel(
      elevation: GlassElevation.g1,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.auroraStart,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isEn ? 'How It Works' : 'Nasil Calisir',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(steps.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.auroraStart.withValues(alpha: 0.15),
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.auroraStart,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      steps[i],
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STATE 2: LINKING — Enter partner's code + their name
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildLinkingState(bool isEn, bool isDark) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            GlassPanel(
              elevation: GlassElevation.g2,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title ──
                  Row(
                    children: [
                      Icon(
                        Icons.link_rounded,
                        color: AppColors.auroraStart,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isEn ? 'Link with Partner' : 'Partner ile Bağlan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Invite code input ──
                  Text(
                    isEn ? 'Partner\'s Invite Code' : 'Partnerin Davet Kodu',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _codeController,
                    focusNode: _codeFocusNode,
                    maxLength: 6,
                    textCapitalization: TextCapitalization.characters,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ABC123',
                      hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.textMuted.withValues(alpha: 0.5)
                            : AppColors.lightTextMuted.withValues(alpha: 0.5),
                        letterSpacing: 4,
                      ),
                      counterText: '',
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.12)
                              : Colors.black.withValues(alpha: 0.1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.12)
                              : Colors.black.withValues(alpha: 0.1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.auroraStart,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: (_) {
                      _nameFocusNode.requestFocus();
                    },
                  ),

                  const SizedBox(height: 20),

                  // ── Partner name input ──
                  Text(
                    isEn ? 'Partner\'s Name' : 'Partnerin Adi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: isEn ? 'Enter their name' : 'Adini girin',
                      hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.textMuted.withValues(alpha: 0.5)
                            : AppColors.lightTextMuted.withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.12)
                              : Colors.black.withValues(alpha: 0.1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.12)
                              : Colors.black.withValues(alpha: 0.1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.auroraStart,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: (_) => _linkPartner(),
                  ),

                  const SizedBox(height: 24),

                  // ── Action buttons ──
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _isLinking = false;
                              _codeController.clear();
                              _nameController.clear();
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.black.withValues(alpha: 0.15),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isEn ? 'Cancel' : 'İptal',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _linkPartner,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppColors.auroraStart,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            isEn ? 'Link Partner' : 'Partneri Bagla',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STATE 3: LINKED — Show partner info, shared mood, unlink
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildLinkedState(bool isEn, bool isDark) {
    final partner = _partner!;
    final daysTogether = partner.daysTogether;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ── Partner card ──
            _buildPartnerCard(
              partner,
              isEn,
              isDark,
              daysTogether,
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),

            const SizedBox(height: 16),

            // ── Shared mood card ──
            _buildSharedMoodCard(partner, isEn, isDark)
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms)
                .slideY(begin: 0.05, end: 0),

            const SizedBox(height: 16),

            // ── Your invite code (still visible for reference) ──
            _buildMyCodeCardCompact(isEn, isDark)
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .slideY(begin: 0.05, end: 0),

            const SizedBox(height: 24),

            // ── Unlink button ──
            _buildUnlinkButton(
              isEn,
              isDark,
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerCard(
    PartnerProfile partner,
    bool isEn,
    bool isDark,
    int daysTogether,
  ) {
    return GlassPanel(
      elevation: GlassElevation.g3,
      padding: const EdgeInsets.all(24),
      glowColor: AppColors.sunriseStart.withValues(alpha: 0.15),
      child: Column(
        children: [
          // ── Avatar + Name ──
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.sunriseStart.withValues(alpha: 0.4),
                  AppColors.sunriseEnd.withValues(alpha: 0.4),
                ],
              ),
            ),
            child: Center(
              child: Text(
                partner.name.isNotEmpty ? partner.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            partner.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.link_rounded,
                size: 16,
                color: AppColors.success.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 6),
              Text(
                isEn ? 'Linked' : 'Bağlandı',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Stats row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn(
                value: daysTogether.toString(),
                label: isEn ? 'Days Together' : 'Birlikte Gun',
                isDark: isDark,
              ),
              Container(
                width: 1,
                height: 36,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.08),
              ),
              _buildStatColumn(
                value: _formatLinkedDate(partner.linkedDate, isEn),
                label: isEn ? 'Linked Since' : 'Bagli',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSharedMoodCard(PartnerProfile partner, bool isEn, bool isDark) {
    final hasMoodData =
        partner.lastSharedMood != null || partner.lastSharedPhase != null;

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sync_rounded, color: AppColors.auroraStart, size: 20),
              const SizedBox(width: 8),
              Text(
                isEn ? 'Shared Cycle Data' : 'Paylasilan Dongu Verisi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (!hasMoodData) ...[
            // ── Empty state ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.03),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.06),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_sync_outlined,
                    size: 36,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isEn
                        ? 'No shared data yet.\nYour partner\'s cycle position will appear here once they sync.'
                        : 'Henüz paylaşılan veri yok.\nPartnerinizin döngü konumu senkronize ettiklerinde burada görünecek.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // ── Mood + Phase indicators ──
            if (partner.lastSharedMood != null)
              _buildDataRow(
                icon: Icons.mood_rounded,
                label: isEn ? 'Mood' : 'Ruh Hali',
                value: partner.lastSharedMood!,
                isDark: isDark,
              ),
            if (partner.lastSharedPhase != null) ...[
              const SizedBox(height: 12),
              _buildDataRow(
                icon: Icons.autorenew_rounded,
                label: isEn ? 'Phase' : 'Faz',
                value: partner.lastSharedPhase!,
                isDark: isDark,
              ),
            ],
            if (partner.lastUpdated != null) ...[
              const SizedBox(height: 12),
              Text(
                isEn
                    ? 'Last updated: ${_formatRelativeTime(partner.lastUpdated!, isEn)}'
                    : 'Son güncelleme: ${_formatRelativeTime(partner.lastUpdated!, isEn)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildMyCodeCardCompact(bool isEn, bool isDark) {
    return GlassPanel(
      elevation: GlassElevation.g1,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.qr_code_rounded,
            color: AppColors.starGold.withValues(alpha: 0.7),
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            isEn ? 'Your Code: ' : 'Kodunuz: ',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            _myInviteCode,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: AppColors.starGold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.copy_rounded,
              size: 18,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _myInviteCode));
              HapticFeedback.lightImpact();
              _showSnackBar(
                isEn ? 'Code copied to clipboard' : 'Kod panoya kopyalandi',
              );
            },
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildUnlinkButton(bool isEn, bool isDark) {
    return TextButton(
      onPressed: () => _showUnlinkConfirmation(isEn, isDark),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.error.withValues(alpha: 0.8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.link_off_rounded,
            size: 18,
            color: AppColors.error.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Text(
            isEn ? 'Unlink Partner' : 'Partneri Çıkart',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.error.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DIALOGS
  // ══════════════════════════════════════════════════════════════════════════

  void _showUnlinkConfirmation(bool isEn, bool isDark) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          isEn ? 'Unlink Partner?' : 'Partneri Çıkart?',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          isEn
              ? 'This will remove the link with ${_partner?.name ?? 'your partner'}. You can always link again later with a new code.'
              : 'Bu, ${_partner?.name ?? 'partneriniz'} ile olan bağlantınızı kaldıracak. Daha sonra yeni bir kodla tekrar bağlanabilirsiniz.',
          style: TextStyle(
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              isEn ? 'Cancel' : 'İptal',
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              _unlinkPartner();
            },
            child: Text(
              isEn ? 'Unlink' : 'Çıkart',
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SHARED WIDGETS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildSmallButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.04),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn({
    required String value,
    required String label,
    required bool isDark,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.auroraStart),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FORMATTING
  // ══════════════════════════════════════════════════════════════════════════

  String _formatLinkedDate(DateTime date, bool isEn) {
    final months = isEn
        ? [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ]
        : [
            'Oca',
            'Sub',
            'Mar',
            'Nis',
            'May',
            'Haz',
            'Tem',
            'Agu',
            'Eyl',
            'Eki',
            'Kas',
            'Ara',
          ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatRelativeTime(DateTime dateTime, bool isEn) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) {
      return isEn ? 'Just now' : 'Az once';
    } else if (diff.inMinutes < 60) {
      return isEn ? '${diff.inMinutes}m ago' : '${diff.inMinutes}dk once';
    } else if (diff.inHours < 24) {
      return isEn ? '${diff.inHours}h ago' : '${diff.inHours}sa once';
    } else {
      return isEn ? '${diff.inDays}d ago' : '${diff.inDays}g once';
    }
  }
}
