import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';

/// Solar Return Screen
/// Shows the yearly forecast based on the Sun returning to its natal position
class SolarReturnScreen extends ConsumerStatefulWidget {
  const SolarReturnScreen({super.key});

  @override
  ConsumerState<SolarReturnScreen> createState() => _SolarReturnScreenState();
}

class _SolarReturnScreenState extends ConsumerState<SolarReturnScreen> {
  late int _selectedYear;
  late SolarReturnData _returnData;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
    _calculateReturn();
  }

  void _calculateReturn() {
    final userProfile = ref.read(userProfileProvider);
    final birthDate = userProfile?.birthDate ?? DateTime(1990, 6, 15);
    _returnData = SolarReturnCalculator.calculate(birthDate, _selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    // Watch for profile changes
    ref.watch(userProfileProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: AppConstants.spacingXl),
                _buildYearSelector(context),
                const SizedBox(height: AppConstants.spacingXl),
                _buildReturnInfo(context),
                const SizedBox(height: AppConstants.spacingXl),
                _buildYearThemes(context),
                const SizedBox(height: AppConstants.spacingXl),
                _buildMonthlyHighlights(context),
                const SizedBox(height: AppConstants.spacingXl),
                _buildKeyDates(context),
                const SizedBox(height: AppConstants.spacingXl),
                _buildAdvice(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
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
                'Solar Return',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Dogum Gunu Haritasi',
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
                AppColors.starGold.withAlpha(60),
                AppColors.starGold.withAlpha(20),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Text(
            '☀️',
            style: TextStyle(fontSize: 28),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildYearSelector(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (i) => currentYear - 2 + i);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(30),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];
          final isSelected = year == _selectedYear;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedYear = year;
                _calculateReturn();
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.starGold : Colors.transparent,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Center(
                child: Text(
                  '$year',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected ? AppColors.deepSpace : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildReturnInfo(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final sunSign = userProfile?.sunSign ?? ZodiacSign.aries;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.starGold.withAlpha(30),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.starGold.withAlpha(50)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.starGold.withAlpha(100),
                      AppColors.starGold.withAlpha(30),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    sunSign.symbol,
                    style: TextStyle(fontSize: 28, color: sunSign.color),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_selectedYear Solar Return',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.starGold,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gunes ${sunSign.nameTr} burcuna donuyor',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(context, 'Donus Tarihi', _formatDate(_returnData.exactReturnDate)),
                    _buildInfoItem(context, 'Yukselen', _returnData.risingSign.nameTr),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(context, 'Gunes Evi', '${_returnData.sunHouse}. Ev'),
                    _buildInfoItem(context, 'Ay Burcu', _returnData.moonSign.nameTr),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
        const SizedBox(height: 2),
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

  Widget _buildYearThemes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.starGold, size: 20),
            const SizedBox(width: 8),
            Text(
              'Yil Temalari',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ..._returnData.themes.asMap().entries.map((entry) {
          final index = entry.key;
          final theme = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
            child: _buildThemeCard(context, theme),
          ).animate().fadeIn(delay: (300 + index * 100).ms, duration: 400.ms);
        }),
      ],
    );
  }

  Widget _buildThemeCard(BuildContext context, SolarReturnTheme theme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: theme.color.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: theme.color.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(theme.emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  theme.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: theme.color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  theme.description,
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

  Widget _buildMonthlyHighlights(BuildContext context) {
    final months = [
      'Ocak', 'Subat', 'Mart', 'Nisan', 'Mayis', 'Haziran',
      'Temmuz', 'Agustos', 'Eylul', 'Ekim', 'Kasim', 'Aralik'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month, color: AppColors.auroraStart, size: 20),
            const SizedBox(width: 8),
            Text(
              'Aylik One Cikanlar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            itemBuilder: (context, index) {
              final highlight = _returnData.monthlyHighlights[index];
              return Container(
                width: 80,
                margin: EdgeInsets.only(right: index < 11 ? 8 : 0),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: highlight.isPositive
                      ? Colors.green.withAlpha(20)
                      : highlight.isChallenging
                          ? Colors.orange.withAlpha(20)
                          : AppColors.surfaceLight.withAlpha(30),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  border: Border.all(
                    color: highlight.isPositive
                        ? Colors.green.withAlpha(40)
                        : highlight.isChallenging
                            ? Colors.orange.withAlpha(40)
                            : AppColors.surfaceLight.withAlpha(50),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      months[index].substring(0, 3),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      highlight.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      highlight.keyword,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 9,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }

  Widget _buildKeyDates(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.event_note, color: AppColors.twilightStart, size: 20),
            const SizedBox(width: 8),
            Text(
              'Onemli Tarihler',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ..._returnData.keyDates.map((keyDate) => Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withAlpha(30),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      child: Column(
                        children: [
                          Text(
                            '${keyDate.date.day}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.starGold,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            _getMonthAbbr(keyDate.date.month),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            keyDate.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          Text(
                            keyDate.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      keyDate.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            )),
      ],
    ).animate().fadeIn(delay: 700.ms, duration: 400.ms);
  }

  Widget _buildAdvice(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.auroraStart.withAlpha(20),
            AppColors.auroraEnd.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.auroraStart.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: AppColors.auroraStart, size: 20),
              const SizedBox(width: 8),
              Text(
                'Yil Icin Onerim',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.auroraStart,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            _returnData.yearAdvice,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms, duration: 400.ms);
  }

  String _formatDate(DateTime date) {
    final months = [
      'Ocak', 'Subat', 'Mart', 'Nisan', 'Mayis', 'Haziran',
      'Temmuz', 'Agustos', 'Eylul', 'Ekim', 'Kasim', 'Aralik'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getMonthAbbr(int month) {
    final months = ['Oca', 'Sub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Agu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    return months[month - 1];
  }
}

/// Solar Return Calculator
class SolarReturnCalculator {
  static SolarReturnData calculate(DateTime birthDate, int year) {
    // Calculate exact return date (approximate - Sun returns to natal position)
    final exactReturnDate = DateTime(year, birthDate.month, birthDate.day, 12, 0);

    // Generate return data based on year and birth data
    final seed = year * 1000 + birthDate.month * 10 + birthDate.day;

    // Pseudo-random but consistent results
    final risingIndex = (seed + year) % 12;
    final moonIndex = (seed + year * 2) % 12;
    final sunHouse = ((seed + year) % 12) + 1;

    return SolarReturnData(
      year: year,
      birthDate: birthDate,
      exactReturnDate: exactReturnDate,
      risingSign: ZodiacSign.values[risingIndex],
      moonSign: ZodiacSign.values[moonIndex],
      sunHouse: sunHouse,
      themes: _generateThemes(seed, sunHouse),
      monthlyHighlights: _generateMonthlyHighlights(seed),
      keyDates: _generateKeyDates(year, seed),
      yearAdvice: _generateAdvice(sunHouse, ZodiacSign.values[risingIndex]),
    );
  }

  static List<SolarReturnTheme> _generateThemes(int seed, int sunHouse) {
    final allThemes = [
      SolarReturnTheme(title: 'Kariyer Odagi', description: 'Mesleki gelisim ve toplumsal konum on planda', emoji: '💼', color: AppColors.starGold),
      SolarReturnTheme(title: 'Iliskiler', description: 'Partnerllik ve isbirliklerinde onemli gelismeler', emoji: '💕', color: Colors.pink),
      SolarReturnTheme(title: 'Kisisel Gelisim', description: 'Kendinizi yeniden kesfetme zamani', emoji: '🌱', color: AppColors.earthElement),
      SolarReturnTheme(title: 'Finansal Buyume', description: 'Maddi konularda firsatlar', emoji: '💰', color: AppColors.celestialGold),
      SolarReturnTheme(title: 'Egitim ve Seyahat', description: 'Ufkunuzu genisletme zamani', emoji: '✈️', color: AppColors.airElement),
      SolarReturnTheme(title: 'Ev ve Aile', description: 'Koklere donus ve yuva kurma', emoji: '🏠', color: AppColors.waterElement),
      SolarReturnTheme(title: 'Yaraticilik', description: 'Sanatsal ifade ve eglence', emoji: '🎨', color: AppColors.auroraStart),
      SolarReturnTheme(title: 'Saglik ve Rutin', description: 'Gunluk yasami iyilestirme', emoji: '🧘', color: Colors.teal),
    ];

    // Select 3-4 themes based on sun house
    final selectedIndices = <int>{};
    selectedIndices.add(sunHouse % allThemes.length);
    selectedIndices.add((sunHouse + 3) % allThemes.length);
    selectedIndices.add((sunHouse + 7) % allThemes.length);
    if (sunHouse > 6) {
      selectedIndices.add((sunHouse + 5) % allThemes.length);
    }

    return selectedIndices.map((i) => allThemes[i]).toList();
  }

  static List<MonthlyHighlight> _generateMonthlyHighlights(int seed) {
    final keywords = ['Baslangic', 'Buyume', 'Zorluk', 'Firsat', 'Dinlenme', 'Aksiyon', 'Dusunme', 'Ilerleme', 'Degisim', 'Denge', 'Hasat', 'Kapaniş'];
    final emojis = ['🚀', '🌿', '⚡', '✨', '🌙', '🔥', '🤔', '📈', '🔄', '⚖️', '🌾', '🎁'];

    return List.generate(12, (month) {
      final monthSeed = seed + month;
      final isPositive = monthSeed % 3 == 0;
      final isChallenging = monthSeed % 5 == 0 && !isPositive;

      return MonthlyHighlight(
        month: month + 1,
        keyword: keywords[month],
        emoji: emojis[month],
        isPositive: isPositive,
        isChallenging: isChallenging,
      );
    });
  }

  static List<KeyDate> _generateKeyDates(int year, int seed) {
    return [
      KeyDate(
        date: DateTime(year, 3, 20 + (seed % 3)),
        title: 'Bahar Ekinoksu',
        description: 'Yeni projelere baslamak icin ideal',
        emoji: '🌸',
      ),
      KeyDate(
        date: DateTime(year, 6, 20 + (seed % 2)),
        title: 'Yaz Donumu',
        description: 'Enerji zirvede, aksiyona gec',
        emoji: '☀️',
      ),
      KeyDate(
        date: DateTime(year, 9, 22 + (seed % 2)),
        title: 'Sonbahar Ekinoksu',
        description: 'Dengeleme ve dusunme zamani',
        emoji: '🍂',
      ),
      KeyDate(
        date: DateTime(year, 12, 21),
        title: 'Kis Donumu',
        description: 'Ice donus ve planlama',
        emoji: '❄️',
      ),
    ];
  }

  static String _generateAdvice(int sunHouse, ZodiacSign rising) {
    final houseAdvice = {
      1: 'Bu yil kendinize odaklanin. Kisisel hedeflerinizi belirleyin ve cesaretinizi kullanin.',
      2: 'Finansal planlarinizi gozden gecirin. Degerleriniz ve kaynaklariniz uzerinde calisin.',
      3: 'Iletisim becerilerinizi gelistirin. Yakin cevrenizle baglantilari guclendirin.',
      4: 'Evinize ve ailenize zaman ayirin. Duygusal guvenliginizi oncelikli yapin.',
      5: 'Yaraticiliginda ozgur birakin. Ask ve eglence hayatinda canlilik bekleyin.',
      6: 'Sagliginiza ve gunluk rutinlerinize dikkat edin. Is ortaminda gelismeler olacak.',
      7: 'Iliskileriniz on planda. Ortakliklar ve evlilik konularinda onemli adimlar.',
      8: 'Derinlere inin. Donusum ve yenilenme zamani. Ortak finanslar onem kazaniyor.',
      9: 'Ufkunuzu genisletin. Egitim, seyahat ve felsefi arayislar icin ideal yil.',
      10: 'Kariyer hedeflerinize odaklanin. Toplumda yerinizi belirleyin.',
      11: 'Sosyal cevrenizi genisletin. Gelecek hayalleriniz icin calisin.',
      12: 'Ice donus yili. Ruhsal gelisim ve dinlenme oncelikli olmali.',
    };

    return houseAdvice[sunHouse] ?? 'Bu yil sizin icin onemli donusumler getirecek.';
  }
}

/// Solar Return Data
class SolarReturnData {
  final int year;
  final DateTime birthDate;
  final DateTime exactReturnDate;
  final ZodiacSign risingSign;
  final ZodiacSign moonSign;
  final int sunHouse;
  final List<SolarReturnTheme> themes;
  final List<MonthlyHighlight> monthlyHighlights;
  final List<KeyDate> keyDates;
  final String yearAdvice;

  SolarReturnData({
    required this.year,
    required this.birthDate,
    required this.exactReturnDate,
    required this.risingSign,
    required this.moonSign,
    required this.sunHouse,
    required this.themes,
    required this.monthlyHighlights,
    required this.keyDates,
    required this.yearAdvice,
  });
}

class SolarReturnTheme {
  final String title;
  final String description;
  final String emoji;
  final Color color;

  SolarReturnTheme({
    required this.title,
    required this.description,
    required this.emoji,
    required this.color,
  });
}

class MonthlyHighlight {
  final int month;
  final String keyword;
  final String emoji;
  final bool isPositive;
  final bool isChallenging;

  MonthlyHighlight({
    required this.month,
    required this.keyword,
    required this.emoji,
    required this.isPositive,
    required this.isChallenging,
  });
}

class KeyDate {
  final DateTime date;
  final String title;
  final String description;
  final String emoji;

  KeyDate({
    required this.date,
    required this.title,
    required this.description,
    required this.emoji,
  });
}
