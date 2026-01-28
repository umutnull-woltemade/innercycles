import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../shared/widgets/cosmic_background.dart';

/// Transit Calendar Screen - Monthly view of astrological transits
class TransitCalendarScreen extends ConsumerStatefulWidget {
  const TransitCalendarScreen({super.key});

  @override
  ConsumerState<TransitCalendarScreen> createState() =>
      _TransitCalendarScreenState();
}

class _TransitCalendarScreenState extends ConsumerState<TransitCalendarScreen> {
  late DateTime _selectedMonth;
  DateTime? _selectedDate;
  late List<TransitEvent> _monthEvents;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _monthEvents = TransitCalendarService.getMonthEvents(
      _selectedMonth.year,
      _selectedMonth.month,
    );
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + delta,
      );
      _monthEvents = TransitCalendarService.getMonthEvents(
        _selectedMonth.year,
        _selectedMonth.month,
      );
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildMonthSelector(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  child: Column(
                    children: [
                      _buildCalendarGrid(context),
                      const SizedBox(height: AppConstants.spacingXl),
                      _buildEventsList(context),
                    ],
                  ),
                ),
              ),
            ],
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
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textPrimary,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transit Takvimi',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.starGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Önemli astrolojik olaylar',
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
                  AppColors.auroraStart.withAlpha(60),
                  AppColors.auroraStart.withAlpha(20),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Text('📅', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildMonthSelector(BuildContext context) {
    final months = [
      'Ocak',
      'Subat',
      'Mart',
      'Nisan',
      'Mayis',
      'Haziran',
      'Temmuz',
      'Agustos',
      'Eylul',
      'Ekim',
      'Kasim',
      'Aralik',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: AppConstants.spacingMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _changeMonth(-1),
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.textPrimary,
              size: 28,
            ),
          ),
          GestureDetector(
            onTap: () => _showMonthPicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight.withAlpha(30),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(color: AppColors.starGold.withAlpha(50)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${months[_selectedMonth.month - 1]} ${_selectedMonth.year}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.starGold,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => _changeMonth(1),
            icon: const Icon(
              Icons.chevron_right,
              color: AppColors.textPrimary,
              size: 28,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ay Sec',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppConstants.spacingLg),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final months = [
                      'Ocak',
                      'Subat',
                      'Mart',
                      'Nisan',
                      'Mayis',
                      'Haziran',
                      'Temmuz',
                      'Agustos',
                      'Eylul',
                      'Ekim',
                      'Kasim',
                      'Aralik',
                    ];
                    final isSelected = index + 1 == _selectedMonth.month;
                    return ListTile(
                      title: Text(
                        months[index],
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.starGold
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: AppColors.starGold)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedMonth = DateTime(
                            _selectedMonth.year,
                            index + 1,
                          );
                          _monthEvents = TransitCalendarService.getMonthEvents(
                            _selectedMonth.year,
                            _selectedMonth.month,
                          );
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final daysInMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    ).day;
    final firstDayOfMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
      1,
    );
    final startingWeekday = (firstDayOfMonth.weekday % 7); // 0 = Monday

    final dayNames = ['Pzt', 'Sal', 'Car', 'Per', 'Cum', 'Cmt', 'Paz'];

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.surfaceLight.withAlpha(30)),
      ),
      child: Column(
        children: [
          // Day names header
          Row(
            children: dayNames
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          // Calendar grid
          ...List.generate(6, (weekIndex) {
            return Row(
              children: List.generate(7, (dayIndex) {
                final dayNumber =
                    weekIndex * 7 + dayIndex - startingWeekday + 1;
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return Expanded(child: Container(height: 44));
                }

                final date = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month,
                  dayNumber,
                );
                final eventsOnDay = _monthEvents
                    .where((e) => e.date.day == dayNumber)
                    .toList();
                final isSelected = _selectedDate?.day == dayNumber;
                final isToday =
                    DateTime.now().year == date.year &&
                    DateTime.now().month == date.month &&
                    DateTime.now().day == date.day;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: Container(
                      height: 44,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.starGold.withAlpha(100)
                            : isToday
                            ? AppColors.auroraStart.withAlpha(50)
                            : eventsOnDay.isNotEmpty
                            ? eventsOnDay.first.type.color.withAlpha(30)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isToday
                            ? Border.all(color: AppColors.auroraStart, width: 2)
                            : null,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            '$dayNumber',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: isSelected
                                      ? AppColors.deepSpace
                                      : AppColors.textPrimary,
                                  fontWeight: eventsOnDay.isNotEmpty || isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                          ),
                          if (eventsOnDay.isNotEmpty)
                            Positioned(
                              bottom: 4,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: eventsOnDay
                                    .take(3)
                                    .map(
                                      (e) => Container(
                                        width: 4,
                                        height: 4,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: e.type.color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildEventsList(BuildContext context) {
    final eventsToShow = _selectedDate != null
        ? _monthEvents.where((e) => e.date.day == _selectedDate!.day).toList()
        : _monthEvents;

    if (eventsToShow.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          children: [
            const Text('🌙', style: TextStyle(fontSize: 48)),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              _selectedDate != null
                  ? 'Bu gun icin ozel transit yok'
                  : 'Bu ay icin transit yok',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.event_note, color: AppColors.starGold, size: 20),
            const SizedBox(width: 8),
            Text(
              _selectedDate != null
                  ? '${_selectedDate!.day} ${_getMonthName(_selectedDate!.month)} Transitler'
                  : 'Ayin Transitler',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
            ),
            const Spacer(),
            if (_selectedDate != null)
              TextButton(
                onPressed: () => setState(() => _selectedDate = null),
                child: Text(
                  'Tumunu Goster',
                  style: TextStyle(color: AppColors.starGold),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ...eventsToShow.asMap().entries.map((entry) {
          final index = entry.key;
          final event = entry.value;
          return _buildEventCard(
            context,
            event,
          ).animate().fadeIn(delay: (300 + index * 50).ms, duration: 300.ms);
        }),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, TransitEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [event.type.color.withAlpha(30), AppColors.surfaceDark],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: event.type.color.withAlpha(50)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Text(
                  '${event.date.day}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: event.type.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getMonthAbbr(event.date.month),
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: event.type.color.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(event.emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: event.type.color.withAlpha(30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event.type.nameTr,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: event.type.color,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  event.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    final months = [
      'Ocak',
      'Subat',
      'Mart',
      'Nisan',
      'Mayis',
      'Haziran',
      'Temmuz',
      'Agustos',
      'Eylul',
      'Ekim',
      'Kasim',
      'Aralik',
    ];
    return months[month - 1];
  }

  String _getMonthAbbr(int month) {
    final months = [
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
    return months[month - 1];
  }
}

/// Transit Event Types
enum TransitEventType {
  newMoon,
  fullMoon,
  eclipse,
  retrograde,
  directStation,
  signIngress,
  majorAspect,
  minorAspect;

  String get nameTr => switch (this) {
    newMoon => 'Yeni Ay',
    fullMoon => 'Dolunay',
    eclipse => 'Tutulma',
    retrograde => 'Retro Baslangic',
    directStation => 'Duz Yuruyus',
    signIngress => 'Burc Gecisi',
    majorAspect => 'Buyuk Aci',
    minorAspect => 'Kucuk Aci',
  };

  Color get color => switch (this) {
    newMoon => AppColors.twilightStart,
    fullMoon => AppColors.starGold,
    eclipse => AppColors.fireElement,
    retrograde => Colors.orange,
    directStation => AppColors.earthElement,
    signIngress => AppColors.auroraStart,
    majorAspect => AppColors.waterElement,
    minorAspect => AppColors.airElement,
  };
}

/// Transit Event Model
class TransitEvent {
  final DateTime date;
  final String title;
  final String description;
  final String emoji;
  final TransitEventType type;
  final ZodiacSign? sign;

  TransitEvent({
    required this.date,
    required this.title,
    required this.description,
    required this.emoji,
    required this.type,
    this.sign,
  });
}

/// Transit Calendar Service
class TransitCalendarService {
  static List<TransitEvent> getMonthEvents(int year, int month) {
    final events = <TransitEvent>[];

    // Generate moon phases
    events.addAll(_generateMoonPhases(year, month));

    // Generate eclipses (if applicable)
    events.addAll(_generateEclipses(year, month));

    // Generate retrogrades
    events.addAll(_generateRetrogrades(year, month));

    // Generate sign ingresses
    events.addAll(_generateSignIngresses(year, month));

    // Generate major aspects
    events.addAll(_generateMajorAspects(year, month));

    // Sort by date
    events.sort((a, b) => a.date.compareTo(b.date));

    return events;
  }

  static List<TransitEvent> _generateMoonPhases(int year, int month) {
    final events = <TransitEvent>[];

    // Approximate new moon and full moon dates
    // In reality, this should use astronomical calculations
    final seed = year * 12 + month;
    final newMoonDay = 1 + (seed % 5);
    final fullMoonDay = 14 + (seed % 4);

    final moonSigns = ZodiacSign.values;
    final newMoonSign = moonSigns[(month - 1) % 12];
    final fullMoonSign = moonSigns[(month + 5) % 12];

    events.add(
      TransitEvent(
        date: DateTime(year, month, newMoonDay),
        title: 'Yeni Ay - ${newMoonSign.nameTr}',
        description:
            '${newMoonSign.nameTr} burcunda yeni ay. Yeni başlangıçlar için ideal zaman. '
            '${newMoonSign.element.nameTr} elementi enerjisi hakim.',
        emoji: '🌑',
        type: TransitEventType.newMoon,
        sign: newMoonSign,
      ),
    );

    events.add(
      TransitEvent(
        date: DateTime(year, month, fullMoonDay),
        title: 'Dolunay - ${fullMoonSign.nameTr}',
        description:
            '${fullMoonSign.nameTr} burcunda dolunay. Tamamlanma ve hasat zamanı. '
            'Duygular yoğunlaşıyor.',
        emoji: '🌕',
        type: TransitEventType.fullMoon,
        sign: fullMoonSign,
      ),
    );

    return events;
  }

  static List<TransitEvent> _generateEclipses(int year, int month) {
    final events = <TransitEvent>[];

    // Eclipse seasons typically occur twice a year
    // This is a simplified approximation
    final eclipseMonths2024 = [3, 4, 9, 10];
    final eclipseMonths2025 = [3, 9];
    final eclipseMonths2026 = [2, 3, 8, 9];

    List<int> eclipseMonths;
    if (year == 2024) {
      eclipseMonths = eclipseMonths2024;
    } else if (year == 2025) {
      eclipseMonths = eclipseMonths2025;
    } else if (year == 2026) {
      eclipseMonths = eclipseMonths2026;
    } else {
      eclipseMonths = [(month + 2) % 12 + 1, (month + 8) % 12 + 1];
    }

    if (eclipseMonths.contains(month)) {
      final isSolar = month % 2 == 0;
      final eclipseDay = 8 + (year % 10);
      final eclipseSign = ZodiacSign.values[(month + 2) % 12];

      events.add(
        TransitEvent(
          date: DateTime(year, month, eclipseDay.clamp(1, 28)),
          title: isSolar
              ? 'Güneş Tutulması - ${eclipseSign.nameTr}'
              : 'Ay Tutulması - ${eclipseSign.nameTr}',
          description: isSolar
              ? '${eclipseSign.nameTr} burcunda güneş tutulması. Güçlü yeni başlangıçlar. Kader kapıları açılıyor.'
              : '${eclipseSign.nameTr} burcunda ay tutulması. Büyük kapatışlar ve sonlanmalar. Duygusal dönüşüm.',
          emoji: isSolar ? '🌘' : '🌒',
          type: TransitEventType.eclipse,
          sign: eclipseSign,
        ),
      );
    }

    return events;
  }

  static List<TransitEvent> _generateRetrogrades(int year, int month) {
    final events = <TransitEvent>[];

    // Mercury retrograde periods (approximately 3-4 times per year)
    final mercuryRetroMonths = [1, 4, 8, 12];
    if (mercuryRetroMonths.contains(month)) {
      final startDay = 10 + (year % 5);
      events.add(
        TransitEvent(
          date: DateTime(year, month, startDay),
          title: 'Merkur Retro Basliyor',
          description:
              'Iletisim, seyahat ve teknolojide aksakliklar yasanabilir. '
              'Eski konulari gozden gecirin. Yeni sozlesmeler icin bekleyin.',
          emoji: '☿️',
          type: TransitEventType.retrograde,
        ),
      );
    }

    // Venus retrograde (approximately every 18 months)
    if ((year + month) % 18 == 0) {
      events.add(
        TransitEvent(
          date: DateTime(year, month, 5),
          title: 'Venus Retro Basliyor',
          description:
              'Ask ve iliskilerde tekrar degerledirme zamani. '
              'Eski asklar geri donebilir. Estetik kararlari erteleyin.',
          emoji: '♀️',
          type: TransitEventType.retrograde,
        ),
      );
    }

    // Mars retrograde (approximately every 2 years)
    if (year % 2 == 0 && month == 10) {
      events.add(
        TransitEvent(
          date: DateTime(year, month, 20),
          title: 'Mars Retro Basliyor',
          description:
              'Enerji iceride yonlendirilmeli. Agresif kararlardan kacinin. '
              'Fiziksel aktivitelerde dikkatli olun.',
          emoji: '♂️',
          type: TransitEventType.retrograde,
        ),
      );
    }

    return events;
  }

  static List<TransitEvent> _generateSignIngresses(int year, int month) {
    final events = <TransitEvent>[];

    // Sun ingress (approximately on 20-22 of each month)
    final sunIngressDay = 20 + (month % 3);
    final nextSign = ZodiacSign.values[month % 12];

    events.add(
      TransitEvent(
        date: DateTime(year, month, sunIngressDay),
        title: 'Gunes ${nextSign.nameTr} Burcuna Giriyor',
        description:
            '${nextSign.nameTr} sezonu basliyor. ${nextSign.element.nameTr} elementi enerjisi '
            'yoğunlasiyor. ${nextSign.nameTr} burcunun temalari on plana cikiyor.',
        emoji: '☀️',
        type: TransitEventType.signIngress,
        sign: nextSign,
      ),
    );

    return events;
  }

  static List<TransitEvent> _generateMajorAspects(int year, int month) {
    final events = <TransitEvent>[];

    // Generate some significant planetary aspects
    final seed = year * 100 + month;

    // Jupiter-Saturn aspects (rare and significant)
    if (seed % 20 == 0) {
      events.add(
        TransitEvent(
          date: DateTime(year, month, 15),
          title: 'Jüpiter-Satürn Kavuşumu',
          description:
              'Önemli toplumsal ve kişisel dönüşüm. 20 yılda bir gerçekleşen bu '
              'olay büyük değişimler getirir.',
          emoji: '⚡',
          type: TransitEventType.majorAspect,
        ),
      );
    }

    // Mars-Jupiter positive aspect
    if (month % 4 == 0) {
      final aspectDay = 5 + (seed % 10);
      events.add(
        TransitEvent(
          date: DateTime(year, month, aspectDay.clamp(1, 28)),
          title: 'Mars-Jüpiter Üçgeni',
          description:
              'Enerji ve şans buluşuyor. Cesur girişimler için mükemmel zaman. '
              'Fiziksel aktiviteler ve sporlar destekleniyor.',
          emoji: '🔥',
          type: TransitEventType.majorAspect,
        ),
      );
    }

    // Venus-Neptune aspect
    if (month % 3 == 1) {
      final aspectDay = 12 + (seed % 8);
      events.add(
        TransitEvent(
          date: DateTime(year, month, aspectDay.clamp(1, 28)),
          title: 'Venüs-Neptün Kavuşumu',
          description:
              'Romantik ve sanatsal ilham. Rüyalar ve hayal gücü güçleniyor. '
              'Spiritüel aşk deneyimleri.',
          emoji: '💫',
          type: TransitEventType.majorAspect,
        ),
      );
    }

    return events;
  }
}
