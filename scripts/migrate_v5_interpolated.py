#!/usr/bin/env python3
"""
isEn -> L10nService migration v5: Interpolated strings.
Handles patterns like: isEn ? '$count words' : '$count kelime'
Uses L10nService.getWithParams() with {param} placeholders.
"""

import json, os, re
from pathlib import Path
from collections import OrderedDict

PROJECT_ROOT = Path(__file__).parent.parent
LIB_DIR = PROJECT_ROOT / "lib"
EN_JSON = PROJECT_ROOT / "assets" / "l10n" / "en.json"
TR_JSON = PROJECT_ROOT / "assets" / "l10n" / "tr.json"

# Each migration entry: (file, line_search_text, l10n_key, en_template, tr_template, params_expr, isEn_accessor)
# params_expr maps {placeholder} -> dart expression
# isEn_accessor is how to reference isEn in that scope (isEn, widget.isEn, _isEn)

MIGRATIONS = [
    # ═══════════════════════════════════════════════════════════════
    # JOURNAL
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/journal/presentation/daily_entry_screen.dart',
        'old': "isEn ? '$words words' : '$words kelime'",
        'key': 'journal.daily_entry.word_count',
        'en': '{count} words',
        'tr': '{count} kelime',
        'params': "{'count': '$words'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/journal/presentation/daily_entry_screen.dart',
        'old': "isEn ? '$streak day streak' : '$streak gün seri'",
        'key': 'journal.daily_entry.day_streak',
        'en': '{count} day streak',
        'tr': '{count} gün seri',
        'params': "{'count': '$streak'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/journal/presentation/annual_report_screen.dart',
        'old': "isEn ? '$count entries recorded' : '$count kayıt yazıldı'",
        'key': 'journal.annual_report.entries_recorded',
        'en': '{count} entries recorded',
        'tr': '{count} kayıt yazıldı',
        'params': "{'count': '$count'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/journal/presentation/archive_screen.dart',
        'old': "isEn ? 'Filter: $label' : 'Filtre: $label'",
        'key': 'journal.archive.filter_label',
        'en': 'Filter: {label}',
        'tr': 'Filtre: {label}',
        'params': "{'label': label}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/journal/presentation/archive_screen.dart',
        'old': "isEn ? '$words words' : '$words kelime'",
        'key': 'journal.archive.word_count',
        'en': '{count} words',
        'tr': '{count} kelime',
        'params': "{'count': '$words'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/journal/presentation/emotional_cycle_screen.dart',
        'old': "isEn ? 'Last $displayDays Days' : 'Son $displayDays Gün'",
        'key': 'journal.emotional_cycle.last_n_days',
        'en': 'Last {count} Days',
        'tr': 'Son {count} Gün',
        'params': "{'count': '$displayDays'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/journal/presentation/emotional_cycle_screen.dart',
        'old': "isEn ? '$displayDays days ago' : '$displayDays gün önce'",
        'key': 'journal.emotional_cycle.days_ago',
        'en': '{count} days ago',
        'tr': '{count} gün önce',
        'params': "{'count': '$displayDays'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/journal/presentation/patterns_screen.dart',
        'old': "isEn ? '$days days' : '$days gün'",
        'key': 'journal.patterns.n_days',
        'en': '{count} days',
        'tr': '{count} gün',
        'params': "{'count': '$days'}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # MEDITATION
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/meditation/presentation/meditation_timer_screen.dart',
        'old': "isEn ? '$m minutes' : '$m dakika'",
        'key': 'meditation.timer.n_minutes',
        'en': '{count} minutes',
        'tr': '{count} dakika',
        'params': "{'count': '$m'}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # BLIND SPOT
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/blind_spot/presentation/blind_spot_screen.dart',
        'old': "isEn ? '$entryCount / 14 entries' : '$entryCount / 14 kayıt'",
        'key': 'blind_spot.entry_count_progress',
        'en': '{count} / 14 entries',
        'tr': '{count} / 14 kayıt',
        'params': "{'count': '$entryCount'}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # AFFIRMATION
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/affirmation/presentation/affirmation_library_screen.dart',
        'old': "isEn ? 'Filter: $label' : 'Filtre: $label'",
        'key': 'affirmation.library.filter_label',
        'en': 'Filter: {label}',
        'tr': 'Filtre: {label}',
        'params': "{'label': label}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # ARCHETYPE
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/archetype/presentation/archetype_screen.dart',
        'old': "isEn ? '$confidencePct% alignment' : '%$confidencePct uyum'",
        'key': 'archetype.alignment_pct',
        'en': '{pct}% alignment',
        'tr': '%{pct} uyum',
        'params': "{'pct': '$confidencePct'}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # YEAR REVIEW
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/year_review/presentation/year_review_screen.dart',
        'old': "isEn ? 'My ${review.year} Summary' : '${review.year} Özetim'",
        'key': 'year_review.my_year_summary',
        'en': 'My {year} Summary',
        'tr': '{year} Özetim',
        'params': "{'year': '${review.year}'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/year_review/presentation/wrapped_screen.dart',
        'old': "isEn ? '$count entries this year' : 'Bu yıl $count kayıt'",
        'key': 'year_review.entries_this_year',
        'en': '{count} entries this year',
        'tr': 'Bu yıl {count} kayıt',
        'params': "{'count': '$count'}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # TODAY FEED
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/today/presentation/today_feed_screen.dart',
        'old': "isEn ? '$label Anniversary!' : '$label Y\\u0131l D\\u00f6n\\u00fcm\\u00fc!'",
        'key': 'today.anniversary_label',
        'en': '{label} Anniversary!',
        'tr': '{label} Yıl Dönümü!',
        'params': "{'label': label}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/today/presentation/widgets/daily_pulse_card.dart',
        'old': "isEn ? 'Try this for $areaLabel' : '$areaLabel için dene'",
        'key': 'today.daily_pulse.try_for_area',
        'en': 'Try this for {area}',
        'tr': '{area} için dene',
        'params': "{'area': areaLabel}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # STREAK
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/streak/presentation/streak_stats_screen.dart',
        'old': "isEn ? '$milestone d' : '$milestone g'",
        'key': 'streak.milestone_days_short',
        'en': '{count} d',
        'tr': '{count} g',
        'params': "{'count': '$milestone'}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # CYCLE SYNC
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/cycle_sync/presentation/cycle_sync_screen.dart',
        'old': "isEn ? 'of $cycleLength' : '/ $cycleLength'",
        'key': 'cycle_sync.of_cycle_length',
        'en': 'of {count}',
        'tr': '/ {count}',
        'params': "{'count': '$cycleLength'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/cycle_sync/presentation/cycle_sync_screen.dart',
        'old': "isEn ? 'in ~$daysUntil days' : '~$daysUntil gün sonra'",
        'key': 'cycle_sync.in_n_days',
        'en': 'in ~{count} days',
        'tr': '~{count} gün sonra',
        'params': "{'count': '$daysUntil'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/cycle_sync/presentation/cycle_sync_screen.dart',
        'old': """isEn ? 'Upgrade to Pro' : "Pro'ya Yükselt\"""",
        'key': 'common.upgrade_to_pro',
        'en': 'Upgrade to Pro',
        'tr': "Pro'ya Yükselt",
        'params': None,  # No params needed
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # DIGEST
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/digest/presentation/weekly_digest_screen.dart',
        'old': "isEn ? 'Week of $range' : '$range Haftasi'",
        'key': 'digest.week_of_range',
        'en': 'Week of {range}',
        'tr': '{range} Haftası',
        'params': "{'range': range}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # RETROSPECTIVE
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/retrospective/presentation/retrospective_screen.dart',
        'old': "isEn ? '$savedCount memories saved' : '$savedCount anı kaydedildi'",
        'key': 'retrospective.memories_saved',
        'en': '{count} memories saved',
        'tr': '{count} anı kaydedildi',
        'params': "{'count': '$savedCount'}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # GROWTH
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/growth/presentation/growth_dashboard_screen.dart',
        'old': "isEn ? 'Best: $longestStreak days' : 'En iyi: $longestStreak gün'",
        'key': 'growth.best_streak_days',
        'en': 'Best: {count} days',
        'tr': 'En iyi: {count} gün',
        'params': "{'count': '$longestStreak'}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # SHADOW WORK
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/shadow_work/presentation/shadow_work_screen.dart',
        'old': "isEn ? '$daysAgo days ago' : '$daysAgo gün önce'",
        'key': 'shadow_work.days_ago',
        'en': '{count} days ago',
        'tr': '{count} gün önce',
        'params': "{'count': '$daysAgo'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/shadow_work/presentation/shadow_work_screen.dart',
        'old': """isEn ? 'Upgrade to Pro' : "Pro'ya Yükselt\"""",
        'key': 'common.upgrade_to_pro',
        'en': 'Upgrade to Pro',
        'tr': "Pro'ya Yükselt",
        'params': None,
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # PROGRAMS
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/programs/presentation/active_program_screen.dart',
        'old': "isEn ? 'Day $dayNumber complete — keep the momentum going!' : '$dayNumber. gün tamam — ivmeni sürdür!'",
        'key': 'programs.day_complete',
        'en': 'Day {day} complete — keep the momentum going!',
        'tr': '{day}. gün tamam — ivmeni sürdür!',
        'params': "{'day': '$dayNumber'}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # MILESTONES
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/milestones/presentation/milestone_screen.dart',
        'old': "isEn ? '$label filter' : '$label filtresi'",
        'key': 'milestones.filter_label',
        'en': '{label} filter',
        'tr': '{label} filtresi',
        'params': "{'label': label}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # GRATITUDE
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/gratitude/presentation/gratitude_archive_screen.dart',
        'old': "isEn ? '$count entries' : '$count kayıt'",
        'key': 'gratitude.archive.entry_count',
        'en': '{count} entries',
        'tr': '{count} kayıt',
        'params': "{'count': '$count'}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # PREMIUM
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/features/premium/presentation/contextual_paywall_modal.dart',
        'old': "isEn ? '$entryCount entries' : '$entryCount kayıt'",
        'key': 'premium.entry_count',
        'en': '{count} entries',
        'tr': '{count} kayıt',
        'params': "{'count': '$entryCount'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/premium/presentation/contextual_paywall_modal.dart',
        'old': "isEn ? '$streakDays-day streak' : '$streakDays gün seri'",
        'key': 'premium.day_streak',
        'en': '{count}-day streak',
        'tr': '{count} gün seri',
        'params': "{'count': '$streakDays'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/features/premium/presentation/contextual_paywall_modal.dart',
        'old': "isEn ? '$dreamCount dreams' : '$dreamCount rüya'",
        'key': 'premium.dream_count',
        'en': '{count} dreams',
        'tr': '{count} rüya',
        'params': "{'count': '$dreamCount'}",
        'isEn': 'isEn',
    },
    # ═══════════════════════════════════════════════════════════════
    # SHARE CARD TEMPLATES
    # ═══════════════════════════════════════════════════════════════
    {
        'file': 'lib/data/content/share_card_templates.dart',
        'old': "isEn ? 'Day $streakText' : '$streakText Gün'",
        'key': 'share.day_streak_headline',
        'en': 'Day {count}',
        'tr': '{count} Gün',
        'params': "{'count': streakText}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/data/content/share_card_templates.dart',
        'old': "isEn ? '$days Days of Journaling' : '$days Gün Günlük'",
        'key': 'share.days_of_journaling',
        'en': '{count} Days of Journaling',
        'tr': '{count} Gün Günlük',
        'params': "{'count': '$days'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/data/content/share_card_templates.dart',
        'old': "isEn ? 'Explored $count Dreams' : '$count Rüya Keşfedildi'",
        'key': 'share.explored_dreams',
        'en': 'Explored {count} Dreams',
        'tr': '{count} Rüya Keşfedildi',
        'params': "{'count': '$count'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/data/content/share_card_templates.dart',
        'old': "isEn ? 'Found $count Patterns' : '$count Örüntü Bulundu'",
        'key': 'share.found_patterns',
        'en': 'Found {count} Patterns',
        'tr': '{count} Örüntü Bulundu',
        'params': "{'count': '$count'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/data/content/share_card_templates.dart',
        'old': "isEn ? 'Day $day of $length' : '$length günün $day. günü'",
        'key': 'share.day_of_length',
        'en': 'Day {day} of {length}',
        'tr': '{length} günün {day}. günü',
        'params': "{'day': '$day', 'length': '$length'}",
        'isEn': 'isEn',
    },
    {
        'file': 'lib/data/content/share_card_templates.dart',
        'old': "isEn ? '$name Completed!' : '$name Tamamlandı!'",
        'key': 'share.program_completed',
        'en': '{name} Completed!',
        'tr': '{name} Tamamlandı!',
        'params': "{'name': name}",
        'isEn': 'isEn',
    },
]

def set_nested_key(d, key, value):
    parts = key.split('.')
    current = d
    for part in parts[:-1]:
        if part not in current:
            current[part] = OrderedDict()
        elif not isinstance(current[part], dict):
            current[part] = OrderedDict()
        current = current[part]
    current[parts[-1]] = value


def main():
    print("=" * 60)
    print("InnerCycles: isEn -> L10nService Migration v5")
    print("Interpolated strings with getWithParams()")
    print("=" * 60)

    # Load JSON files
    with open(EN_JSON, 'r', encoding='utf-8') as f:
        en_data = json.load(f, object_pairs_hook=OrderedDict)
    with open(TR_JSON, 'r', encoding='utf-8') as f:
        tr_data = json.load(f, object_pairs_hook=OrderedDict)

    total_replaced = 0
    total_keys = 0
    files_modified = set()

    for m in MIGRATIONS:
        filepath = os.path.join(PROJECT_ROOT, m['file'])
        if not os.path.exists(filepath):
            print(f"  SKIP (not found): {m['file']}")
            continue

        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        old_text = m['old']
        if old_text not in content:
            print(f"  SKIP (not found in file): {m['key']} in {m['file']}")
            continue

        key = m['key']
        isEn = m['isEn']

        if m['params'] is not None:
            # Use getWithParams
            new_text = f"L10nService.getWithParams('{key}', {isEn} ? AppLanguage.en : AppLanguage.tr, params: {m['params']})"
        else:
            # Simple get (no params)
            new_text = f"L10nService.get('{key}', {isEn} ? AppLanguage.en : AppLanguage.tr)"

        content = content.replace(old_text, new_text, 1)
        total_replaced += 1
        files_modified.add(filepath)

        # Add key to JSON
        set_nested_key(en_data, key, m['en'])
        set_nested_key(tr_data, key, m['tr'])
        total_keys += 1

        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)

        print(f"  OK  {m['key']}")

    # Save JSON
    with open(EN_JSON, 'w', encoding='utf-8') as f:
        json.dump(en_data, f, ensure_ascii=False, indent=2)
        f.write('\n')
    with open(TR_JSON, 'w', encoding='utf-8') as f:
        json.dump(tr_data, f, ensure_ascii=False, indent=2)
        f.write('\n')

    print(f"\n{'=' * 60}")
    print(f"Files:     {len(files_modified)}")
    print(f"Replaced:  {total_replaced}")
    print(f"L10n keys: {total_keys}")
    print(f"{'=' * 60}")


if __name__ == '__main__':
    main()
