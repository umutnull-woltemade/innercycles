// ════════════════════════════════════════════════════════════════════════════
// PRIVATE TOGGLE - "Gizli Kaydet" toggle for journal/note screens
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/providers/app_providers.dart';

class PrivateToggle extends ConsumerWidget {
  final bool isPrivate;
  final ValueChanged<bool> onChanged;
  final bool isEn;
  final bool isDark;

  const PrivateToggle({
    super.key,
    required this.isPrivate,
    required this.onChanged,
    required this.isEn,
    required this.isDark,
  });

  Future<void> _handleToggle(BuildContext context, WidgetRef ref, bool value) async {
    if (value) {
      // Turning ON — check vault setup
      final vaultService = await ref.read(vaultServiceProvider.future);
      if (!vaultService.isVaultSetUp) {
        // No vault yet — prompt setup via dialog
        if (!context.mounted) return;
        final shouldSetup = await showCupertinoDialog<bool>(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: Text(isEn ? 'Set Up Vault PIN' : 'Kasa PIN\'i Ayarla'),
            content: Text(
              isEn
                  ? 'You need to create a 4-digit PIN to protect your private content.'
                  : 'Gizli içeriklerini korumak için 4 haneli bir PIN oluşturman gerekiyor.',
            ),
            actions: [
              CupertinoDialogAction(
                child: Text(isEn ? 'Cancel' : 'Vazgeç'),
                onPressed: () => Navigator.pop(ctx, false),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(isEn ? 'Set Up' : 'Ayarla'),
                onPressed: () => Navigator.pop(ctx, true),
              ),
            ],
          ),
        );
        if (shouldSetup == true && context.mounted) {
          context.push(Routes.vaultPin, extra: {'mode': 'setup'});
        }
        return; // Don't toggle yet — they'll enable after setup
      }
    }
    onChanged(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _handleToggle(context, ref, !isPrivate),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isPrivate
              ? AppColors.amethyst.withValues(alpha: 0.12)
              : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: isPrivate
              ? Border.all(color: AppColors.amethyst.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isPrivate ? CupertinoIcons.lock_fill : CupertinoIcons.lock_open,
                key: ValueKey(isPrivate),
                size: 18,
                color: isPrivate
                    ? AppColors.amethyst
                    : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEn ? 'Save to Vault' : 'Gizli Kaydet',
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: isPrivate
                          ? AppColors.amethyst
                          : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                    ).copyWith(fontWeight: isPrivate ? FontWeight.w600 : FontWeight.w400),
                  ),
                  Text(
                    isEn
                        ? 'Protected with PIN & Face ID'
                        : 'PIN ve Face ID ile korunur',
                    style: AppTypography.subtitle(
                      fontSize: 11,
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            CupertinoSwitch(
              value: isPrivate,
              onChanged: (v) => _handleToggle(context, ref, v),
              activeTrackColor: AppColors.amethyst,
            ),
          ],
        ),
      ),
    ).animate(target: isPrivate ? 1 : 0).shimmer(
      duration: 800.ms,
      color: AppColors.amethyst.withValues(alpha: 0.05),
    );
  }
}
