import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/zodiac_card.dart';

class HoroscopeScreen extends StatelessWidget {
  const HoroscopeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: AppColors.textPrimary,
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Text(
                      'Daily Horoscopes',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: ZodiacSign.values.length,
                  itemBuilder: (context, index) {
                    final sign = ZodiacSign.values[index];
                    return ZodiacGridCard(
                      sign: sign,
                      onTap: () => context.push(
                          '${Routes.horoscope}/${sign.name.toLowerCase()}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
