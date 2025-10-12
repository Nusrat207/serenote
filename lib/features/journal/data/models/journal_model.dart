// lib/features/journal/data/models/journal_model.dart

import '../../domain/entities/journal_entity.dart';

class JournalModel extends JournalEntity {
  const JournalModel({
    super.id,
    required super.title,
    required super.content,
    required super.timestamp,
    super.audioPath,
    super.linkedMood,
    super.tags,
  });

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'] as int?,
      title: json['title'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      audioPath: json['audioPath'] as String?,
      linkedMood: json['linkedMood'] as String?,
      tags: json['tags'] != null 
          ? List<String>.from(json['tags'] as List)
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'audioPath': audioPath,
      'linkedMood': linkedMood,
      'tags': tags,
    };
  }

  factory JournalModel.fromEntity(JournalEntity entity) {
    return JournalModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      timestamp: entity.timestamp,
      audioPath: entity.audioPath,
      linkedMood: entity.linkedMood,
      tags: entity.tags,
    );
  }
}