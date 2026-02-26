// ════════════════════════════════════════════════════════════════════════════
// VAULT PHOTO MODEL - Private Photo Album
// ════════════════════════════════════════════════════════════════════════════

class VaultPhoto {
  final String id;
  final DateTime createdAt;
  final String filePath;
  final String? caption;
  final String? thumbnailPath;

  const VaultPhoto({
    required this.id,
    required this.createdAt,
    required this.filePath,
    this.caption,
    this.thumbnailPath,
  });

  VaultPhoto copyWith({
    String? id,
    DateTime? createdAt,
    String? filePath,
    String? caption,
    String? thumbnailPath,
  }) {
    return VaultPhoto(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      filePath: filePath ?? this.filePath,
      caption: caption ?? this.caption,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'filePath': filePath,
    'caption': caption,
    'thumbnailPath': thumbnailPath,
  };

  factory VaultPhoto.fromJson(Map<String, dynamic> json) => VaultPhoto(
    id: json['id'] as String? ?? '',
    createdAt:
        DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
        DateTime.now(),
    filePath: json['filePath'] as String? ?? '',
    caption: json['caption'] as String?,
    thumbnailPath: json['thumbnailPath'] as String?,
  );
}
