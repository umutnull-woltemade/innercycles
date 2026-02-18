import 'package:uuid/uuid.dart';
import '../providers/app_providers.dart';
import '../services/l10n_service.dart';

class UserProfile {
  final String id;
  final String? name;
  final DateTime birthDate;
  final String? birthTime;
  final String? birthPlace;
  final double? birthLatitude;
  final double? birthLongitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPrimary;
  final String? relationship; // 'partner', 'friend', 'family', 'child', etc.
  final String? avatarEmoji; // Custom emoji for the profile

  UserProfile({
    String? id,
    this.name,
    required this.birthDate,
    this.birthTime,
    this.birthPlace,
    this.birthLatitude,
    this.birthLongitude,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isPrimary = false,
    this.relationship,
    this.avatarEmoji,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'birthDate': birthDate.toIso8601String(),
    'birthTime': birthTime,
    'birthPlace': birthPlace,
    'birthLatitude': birthLatitude,
    'birthLongitude': birthLongitude,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isPrimary': isPrimary,
    'relationship': relationship,
    'avatarEmoji': avatarEmoji,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String?,
      name: json['name'] as String?,
      birthDate: DateTime.tryParse(json['birthDate']?.toString() ?? '') ?? DateTime(2000, 1, 1),
      birthTime: json['birthTime'] as String?,
      birthPlace: json['birthPlace'] as String?,
      birthLatitude: json['birthLatitude'] as double?,
      birthLongitude: json['birthLongitude'] as double?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      isPrimary: json['isPrimary'] as bool? ?? false,
      relationship: json['relationship'] as String?,
      avatarEmoji: json['avatarEmoji'] as String?,
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    String? birthTime,
    String? birthPlace,
    double? birthLatitude,
    double? birthLongitude,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPrimary,
    String? relationship,
    String? avatarEmoji,
  }) => UserProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    birthDate: birthDate ?? this.birthDate,
    birthTime: birthTime ?? this.birthTime,
    birthPlace: birthPlace ?? this.birthPlace,
    birthLatitude: birthLatitude ?? this.birthLatitude,
    birthLongitude: birthLongitude ?? this.birthLongitude,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
    isPrimary: isPrimary ?? this.isPrimary,
    relationship: relationship ?? this.relationship,
    avatarEmoji: avatarEmoji ?? this.avatarEmoji,
  );

  /// Check if the profile has complete birth data
  bool get hasCompleteBirthData =>
      birthTime != null && birthLatitude != null && birthLongitude != null;

  /// Get display emoji (uses avatar emoji or generic sparkle)
  String get displayEmoji => avatarEmoji ?? '✨';

  /// Get relationship display name
  String get relationshipLabel {
    switch (relationship) {
      case 'partner':
        return 'Partner';
      case 'friend':
        return 'Friend';
      case 'family':
        return 'Family';
      case 'child':
        return 'Child';
      case 'crush':
        return 'Crush';
      case 'ex':
        return 'Ex';
      case 'colleague':
        return 'Colleague';
      default:
        return relationship ?? '';
    }
  }

  /// Get localized relationship display name
  String getLocalizedRelationshipLabel(AppLanguage language) {
    if (relationship == null) return '';
    return L10nService.get(
      'profile.relationship_types.$relationship',
      language,
    );
  }

  /// Calculate age from birth date
  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
