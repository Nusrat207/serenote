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
