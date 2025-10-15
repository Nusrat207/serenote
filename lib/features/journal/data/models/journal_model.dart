class JournalModel extends JournalEntity {
  const JournalModel({
    required String? id,
    required super.title,
    required super.content,
    required super.timestamp,
    super.audioPath,
    super.linkedMood,
    super.tags,
    super.imageData, // NEW
    required String userId,
  }) : _userId = userId, super(id: id);

  final String _userId;

  String get userId => _userId;

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
    userId: userId, // Make sure this is set
  );
}

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'entry_date': _formatDate(timestamp),
      'audio_path': audioPath,
      'linked_mood': linkedMood,
      'tags': tags,
      'image_data': imageData, // NEW
      'user_id': userId,
    };
  }

  // Use this for creating NEW journals (without ID)
  factory JournalModel.fromEntityForCreate(JournalEntity entity, {required String userId}) {
    return JournalModel(
      id: null,
      title: entity.title,
      content: entity.content,
      timestamp: entity.timestamp,
      audioPath: entity.audioPath,
      linkedMood: entity.linkedMood,
      tags: entity.tags,
      imageData: entity.imageData, // NEW
      userId: userId,
    );
  }

  // Use this for updating EXISTING journals (with ID)
  factory JournalModel.fromEntityForUpdate(JournalEntity entity, {required String userId}) {
    if (entity.id == null) {
      throw Exception('Cannot update journal without ID');
    }
    return JournalModel(
      id: entity.id as String,
      title: entity.title,
      content: entity.content,
      timestamp: entity.timestamp,
      audioPath: entity.audioPath,
      linkedMood: entity.linkedMood,
      tags: entity.tags,
      imageData: entity.imageData, // NEW
      userId: userId,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  JournalModel copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? timestamp,
    String? audioPath,
    String? linkedMood,
    List<String>? tags,
    String? imageData, // NEW
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
      imageData: imageData ?? this.imageData, // NEW
      userId: userId ?? this.userId,
    );
  }
}