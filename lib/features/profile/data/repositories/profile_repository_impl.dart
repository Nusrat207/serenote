import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileEntity> getProfile(String userId) async {
    try {
      final profileModel = await remoteDataSource.getProfile(userId);
      return _mapModelToEntity(profileModel);
    } catch (e) {
      print('Repository error getting profile: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    try {
      final profileModel = _mapEntityToModel(profile);
      await remoteDataSource.updateProfile(profileModel);
    } catch (e) {
      print('Repository error updating profile: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateDisplayName(String userId, String displayName) async {
    try {
      final currentProfile = await getProfile(userId);
      await updateProfile(currentProfile.copyWith(displayName: displayName));
    } catch (e) {
      print('Repository error updating display name: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateAvatar(String userId, String avatarPath) async {
    try {
      final currentProfile = await getProfile(userId);
      await updateProfile(currentProfile.copyWith(avatarPath: avatarPath));
    } catch (e) {
      print('Repository error updating avatar: $e');
      rethrow;
    }
  }

  ProfileEntity _mapModelToEntity(ProfileModel model) {
    return ProfileEntity(
      id: model.id,
      email: model.email,
      displayName: model.displayName,
      avatarPath: model.avatarPath,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  ProfileModel _mapEntityToModel(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      avatarPath: entity.avatarPath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}