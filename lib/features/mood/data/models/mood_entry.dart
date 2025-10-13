class MoodEntry {
  final int? id;
  final String text;
  final String detectedMood;
  final double confidence;
  final DateTime timestamp;
  final bool isVoiceInput;

  MoodEntry({
    this.id,
    required this.text,
    required this.detectedMood,
    required this.confidence,
    required this.timestamp,
    this.isVoiceInput = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'detected_mood': detectedMood,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
      'is_voice_input': isVoiceInput,
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'] as int?,
      text: map['text'] as String? ?? '',
      detectedMood: map['detected_mood'] as String? ?? 'neutral',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.0,
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      isVoiceInput: map['is_voice_input'] as bool? ?? false,
    );
  }

  static String mapSentimentToMood(String sentiment) {
    final s = sentiment.toLowerCase();
    if (s.contains('joy') || s.contains('happiness')) return 'joy';
    if (s.contains('positive')) return 'happy';
    if (s.contains('negative') || s.contains('sadness')) return 'sad';
    if (s.contains('anger')) return 'angry';
    if (s.contains('fear') || s.contains('anxiety')) return 'anxious';
    if (s.contains('surprise')) return 'neutral';
    return 'neutral';
  }
}

extension MoodEntryCopy on MoodEntry {
  MoodEntry copyWith({
    int? id,
    String? text,
    String? detectedMood,
    double? confidence,
    DateTime? timestamp,
    bool? isVoiceInput,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      text: text ?? this.text,
      detectedMood: detectedMood ?? this.detectedMood,
      confidence: confidence ?? this.confidence,
      timestamp: timestamp ?? this.timestamp,
      isVoiceInput: isVoiceInput ?? this.isVoiceInput,
    );
  }
} 
