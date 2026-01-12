import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../shared/widgets/cosmic_background.dart';

/// Eclipse Calendar Screen - Comprehensive eclipse listing
class EclipseCalendarScreen extends ConsumerStatefulWidget {
  const EclipseCalendarScreen({super.key});

  @override
  ConsumerState<EclipseCalendarScreen> createState() => _EclipseCalendarScreenState();
}

class _EclipseCalendarScreenState extends ConsumerState<EclipseCalendarScreen> {
  int _selectedYear = DateTime.now().year;
  Eclipse? _selectedEclipse;

  @override
  Widget build(BuildContext context) {
    final eclipses = EclipseService.getEclipsesForYear(_selectedYear);
    final upcomingEclipses = EclipseService.getUpcomingEclipses();

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: _selectedEclipse != null
              ? _buildEclipseDetail(context)
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      _buildNextEclipseCard(context, upcomingEclipses.isNotEmpty ? upcomingEclipses.first : null),
                      _buildYearSelector(context),
                      _buildEclipseList(context, eclipses),
                      const SizedBox(height: AppConstants.spacingXl),
                      _buildEclipseExplanation(context),
                      const SizedBox(height: AppConstants.spacingXxl),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tutulma Takvimi',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.starGold,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Gunes ve Ay Tutulmalari',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.fireElement.withAlpha(60),
                  AppColors.fireElement.withAlpha(20),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Text('🌒', style: TextStyle(fontSize: 28)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildNextEclipseCard(BuildContext context, Eclipse? nextEclipse) {
    if (nextEclipse == null) {
      return const SizedBox.shrink();
    }

    final daysUntil = nextEclipse.date.difference(DateTime.now()).inDays;

    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingLg),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            nextEclipse.type.color.withAlpha(40),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(color: nextEclipse.type.color.withAlpha(60)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: nextEclipse.type.color.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    nextEclipse.type.emoji,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingLg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.starGold.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'SIRADAKI TUTULMA',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.starGold,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      nextEclipse.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      nextEclipse.sign.nameTr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: nextEclipse.sign.color,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCountdownItem(context, daysUntil.toString(), 'Gun'),
              Container(width: 1, height: 40, color: AppColors.surfaceLight.withAlpha(30)),
              _buildCountdownItem(context, _formatDate(nextEclipse.date), 'Tarih'),
              Container(width: 1, height: 40, color: AppColors.surfaceLight.withAlpha(30)),
              _buildCountdownItem(context, '${nextEclipse.degree.toStringAsFixed(0)}°', 'Derece'),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          GestureDetector(
            onTap: () => setState(() => _selectedEclipse = nextEclipse),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: nextEclipse.type.color.withAlpha(30),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Detaylari Gor',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: nextEclipse.type.color,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: nextEclipse.type.color),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildCountdownItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.starGold,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
      ],
    );
  }

  Widget _buildYearSelector(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (i) => currentYear - 1 + i);

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: AppConstants.spacingMd),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];
          final isSelected = year == _selectedYear;

          return GestureDetector(
            onTap: () => setState(() => _selectedYear = year),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.starGold : AppColors.surfaceLight.withAlpha(30),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Text(
                '$year',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected ? AppColors.deepSpace : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildEclipseList(BuildContext context, List<Eclipse> eclipses) {
    if (eclipses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Center(
          child: Text(
            'Bu yil icin tutulma verisi yok',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$_selectedYear Tutulmalari',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...eclipses.asMap().entries.map((entry) {
            final index = entry.key;
            final eclipse = entry.value;
            return _buildEclipseCard(context, eclipse)
                .animate()
                .fadeIn(delay: (300 + index * 100).ms, duration: 400.ms);
          }),
        ],
      ),
    );
  }

  Widget _buildEclipseCard(BuildContext context, Eclipse eclipse) {
    final isPast = eclipse.date.isBefore(DateTime.now());

    return GestureDetector(
      onTap: () => setState(() => _selectedEclipse = eclipse),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isPast
              ? AppColors.surfaceLight.withAlpha(20)
              : eclipse.type.color.withAlpha(20),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: isPast
                ? AppColors.surfaceLight.withAlpha(30)
                : eclipse.type.color.withAlpha(40),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: eclipse.type.color.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  eclipse.type.emoji,
                  style: TextStyle(
                    fontSize: 24,
                    color: isPast ? AppColors.textMuted : null,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        eclipse.type.nameTr,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: isPast ? AppColors.textMuted : eclipse.type.color,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (isPast) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.textMuted.withAlpha(30),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'GECMIS',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 8,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        eclipse.sign.symbol,
                        style: TextStyle(color: eclipse.sign.color),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${eclipse.sign.nameTr} ${eclipse.degree.toStringAsFixed(0)}°',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isPast ? AppColors.textMuted : AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDate(eclipse.date),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isPast ? AppColors.textMuted : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  eclipse.time,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: isPast ? AppColors.textMuted : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEclipseExplanation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight.withAlpha(20),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.auroraStart, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Tutulmalar Hakkinda',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMd),
            _buildExplanationItem(context, '🌑', 'Gunes Tutulmasi',
                'Yeni Ay\'da gerceklesir. Yeni baslangiclari tetikler.'),
            _buildExplanationItem(context, '🌕', 'Ay Tutulmasi',
                'Dolunay\'da gerceklesir. Sonlanmalar ve kapanislar getirir.'),
            _buildExplanationItem(context, '⚡', 'Tutulma Ekseni',
                'Tutulmalar belirli burc eksenlerinde gerceklesir ve o alanlari aktive eder.'),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }

  Widget _buildExplanationItem(BuildContext context, String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEclipseDetail(BuildContext context) {
    final eclipse = _selectedEclipse!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _selectedEclipse = null),
                icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
              ),
              Expanded(
                child: Text(
                  'Tutulma Detayi',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingXl),

          // Eclipse visualization
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    eclipse.type.color.withAlpha(60),
                    eclipse.type.color.withAlpha(20),
                    Colors.transparent,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  eclipse.type.emoji,
                  style: const TextStyle(fontSize: 80),
                ),
              ),
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

          const SizedBox(height: AppConstants.spacingXl),

          // Title and basic info
          Center(
            child: Column(
              children: [
                Text(
                  eclipse.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      eclipse.sign.symbol,
                      style: TextStyle(fontSize: 20, color: eclipse.sign.color),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${eclipse.sign.nameTr} ${eclipse.degree.toStringAsFixed(1)}°',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: eclipse.sign.color,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

          const SizedBox(height: AppConstants.spacingXl),

          // Details grid
          _buildDetailGrid(context, eclipse),

          const SizedBox(height: AppConstants.spacingXl),

          // Meaning
          _buildSection(context, '🔮', 'Anlami', eclipse.meaning),

          const SizedBox(height: AppConstants.spacingLg),

          // Effects
          _buildSection(context, '⚡', 'Etkileri', eclipse.effects),

          const SizedBox(height: AppConstants.spacingLg),

          // Advice
          _buildSection(context, '💡', 'Tavsiyeler', eclipse.advice),

          const SizedBox(height: AppConstants.spacingLg),

          // Affected signs
          _buildAffectedSigns(context, eclipse),

          const SizedBox(height: AppConstants.spacingXxl),
        ],
      ),
    );
  }

  Widget _buildDetailGrid(BuildContext context, Eclipse eclipse) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDetailItem(context, 'Tarih', _formatDateLong(eclipse.date))),
              Expanded(child: _buildDetailItem(context, 'Saat', eclipse.time)),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Expanded(child: _buildDetailItem(context, 'Tur', eclipse.type.nameTr)),
              Expanded(child: _buildDetailItem(context, 'Sure', eclipse.duration)),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Expanded(child: _buildDetailItem(context, 'Gorunurluk', eclipse.visibility)),
              Expanded(child: _buildDetailItem(context, 'Saros', eclipse.sarosCycle.toString())),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String emoji, String title, String content) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildAffectedSigns(BuildContext context, Eclipse eclipse) {
    final affectedSigns = eclipse.getAffectedSigns();

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎯', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'En Cok Etkilenen Burclar',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: affectedSigns.map((sign) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: sign.color.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: sign.color.withAlpha(50)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(sign.symbol, style: TextStyle(fontSize: 16, color: sign.color)),
                  const SizedBox(width: 6),
                  Text(
                    sign.nameTr,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: sign.color,
                        ),
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
  }

  String _formatDate(DateTime date) {
    final months = ['Oca', 'Sub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Agu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatDateLong(DateTime date) {
    final months = [
      'Ocak', 'Subat', 'Mart', 'Nisan', 'Mayis', 'Haziran',
      'Temmuz', 'Agustos', 'Eylul', 'Ekim', 'Kasim', 'Aralik'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

/// Eclipse Type
enum EclipseType {
  solarTotal,
  solarPartial,
  solarAnnular,
  lunarTotal,
  lunarPartial,
  lunarPenumbral;

  String get nameTr => switch (this) {
    solarTotal => 'Tam Gunes Tutulmasi',
    solarPartial => 'Kismi Gunes Tutulmasi',
    solarAnnular => 'Halkali Gunes Tutulmasi',
    lunarTotal => 'Tam Ay Tutulmasi',
    lunarPartial => 'Kismi Ay Tutulmasi',
    lunarPenumbral => 'Yarigolge Ay Tutulmasi',
  };

  String get emoji => switch (this) {
    solarTotal => '🌑',
    solarPartial => '🌒',
    solarAnnular => '🌘',
    lunarTotal => '🌕',
    lunarPartial => '🌖',
    lunarPenumbral => '🌗',
  };

  Color get color => switch (this) {
    solarTotal => AppColors.fireElement,
    solarPartial => Colors.orange,
    solarAnnular => AppColors.starGold,
    lunarTotal => AppColors.waterElement,
    lunarPartial => AppColors.auroraStart,
    lunarPenumbral => AppColors.twilightStart,
  };

  bool get isSolar => this == solarTotal || this == solarPartial || this == solarAnnular;
}

/// Eclipse Model
class Eclipse {
  final DateTime date;
  final String time;
  final EclipseType type;
  final ZodiacSign sign;
  final double degree;
  final String title;
  final String meaning;
  final String effects;
  final String advice;
  final String visibility;
  final String duration;
  final int sarosCycle;

  Eclipse({
    required this.date,
    required this.time,
    required this.type,
    required this.sign,
    required this.degree,
    required this.title,
    required this.meaning,
    required this.effects,
    required this.advice,
    required this.visibility,
    required this.duration,
    required this.sarosCycle,
  });

  List<ZodiacSign> getAffectedSigns() {
    final signs = <ZodiacSign>[];
    signs.add(sign); // The eclipse sign

    // Opposite sign
    final oppositeIndex = (sign.index + 6) % 12;
    signs.add(ZodiacSign.values[oppositeIndex]);

    // Square signs
    final square1Index = (sign.index + 3) % 12;
    final square2Index = (sign.index + 9) % 12;
    signs.add(ZodiacSign.values[square1Index]);
    signs.add(ZodiacSign.values[square2Index]);

    return signs;
  }
}

/// Eclipse Service
class EclipseService {
  static List<Eclipse> getEclipsesForYear(int year) {
    // Real eclipse data for years 2024-2027
    final eclipseData = <int, List<Eclipse>>{
      2024: [
        Eclipse(
          date: DateTime(2024, 3, 25),
          time: '10:13 UTC',
          type: EclipseType.lunarPenumbral,
          sign: ZodiacSign.libra,
          degree: 5.07,
          title: 'Terazi Yarigolge Ay Tutulmasi',
          meaning: 'Iliksiler ve ortakliklar uzerinde yogunlasan bir donem. Dengeler yeniden ayarlaniyor.',
          effects: 'Iliskilerdeki dengesizlikler yuzey cikiyor. Karar vermek zorunda kalabilirsiniz.',
          advice: 'Iliskilerde denge arayin. Uzlasmaci olun ama kendinizi de ihmal etmeyin.',
          visibility: 'Amerika, Avrupa, Afrika',
          duration: '4 saat 39 dakika',
          sarosCycle: 113,
        ),
        Eclipse(
          date: DateTime(2024, 4, 8),
          time: '18:17 UTC',
          type: EclipseType.solarTotal,
          sign: ZodiacSign.aries,
          degree: 19.24,
          title: 'Koc Tam Gunes Tutulmasi',
          meaning: 'Yeni baslangiclarin guclu enerjisi. Kisisel kimlik ve cesaret temalari.',
          effects: 'Hayatinizda buyuk bir sayfa aciliyor. Cesur adimlar atma zamani.',
          advice: 'Korkularinizi yenin. Kendinizi oncelikli yapin. Yeni projelere baslayin.',
          visibility: 'Meksika, ABD, Kanada',
          duration: '4 dakika 28 saniye',
          sarosCycle: 139,
        ),
        Eclipse(
          date: DateTime(2024, 9, 18),
          time: '02:44 UTC',
          type: EclipseType.lunarPartial,
          sign: ZodiacSign.pisces,
          degree: 25.41,
          title: 'Balik Kismi Ay Tutulmasi',
          meaning: 'Spiritüel kapanislar ve duygusal arinma. Gecmisi birakma zamani.',
          effects: 'Eski duygusal baglar cozuluyor. Ruyalar yogunlasiyor.',
          advice: 'Meditasyon yapin. Bagislayin ve birakin. Sezgilerinize guvenin.',
          visibility: 'Avrupa, Afrika, Asya, Avustralya',
          duration: '1 saat 3 dakika',
          sarosCycle: 118,
        ),
        Eclipse(
          date: DateTime(2024, 10, 2),
          time: '18:49 UTC',
          type: EclipseType.solarAnnular,
          sign: ZodiacSign.libra,
          degree: 10.04,
          title: 'Terazi Halkali Gunes Tutulmasi',
          meaning: 'Iliskiler ve ortakliklar icin yeni bir sayfa. Dengelerin yeniden kurulmasi.',
          effects: 'Onemli iliskilerde yeni baslangilar. Evlilik veya ayrilik kararlari.',
          advice: 'Iliskilerde netlik arayin. Adil ve dengeli olun.',
          visibility: 'Guney Amerika',
          duration: '7 dakika 25 saniye',
          sarosCycle: 144,
        ),
      ],
      2025: [
        Eclipse(
          date: DateTime(2025, 3, 14),
          time: '06:54 UTC',
          type: EclipseType.lunarTotal,
          sign: ZodiacSign.virgo,
          degree: 23.95,
          title: 'Basak Tam Ay Tutulmasi',
          meaning: 'Saglik, is ve gunluk rutinler uzerinde yogun kapanislar.',
          effects: 'Is hayatinda onemli sonlanmalar. Saglik konulari gundemde.',
          advice: 'Rutinlerinizi gozden gecirin. Sagliginiza dikkat edin.',
          visibility: 'Amerika, Avrupa, Afrika',
          duration: '1 saat 5 dakika',
          sarosCycle: 123,
        ),
        Eclipse(
          date: DateTime(2025, 3, 29),
          time: '10:48 UTC',
          type: EclipseType.solarPartial,
          sign: ZodiacSign.aries,
          degree: 9.00,
          title: 'Koc Kismi Gunes Tutulmasi',
          meaning: 'Kisisel kimlik ve yeni baslangilar. Cesaret ve liderlik temalari.',
          effects: 'Yeni projeler ve girisimler icin guclu enerji.',
          advice: 'Inisiyatif alin. Kendinize guvenin.',
          visibility: 'Kuzey Amerika, Avrupa',
          duration: '-',
          sarosCycle: 149,
        ),
        Eclipse(
          date: DateTime(2025, 9, 7),
          time: '18:11 UTC',
          type: EclipseType.lunarTotal,
          sign: ZodiacSign.pisces,
          degree: 15.23,
          title: 'Balik Tam Ay Tutulmasi',
          meaning: 'Derin spiritüel kapanislar. Bilinçalti temizligi.',
          effects: 'Eski korkular ve bagimliliklar cozuluyor.',
          advice: 'Ice donun. Meditasyon ve terapi faydali olabilir.',
          visibility: 'Avrupa, Afrika, Asya',
          duration: '1 saat 22 dakika',
          sarosCycle: 128,
        ),
        Eclipse(
          date: DateTime(2025, 9, 21),
          time: '19:42 UTC',
          type: EclipseType.solarPartial,
          sign: ZodiacSign.virgo,
          degree: 29.05,
          title: 'Basak Kismi Gunes Tutulmasi',
          meaning: 'Is ve saglik konularinda yeni baslangilar.',
          effects: 'Yeni is firsatlari. Saglikli yasam degisiklikleri.',
          advice: 'Detaylara dikkat edin. Organize olun.',
          visibility: 'Güney Yarımküre',
          duration: '-',
          sarosCycle: 154,
        ),
      ],
      2026: [
        Eclipse(
          date: DateTime(2026, 2, 17),
          time: '12:01 UTC',
          type: EclipseType.solarAnnular,
          sign: ZodiacSign.aquarius,
          degree: 28.50,
          title: 'Kova Halkali Gunes Tutulmasi',
          meaning: 'Toplumsal degisimler ve yenilikcilik. Grup dinamikleri.',
          effects: 'Sosyal cevre degisiklikleri. Yeni idealler.',
          advice: 'Topluluklar icinde yerinizi bulun. Yenilikci olun.',
          visibility: 'Güney Amerika, Afrika',
          duration: '2 dakika 20 saniye',
          sarosCycle: 121,
        ),
        Eclipse(
          date: DateTime(2026, 3, 3),
          time: '11:33 UTC',
          type: EclipseType.lunarTotal,
          sign: ZodiacSign.virgo,
          degree: 12.85,
          title: 'Basak Tam Ay Tutulmasi',
          meaning: 'Is ve saglik konularinda onemli kapanislar.',
          effects: 'Is yerinde degisiklikler. Saglik sorunlari cozuluyor.',
          advice: 'Rutinlerinizi sadellestirin. Sagliginiza oncelik verin.',
          visibility: 'Amerika, Avrupa, Afrika',
          duration: '58 dakika',
          sarosCycle: 133,
        ),
        Eclipse(
          date: DateTime(2026, 8, 12),
          time: '17:46 UTC',
          type: EclipseType.solarTotal,
          sign: ZodiacSign.leo,
          degree: 19.88,
          title: 'Aslan Tam Gunes Tutulmasi',
          meaning: 'Yaraticilik ve kendini ifade etme. Liderlik temalari.',
          effects: 'Yaratici projelerde buyuk baslangilar. Sahne almak.',
          advice: 'Yaraticiliginda ozgur birakin. Isik olun.',
          visibility: 'Avrupa, Afrika',
          duration: '2 dakika 18 saniye',
          sarosCycle: 126,
        ),
        Eclipse(
          date: DateTime(2026, 8, 28),
          time: '04:12 UTC',
          type: EclipseType.lunarPartial,
          sign: ZodiacSign.pisces,
          degree: 4.77,
          title: 'Balik Kismi Ay Tutulmasi',
          meaning: 'Spiritüel konularda farkindaliik. Rüyalar ve sezgiler.',
          effects: 'Bilinçalti mesajlar. Duygusal temizlik.',
          advice: 'Sezgilerinizi dinleyin. Meditasyon yapin.',
          visibility: 'Asya, Avustralya, Amerika',
          duration: '3 saat 18 dakika',
          sarosCycle: 138,
        ),
      ],
    };

    return eclipseData[year] ?? [];
  }

  static List<Eclipse> getUpcomingEclipses() {
    final now = DateTime.now();
    final allEclipses = <Eclipse>[];

    for (int year = now.year; year <= now.year + 2; year++) {
      allEclipses.addAll(getEclipsesForYear(year));
    }

    return allEclipses.where((e) => e.date.isAfter(now)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}
