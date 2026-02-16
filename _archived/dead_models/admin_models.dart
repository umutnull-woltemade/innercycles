/// Admin System Data Models
/// ═══════════════════════════════════════════════════════════════════
/// Prisma-style schema definitions for admin dashboard
library;

// ═══════════════════════════════════════════════════════════════════
// MetricDaily - Daily KPI snapshots
// ═══════════════════════════════════════════════════════════════════

/// Daily metrics snapshot
/// Stores aggregated KPIs for dashboard
class MetricDaily {
  final String id;
  final DateTime date;
  final double d1Return; // D1 retention rate (%)
  final double d7Return; // D7 retention rate (%)
  final double avgSessionDepth; // Avg pages per session
  final double recoCtr; // Recommendation CTR (%)
  final double shareReturn; // Share-to-return rate (%)
  final int totalSessions; // Total sessions
  final int uniqueUsers; // Unique users
  final int premiumConversions; // Premium purchases
  final DateTime createdAt;

  MetricDaily({
    required this.id,
    required this.date,
    required this.d1Return,
    required this.d7Return,
    required this.avgSessionDepth,
    required this.recoCtr,
    required this.shareReturn,
    required this.totalSessions,
    required this.uniqueUsers,
    required this.premiumConversions,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'd1_return': d1Return,
    'd7_return': d7Return,
    'avg_session_depth': avgSessionDepth,
    'reco_ctr': recoCtr,
    'share_return': shareReturn,
    'total_sessions': totalSessions,
    'unique_users': uniqueUsers,
    'premium_conversions': premiumConversions,
    'created_at': createdAt.toIso8601String(),
  };

  factory MetricDaily.fromJson(Map<String, dynamic> json) => MetricDaily(
    id: json['id'],
    date: DateTime.parse(json['date']),
    d1Return: (json['d1_return'] as num).toDouble(),
    d7Return: (json['d7_return'] as num).toDouble(),
    avgSessionDepth: (json['avg_session_depth'] as num).toDouble(),
    recoCtr: (json['reco_ctr'] as num).toDouble(),
    shareReturn: (json['share_return'] as num).toDouble(),
    totalSessions: json['total_sessions'],
    uniqueUsers: json['unique_users'],
    premiumConversions: json['premium_conversions'],
    createdAt: DateTime.parse(json['created_at']),
  );
}

// ═══════════════════════════════════════════════════════════════════
// EventLog - Individual event records
// ═══════════════════════════════════════════════════════════════════

/// Event log entry
/// Tracks individual analytics events
class EventLogModel {
  final String id;
  final String eventName;
  final String? userId;
  final String? sessionId;
  final Map<String, dynamic>? payload;
  final DateTime timestamp;
  final String? page;
  final String? referrer;

  EventLogModel({
    required this.id,
    required this.eventName,
    this.userId,
    this.sessionId,
    this.payload,
    required this.timestamp,
    this.page,
    this.referrer,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_name': eventName,
    'user_id': userId,
    'session_id': sessionId,
    'payload': payload,
    'timestamp': timestamp.toIso8601String(),
    'page': page,
    'referrer': referrer,
  };

  factory EventLogModel.fromJson(Map<String, dynamic> json) => EventLogModel(
    id: json['id'],
    eventName: json['event_name'],
    userId: json['user_id'],
    sessionId: json['session_id'],
    payload: json['payload'],
    timestamp: DateTime.parse(json['timestamp']),
    page: json['page'],
    referrer: json['referrer'],
  );
}

// ═══════════════════════════════════════════════════════════════════
// GrowthTask - Task tracking for growth initiatives
// ═══════════════════════════════════════════════════════════════════

/// Growth task model
/// Tracks growth initiatives and experiments
class GrowthTaskModel {
  final String id;
  final String title;
  final String? description;
  final String category; // retention, conversion, growth, experimentation
  final String priority; // high, medium, low
  final String status; // pending, in_progress, completed, blocked
  final DateTime? dueDate;
  final String? assignee;
  final List<String>? tags;
  final DateTime createdAt;
  final DateTime? completedAt;

  GrowthTaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.priority,
    required this.status,
    this.dueDate,
    this.assignee,
    this.tags,
    required this.createdAt,
    this.completedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'priority': priority,
    'status': status,
    'due_date': dueDate?.toIso8601String(),
    'assignee': assignee,
    'tags': tags,
    'created_at': createdAt.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
  };

  factory GrowthTaskModel.fromJson(Map<String, dynamic> json) =>
      GrowthTaskModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        category: json['category'],
        priority: json['priority'],
        status: json['status'],
        dueDate: json['due_date'] != null
            ? DateTime.parse(json['due_date'])
            : null,
        assignee: json['assignee'],
        tags: (json['tags'] as List?)?.cast<String>(),
        createdAt: DateTime.parse(json['created_at']),
        completedAt: json['completed_at'] != null
            ? DateTime.parse(json['completed_at'])
            : null,
      );
}

// ═══════════════════════════════════════════════════════════════════
// Snapshot - Context preservation
// ═══════════════════════════════════════════════════════════════════

/// Admin snapshot model
/// Stores context snapshots for continuity
class SnapshotModel {
  final String id;
  final String type; // resume, decision, open_loops, risk, etc.
  final String title;
  final String content;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final String? createdBy;

  SnapshotModel({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    this.metadata,
    required this.createdAt,
    this.createdBy,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'content': content,
    'metadata': metadata,
    'created_at': createdAt.toIso8601String(),
    'created_by': createdBy,
  };

  factory SnapshotModel.fromJson(Map<String, dynamic> json) => SnapshotModel(
    id: json['id'],
    type: json['type'],
    title: json['title'],
    content: json['content'],
    metadata: json['metadata'],
    createdAt: DateTime.parse(json['created_at']),
    createdBy: json['created_by'],
  );
}

// ═══════════════════════════════════════════════════════════════════
// Alert - Metric alerts
// ═══════════════════════════════════════════════════════════════════

/// Alert model
/// Triggers when metrics cross thresholds
class AlertModel {
  final String id;
  final String metric; // d1_return, d7_return, etc.
  final String condition; // above, below, change
  final double threshold;
  final double currentValue;
  final String severity; // info, warning, critical
  final bool acknowledged;
  final DateTime triggeredAt;
  final DateTime? acknowledgedAt;

  AlertModel({
    required this.id,
    required this.metric,
    required this.condition,
    required this.threshold,
    required this.currentValue,
    required this.severity,
    required this.acknowledged,
    required this.triggeredAt,
    this.acknowledgedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'metric': metric,
    'condition': condition,
    'threshold': threshold,
    'current_value': currentValue,
    'severity': severity,
    'acknowledged': acknowledged,
    'triggered_at': triggeredAt.toIso8601String(),
    'acknowledged_at': acknowledgedAt?.toIso8601String(),
  };

  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
    id: json['id'],
    metric: json['metric'],
    condition: json['condition'],
    threshold: (json['threshold'] as num).toDouble(),
    currentValue: (json['current_value'] as num).toDouble(),
    severity: json['severity'],
    acknowledged: json['acknowledged'],
    triggeredAt: DateTime.parse(json['triggered_at']),
    acknowledgedAt: json['acknowledged_at'] != null
        ? DateTime.parse(json['acknowledged_at'])
        : null,
  );
}
