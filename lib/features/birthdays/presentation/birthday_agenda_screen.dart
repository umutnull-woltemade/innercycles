// ════════════════════════════════════════════════════════════════════════════
// BIRTHDAY AGENDA SCREEN - Calendar & Upcoming Birthdays
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/common_strings.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/birthday_contact.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/birthday_contact_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/birthday_avatar.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../data/services/l10n_service.dart';

class BirthdayAgendaScreen extends ConsumerStatefulWidget {
  const BirthdayAgendaScreen({super.key});

  @override
  ConsumerState<BirthdayAgendaScreen> createState() =>
      _BirthdayAgendaScreenState();
}

class _BirthdayAgendaScreenState extends ConsumerState<BirthdayAgendaScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  int? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(birthdayContactServiceProvider);

    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.starGold, AppColors.celestialGold],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.starGold.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => context.push(Routes.birthdayAdd),
          tooltip: L10nService.get('birthdays.birthday_agenda.add_birthday', language),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.person_add_rounded,
            color: AppColors.deepSpace,
          ),
        ),
      ),
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const CosmicLoadingIndicator(),
          error: (_, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  L10nService.get('birthdays.birthday_agenda.couldnt_load_your_birthdays', language),
                  textAlign: TextAlign.center,
                  style: AppTypography.subtitle(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () =>
                      ref.invalidate(birthdayContactServiceProvider),
                  icon: Icon(Icons.refresh_rounded,
                      size: 16, color: AppColors.starGold),
                  label: Text(
                    L10nService.get('birthdays.birthday_agenda.retry', language),
                    style: AppTypography.elegantAccent(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.starGold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          data: (service) => _buildContent(context, service, isDark, isEn),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    BirthdayContactService service,
    bool isDark,
    bool isEn,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    final allContacts = service.getAllContacts();
    final todayBirthdays = service.getTodayBirthdays();
    final birthdayMap = service.getBirthdayMap();
    final upcoming = service.getUpcomingBirthdays(withinDays: 30);
    final isEmpty = allContacts.isEmpty;

    return CupertinoScrollbar(
      child: RefreshIndicator(
        color: AppColors.starGold,
        onRefresh: () async {
          ref.invalidate(birthdayContactServiceProvider);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            GlassSliverAppBar(
              title: L10nService.get('birthdays.birthday_agenda.birthday_agenda', language),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Empty state
                  if (isEmpty) ...[
                    _EmptyState(
                      isDark: isDark,
                      isEn: isEn,
                      onImport: () => context.push(Routes.birthdayImport),
                      onAdd: () => context.push(Routes.birthdayAdd),
                    ),
                    const SizedBox(height: 40),
                  ],

                  // 1. Today banner
                  if (todayBirthdays.isNotEmpty) ...[
                    _TodayBanner(
                      contacts: todayBirthdays,
                      isDark: isDark,
                      isEn: isEn,
                      onTap: (id) => context.push(
                        Routes.birthdayDetail.replaceFirst(':id', id),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // 2. Month navigator
                  _MonthNav(
                    year: _selectedYear,
                    month: _selectedMonth,
                    isDark: isDark,
                    isEn: isEn,
                    onPrevious: () {
                      final minYear = DateTime.now().year - 1;
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedMonth--;
                        if (_selectedMonth < 1) {
                          if (_selectedYear > minYear) {
                            _selectedMonth = 12;
                            _selectedYear--;
                          } else {
                            _selectedMonth = 1;
                          }
                        }
                        _selectedDay = null;
                      });
                    },
                    onNext: () {
                      final maxYear = DateTime.now().year + 1;
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedMonth++;
                        if (_selectedMonth > 12) {
                          if (_selectedYear < maxYear) {
                            _selectedMonth = 1;
                            _selectedYear++;
                          } else {
                            _selectedMonth = 12;
                          }
                        }
                        _selectedDay = null;
                      });
                    },
                    onToday: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        final now = DateTime.now();
                        _selectedYear = now.year;
                        _selectedMonth = now.month;
                        _selectedDay = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. Calendar grid
                  _BirthdayCalendarGrid(
                    year: _selectedYear,
                    month: _selectedMonth,
                    birthdayMap: birthdayMap,
                    selectedDay: _selectedDay,
                    isDark: isDark,
                    isEn: isEn,
                    onDayTap: (day) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _selectedDay = _selectedDay == day ? null : day;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // 4. Selected day detail
                  if (_selectedDay != null) ...[
                    _SelectedDayDetail(
                      day: _selectedDay!,
                      month: _selectedMonth,
                      birthdayMap: birthdayMap,
                      isDark: isDark,
                      isEn: isEn,
                      onContactTap: (id) => context.push(
                        Routes.birthdayDetail.replaceFirst(':id', id),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 5. Upcoming birthdays
                  if (upcoming.isNotEmpty) ...[
                    GradientText(
                      L10nService.get('birthdays.birthday_agenda.upcoming_birthdays', language),
                      variant: GradientTextVariant.gold,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...upcoming.map(
                      (contact) => _UpcomingCard(
                        contact: contact,
                        isDark: isDark,
                        isEn: isEn,
                        onTap: () => context.push(
                          Routes.birthdayDetail.replaceFirst(':id', contact.id),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // 6. Action buttons
                  _ActionButtons(
                    isDark: isDark,
                    isEn: isEn,
                    onImport: () => context.push(Routes.birthdayImport),
                    onAdd: () => context.push(Routes.birthdayAdd),
                  ),

                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TODAY BANNER
// ═══════════════════════════════════════════════════════════════════════════

class _TodayBanner extends StatelessWidget {
  final List<BirthdayContact> contacts;
  final bool isDark;
  final bool isEn;
  final ValueChanged<String> onTap;

  const _TodayBanner({
    required this.contacts,
    required this.isDark,
    required this.isEn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    return PremiumCard(
      style: PremiumCardStyle.gold,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppSymbol.card('\u{1F382}'),
              const SizedBox(width: 10),
              GradientText(
                L10nService.get('birthdays.birthday_agenda.todays_birthdays', language),
                variant: GradientTextVariant.gold,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: contacts.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (_, index) {
                final contact = contacts[index];
                return GestureDetector(
                  onTap: () => onTap(contact.id),
                  child: Column(
                    children: [
                      BirthdayAvatar(
                        photoPath: contact.photoPath,
                        name: contact.name,
                        size: 56,
                        showBirthdayCake: true,
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 64,
                        child: Text(
                          contact.name.split(' ').first,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.elegantAccent(
                            fontSize: 11,
                            letterSpacing: 0.5,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MONTH NAVIGATOR
// ═══════════════════════════════════════════════════════════════════════════

class _MonthNav extends StatelessWidget {
  final int year;
  final int month;
  final bool isDark;
  final bool isEn;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback? onToday;

  const _MonthNav({
    required this.year,
    required this.month,
    required this.isDark,
    required this.isEn,
    required this.onPrevious,
    required this.onNext,
    this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    final monthNames = isEn
        ? CommonStrings.monthsFullEn
        : CommonStrings.monthsFullTr;
    final now = DateTime.now();
    final isCurrentMonth = year == now.year && month == now.month;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            Icons.chevron_left_rounded,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
          tooltip: L10nService.get('birthdays.birthday_agenda.previous_month', language),
          onPressed: onPrevious,
        ),
        GestureDetector(
          onTap: isCurrentMonth ? null : onToday,
          child: Column(
            children: [
              GradientText(
                '${monthNames[month - 1]} $year',
                variant: GradientTextVariant.gold,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!isCurrentMonth)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    L10nService.get('birthdays.birthday_agenda.tap_for_today', language),
                    style: AppTypography.elegantAccent(
                      fontSize: 10,
                      color: AppColors.starGold.withValues(alpha: 0.6),
                    ),
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.chevron_right_rounded,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
          tooltip: L10nService.get('birthdays.birthday_agenda.next_month', language),
          onPressed: onNext,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BIRTHDAY CALENDAR GRID
// ═══════════════════════════════════════════════════════════════════════════

class _BirthdayCalendarGrid extends StatelessWidget {
  final int year;
  final int month;
  final Map<String, List<BirthdayContact>> birthdayMap;
  final int? selectedDay;
  final bool isDark;
  final bool isEn;
  final ValueChanged<int> onDayTap;

  const _BirthdayCalendarGrid({
    required this.year,
    required this.month,
    required this.birthdayMap,
    this.selectedDay,
    required this.isDark,
    required this.isEn,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startOffset = firstDay.weekday - 1; // Mon=0 through Sun=6
    final today = DateTime.now();

    return PremiumCard(
      style: PremiumCardStyle.aurora,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Day headers
          Row(
            children:
                (isEn
                        ? ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                        : ['Pt', 'Sa', '\u{00C7}a', 'Pe', 'Cu', 'Ct', 'Pa'])
                    .map(
                      (d) => Expanded(
                        child: Center(
                          child: Text(
                            d,
                            style: AppTypography.elegantAccent(
                              fontSize: 11,
                              letterSpacing: 1.0,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 8),

          // Day cells
          ...List.generate(_weekCount(startOffset, daysInMonth), (week) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: List.generate(7, (weekday) {
                  final dayIndex = week * 7 + weekday - startOffset + 1;
                  if (dayIndex < 1 || dayIndex > daysInMonth) {
                    return const Expanded(child: SizedBox(height: 64));
                  }

                  final dateKey =
                      '${month.toString().padLeft(2, '0')}-${dayIndex.toString().padLeft(2, '0')}';
                  final dayContacts = birthdayMap[dateKey] ?? [];
                  final isToday =
                      year == today.year &&
                      month == today.month &&
                      dayIndex == today.day;
                  final isSelected = dayIndex == selectedDay;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onDayTap(dayIndex),
                      child: Container(
                        height: 64,
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.starGold.withValues(alpha: 0.12)
                              : isToday
                              ? AppColors.auroraStart.withValues(alpha: 0.08)
                              : (isDark
                                    ? Colors.white.withValues(alpha: 0.03)
                                    : Colors.black.withValues(alpha: 0.03)),
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: AppColors.starGold, width: 2)
                              : isToday
                              ? Border.all(
                                  color: AppColors.auroraStart.withValues(
                                    alpha: 0.4,
                                  ),
                                  width: 1.5,
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$dayIndex',
                              style: AppTypography.elegantAccent(
                                fontSize: 12,
                                fontWeight: dayContacts.isNotEmpty
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: dayContacts.isNotEmpty
                                    ? AppColors.starGold
                                    : (isDark
                                          ? AppColors.textMuted
                                          : AppColors.lightTextMuted),
                              ),
                            ),
                            if (dayContacts.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: dayContacts
                                    .take(3)
                                    .map(
                                      (c) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 1,
                                        ),
                                        child: BirthdayAvatar(
                                          photoPath: c.photoPath,
                                          name: c.name,
                                          size: 20,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              if (dayContacts.length > 3)
                                Text(
                                  '+${dayContacts.length - 3}',
                                  style: AppTypography.elegantAccent(
                                    fontSize: 10,
                                    color: AppColors.starGold,
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  int _weekCount(int startOffset, int daysInMonth) {
    return ((startOffset + daysInMonth) / 7).ceil();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SELECTED DAY DETAIL
// ═══════════════════════════════════════════════════════════════════════════

class _SelectedDayDetail extends StatelessWidget {
  final int day;
  final int month;
  final Map<String, List<BirthdayContact>> birthdayMap;
  final bool isDark;
  final bool isEn;
  final ValueChanged<String> onContactTap;

  const _SelectedDayDetail({
    required this.day,
    required this.month,
    required this.birthdayMap,
    required this.isDark,
    required this.isEn,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    final dateKey =
        '${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
    final contacts = birthdayMap[dateKey] ?? [];

    if (contacts.isEmpty) {
      return PremiumCard(
        style: PremiumCardStyle.subtle,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            L10nService.get('birthdays.birthday_agenda.no_birthdays_on_this_day', language),
            style: AppTypography.subtitle(
              fontSize: 14,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ),
      ).animate().fadeIn(duration: 200.ms);
    }

    return Column(
      children: contacts.map((contact) {
        final language = AppLanguage.fromIsEn(isEn);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () => onContactTap(contact.id),
            child: PremiumCard(
              style: PremiumCardStyle.gold,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  BirthdayAvatar(
                    photoPath: contact.photoPath,
                    name: contact.name,
                    size: 48,
                    showBirthdayCake: contact.isBirthdayToday,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.modernAccent(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${contact.relationship.emoji} ${contact.relationship.localizedName(language)}'
                          '${contact.age != null ? ' \u{2022} ${contact.age} ${L10nService.get('common.years', language)}' : ''}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.elegantAccent(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
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
        );
      }).toList(),
    ).animate().fadeIn(duration: 200.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// UPCOMING CARD
// ═══════════════════════════════════════════════════════════════════════════

class _UpcomingCard extends StatelessWidget {
  final BirthdayContact contact;
  final bool isDark;
  final bool isEn;
  final VoidCallback onTap;

  const _UpcomingCard({
    required this.contact,
    required this.isDark,
    required this.isEn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    final days = contact.daysUntilBirthday;
    final isToday = contact.isBirthdayToday;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.7)
                : AppColors.lightCard,
            borderRadius: BorderRadius.circular(14),
            border: isToday
                ? Border.all(color: AppColors.starGold.withValues(alpha: 0.4))
                : null,
          ),
          child: Row(
            children: [
              BirthdayAvatar(
                photoPath: contact.photoPath,
                name: contact.name,
                size: 48,
                showBirthdayCake: isToday,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: AppTypography.modernAccent(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${contact.relationship.emoji} ${contact.relationship.localizedName(language)}',
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
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
                  color: isToday
                      ? AppColors.starGold.withValues(alpha: 0.15)
                      : AppColors.auroraStart.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isToday
                      ? (L10nService.get('birthdays.birthday_agenda.today', language))
                      : '$days ${L10nService.get('birthdays.birthday_agenda.days', language)}',
                  style: AppTypography.elegantAccent(
                    fontSize: 12,
                    letterSpacing: 0.5,
                    color: isToday ? AppColors.starGold : AppColors.auroraStart,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final bool isEn;
  final VoidCallback onImport;
  final VoidCallback onAdd;

  const _EmptyState({
    required this.isDark,
    required this.isEn,
    required this.onImport,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    return PremiumCard(
      style: PremiumCardStyle.aurora,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          const AppSymbol.hero('\u{1F382}'),
          const SizedBox(height: 16),
          GradientText(
            L10nService.get('birthdays.birthday_agenda.never_miss_a_birthday', language),
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            L10nService.get('birthdays.birthday_agenda.add_your_friends_and_family_to_get_remin', language),
            textAlign: TextAlign.center,
            style: AppTypography.decorativeScript(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 24),
          _ActionButtons(
            isDark: isDark,
            isEn: isEn,
            onImport: onImport,
            onAdd: onAdd,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ACTION BUTTONS
// ═══════════════════════════════════════════════════════════════════════════

class _ActionButtons extends StatelessWidget {
  final bool isDark;
  final bool isEn;
  final VoidCallback onImport;
  final VoidCallback onAdd;

  const _ActionButtons({
    required this.isDark,
    required this.isEn,
    required this.onImport,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    return Column(
      children: [
        // Import CTA
        GestureDetector(
          onTap: onImport,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.starGold, AppColors.celestialGold],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.starGold.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.download_rounded,
                  color: AppColors.deepSpace,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  L10nService.get('birthdays.birthday_agenda.import_from_facebook', language),
                  style: AppTypography.modernAccent(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepSpace,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 12),
        // Manual add
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDark.withValues(alpha: 0.6)
                  : AppColors.lightCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.starGold.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add_rounded,
                  color: AppColors.starGold,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  L10nService.get('birthdays.birthday_agenda.add_manually', language),
                  style: AppTypography.modernAccent(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.starGold,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
      ],
    );
  }
}
