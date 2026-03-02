// ════════════════════════════════════════════════════════════════════════════
// TIME CAPSULE ENTRY MODEL - Letter to future self
// ════════════════════════════════════════════════════════════════════════════

class TimeCapsuleEntry {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime deliveryDate;
  final bool isDelivered;
  final bool isOpened;

  const TimeCapsuleEntry({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.deliveryDate,
    this.isDelivered = false,
    this.isOpened = false,
  });

  String get dateKey =>
      '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';

  String get deliveryDateKey =>
      '${deliveryDate.year}-${deliveryDate.month.toString().padLeft(2, '0')}-${deliveryDate.day.toString().padLeft(2, '0')}';

  bool get isReadyToDeliver {
    final now = DateTime.now();
    return !isOpened && now.isAfter(deliveryDate);
  }

  TimeCapsuleEntry copyWith({
    bool? isDelivered,
    bool? isOpened,
  }) {
    return TimeCapsuleEntry(
      id: id,
      content: content,
      createdAt: createdAt,
      deliveryDate: deliveryDate,
      isDelivered: isDelivered ?? this.isDelivered,
      isOpened: isOpened ?? this.isOpened,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'deliveryDate': deliveryDate.toIso8601String(),
        'isDelivered': isDelivered,
        'isOpened': isOpened,
      };

  factory TimeCapsuleEntry.fromJson(Map<String, dynamic> json) =>
      TimeCapsuleEntry(
        id: json['id'] as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        deliveryDate: DateTime.parse(json['deliveryDate'] as String),
        isDelivered: json['isDelivered'] as bool? ?? false,
        isOpened: json['isOpened'] as bool? ?? false,
      );
}
