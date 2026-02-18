// ════════════════════════════════════════════════════════════════════════════
// UPGRADE TRIGGER SERVICE - InnerCycles Premium Upgrade Momentum Engine
// ════════════════════════════════════════════════════════════════════════════
// Determines WHEN to show premium upgrade prompts based on emotional
// momentum and user behavior milestones. Rate-limited and respectful.
// Uses SharedPreferences for persistence.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ════════════════════════════════════════════════════════════════════════════
// UPGRADE TRIGGER ENUM
// ════════════════════════════════════════════════════════════════════════════

enum UpgradeTrigger {
  insightsReady, // After 7th journal entry — "Your first pattern is emerging"
  dreamPatterns, // After 3rd dream entry — "Your dream symbols form a pattern"
  streakMilestone, // After 7-day streak — "You're building something — go deeper"
  monthlyReport, // End of first month — "Your monthly report is ready"
  unlimitedSharing, // After first share — "Create unlimited insight cards"
  attachmentDeep, // After attachment quiz — "Get your full attachment breakdown"
  comparePatterns, // After adding 2nd profile — "Compare your patterns"
  patternShift, // When pattern shifts detected — "Something changed — see what"
  seasonalReset, // Seasonal transition — "Your seasonal reset toolkit is ready"
  removeAds, // After 3 ad exposures in session — "Remove ads and focus"
}

// ════════════════════════════════════════════════════════════════════════════
// UPGRADE PROMPT MODEL
// ════════════════════════════════════════════════════════════════════════════

class UpgradePrompt {
  final UpgradeTrigger trigger;
  final String headlineEn;
  final String headlineTr;
  final String subtitleEn;
  final String subtitleTr;
  final String ctaEn;
  final String ctaTr;
  final IconData icon;

  const UpgradePrompt({
    required this.trigger,
    required this.headlineEn,
    required this.headlineTr,
    required this.subtitleEn,
    required this.subtitleTr,
    required this.ctaEn,
    required this.ctaTr,
    required this.icon,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// UPGRADE TRIGGER SERVICE
// ════════════════════════════════════════════════════════════════════════════

class UpgradeTriggerService {
  static const String _triggerHistoryKey = 'ic_upgrade_trigger_history';
  static const String _dismissedTriggersKey = 'ic_upgrade_dismissed_triggers';
  static const String _lastGlobalPromptKey = 'ic_upgrade_last_global_prompt';

  /// Rate limit: each trigger max once per 14 days
  static const int _perTriggerCooldownDays = 14;

  /// Global rate limit: max 1 upgrade prompt per 3 days
  static const int _globalCooldownDays = 3;

  /// Dismissed triggers don't show for 30 days
  static const int _dismissCooldownDays = 30;

  final SharedPreferences _prefs;

  /// Map of trigger name → last shown DateTime
  Map<String, DateTime> _triggerHistory = {};

  /// Map of trigger name → dismiss DateTime
  Map<String, DateTime> _dismissedTriggers = {};

  /// DateTime of any last upgrade prompt shown
  DateTime? _lastGlobalPrompt;

  UpgradeTriggerService._(this._prefs) {
    _loadState();
  }

  /// Initialize the upgrade trigger service
  static Future<UpgradeTriggerService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return UpgradeTriggerService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TRIGGER EVALUATION
  // ══════════════════════════════════════════════════════════════════════════

  /// Returns the highest-priority trigger that hasn't been shown recently,
  /// or null if none qualify. Checks emotional momentum milestones in
  /// priority order and applies all rate limits.
  UpgradeTrigger? checkTriggers({
    required int entryCount,
    required int dreamCount,
    required int streak,
    required int shareCount,
    required int profileCount,
    required bool hasCompletedQuiz,
    required int adExposures,
  }) {
    final now = DateTime.now();

    // Build candidates in priority order (highest first)
    final candidates = <UpgradeTrigger>[];

    // 1. insightsReady — if entryCount >= 7 AND entryCount < 15
    if (entryCount >= 7 && entryCount < 15) {
      candidates.add(UpgradeTrigger.insightsReady);
    }

    // 2. dreamPatterns — if dreamCount >= 3
    if (dreamCount >= 3) {
      candidates.add(UpgradeTrigger.dreamPatterns);
    }

    // 3. streakMilestone — if streak >= 7 AND streak is multiple of 7
    if (streak >= 7 && streak % 7 == 0) {
      candidates.add(UpgradeTrigger.streakMilestone);
    }

    // 4. monthlyReport — if entryCount >= 25
    if (entryCount >= 25) {
      candidates.add(UpgradeTrigger.monthlyReport);
    }

    // 5. unlimitedSharing — if shareCount >= 1
    if (shareCount >= 1) {
      candidates.add(UpgradeTrigger.unlimitedSharing);
    }

    // 6. attachmentDeep — if hasCompletedQuiz
    if (hasCompletedQuiz) {
      candidates.add(UpgradeTrigger.attachmentDeep);
    }

    // 7. comparePatterns — if profileCount >= 2
    if (profileCount >= 2) {
      candidates.add(UpgradeTrigger.comparePatterns);
    }

    // 8. removeAds — if adExposures >= 3
    if (adExposures >= 3) {
      candidates.add(UpgradeTrigger.removeAds);
    }

    // 9. patternShift — always eligible after 14+ entries
    if (entryCount >= 14) {
      candidates.add(UpgradeTrigger.patternShift);
    }

    // 10. seasonalReset — during equinox/solstice weeks
    if (_isSeasonalTransitionWeek(now)) {
      candidates.add(UpgradeTrigger.seasonalReset);
    }

    // Return the first candidate that passes rate limits
    for (final trigger in candidates) {
      if (shouldShowUpgrade(trigger)) {
        return trigger;
      }
    }

    return null;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // RATE LIMITING
  // ══════════════════════════════════════════════════════════════════════════

  /// Rate limit check: each trigger max once per 14 days,
  /// global max 1 prompt per 3 days, dismissed triggers wait 30 days.
  bool shouldShowUpgrade(UpgradeTrigger trigger) {
    final now = DateTime.now();
    final triggerName = trigger.name;

    // Check global cooldown: max 1 upgrade prompt per 3 days
    if (_lastGlobalPrompt != null) {
      final daysSinceGlobal = now.difference(_lastGlobalPrompt!).inDays;
      if (daysSinceGlobal < _globalCooldownDays) {
        return false;
      }
    }

    // Check dismissed cooldown: 30 days after user dismissal
    final dismissDate = _dismissedTriggers[triggerName];
    if (dismissDate != null) {
      final daysSinceDismiss = now.difference(dismissDate).inDays;
      if (daysSinceDismiss < _dismissCooldownDays) {
        return false;
      }
    }

    // Check per-trigger cooldown: max once per 14 days
    final lastShown = _triggerHistory[triggerName];
    if (lastShown != null) {
      final daysSinceShown = now.difference(lastShown).inDays;
      if (daysSinceShown < _perTriggerCooldownDays) {
        return false;
      }
    }

    return true;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TRIGGER LIFECYCLE
  // ══════════════════════════════════════════════════════════════════════════

  /// Mark a trigger as shown. Updates both per-trigger and global timestamps.
  Future<void> markTriggerShown(UpgradeTrigger trigger) async {
    final now = DateTime.now();
    _triggerHistory[trigger.name] = now;
    _lastGlobalPrompt = now;
    await _persistState();
  }

  /// User dismissed this trigger — don't show for 30 days.
  Future<void> dismissTrigger(UpgradeTrigger trigger) async {
    _dismissedTriggers[trigger.name] = DateTime.now();
    await _persistState();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROMPT CONTENT
  // ══════════════════════════════════════════════════════════════════════════

  /// Get the localized prompt content for a given trigger.
  UpgradePrompt getPromptForTrigger(UpgradeTrigger trigger) {
    return _prompts[trigger] ?? _prompts.values.first;
  }

  static final Map<UpgradeTrigger, UpgradePrompt> _prompts = {
    UpgradeTrigger.insightsReady: const UpgradePrompt(
      trigger: UpgradeTrigger.insightsReady,
      headlineEn: 'Your first pattern is emerging',
      headlineTr: 'İlk örüntün belirmeye başladı',
      subtitleEn:
          'Seven entries in — your journal is starting to reveal connections '
          'only you can see. Unlock full pattern insights.',
      subtitleTr:
          'Yedi giriş tamamlandı — günlüğün yalnızca senin görebileceğin '
          'bağlantıları ortaya çıkarıyor. Tam örüntü analizini aç.',
      ctaEn: 'See My Patterns',
      ctaTr: 'Örüntülerimi Gör',
      icon: Icons.auto_awesome,
    ),
    UpgradeTrigger.dreamPatterns: const UpgradePrompt(
      trigger: UpgradeTrigger.dreamPatterns,
      headlineEn: 'Your dream symbols form a pattern',
      headlineTr: 'Rüya sembollerin bir örüntü oluşturuyor',
      subtitleEn:
          'Three dreams logged — recurring themes are surfacing. '
          'Explore what your subconscious is telling you.',
      subtitleTr:
          'Üç rüya kaydedildi — tekrarlayan temalar beliriyor. '
          'Bilinçaltının sana ne söylediğini keşfet.',
      ctaEn: 'Explore Dream Insights',
      ctaTr: 'Rüya Analizini Keşfet',
      icon: Icons.nightlight_round,
    ),
    UpgradeTrigger.streakMilestone: const UpgradePrompt(
      trigger: UpgradeTrigger.streakMilestone,
      headlineEn: "You're building something — go deeper",
      headlineTr: 'Bir şey inşa ediyorsun — derine dal',
      subtitleEn:
          'A week of consistent reflection. Your commitment deserves '
          'tools that match it.',
      subtitleTr:
          'Bir haftalık tutarlı yansıma. Kararlılığın, ona eşlik edecek '
          'araçları hak ediyor.',
      ctaEn: 'Unlock Deeper Tools',
      ctaTr: 'Derinlemesine Araçları Aç',
      icon: Icons.local_fire_department,
    ),
    UpgradeTrigger.monthlyReport: const UpgradePrompt(
      trigger: UpgradeTrigger.monthlyReport,
      headlineEn: 'Your monthly report is ready',
      headlineTr: 'Aylık raporun hazır',
      subtitleEn:
          'A full month of data, distilled into one clear picture. '
          'See how your cycles moved this month.',
      subtitleTr:
          'Bir aylık veri, tek bir net görünümde. '
          'Bu ay döngülerinin nasıl hareket ettiğini gör.',
      ctaEn: 'View My Report',
      ctaTr: 'Raporumu Gör',
      icon: Icons.insert_chart_outlined,
    ),
    UpgradeTrigger.unlimitedSharing: const UpgradePrompt(
      trigger: UpgradeTrigger.unlimitedSharing,
      headlineEn: 'Create unlimited insight cards',
      headlineTr: 'Sınırsız içgörü kartı oluştur',
      subtitleEn:
          'You shared your first insight — beautiful. '
          'Create as many shareable cards as you like.',
      subtitleTr:
          'İlk içgörünü paylaştın — harika. '
          'İstediğin kadar paylaşılabilir kart oluştur.',
      ctaEn: 'Unlock Unlimited Sharing',
      ctaTr: 'Sınırsız Paylaşımı Aç',
      icon: Icons.share_rounded,
    ),
    UpgradeTrigger.attachmentDeep: const UpgradePrompt(
      trigger: UpgradeTrigger.attachmentDeep,
      headlineEn: 'Get your full attachment breakdown',
      headlineTr: 'Tam bağlanma analizini al',
      subtitleEn:
          'Your quiz results scratched the surface. '
          'The full breakdown maps your attachment style across all areas.',
      subtitleTr:
          'Test sonuçların yüzeyi çizdi. '
          'Tam analiz, bağlanma stilini tüm alanlarda haritalandırır.',
      ctaEn: 'See Full Breakdown',
      ctaTr: 'Tam Analizi Gör',
      icon: Icons.psychology,
    ),
    UpgradeTrigger.comparePatterns: const UpgradePrompt(
      trigger: UpgradeTrigger.comparePatterns,
      headlineEn: 'Compare your patterns',
      headlineTr: 'Örüntülerini karşılaştır',
      subtitleEn:
          'Two profiles means twice the insight. '
          'See how your cycles relate and influence each other.',
      subtitleTr:
          'İki profil, iki kat içgörü demek. '
          'Döngülerinin birbirini nasıl etkilediğini gör.',
      ctaEn: 'Compare Now',
      ctaTr: 'Şimdi Karşılaştır',
      icon: Icons.compare_arrows,
    ),
    UpgradeTrigger.patternShift: const UpgradePrompt(
      trigger: UpgradeTrigger.patternShift,
      headlineEn: 'Something changed — see what',
      headlineTr: 'Bir şey değişti — ne olduğunu gör',
      subtitleEn:
          'Your recent entries show a shift in your patterns. '
          'Unlock full shift analysis to understand the movement.',
      subtitleTr:
          'Son girişlerin örüntülerinde bir kayma gösteriyor. '
          'Hareketi anlamak için tam kayma analizini aç.',
      ctaEn: 'View Pattern Shift',
      ctaTr: 'Örüntü Kaymasını Gör',
      icon: Icons.trending_up,
    ),
    UpgradeTrigger.seasonalReset: const UpgradePrompt(
      trigger: UpgradeTrigger.seasonalReset,
      headlineEn: 'Your seasonal reset toolkit is ready',
      headlineTr: 'Mevsimsel sıfırlama araç setin hazır',
      subtitleEn:
          "The season is shifting, and so can you. "
          'Guided prompts and reflections for the transition ahead.',
      subtitleTr:
          'Mevsim değişiyor, sen de değişebilirsin. '
          'Önündeki geçiş için rehberli sorular ve yansımalar.',
      ctaEn: 'Start My Reset',
      ctaTr: 'Sıfırlamaya Başla',
      icon: Icons.eco,
    ),
    UpgradeTrigger.removeAds: const UpgradePrompt(
      trigger: UpgradeTrigger.removeAds,
      headlineEn: 'Remove ads and focus',
      headlineTr: 'Reklamları kaldır ve odaklan',
      subtitleEn:
          'Your reflection space, without interruptions. '
          'A cleaner experience, just for you.',
      subtitleTr:
          'Yansıma alanın, kesintisiz. '
          'Sadece sana özel, daha temiz bir deneyim.',
      ctaEn: 'Go Ad-Free',
      ctaTr: 'Reklamsız Geç',
      icon: Icons.visibility_off,
    ),
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SEASONAL DETECTION
  // ══════════════════════════════════════════════════════════════════════════

  /// Check if the given date falls within an equinox/solstice week.
  /// Mar 18-24, Jun 18-24, Sep 20-26, Dec 18-24
  bool _isSeasonalTransitionWeek(DateTime date) {
    final month = date.month;
    final day = date.day;

    // Spring equinox week: March 18–24
    if (month == 3 && day >= 18 && day <= 24) return true;

    // Summer solstice week: June 18–24
    if (month == 6 && day >= 18 && day <= 24) return true;

    // Autumn equinox week: September 20–26
    if (month == 9 && day >= 20 && day <= 26) return true;

    // Winter solstice week: December 18–24
    if (month == 12 && day >= 18 && day <= 24) return true;

    return false;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadState() {
    // Load trigger history
    final historyJson = _prefs.getString(_triggerHistoryKey);
    if (historyJson != null) {
      try {
        final Map<String, dynamic> decoded = json.decode(historyJson);
        _triggerHistory = decoded.map(
          (key, value) => MapEntry(key, DateTime.parse(value as String)),
        );
      } catch (_) {
        _triggerHistory = {};
      }
    }

    // Load dismissed triggers
    final dismissedJson = _prefs.getString(_dismissedTriggersKey);
    if (dismissedJson != null) {
      try {
        final Map<String, dynamic> decoded = json.decode(dismissedJson);
        _dismissedTriggers = decoded.map(
          (key, value) => MapEntry(key, DateTime.parse(value as String)),
        );
      } catch (_) {
        _dismissedTriggers = {};
      }
    }

    // Load last global prompt timestamp
    final lastGlobalJson = _prefs.getString(_lastGlobalPromptKey);
    if (lastGlobalJson != null) {
      try {
        _lastGlobalPrompt = DateTime.parse(lastGlobalJson);
      } catch (_) {
        _lastGlobalPrompt = null;
      }
    }
  }

  Future<void> _persistState() async {
    // Persist trigger history
    final historyMap = _triggerHistory.map(
      (key, value) => MapEntry(key, value.toIso8601String()),
    );
    await _prefs.setString(_triggerHistoryKey, json.encode(historyMap));

    // Persist dismissed triggers
    final dismissedMap = _dismissedTriggers.map(
      (key, value) => MapEntry(key, value.toIso8601String()),
    );
    await _prefs.setString(_dismissedTriggersKey, json.encode(dismissedMap));

    // Persist last global prompt
    if (_lastGlobalPrompt != null) {
      await _prefs.setString(
        _lastGlobalPromptKey,
        _lastGlobalPrompt!.toIso8601String(),
      );
    }
  }

  /// Clear all upgrade trigger data
  Future<void> clearAll() async {
    _triggerHistory.clear();
    _dismissedTriggers.clear();
    _lastGlobalPrompt = null;
    await _prefs.remove(_triggerHistoryKey);
    await _prefs.remove(_dismissedTriggersKey);
    await _prefs.remove(_lastGlobalPromptKey);
  }
}
