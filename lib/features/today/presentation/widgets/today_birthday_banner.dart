import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/birthday_avatar.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';

class TodayBirthdayBanner extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const TodayBirthdayBanner({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(birthdayContactServiceProvider);
    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final todayBirthdays = service.getTodayBirthdays();
        if (todayBirthdays.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Semantics(
            button: true,
            label: isEn ? 'View birthday agenda' : 'Doğum günü ajandası',
            child: TapScale(
              onTap: () => context.push(Routes.birthdayAgenda),
              child: PremiumCard(
                style: PremiumCardStyle.gold,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Stacked avatars
                    SizedBox(
                      width: todayBirthdays.length == 1 ? 48 : 64,
                      height: 48,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          BirthdayAvatar(
                            photoPath: todayBirthdays.first.photoPath,
                            name: todayBirthdays.first.name,
                            size: 44,
                            showBirthdayCake: true,
                          ),
                          if (todayBirthdays.length > 1)
                            Positioned(
                              left: 24,
                              child: BirthdayAvatar(
                                photoPath: todayBirthdays[1].photoPath,
                                name: todayBirthdays[1].name,
                                size: 44,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todayBirthdays.length == 1
                                ? todayBirthdays.first.name
                                : '${todayBirthdays.first.name} +${todayBirthdays.length - 1}',
                            style: AppTypography.displayFont.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isEn
                                ? '\u{1F382} Birthday today!'
                                : '\u{1F382} Bug\u{00FC}n do\u{011F}um g\u{00FC}n\u{00FC}!',
                            style: AppTypography.subtitle(
                              fontSize: 14,
                              color: AppColors.starGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.starGold,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).glassEntrance(context: context);
      },
    );
  }
}
