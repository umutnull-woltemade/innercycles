import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../data/services/l10n_service.dart';

class BirthDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final AppLanguage language;

  const BirthDatePicker({
    super.key,
    this.initialDate,
    required this.onDateChanged,
    this.language = AppLanguage.tr,
  });

  @override
  State<BirthDatePicker> createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  late int _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;

  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;

  List<String> get _months => [
    L10nService.get('months.january', widget.language),
    L10nService.get('months.february', widget.language),
    L10nService.get('months.march', widget.language),
    L10nService.get('months.april', widget.language),
    L10nService.get('months.may', widget.language),
    L10nService.get('months.june', widget.language),
    L10nService.get('months.july', widget.language),
    L10nService.get('months.august', widget.language),
    L10nService.get('months.september', widget.language),
    L10nService.get('months.october', widget.language),
    L10nService.get('months.november', widget.language),
    L10nService.get('months.december', widget.language),
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final initial = widget.initialDate ?? DateTime(1997, 3, 27);

    _selectedDay = initial.day;
    _selectedMonth = initial.month;
    _selectedYear = initial.year;

    _dayController = FixedExtentScrollController(initialItem: _selectedDay - 1);
    _monthController = FixedExtentScrollController(
      initialItem: _selectedMonth - 1,
    );
    _yearController = FixedExtentScrollController(
      initialItem: now.year - _selectedYear,
    );
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  int _getDaysInMonth(int month, int year) {
    return DateTime(year, month + 1, 0).day;
  }

  void _notifyDateChanged() {
    final daysInMonth = _getDaysInMonth(_selectedMonth, _selectedYear);
    final day = _selectedDay > daysInMonth ? daysInMonth : _selectedDay;

    widget.onDateChanged(DateTime(_selectedYear, _selectedMonth, day));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = _getDaysInMonth(_selectedMonth, _selectedYear);

    // WEB: Use dropdown-based picker (ListWheelScrollView doesn't work on web)
    if (kIsWeb) {
      return _buildWebDatePicker(now, daysInMonth);
    }

    // MOBILE: Use wheel picker
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(128),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.auroraStart.withAlpha(76)),
      ),
      child: Row(
        children: [
          // Day picker
          Expanded(
            flex: 2,
            child: _WheelPicker(
              controller: _dayController,
              itemCount: daysInMonth,
              selectedIndex: _selectedDay - 1,
              onSelectedItemChanged: (index) {
                setState(() => _selectedDay = index + 1);
                _notifyDateChanged();
              },
              itemBuilder: (index) => '${index + 1}',
              label: L10nService.get('widgets.birth_date_picker.day', widget.language),
            ),
          ),

          // Month picker
          Expanded(
            flex: 3,
            child: _WheelPicker(
              controller: _monthController,
              itemCount: 12,
              selectedIndex: _selectedMonth - 1,
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedMonth = index + 1;
                  // Adjust day if needed
                  final newDaysInMonth = _getDaysInMonth(
                    _selectedMonth,
                    _selectedYear,
                  );
                  if (_selectedDay > newDaysInMonth) {
                    _selectedDay = newDaysInMonth;
                    _dayController.jumpToItem(_selectedDay - 1);
                  }
                });
                _notifyDateChanged();
              },
              itemBuilder: (index) => _months[index],
              label: L10nService.get('widgets.birth_date_picker.month', widget.language),
            ),
          ),

          // Year picker
          Expanded(
            flex: 2,
            child: _WheelPicker(
              controller: _yearController,
              itemCount: 100,
              selectedIndex: now.year - _selectedYear,
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedYear = now.year - index;
                  // Adjust day for leap year
                  final newDaysInMonth = _getDaysInMonth(
                    _selectedMonth,
                    _selectedYear,
                  );
                  if (_selectedDay > newDaysInMonth) {
                    _selectedDay = newDaysInMonth;
                    _dayController.jumpToItem(_selectedDay - 1);
                  }
                });
                _notifyDateChanged();
              },
              itemBuilder: (index) => '${now.year - index}',
              label: L10nService.get('widgets.birth_date_picker.year', widget.language),
            ),
          ),
        ],
      ),
    );
  }

  // Web-specific dropdown-based date picker
  Widget _buildWebDatePicker(DateTime now, int daysInMonth) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(128),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.auroraStart.withAlpha(76)),
      ),
      child: Row(
        children: [
          // Day dropdown
          Expanded(
            child: _buildDropdown(
              label: L10nService.get('widgets.birth_date_picker.day', widget.language),
              value: _selectedDay,
              items: List.generate(daysInMonth, (i) => i + 1),
              itemLabel: (i) => '$i',
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedDay = value);
                  _notifyDateChanged();
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          // Month dropdown
          Expanded(
            flex: 2,
            child: _buildDropdown(
              label: L10nService.get('widgets.birth_date_picker.month', widget.language),
              value: _selectedMonth,
              items: List.generate(12, (i) => i + 1),
              itemLabel: (i) => _months[i - 1],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMonth = value;
                    final newDaysInMonth = _getDaysInMonth(_selectedMonth, _selectedYear);
                    if (_selectedDay > newDaysInMonth) {
                      _selectedDay = newDaysInMonth;
                    }
                  });
                  _notifyDateChanged();
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          // Year dropdown
          Expanded(
            child: _buildDropdown(
              label: L10nService.get('widgets.birth_date_picker.year', widget.language),
              value: _selectedYear,
              items: List.generate(100, (i) => now.year - i),
              itemLabel: (i) => '$i',
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedYear = value;
                    final newDaysInMonth = _getDaysInMonth(_selectedMonth, _selectedYear);
                    if (_selectedDay > newDaysInMonth) {
                      _selectedDay = newDaysInMonth;
                    }
                  });
                  _notifyDateChanged();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.auroraStart.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.auroraStart.withAlpha(76)),
          ),
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: const Color(0xFF1a1a2e),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(itemLabel(item)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _WheelPicker extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int itemCount;
  final int selectedIndex;
  final ValueChanged<int> onSelectedItemChanged;
  final String Function(int) itemBuilder;
  final String label;

  const _WheelPicker({
    required this.controller,
    required this.itemCount,
    required this.selectedIndex,
    required this.onSelectedItemChanged,
    required this.itemBuilder,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 1,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              // Selection highlight
              Center(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: AppColors.auroraStart.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.auroraStart.withAlpha(76),
                    ),
                  ),
                ),
              ),
              // Wheel
              ListWheelScrollView.useDelegate(
                controller: controller,
                itemExtent: 40,
                perspective: 0.005,
                diameterRatio: 1.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: onSelectedItemChanged,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: itemCount,
                  builder: (context, index) {
                    final isSelected = index == selectedIndex;
                    return Center(
                      child: Text(
                        itemBuilder(index),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textMuted,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Compact display for selected date
class SelectedDateDisplay extends StatelessWidget {
  final DateTime? date;
  final VoidCallback? onTap;
  final AppLanguage language;

  const SelectedDateDisplay({
    super.key,
    this.date,
    this.onTap,
    this.language = AppLanguage.tr,
  });

  String _getMonthName(int month, AppLanguage lang) {
    final months = [
      L10nService.get('months.january', lang),
      L10nService.get('months.february', lang),
      L10nService.get('months.march', lang),
      L10nService.get('months.april', lang),
      L10nService.get('months.may', lang),
      L10nService.get('months.june', lang),
      L10nService.get('months.july', lang),
      L10nService.get('months.august', lang),
      L10nService.get('months.september', lang),
      L10nService.get('months.october', lang),
      L10nService.get('months.november', lang),
      L10nService.get('months.december', lang),
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLg,
          vertical: AppConstants.spacingMd,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.auroraStart.withAlpha(51),
              AppColors.auroraEnd.withAlpha(51),
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(color: AppColors.auroraStart.withAlpha(76)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cake_outlined,
              color: AppColors.starGold,
              size: 20,
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Text(
              '${_getMonthName(date!.month, language)} ${date!.day}, ${date!.year}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: AppConstants.spacingSm),
            const Icon(Icons.edit, color: AppColors.textMuted, size: 16),
          ],
        ),
      ),
    );
  }
}
