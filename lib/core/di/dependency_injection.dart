// lib/core/di/dependency_injection.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/habits/data/repositories/habit_repository_impl.dart';
import '../../features/habits/domain/repositories/habit_repository.dart';
import '../../features/habits/domain/usecases/create_habit_usecase.dart';
import '../../features/habits/domain/usecases/track_habit_usecase.dart';
import '../../features/habits/domain/usecases/get_habits_usecase.dart';
import '../../features/habits/domain/usecases/update_habit_usecase.dart';
import '../../features/habits/domain/usecases/delete_habit_usecase.dart';
import '../../features/habits/presentation/providers/habit_provider.dart';
import '../../features/habits/presentation/providers/habit_provider.dart';
import '../../features/profile/domain/entities/profile_entity.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/datasources/profile_remote_datasource_impl.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';


// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Repositories - Using Supabase
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return HabitRepositoryImpl(client: client);
});

// Use Cases
final createHabitUseCaseProvider = Provider<CreateHabitUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return CreateHabitUseCase(repository);
});

final trackHabitUseCaseProvider = Provider<TrackHabitUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return TrackHabitUseCase(repository);
});

final getHabitsUseCaseProvider = Provider<GetHabitsUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return GetHabitsUseCase(repository);
});

final updateHabitUseCaseProvider = Provider<UpdateHabitUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return UpdateHabitUseCase(repository);
});

final deleteHabitUseCaseProvider = Provider<DeleteHabitUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return DeleteHabitUseCase(repository);
});

// State Notifier Provider (Main Habit Provider)
final habitProvider = StateNotifierProvider<HabitNotifier, HabitState>((ref) {
  return HabitNotifier(
    createHabitUseCase: ref.watch(createHabitUseCaseProvider),
    trackHabitUseCase: ref.watch(trackHabitUseCaseProvider),
    getHabitsUseCase: ref.watch(getHabitsUseCaseProvider),
    updateHabitUseCase: ref.watch(updateHabitUseCaseProvider),
    deleteHabitUseCase: ref.watch(deleteHabitUseCaseProvider),
  );
});


// Add these providers to your existing dependency_injection.dart

// Profile dependencies
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSourceImpl();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    ref.read(profileRemoteDataSourceProvider),
  );
});

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  return GetProfileUseCase(ref.read(profileRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.read(profileRepositoryProvider));
});

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileEntity?>((ref) {
  return ProfileNotifier(
    getProfileUseCase: ref.read(getProfileUseCaseProvider),
    updateProfileUseCase: ref.read(updateProfileUseCaseProvider),
  );
});