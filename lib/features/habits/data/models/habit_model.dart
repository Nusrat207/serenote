// lib/features/habits/data/models/habit_model.dart

import '../../domain/entities/habit_entity.dart';

class HabitModel {
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
  final List<int>? assignedDays;

  const HabitModel({
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

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String,
      color: json['color'] as String,
      targetDaysPerWeek: json['target_days_per_week'] as int,
      completedDates:
          (json['completed_dates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
      linkedMood: json['linked_mood'] as String?,
      assignedDays: (json['assigned_days'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final json = <String, dynamic>{
      'user_id': userId,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'target_days_per_week': targetDaysPerWeek,
      'completed_dates': completedDates
          .map((date) => date.toIso8601String())
          .toList(),
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
      'linked_mood': linkedMood,
      'assigned_days': assignedDays,
    };

    // Only include id if it's not empty and includeId is true
    if (includeId && id.isNotEmpty) {
      json['id'] = id;
    }

    return json;
  }

  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      description: entity.description,
      icon: entity.icon,
      color: entity.color,
      targetDaysPerWeek: entity.targetDaysPerWeek,
      completedDates: entity.completedDates,
      createdAt: entity.createdAt,
      isActive: entity.isActive,
      linkedMood: entity.linkedMood,
      assignedDays: entity.assignedDays,
    );
  }

  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      userId: userId,
      name: name,
      description: description,
      icon: icon,
      color: color,
      targetDaysPerWeek: targetDaysPerWeek,
      completedDates: completedDates,
      createdAt: createdAt,
      isActive: isActive,
      linkedMood: linkedMood,
      assignedDays: assignedDays,
    );
  }

  HabitModel copyWith({
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
    return HabitModel(
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
}
