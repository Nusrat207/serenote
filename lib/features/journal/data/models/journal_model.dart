import '../../domain/entities/journal_entity.dart';

class JournalModel extends JournalEntity {
  const JournalModel({
    required String? id,
    required super.title,
    required super.content,
    required super.timestamp,
    super.audioPath,
    super.linkedMood,
    super.tags,
    super.imageData,
    required String userId,
  })  : _userId = userId,
        super(id: id);

  final String _userId;
  String get userId => _userId;

  /// Convert JournalEntity to JournalModel for creating a new journal
  factory JournalModel.fromEntityForCreate(JournalEntity entity, {required String userId}) {
    return JournalModel(
      id: null,
      title: entity.title,
      content: entity.content,
      timestamp: entity.timestamp,
      audioPath: entity.audioPath,
      linkedMood: entity.linkedMood,
      tags: entity.tags,
      imageData: entity.imageData,
      userId: userId,
    );
  }

  /// Convert JournalEntity to JournalModel for updating an existing journal
  factory JournalModel.fromEntityForUpdate(JournalEntity entity, {required String userId}) {
    if (entity.id == null) {
      throw Exception('Cannot update journal without ID');
    }
    return JournalModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      timestamp: entity.timestamp,
      audioPath: entity.audioPath,
      linkedMood: entity.linkedMood,
      tags: entity.tags,
      imageData: entity.imageData,
      userId: userId,
    );
  }

  /// Convert JSON from Supabase to JournalModel
  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['entry_date'] as String),
      audioPath: json['audio_path'] as String?,
      linkedMood: json['linked_mood'] as String?,
      tags: (json['tags'] as List<dynamic>?)!.map((e) => e.toString()).toList(),
      imageData: json['image_data'] as String?,
      userId: json['user_id'] as String,
    );
  }

  /// Convert JournalModel to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'entry_date': _formatDate(timestamp),
      'audio_path': audioPath,
      'linked_mood': linkedMood,
      'tags': tags,
      'image_data': imageData,
      'user_id': userId,
    };
  }

  /// CopyWith for immutability
  @override
  JournalModel copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? timestamp,
    String? audioPath,
    String? linkedMood,
    List<String>? tags,
    String? imageData,
    String? userId,
  }) {
    return JournalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      audioPath: audioPath ?? this.audioPath,
      linkedMood: linkedMood ?? this.linkedMood,
      tags: tags ?? this.tags,
      imageData: imageData ?? this.imageData,
      userId: userId ?? this.userId,
    );
  }

  /// Helper to format date for Supabase
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
