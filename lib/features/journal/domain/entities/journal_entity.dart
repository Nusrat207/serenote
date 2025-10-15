class JournalEntity {
  final String? id;
  final String title;
  final String content;
  final DateTime timestamp;
  final String? audioPath;
  final String? linkedMood;
  final List<String> tags;
  final String? imageData; // NEW: Store image as Base64 string

  const JournalEntity({
    this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    this.audioPath,
    this.linkedMood,
    this.tags = const [],
    this.imageData, // NEW
  });

  JournalEntity copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? timestamp,
    String? audioPath,
    String? linkedMood,
    List<String>? tags,
    String? imageData, // NEW
  }) {
    return JournalEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      audioPath: audioPath ?? this.audioPath,
      linkedMood: linkedMood ?? this.linkedMood,
      tags: tags ?? this.tags,
      imageData: imageData ?? this.imageData, // NEW
    );
  }
}