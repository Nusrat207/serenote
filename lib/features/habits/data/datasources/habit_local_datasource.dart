// lib/features/habits/data/datasources/habit_local_datasource.dart

import 'package:uuid/uuid.dart';
import '../models/habit_model.dart';

abstract class HabitLocalDataSource {
  Future<List<HabitModel>> getHabits({bool activeOnly = true, String? forMood});

  Future<HabitModel> createHabit({
    required String userId, // ← ADD THIS
    required String name,
    String? description,
    required String icon,
    required String color,
    required int targetDaysPerWeek,
    String? linkedMood,
    List<int>? assignedDays,
  });

  Future<HabitModel> trackHabit({
    required String habitId,
    required bool isCompleting,
    required DateTime date,
  });

  Future<HabitModel> updateHabit(HabitModel habit);

  Future<void> deleteHabit(String habitId);
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  // In-memory storage for now
  static final Map<String, HabitModel> _habits = {};

  @override
  Future<List<HabitModel>> getHabits({
    bool activeOnly = true,
    String? forMood,
  }) async {
    var habits = _habits.values.toList();

    if (activeOnly) {
      habits = habits.where((h) => h.isActive).toList();
    }

    if (forMood != null) {
      habits = habits.where((h) => h.linkedMood == forMood).toList();
    }

    return habits;
  }

  @override
  Future<HabitModel> createHabit({
    required String userId, // ← ADD THIS
    required String name,
    String? description,
    required String icon,
    required String color,
    required int targetDaysPerWeek,
    String? linkedMood,
    List<int>? assignedDays,
  }) async {
    const uuid = Uuid();
    final id = uuid.v4();

    final habit = HabitModel(
      id: id,
      userId: userId, // ← ADD THIS
      name: name,
      description: description,
      icon: icon,
      color: color,
      targetDaysPerWeek: targetDaysPerWeek,
      completedDates: [],
      createdAt: DateTime.now(),
      isActive: true,
      linkedMood: linkedMood,
      assignedDays: assignedDays,
    );

    _habits[id] = habit;
    return habit;
  }

  @override
  Future<HabitModel> trackHabit({
    required String habitId,
    required bool isCompleting,
    required DateTime date,
  }) async {
    final habit = _habits[habitId];
    if (habit == null) throw Exception('Habit not found');

    final dateOnly = DateTime(date.year, date.month, date.day);
    final isAlreadyCompleted = habit.completedDates.any(
      (d) => DateTime(d.year, d.month, d.day).isAtSameMomentAs(dateOnly),
    );

    List<DateTime> updatedDates = List.from(habit.completedDates);

    if (isCompleting && !isAlreadyCompleted) {
      updatedDates.add(dateOnly);
    } else if (!isCompleting && isAlreadyCompleted) {
      updatedDates.removeWhere(
        (d) => DateTime(d.year, d.month, d.day).isAtSameMomentAs(dateOnly),
      );
    }

    final updated = habit.copyWith(completedDates: updatedDates);
    _habits[habitId] = updated;
    return updated;
  }

  @override
  Future<HabitModel> updateHabit(HabitModel habit) async {
    if (!_habits.containsKey(habit.id)) {
      throw Exception('Habit not found');
    }
    _habits[habit.id] = habit;
    return habit;
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    _habits.remove(habitId);
  }
}
