// ════════════════════════════════════════════════════════════════════════════
// TIMELINE EVENT MODEL - Unified event for emotional timeline visualization
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

enum TimelineEventType { journal, mood, lifeEvent, dream }

class TimelineEvent {
  final String id;
  final DateTime date;
  final TimelineEventType type;
  final String title;
  final String? subtitle;
  final Color color;
  final IconData icon;
  final int? rating; // 1-5 if applicable
  final String? routeId; // for navigation

  const TimelineEvent({
    required this.id,
    required this.date,
    required this.type,
    required this.title,
    this.subtitle,
    required this.color,
    required this.icon,
    this.rating,
    this.routeId,
  });

  static Color colorForFocusArea(FocusArea area) => area.color;

  static Color colorForMood(int mood) {
    switch (mood) {
      case 1:
        return const Color(0xFF8B6F5E);
      case 2:
        return const Color(0xFFA0876F);
      case 3:
        return const Color(0xFFB59F80);
      case 4:
        return const Color(0xFFD4A07A);
      case 5:
        return const Color(0xFFC8553D);
      default:
        return const Color(0xFFB59F80);
    }
  }
}
