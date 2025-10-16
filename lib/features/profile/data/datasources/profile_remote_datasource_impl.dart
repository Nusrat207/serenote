import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/profile_model.dart';
import 'profile_remote_datasource.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient _supabase = SupabaseService().client;

  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle(); // Use maybeSingle instead of single

      if (response == null) {
        // If no profile exists, create one
        return await _createDefaultProfile(userId);
      }

      return ProfileModel.fromJson(response);
    } catch (e) {
      print('Error getting profile: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    try {
      // Use upsert to handle both insert and update
      await _supabase
          .from('profiles')
          .upsert(profile.toJson());
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  Future<ProfileModel> _createDefaultProfile(String userId) async {
    try {
      // Get user email from auth
      final user = _supabase.auth.currentUser;
      final email = user?.email ?? 'user@example.com';
      
      final defaultProfile = ProfileModel(
        id: userId,
        email: email,
        displayName: email.split('@').first, // Use email prefix as default name
        avatarPath: 'assets/avatars/avatar1.png', // Default avatar
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Insert the default profile
      await _supabase
          .from('profiles')
          .insert(defaultProfile.toJson());

      return defaultProfile;
    } catch (e) {
      print('Error creating default profile: $e');
      rethrow;
    }
  }
}