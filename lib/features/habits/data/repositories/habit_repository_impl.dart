// lib/features/habits/data/repositories/habit_repository_impl.dart

import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../models/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  final SupabaseClient client;

  HabitRepositoryImpl({required this.client});

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

      // Create JSON without the 'id' field - let Supabase generate it
      final habitJson = {
        'user_id': userId,
        'name': name,
        'description': description,
        'icon': icon,
        'color': color,
        'target_days_per_week': targetDaysPerWeek,
        'completed_dates': [],
        'created_at': DateTime.now().toIso8601String(),
        'is_active': true,
        'linked_mood': linkedMood,
        'assigned_days': assignedDays,
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

      final completedDates = habit.completedDates.toList();
      if (isCompleting) {
        completedDates.add(date);
      } else {
        completedDates.removeWhere(
          (d) =>
              d.year == date.year && d.month == date.month && d.day == date.day,
        );
      }

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

      final data = await client
          .from('habits')
          .update(habitModel.toJson(includeId: true))
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
