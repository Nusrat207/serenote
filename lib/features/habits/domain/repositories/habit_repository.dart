// lib/features/habits/domain/repositories/habit_repository.dart

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit_entity.dart';

abstract class HabitRepository {
  Future<Either<Failure, List<HabitEntity>>> getHabits({
    bool activeOnly = true,
    String? forMood,
  });

  Future<Either<Failure, HabitEntity>> createHabit({
    required String name,
    String? description,
    required String icon,
    required String color,
    required int targetDaysPerWeek,
    String? linkedMood,
    List<int>? assignedDays,
  });

  Future<Either<Failure, HabitEntity>> trackHabit({
    required String habitId,
    required bool isCompleting,
    required DateTime date,
  });

  Future<Either<Failure, HabitEntity>> updateHabit(HabitEntity habit);

  Future<Either<Failure, void>> deleteHabit(String habitId);
}
