/// Signal Content — 16 mood signals across 4 quadrants (circumplex model)
/// Replaces the basic 5-emoji mood scale with a rich, 2-axis emotional model.
/// Each signal maps backward to mood 1-5 for legacy compatibility.
/// Apple App Store 4.3(b) compliant. Educational and reflective only.
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../providers/app_providers.dart';

// ═══════════════════════════════════════════════════════════════════════════
// QUADRANT ENUM
// ═══════════════════════════════════════════════════════════════════════════

enum SignalQuadrant {
  fire, // High energy + High pleasantness
  water, // Low energy + High pleasantness
  storm, // High energy + Low pleasantness
  shadow; // Low energy + Low pleasantness

  String get nameEn {
    switch (this) {
      case fire:
        return 'Fire';
      case water:
        return 'Water';
      case storm:
        return 'Storm';
      case shadow:
        return 'Shadow';
    }
  }

  String get nameTr {
    switch (this) {
      case fire:
        return 'Ateş';
      case water:
        return 'Su';
      case storm:
        return 'Fırtına';
      case shadow:
        return 'Gölge';
    }
  }

  String localizedName(AppLanguage language) =>
      language == AppLanguage.en ? nameEn : nameTr;

  String get emoji {
    switch (this) {
      case fire:
        return '🔥';
      case water:
        return '💧';
      case storm:
        return '⚡';
      case shadow:
        return '🌑';
    }
  }

  /// Primary gradient colors for this quadrant
  List<Color> get gradientColors {
    switch (this) {
      case fire:
        return [AppColors.starGold, AppColors.celestialGold];
      case water:
        return [const Color(0xFF7EB8A8), const Color(0xFF5D9B8A)];
      case storm:
        return [const Color(0xFFD4944A), const Color(0xFF8B7355)];
      case shadow:
        return [AppColors.amethyst, AppColors.deepSpace];
    }
  }

  /// Single representative color
  Color get color {
    switch (this) {
      case fire:
        return AppColors.starGold;
      case water:
        return const Color(0xFF7EB8A8);
      case storm:
        return const Color(0xFFD4944A);
      case shadow:
        return AppColors.amethyst;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MOOD SIGNAL MODEL
// ═══════════════════════════════════════════════════════════════════════════

class MoodSignal {
  final String id;
  final SignalQuadrant quadrant;
  final String nameEn;
  final String nameTr;
  final int defaultEnergy; // 1-10
  final int defaultPleasantness; // 1-10
  final int backwardCompatMood; // 1-5 for legacy support
  final List<Color> orbGradientColors;
  final int pulseSpeedMs; // animation duration in ms
  final String emoji;

  const MoodSignal({
    required this.id,
    required this.quadrant,
    required this.nameEn,
    required this.nameTr,
    required this.defaultEnergy,
    required this.defaultPleasantness,
    required this.backwardCompatMood,
    required this.orbGradientColors,
    required this.pulseSpeedMs,
    required this.emoji,
  });

  String localizedName(AppLanguage language) =>
      language == AppLanguage.en ? nameEn : nameTr;
}

// ═══════════════════════════════════════════════════════════════════════════
// CONTENT — 16 Mood Signals (4 per quadrant)
// ═══════════════════════════════════════════════════════════════════════════

const List<MoodSignal> allMoodSignals = [
  // ═══════════════════════════════════════════════════════════════
  // FIRE QUADRANT — High energy + High pleasantness
  // ═══════════════════════════════════════════════════════════════
  MoodSignal(
    id: 'fire_alive',
    quadrant: SignalQuadrant.fire,
    nameEn: 'Alive',
    nameTr: 'Canlı',
    defaultEnergy: 9,
    defaultPleasantness: 8,
    backwardCompatMood: 5,
    orbGradientColors: [Color(0xFFFF6B35), Color(0xFFC8553D)],
    pulseSpeedMs: 800,
    emoji: '🔥',
  ),
  MoodSignal(
    id: 'fire_excited',
    quadrant: SignalQuadrant.fire,
    nameEn: 'Excited',
    nameTr: 'Heyecanlı',
    defaultEnergy: 8,
    defaultPleasantness: 9,
    backwardCompatMood: 5,
    orbGradientColors: [Color(0xFFD4704A), Color(0xFFFF6B35)],
    pulseSpeedMs: 900,
    emoji: '🤩',
  ),
  MoodSignal(
    id: 'fire_inspired',
    quadrant: SignalQuadrant.fire,
    nameEn: 'Inspired',
    nameTr: 'İlham Dolu',
    defaultEnergy: 7,
    defaultPleasantness: 8,
    backwardCompatMood: 5,
    orbGradientColors: [Color(0xFFC8553D), Color(0xFFD4A07A)],
    pulseSpeedMs: 1000,
    emoji: '💡',
  ),
  MoodSignal(
    id: 'fire_joyful',
    quadrant: SignalQuadrant.fire,
    nameEn: 'Joyful',
    nameTr: 'Neşeli',
    defaultEnergy: 7,
    defaultPleasantness: 9,
    backwardCompatMood: 5,
    orbGradientColors: [Color(0xFFD4704A), Color(0xFFD4A07A)],
    pulseSpeedMs: 1100,
    emoji: '😊',
  ),

  // ═══════════════════════════════════════════════════════════════
  // WATER QUADRANT — Low energy + High pleasantness
  // ═══════════════════════════════════════════════════════════════
  MoodSignal(
    id: 'water_peaceful',
    quadrant: SignalQuadrant.water,
    nameEn: 'Peaceful',
    nameTr: 'Huzurlu',
    defaultEnergy: 3,
    defaultPleasantness: 8,
    backwardCompatMood: 4,
    orbGradientColors: [Color(0xFF7EB8A8), Color(0xFF5D9B8A)],
    pulseSpeedMs: 2500,
    emoji: '☮️',
  ),
  MoodSignal(
    id: 'water_serene',
    quadrant: SignalQuadrant.water,
    nameEn: 'Serene',
    nameTr: 'Dingin',
    defaultEnergy: 2,
    defaultPleasantness: 9,
    backwardCompatMood: 4,
    orbGradientColors: [Color(0xFF5D9B8A), Color(0xFF7EB8A8)],
    pulseSpeedMs: 3000,
    emoji: '🧘',
  ),
  MoodSignal(
    id: 'water_grateful',
    quadrant: SignalQuadrant.water,
    nameEn: 'Grateful',
    nameTr: 'Minnettar',
    defaultEnergy: 4,
    defaultPleasantness: 8,
    backwardCompatMood: 4,
    orbGradientColors: [Color(0xFF7EB8A8), Color(0xFFD4A07A)],
    pulseSpeedMs: 2200,
    emoji: '🙏',
  ),
  MoodSignal(
    id: 'water_safe',
    quadrant: SignalQuadrant.water,
    nameEn: 'Safe',
    nameTr: 'Güvende',
    defaultEnergy: 3,
    defaultPleasantness: 7,
    backwardCompatMood: 4,
    orbGradientColors: [Color(0xFF5D9B8A), Color(0xFFB8A99A)],
    pulseSpeedMs: 2800,
    emoji: '🏠',
  ),

  // ═══════════════════════════════════════════════════════════════
  // STORM QUADRANT — High energy + Low pleasantness
  // ═══════════════════════════════════════════════════════════════
  MoodSignal(
    id: 'storm_anxious',
    quadrant: SignalQuadrant.storm,
    nameEn: 'Anxious',
    nameTr: 'Kaygılı',
    defaultEnergy: 8,
    defaultPleasantness: 3,
    backwardCompatMood: 2,
    orbGradientColors: [Color(0xFFD4944A), Color(0xFFC8553D)],
    pulseSpeedMs: 800,
    emoji: '😰',
  ),
  MoodSignal(
    id: 'storm_tense',
    quadrant: SignalQuadrant.storm,
    nameEn: 'Tense',
    nameTr: 'Gergin',
    defaultEnergy: 7,
    defaultPleasantness: 3,
    backwardCompatMood: 2,
    orbGradientColors: [Color(0xFF8B7355), Color(0xFFD4944A)],
    pulseSpeedMs: 900,
    emoji: '😤',
  ),
  MoodSignal(
    id: 'storm_angry',
    quadrant: SignalQuadrant.storm,
    nameEn: 'Angry',
    nameTr: 'Kızgın',
    defaultEnergy: 9,
    defaultPleasantness: 2,
    backwardCompatMood: 2,
    orbGradientColors: [Color(0xFFE74C3C), Color(0xFFD4944A)],
    pulseSpeedMs: 800,
    emoji: '😠',
  ),
  MoodSignal(
    id: 'storm_overwhelmed',
    quadrant: SignalQuadrant.storm,
    nameEn: 'Overwhelmed',
    nameTr: 'Bunalmış',
    defaultEnergy: 8,
    defaultPleasantness: 2,
    backwardCompatMood: 2,
    orbGradientColors: [Color(0xFFD4944A), Color(0xFF8B7355)],
    pulseSpeedMs: 1000,
    emoji: '🤯',
  ),

  // ═══════════════════════════════════════════════════════════════
  // SHADOW QUADRANT — Low energy + Low pleasantness
  // ═══════════════════════════════════════════════════════════════
  MoodSignal(
    id: 'shadow_drained',
    quadrant: SignalQuadrant.shadow,
    nameEn: 'Drained',
    nameTr: 'Tükenmiş',
    defaultEnergy: 2,
    defaultPleasantness: 3,
    backwardCompatMood: 1,
    orbGradientColors: [Color(0xFF8B6F5E), Color(0xFF5A4A3E)],
    pulseSpeedMs: 2500,
    emoji: '🪫',
  ),
  MoodSignal(
    id: 'shadow_sad',
    quadrant: SignalQuadrant.shadow,
    nameEn: 'Sad',
    nameTr: 'Üzgün',
    defaultEnergy: 3,
    defaultPleasantness: 2,
    backwardCompatMood: 1,
    orbGradientColors: [Color(0xFF5A4A3E), Color(0xFF8B6F5E)],
    pulseSpeedMs: 2800,
    emoji: '😢',
  ),
  MoodSignal(
    id: 'shadow_lonely',
    quadrant: SignalQuadrant.shadow,
    nameEn: 'Lonely',
    nameTr: 'Yalnız',
    defaultEnergy: 2,
    defaultPleasantness: 2,
    backwardCompatMood: 1,
    orbGradientColors: [Color(0xFF8B6F5E), Color(0xFF3D322B)],
    pulseSpeedMs: 3000,
    emoji: '😔',
  ),
  MoodSignal(
    id: 'shadow_empty',
    quadrant: SignalQuadrant.shadow,
    nameEn: 'Empty',
    nameTr: 'Boş',
    defaultEnergy: 1,
    defaultPleasantness: 2,
    backwardCompatMood: 1,
    orbGradientColors: [Color(0xFF3D322B), Color(0xFF1E1714)],
    pulseSpeedMs: 3000,
    emoji: '🫥',
  ),
];

// ═══════════════════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════════════════

/// Get all signals for a given quadrant
List<MoodSignal> getSignalsByQuadrant(SignalQuadrant quadrant) {
  return allMoodSignals.where((s) => s.quadrant == quadrant).toList();
}

/// Get a signal by its ID, or null if not found
MoodSignal? getSignalById(String id) {
  for (final s in allMoodSignals) {
    if (s.id == id) return s;
  }
  return null;
}

/// Convert a signal ID to a backward-compatible mood score (1-5)
int signalToMoodScore(String signalId) {
  return getSignalById(signalId)?.backwardCompatMood ?? 3;
}

/// Get the quadrant for a signal ID
SignalQuadrant? getQuadrantForSignal(String signalId) {
  return getSignalById(signalId)?.quadrant;
}

/// Get color for a signal ID (for calendar/trail dots)
Color getSignalColor(String signalId) {
  final signal = getSignalById(signalId);
  if (signal == null) return AppColors.textMuted;
  return signal.orbGradientColors.first;
}
