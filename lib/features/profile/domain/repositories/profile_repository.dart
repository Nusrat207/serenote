import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile(String userId);
  Future<void> updateProfile(ProfileEntity profile);
  Future<void> updateDisplayName(String userId, String displayName);
  Future<void> updateAvatar(String userId, String avatarPath);
}