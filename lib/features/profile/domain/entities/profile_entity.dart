class ProfileEntity {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarPath,
    this.createdAt,
    this.updatedAt,
  });

  ProfileEntity copyWith({
    String? displayName,
    String? avatarPath,
    DateTime? updatedAt,
  }) {
    return ProfileEntity(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}