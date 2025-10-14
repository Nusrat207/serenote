// lib/features/habits/domain/entities/habit_entity.dart

import 'package:equatable/equatable.dart';

class HabitEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final String icon;
  final String color;
  final int targetDaysPerWeek;
  final List<DateTime> completedDates;
  final DateTime createdAt;
  final bool isActive;
  final String? linkedMood;
  final List<int>? assignedDays; // 1=Monday, 2=Tuesday, ..., 7=Sunday

  const HabitEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.icon,
    required this.color,
    required this.targetDaysPerWeek,
    required this.completedDates,
    required this.createdAt,
    this.isActive = true,
    this.linkedMood,
    this.assignedDays,
  });

  int get currentStreak {
    if (completedDates.isEmpty) return 0;

    final sorted = List<DateTime>.from(completedDates)
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (var date in sorted) {
      final dateOnly = DateTime(date.year, date.month, date.day);
      final checkDateOnly = DateTime(
        checkDate.year,
        checkDate.month,
        checkDate.day,
      );

      if (dateOnly.isAtSameMomentAs(checkDateOnly)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (dateOnly.isBefore(
        checkDateOnly.subtract(const Duration(days: 1)),
      )) {
        break;
      }
    }

    return streak;
  }

  int get longestStreak {
    if (completedDates.isEmpty) return 0;

    final sorted = List<DateTime>.from(completedDates)..sort();

    int maxStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < sorted.length; i++) {
      final diff = sorted[i].difference(sorted[i - 1]).inDays;
      if (diff == 1) {
        currentStreak++;
        maxStreak = maxStreak > currentStreak ? maxStreak : currentStreak;
      } else if (diff > 1) {
        currentStreak = 1;
      }
    }

    return maxStreak;
  }

  int get totalCompletions => completedDates.length;

  bool isCompletedToday() {
    final today = DateTime.now();
    return completedDates.any(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );
  }

  double get weeklyCompletionRate {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final weekCompletions = completedDates
        .where((date) => date.isAfter(weekAgo) && date.isBefore(now))
        .length;
    return weekCompletions / 7;
  }

  HabitEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? icon,
    String? color,
    int? targetDaysPerWeek,
    List<DateTime>? completedDates,
    DateTime? createdAt,
    bool? isActive,
    String? linkedMood,
    List<int>? assignedDays,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
      completedDates: completedDates ?? this.completedDates,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      linkedMood: linkedMood ?? this.linkedMood,
      assignedDays: assignedDays ?? this.assignedDays,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    description,
    icon,
    color,
    targetDaysPerWeek,
    completedDates,
    createdAt,
    isActive,
    linkedMood,
    assignedDays,
  ];
}
