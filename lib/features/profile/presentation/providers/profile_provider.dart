import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class ProfileNotifier extends StateNotifier<ProfileEntity?> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileNotifier({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(null);

  Future<void> loadProfile(String userId) async {
    try {
      final profile = await getProfileUseCase(userId);
      state = profile;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDisplayName(String userId, String displayName) async {
    try {
      await updateProfileUseCase(
        state!.copyWith(
          displayName: displayName,
          updatedAt: DateTime.now(),
        ),
      );
      state = state!.copyWith(displayName: displayName);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAvatar(String userId, String avatarPath) async {
    try {
      await updateProfileUseCase(
        state!.copyWith(
          avatarPath: avatarPath,
          updatedAt: DateTime.now(),
        ),
      );
      state = state!.copyWith(avatarPath: avatarPath);
    } catch (e) {
      rethrow;
    }
  }
}

// Provider will be set up in dependency injection