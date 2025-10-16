// lib/features/habits/data/models/habit_model.dart

import '../../domain/entities/habit_entity.dart';

class HabitModel {
  // ← CHANGE THIS FROM "Habit" to "HabitModel"
  final String? id;
  final String userId;
  final String name; // ← ALSO CHANGE "title" to "name" to match your schema
  final String? description;
  final String? icon;
  final String? color;
  final List<int> assignedDays;
  final List<DateTime> completedDates;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final String? linkedMood;
  final int? targetDaysPerWeek;

  HabitModel({
    this.id,
    required this.userId,
    required this.name,
    this.description,
    this.icon,
    this.color,
    required this.assignedDays,
    required this.completedDates,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.linkedMood,
    this.targetDaysPerWeek,
  });

  HabitModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? icon,
    String? color,
    List<int>? assignedDays,
    List<DateTime>? completedDates,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? linkedMood,
    int? targetDaysPerWeek,
  }) {
    return HabitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      assignedDays: assignedDays ?? this.assignedDays,
      completedDates: completedDates ?? this.completedDates,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      linkedMood: linkedMood ?? this.linkedMood,
      targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final json = <String, dynamic>{
      'user_id': userId,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'assigned_days': assignedDays,
      'completed_dates': completedDates
          .map((d) => d.toIso8601String())
          .toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_active': isActive,
      'linked_mood': linkedMood,
      'target_days_per_week': targetDaysPerWeek,
    };

    if (includeId && id != null && id!.isNotEmpty) {
      json['id'] = id;
    }

    return json;
  }

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      name: json['name'] as String? ?? json['title'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      assignedDays:
          (json['assigned_days'] as List<dynamic>?)?.cast<int>().toList() ?? [],
      completedDates:
          (json['completed_dates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      linkedMood: json['linked_mood'] as String?,
      targetDaysPerWeek: json['target_days_per_week'] as int?,
    );
  }

  HabitEntity toEntity() {
    return HabitEntity(
      id: id ?? '',
      userId: userId,
      name: name,
      description: description,
      icon: icon ?? '💧',
      color: color ?? 'ff00bfff',
      targetDaysPerWeek: targetDaysPerWeek ?? 3,
      completedDates: completedDates,
      createdAt: createdAt,
      isActive: isActive,
      linkedMood: linkedMood,
      assignedDays: assignedDays,
    );
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
      assignedDays: entity.assignedDays ?? [],
    );
  }

  bool isScheduledForDay(int weekday) {
    return assignedDays.contains(weekday);
  }
}
