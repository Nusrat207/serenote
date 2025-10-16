import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../models/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  final SupabaseClient client;

  HabitRepositoryImpl({required this.client});

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

  // ---------------- Get Habits ----------------
  @override
  Future<Either<Failure, List<HabitEntity>>> getHabits({
    bool activeOnly = true,
    String? forMood,
  }) async {
    try {
      final userId = client.auth.currentUser!.id;
      var query = client.from('habits').select().eq('user_id', userId);

      if (activeOnly) query = query.eq('is_active', true);
      if (forMood != null) query = query.eq('linked_mood', forMood);

      final data = await query;
      final habits = (data as List<dynamic>)
          .map((json) => HabitModel.fromJson(json).toEntity())
          .toList();
      return Right(habits);
    } catch (e) {
      return Left(CacheFailure('Failed to get habits: ${e.toString()}'));
    }
  }

  // ---------------- Create Habit ----------------
  @override
  Future<Either<Failure, HabitEntity>> createHabit({
    required String name,
    String? description,
    required String icon,
    required String color,
    required int targetDaysPerWeek,
    String? linkedMood,
    List<int>? assignedDays,
  }) async {
    try {
      final userId = client.auth.currentUser!.id;

      // Create JSON - assigned_days stored as JSONB in database
      final habitJson = {
        'user_id': userId,
        'name': name,
        'description': description,
        'icon': icon,
        'color': color,
        'target_days_per_week': targetDaysPerWeek,
        'completed_dates': [], // Empty JSONB array
        'created_at': DateTime.now().toIso8601String(),
        'is_active': true,
        'linked_mood': linkedMood,
        'assigned_days': assignedDays ?? [], // JSONB array
      };

      final response = await client
          .from('habits')
          .insert(habitJson)
          .select()
          .single();

      final createdHabit = HabitModel.fromJson(response).toEntity();
      return Right(createdHabit);
    } catch (e) {
      return Left(CacheFailure('Failed to create habit: ${e.toString()}'));
    }
  }

  // ---------------- Track Habit Completion ----------------
  @override
  Future<Either<Failure, HabitEntity>> trackHabit({
    required String habitId,
    required bool isCompleting,
    required DateTime date,
  }) async {
    try {
      final userId = client.auth.currentUser!.id;

      // Get current habit
      final habitData = await client
          .from('habits')
          .select()
          .eq('id', habitId)
          .eq('user_id', userId)
          .single();

      final habit = HabitModel.fromJson(habitData);

      // Validate: Can only complete today and past dates (after habit creation)
      if (!_canMarkDateAsCompleted(date, habit.createdAt)) {
        return Left(
          CacheFailure(
            'Cannot mark this date as completed. You can only mark today and past dates (after habit creation).',
          ),
        );
      }

      // Validate: Date must be an assigned day
      if (!_isAssignedDay(date, habit.assignedDays)) {
        return Left(
          CacheFailure('This habit is not scheduled for this day of the week.'),
        );
      }

      final normalizedDate = _normalizeDate(date);
      final completedDates = habit.completedDates.toList();

      if (isCompleting) {
        // Check if date is already completed
        final alreadyCompleted = completedDates.any(
          (d) => _normalizeDate(d).isAtSameMomentAs(normalizedDate),
        );

        if (!alreadyCompleted) {
          completedDates.add(normalizedDate);
        }
      } else {
        // Remove the date
        completedDates.removeWhere(
          (d) => _normalizeDate(d).isAtSameMomentAs(normalizedDate),
        );
      }

      // Update in database - completed_dates is JSONB
      final updatedData = await client
          .from('habits')
          .update({
            'completed_dates': completedDates
                .map((d) => d.toIso8601String())
                .toList(),
          })
          .eq('id', habitId)
          .eq('user_id', userId)
          .select()
          .single();

      final updatedHabit = HabitModel.fromJson(updatedData).toEntity();
      return Right(updatedHabit);
    } catch (e) {
      return Left(CacheFailure('Failed to track habit: ${e.toString()}'));
    }
  }

  // ---------------- Update Habit ----------------
  @override
  Future<Either<Failure, HabitEntity>> updateHabit(HabitEntity habit) async {
    try {
      final userId = client.auth.currentUser!.id;
      final habitModel = HabitModel.fromEntity(habit);

      // Filter completed dates to remove any that are before habit creation
      final validCompletedDates = habit.completedDates
          .where((date) => _canMarkDateAsCompleted(date, habit.createdAt))
          .toList();

      // Build update JSON with JSONB fields
      final updateJson = {
        'name': habitModel.name,
        'description': habitModel.description,
        'icon': habitModel.icon,
        'color': habitModel.color,
        'target_days_per_week': habitModel.targetDaysPerWeek,
        'completed_dates': validCompletedDates
            .map((d) => d.toIso8601String())
            .toList(),
        'is_active': habitModel.isActive,
        'linked_mood': habitModel.linkedMood,
        'assigned_days': habitModel.assignedDays ?? [],
      };

      final data = await client
          .from('habits')
          .update(updateJson)
          .eq('id', habit.id)
          .eq('user_id', userId)
          .select()
          .single();

      final updatedHabit = HabitModel.fromJson(data).toEntity();
      return Right(updatedHabit);
    } catch (e) {
      return Left(CacheFailure('Failed to update habit: ${e.toString()}'));
    }
  }

  // ---------------- Delete Habit ----------------
  @override
  Future<Either<Failure, void>> deleteHabit(String habitId) async {
    try {
      final userId = client.auth.currentUser!.id;

      await client
          .from('habits')
          .delete()
          .eq('id', habitId)
          .eq('user_id', userId);

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to delete habit: ${e.toString()}'));
    }
  }
}
