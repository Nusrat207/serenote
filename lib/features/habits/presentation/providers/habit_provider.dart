// lib/features/habits/presentation/providers/habit_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/usecases/create_habit_usecase.dart';
import '../../domain/usecases/track_habit_usecase.dart';
import '../../domain/usecases/get_habits_usecase.dart';
import '../../domain/usecases/update_habit_usecase.dart';
import '../../domain/usecases/delete_habit_usecase.dart';
import '../../../../core/di/dependency_injection.dart';

// State classes
class HabitState {
  final List<HabitEntity> habits;
  final bool isLoading;
  final String? error;
  final HabitEntity? selectedHabit;

  const HabitState({
    this.habits = const [],
    this.isLoading = false,
    this.error,
    this.selectedHabit,
  });

  HabitState copyWith({
    List<HabitEntity>? habits,
    bool? isLoading,
    String? error,
    HabitEntity? selectedHabit,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedHabit: selectedHabit ?? this.selectedHabit,
    );
  }
}

// Notifier
class HabitNotifier extends StateNotifier<HabitState> {
  final CreateHabitUseCase createHabitUseCase;
  final TrackHabitUseCase trackHabitUseCase;
  final GetHabitsUseCase getHabitsUseCase;
  final UpdateHabitUseCase updateHabitUseCase;
  final DeleteHabitUseCase deleteHabitUseCase;

  HabitNotifier({
    required this.createHabitUseCase,
    required this.trackHabitUseCase,
    required this.getHabitsUseCase,
    required this.updateHabitUseCase,
    required this.deleteHabitUseCase,
  }) : super(const HabitState());

  Future<void> loadHabits({bool activeOnly = true, String? forMood}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getHabitsUseCase(
      activeOnly: activeOnly,
      forMood: forMood,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (habits) =>
          state = state.copyWith(habits: habits, isLoading: false, error: null),
    );
  }

  Future<void> createHabit({
    required String name,
    String? description,
    required String icon,
    required String color,
    required int targetDaysPerWeek,
    String? linkedMood,
    List<int>? assignedDays,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await createHabitUseCase(
      name: name,
      description: description,
      icon: icon,
      color: color,
      targetDaysPerWeek: targetDaysPerWeek,
      linkedMood: linkedMood,
      assignedDays: assignedDays,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (habit) {
        final updatedHabits = [...state.habits, habit];
        state = state.copyWith(
          habits: updatedHabits,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  Future<void> toggleHabitCompletion(String habitId, DateTime date) async {
    final habit = state.habits.firstWhere((h) => h.id == habitId);
    final isCompleted = habit.completedDates.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );

    final result = await trackHabitUseCase(
      habitId: habitId,
      isCompleting: !isCompleted,
      date: date,
    );

    result.fold((failure) => state = state.copyWith(error: failure.message), (
      updatedHabit,
    ) {
      final updatedHabits = state.habits
          .map((h) => h.id == habitId ? updatedHabit : h)
          .toList();
      state = state.copyWith(habits: updatedHabits, error: null);
    });
  }

  Future<void> updateHabit(HabitEntity habit) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await updateHabitUseCase(habit);

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (updatedHabit) {
        final updatedHabits = state.habits
            .map((h) => h.id == updatedHabit.id ? updatedHabit : h)
            .toList();
        state = state.copyWith(
          habits: updatedHabits,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  Future<void> deleteHabit(String habitId) async {
    final result = await deleteHabitUseCase(habitId);

    result.fold((failure) => state = state.copyWith(error: failure.message), (
      _,
    ) {
      final updatedHabits = state.habits.where((h) => h.id != habitId).toList();
      state = state.copyWith(habits: updatedHabits, error: null);
    });
  }

  void selectHabit(HabitEntity? habit) {
    state = state.copyWith(selectedHabit: habit);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider connected to dependency injection
final habitNotifierProvider = StateNotifierProvider<HabitNotifier, HabitState>((
  ref,
) {
  return HabitNotifier(
    createHabitUseCase: ref.watch(createHabitUseCaseProvider),
    trackHabitUseCase: ref.watch(trackHabitUseCaseProvider),
    getHabitsUseCase: ref.watch(getHabitsUseCaseProvider),
    updateHabitUseCase: ref.watch(updateHabitUseCaseProvider),
    deleteHabitUseCase: ref.watch(deleteHabitUseCaseProvider),
  );
});
