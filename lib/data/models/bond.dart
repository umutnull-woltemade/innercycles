// ════════════════════════════════════════════════════════════════════════════
// BOND MODELS - Partner/close relationship data models
// ════════════════════════════════════════════════════════════════════════════

import '../providers/app_providers.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ENUMS
// ═══════════════════════════════════════════════════════════════════════════

enum BondType {
  partner,
  bestFriend,
  sibling;

  String get displayNameEn {
    switch (this) {
      case partner:
        return 'Partner';
      case bestFriend:
        return 'Best Friend';
      case sibling:
        return 'Sibling';
    }
  }

  String get displayNameTr {
    switch (this) {
      case partner:
        return 'Partner';
      case bestFriend:
        return 'En Yakın Arkadaş';
      case sibling:
        return 'Kardeş';
    }
  }

  String localizedName(AppLanguage language) =>
      language == AppLanguage.en ? displayNameEn : displayNameTr;

  String get emoji {
    switch (this) {
      case partner:
        return '💑';
      case bestFriend:
        return '👯';
      case sibling:
        return '🤝';
    }
  }
}

enum BondStatus {
  pending,
  active,
  paused,
  dissolving,
  dissolved;

  String get displayNameEn {
    switch (this) {
      case pending:
        return 'Pending';
      case active:
        return 'Active';
      case paused:
        return 'Paused';
      case dissolving:
        return 'Dissolving';
      case dissolved:
        return 'Dissolved';
    }
  }

  String get displayNameTr {
    switch (this) {
      case pending:
        return 'Beklemede';
      case active:
        return 'Aktif';
      case paused:
        return 'Duraklatılmış';
      case dissolving:
        return 'Çözülüyor';
      case dissolved:
        return 'Çözüldü';
    }
  }

  String localizedName(AppLanguage language) =>
      language == AppLanguage.en ? displayNameEn : displayNameTr;
}

enum TouchType {
  warm,
  heartbeat,
  light;

  String get displayNameEn {
    switch (this) {
      case warm:
        return 'Warm';
      case heartbeat:
        return 'Heartbeat';
      case light:
        return 'Light';
    }
  }

  String get displayNameTr {
    switch (this) {
      case warm:
        return 'Sıcak';
      case heartbeat:
        return 'Kalp Atışı';
      case light:
        return 'Hafif';
    }
  }

  String localizedName(AppLanguage language) =>
      language == AppLanguage.en ? displayNameEn : displayNameTr;

  String get emoji {
    switch (this) {
      case warm:
        return '🫶';
      case heartbeat:
        return '💓';
      case light:
        return '✨';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BOND
// ═══════════════════════════════════════════════════════════════════════════

class Bond {
  final String id;
  final String userA;
  final String userB;
  final BondType bondType;
  final BondStatus status;
  final String? displayNameA;
  final String? displayNameB;
  final DateTime? dissolveRequestedAt;
  final String? dissolveRequestedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Bond({
    required this.id,
    required this.userA,
    required this.userB,
    required this.bondType,
    required this.status,
    this.displayNameA,
    this.displayNameB,
    this.dissolveRequestedAt,
    this.dissolveRequestedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Whether the given userId is user_a in this bond
  bool isUserA(String userId) => userA == userId;

  /// Get the partner's user ID given the current user's ID
  String partnerId(String currentUserId) =>
      currentUserId == userA ? userB : userA;

  /// Get the partner's display name
  String? partnerDisplayName(String currentUserId) =>
      currentUserId == userA ? displayNameB : displayNameA;

  /// Days remaining in dissolve cooling period (7 days total)
  int get dissolveDaysRemaining {
    if (dissolveRequestedAt == null) return 0;
    final elapsed = DateTime.now().difference(dissolveRequestedAt!).inDays;
    return (7 - elapsed).clamp(0, 7);
  }

  Bond copyWith({
    BondStatus? status,
    String? displayNameA,
    String? displayNameB,
    DateTime? dissolveRequestedAt,
    String? dissolveRequestedBy,
  }) => Bond(
    id: id,
    userA: userA,
    userB: userB,
    bondType: bondType,
    status: status ?? this.status,
    displayNameA: displayNameA ?? this.displayNameA,
    displayNameB: displayNameB ?? this.displayNameB,
    dissolveRequestedAt: dissolveRequestedAt ?? this.dissolveRequestedAt,
    dissolveRequestedBy: dissolveRequestedBy ?? this.dissolveRequestedBy,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_a': userA,
    'user_b': userB,
    'bond_type': bondType.name,
    'status': status.name,
    if (displayNameA != null) 'display_name_a': displayNameA,
    if (displayNameB != null) 'display_name_b': displayNameB,
    if (dissolveRequestedAt != null)
      'dissolve_requested_at': dissolveRequestedAt!.toIso8601String(),
    if (dissolveRequestedBy != null)
      'dissolve_requested_by': dissolveRequestedBy,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory Bond.fromJson(Map<String, dynamic> json) => Bond(
    id: json['id'] as String,
    userA: json['user_a'] as String,
    userB: json['user_b'] as String,
    bondType: BondType.values.firstWhere(
      (t) => t.name == json['bond_type'],
      orElse: () => BondType.partner,
    ),
    status: BondStatus.values.firstWhere(
      (s) => s.name == json['status'],
      orElse: () => BondStatus.active,
    ),
    displayNameA: json['display_name_a'] as String?,
    displayNameB: json['display_name_b'] as String?,
    dissolveRequestedAt: json['dissolve_requested_at'] != null
        ? DateTime.tryParse(json['dissolve_requested_at'].toString())
        : null,
    dissolveRequestedBy: json['dissolve_requested_by'] as String?,
    createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// BOND INVITE
// ═══════════════════════════════════════════════════════════════════════════

class BondInvite {
  final String id;
  final String creatorId;
  final String code;
  final BondType bondType;
  final DateTime expiresAt;
  final String? acceptedBy;
  final DateTime? acceptedAt;
  final DateTime createdAt;

  const BondInvite({
    required this.id,
    required this.creatorId,
    required this.code,
    required this.bondType,
    required this.expiresAt,
    this.acceptedBy,
    this.acceptedAt,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isAccepted => acceptedBy != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'creator_id': creatorId,
    'code': code,
    'bond_type': bondType.name,
    'expires_at': expiresAt.toIso8601String(),
    if (acceptedBy != null) 'accepted_by': acceptedBy,
    if (acceptedAt != null) 'accepted_at': acceptedAt!.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
  };

  factory BondInvite.fromJson(Map<String, dynamic> json) => BondInvite(
    id: json['id'] as String,
    creatorId: json['creator_id'] as String,
    code: json['code'] as String,
    bondType: BondType.values.firstWhere(
      (t) => t.name == json['bond_type'],
      orElse: () => BondType.partner,
    ),
    expiresAt: DateTime.tryParse(json['expires_at']?.toString() ?? '') ??
        DateTime.now().add(const Duration(hours: 24)),
    acceptedBy: json['accepted_by'] as String?,
    acceptedAt: json['accepted_at'] != null
        ? DateTime.tryParse(json['accepted_at'].toString())
        : null,
    createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// TOUCH
// ═══════════════════════════════════════════════════════════════════════════

class Touch {
  final String id;
  final String bondId;
  final String senderId;
  final String receiverId;
  final TouchType touchType;
  final DateTime? seenAt;
  final DateTime createdAt;

  const Touch({
    required this.id,
    required this.bondId,
    required this.senderId,
    required this.receiverId,
    required this.touchType,
    this.seenAt,
    required this.createdAt,
  });

  bool get isSeen => seenAt != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'bond_id': bondId,
    'sender_id': senderId,
    'receiver_id': receiverId,
    'touch_type': touchType.name,
    if (seenAt != null) 'seen_at': seenAt!.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
  };

  factory Touch.fromJson(Map<String, dynamic> json) => Touch(
    id: json['id']?.toString() ?? '',
    bondId: json['bond_id']?.toString() ?? '',
    senderId: json['sender_id']?.toString() ?? '',
    receiverId: json['receiver_id']?.toString() ?? '',
    touchType: TouchType.values.firstWhere(
      (t) => t.name == json['touch_type'],
      orElse: () => TouchType.warm,
    ),
    seenAt: json['seen_at'] != null
        ? DateTime.tryParse(json['seen_at'].toString())
        : null,
    createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// BOND PRIVACY
// ═══════════════════════════════════════════════════════════════════════════

class BondPrivacy {
  final String id;
  final String bondId;
  final String userId;
  final bool shareMood;
  final bool shareSignal;
  final bool shareStreak;
  final bool allowTouches;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BondPrivacy({
    required this.id,
    required this.bondId,
    required this.userId,
    this.shareMood = true,
    this.shareSignal = true,
    this.shareStreak = false,
    this.allowTouches = true,
    required this.createdAt,
    required this.updatedAt,
  });

  BondPrivacy copyWith({
    bool? shareMood,
    bool? shareSignal,
    bool? shareStreak,
    bool? allowTouches,
  }) => BondPrivacy(
    id: id,
    bondId: bondId,
    userId: userId,
    shareMood: shareMood ?? this.shareMood,
    shareSignal: shareSignal ?? this.shareSignal,
    shareStreak: shareStreak ?? this.shareStreak,
    allowTouches: allowTouches ?? this.allowTouches,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'bond_id': bondId,
    'user_id': userId,
    'share_mood': shareMood,
    'share_signal': shareSignal,
    'share_streak': shareStreak,
    'allow_touches': allowTouches,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory BondPrivacy.fromJson(Map<String, dynamic> json) => BondPrivacy(
    id: json['id'] as String,
    bondId: json['bond_id'] as String,
    userId: json['user_id'] as String,
    shareMood: json['share_mood'] as bool? ?? true,
    shareSignal: json['share_signal'] as bool? ?? true,
    shareStreak: json['share_streak'] as bool? ?? false,
    allowTouches: json['allow_touches'] as bool? ?? true,
    createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
  );
}
