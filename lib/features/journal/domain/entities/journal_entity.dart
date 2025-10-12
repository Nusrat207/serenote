// lib/features/journal/domain/entities/journal_entity.dart

class JournalEntity {
  final int? id;
  final String title;
  final String content;
  final DateTime timestamp;
  final String? audioPath;
  final String? linkedMood;
  final List<String> tags;

  const JournalEntity({
    this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    this.audioPath,
    this.linkedMood,
    this.tags = const [],
  });

  JournalEntity copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? timestamp,
    String? audioPath,
    String? linkedMood,
    List<String>? tags,
  }) {
    return JournalEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      audioPath: audioPath ?? this.audioPath,
      linkedMood: linkedMood ?? this.linkedMood,
      tags: tags ?? this.tags,
    );
  }
}