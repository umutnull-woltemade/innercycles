import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/reference_content.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/services/reference_content_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

class GardeningMoonScreen extends StatefulWidget {
  const GardeningMoonScreen({super.key});

  @override
  State<GardeningMoonScreen> createState() => _GardeningMoonScreenState();
}

class _GardeningMoonScreenState extends State<GardeningMoonScreen> {
  final _service = ReferenceContentService();

  late int _selectedYear;
  late int _selectedMonth;
  List<GardeningMoonDay> _days = [];
  GardeningMoonDay? _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
    _loadCalendar();
  }

  void _loadCalendar() {
    setState(() {
      _days = _service.getGardeningCalendar(_selectedYear, _selectedMonth);
      _selectedDay = _days.firstWhere(
        (d) => d.date.day == DateTime.now().day,
        orElse: () => _days.first,
      );
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth += delta;
      if (_selectedMonth > 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else if (_selectedMonth < 1) {
        _selectedMonth = 12;
        _selectedYear--;
      }
    });
    _loadCalendar();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark),
              _buildMonthSelector(isDark),
              _buildCalendarGrid(isDark),
              Expanded(
                child: _selectedDay == null
                    ? const SizedBox.shrink()
                    : _buildDayDetails(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Bahçe Ay Takvimi',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Ay fazlarına göre bahçıvanlık',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(bool isDark) {
    final months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
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
            icon: Icon(
              Icons.chevron_left,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          Text(
            '${months[_selectedMonth - 1]} $_selectedYear',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          IconButton(
            onPressed: () => _changeMonth(1),
            icon: Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(bool isDark) {
    final dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final firstDay = DateTime(_selectedYear, _selectedMonth, 1);
    final startingWeekday = (firstDay.weekday - 1) % 7;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
      child: Column(
        children: [
          // Day names header
          Row(
            children: dayNames.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white60 : AppColors.textLight,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: 42,
            itemBuilder: (context, index) {
              final dayIndex = index - startingWeekday;
              if (dayIndex < 0 || dayIndex >= _days.length) {
                return const SizedBox.shrink();
              }

              final day = _days[dayIndex];
              final isSelected = _selectedDay?.date.day == day.date.day;
              final isToday = day.date.day == DateTime.now().day &&
                  day.date.month == DateTime.now().month &&
                  day.date.year == DateTime.now().year;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = day;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.cosmic.withValues(alpha: 0.3)
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.white.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isToday
                          ? AppColors.gold
                          : (isSelected
                              ? AppColors.cosmic
                              : Colors.transparent),
                      width: isToday ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${day.date.day}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                      Text(
                        day.phase.icon,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDayDetails(bool isDark) {
    final day = _selectedDay!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDayHeader(day, isDark),
          const SizedBox(height: AppConstants.spacingMd),
          _buildMoonInfo(day, isDark),
          const SizedBox(height: AppConstants.spacingMd),
          _buildBestActivity(day, isDark),
          const SizedBox(height: AppConstants.spacingMd),
          _buildActivityLists(day, isDark),
          const SizedBox(height: AppConstants.spacingMd),
          _buildAdvice(day, isDark),
          const SizedBox(height: AppConstants.spacingXxl),
        ],
      ),
    );
  }

  Widget _buildDayHeader(GardeningMoonDay day, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withValues(alpha: 0.2),
            AppColors.cosmic.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Row(
        children: [
          Text(
            day.phase.icon,
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(width: AppConstants.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${day.date.day}/${day.date.month}/${day.date.year}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                Text(
                  day.phase.nameTr,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.cosmic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < day.fertilityRating
                        ? Icons.eco
                        : Icons.eco_outlined,
                    size: 18,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Verimlilik',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white60 : AppColors.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoonInfo(GardeningMoonDay day, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  '${day.moonSign.symbol}',
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ay ${day.moonSign.nameTr}\'da',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                Text(
                  day.moonSign.element.nameTr,
                  style: TextStyle(
                    fontSize: 12,
                    color: day.moonSign.color,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.3),
          ),
          Expanded(
            child: Column(
              children: [
                Icon(
                  day.phase.isWaxing
                      ? Icons.trending_up
                      : Icons.trending_down,
                  size: 28,
                  color: day.phase.isWaxing ? Colors.green : Colors.orange,
                ),
                const SizedBox(height: 4),
                Text(
                  day.phase.isWaxing ? 'Büyüyen Ay' : 'Azalan Ay',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                Text(
                  day.phase.isWaxing ? 'Dikim zamanı' : 'Hasat zamanı',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestActivity(GardeningMoonDay day, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withValues(alpha: 0.3),
            Colors.green.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Text(
            day.bestActivity.icon,
            style: const TextStyle(fontSize: 36),
          ),
          const SizedBox(width: AppConstants.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bugün İçin En Uygun',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : AppColors.textLight,
                  ),
                ),
                Text(
                  day.bestActivity.nameTr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'EN İYİ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLists(GardeningMoonDay day, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Uygun',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...day.goodActivities.map(
                  (act) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text(act.icon, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          act.nameTr,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.cancel, color: Colors.red, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Kaçının',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...day.avoidActivities.map(
                  (act) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text(act.icon, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          act.nameTr,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvice(GardeningMoonDay day, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Günün Tavsiyesi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            day.advice,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.white70 : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
