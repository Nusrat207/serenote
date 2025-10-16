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

  // Helper: Normalize date to start of day (remove time component)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Helper: Check if a date can be marked as completed
  bool _canMarkDateAsCompleted(DateTime date, DateTime habitCreatedAt) {
    final today = _normalizeDate(DateTime.now());
    final normalizedDate = _normalizeDate(date);
    final normalizedCreatedAt = _normalizeDate(habitCreatedAt);

    // Can't mark dates before habit was created
    if (normalizedDate.isBefore(normalizedCreatedAt)) {
      return false;
    }

    // Can't mark future dates
    if (normalizedDate.isAfter(today)) {
      return false;
    }

    return true;
  }

  // Helper: Check if date is an assigned day for the habit
  bool _isAssignedDay(DateTime date, List<int>? assignedDays) {
    if (assignedDays == null || assignedDays.isEmpty) {
      return true;
    }
    return assignedDays.contains(date.weekday); // 1=Mon, 7=Sun
  }

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

    // Validate: Can only complete today and past dates (after habit creation)
    if (!_canMarkDateAsCompleted(date, habit.createdAt)) {
      state = state.copyWith(
        error:
            'Cannot mark this date. You can only mark today and past dates (after habit creation).',
      );
      // Clear error after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        state = state.copyWith(error: null);
      });
      return;
    }

    // Validate: Date must be an assigned day
    if (!_isAssignedDay(date, habit.assignedDays)) {
      state = state.copyWith(
        error: 'This habit is not scheduled for this day of the week.',
      );
      // Clear error after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        state = state.copyWith(error: null);
      });
      return;
    }

    final isCompleted = habit.completedDates.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );

    final result = await trackHabitUseCase(
      habitId: habitId,
      isCompleting: !isCompleted,
      date: date,
    );

    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        // Clear error after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          state = state.copyWith(error: null);
        });
      },
      (updatedHabit) {
        final updatedHabits = state.habits
            .map((h) => h.id == habitId ? updatedHabit : h)
            .toList();
        state = state.copyWith(habits: updatedHabits, error: null);
      },
    );
  }

  Future<void> updateHabit(HabitEntity habit) async {
    state = state.copyWith(isLoading: true, error: null);

    // Filter completed dates to remove any that are before habit creation
    final validCompletedDates = habit.completedDates
        .where((date) => _canMarkDateAsCompleted(date, habit.createdAt))
        .toList();

    final updatedHabit = habit.copyWith(completedDates: validCompletedDates);

    final result = await updateHabitUseCase(updatedHabit);

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

    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        // Clear error after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          state = state.copyWith(error: null);
        });
      },
      (_) {
        final updatedHabits = state.habits
            .where((h) => h.id != habitId)
            .toList();
        state = state.copyWith(habits: updatedHabits, error: null);
      },
    );
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
