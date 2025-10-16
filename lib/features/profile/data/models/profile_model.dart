class ProfileModel {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileModel({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarPath,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      email: json['email'],
      displayName: json['display_name'],
      avatarPath: json['avatar_path'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'id': id,
    'email': email,
    'display_name': displayName,
    'avatar_path': avatarPath,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
}