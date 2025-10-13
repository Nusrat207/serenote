import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serenote/features/mood/data/models/mood_entry.dart';
import 'package:serenote/features/mood/data/services/sentiment_service.dart';
import 'package:serenote/features/mood/data/services/mood_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sentimentServiceProvider = Provider((ref) => SentimentService());
final moodServiceProvider = Provider((ref) => MoodService());

final moodEntriesProvider =
    StateNotifierProvider<MoodEntriesNotifier, List<MoodEntry>>(
  (ref) => MoodEntriesNotifier(
    ref.read(sentimentServiceProvider),
    ref.read(moodServiceProvider),
  ),
);

class MoodEntriesNotifier extends StateNotifier<List<MoodEntry>> {
  final SentimentService _sentimentService;
  final MoodService _moodService;

  MoodEntriesNotifier(this._sentimentService, this._moodService)
      : super([]) {
    _loadEntries();
  }

  /// Use dummy UUID pre-login
  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ??
      '11111111-1111-1111-1111-111111111111';

  bool get isDummyUser =>
      Supabase.instance.client.auth.currentUser == null;

  /// Load moods for user or dummy fallback
  Future<void> _loadEntries() async {
    try {
      if (isDummyUser) {
        // Dummy fallback data
        state = [
          MoodEntry(
              id: 0,
              text: 'Feeling good!',
              detectedMood: 'joy',
              confidence: 0.9,
              timestamp: DateTime.now().subtract(const Duration(days: 1))),
          MoodEntry(
              id: 1,
              text: 'A bit tired today',
              detectedMood: 'neutral',
              confidence: 0.7,
              timestamp: DateTime.now()),
        ];
      } else {
        final moods = await _moodService.getMoods(_userId);
        state = moods;
      }
    } catch (e) {
      print('Error loading moods: $e');
      state = [];
    }
  }

  /// Refresh UI
  Future<void> refreshEntries() async => await _loadEntries();

  /// Analyze text and add a new mood
  Future<Map<String, dynamic>> analyzeMood(String text,
      {bool isVoiceInput = false}) async {
    try {
      final result = await _sentimentService.analyzeEmotions(text);
      if (!result['success']) {
        return {
          'success': false,
          'error': result['error'] ?? 'Failed to analyze mood'
        };
      }

      final mood = MoodEntry.mapSentimentToMood(result['label']);
      final entry = MoodEntry(
        text: text,
        detectedMood: mood,
        confidence: result['confidence'],
        timestamp: DateTime.now(),
        isVoiceInput: isVoiceInput,
      );

      int? id;
      if (!isDummyUser) {
        id = await _moodService.addMood(entry, _userId);
      }

      state = [entry.copyWith(id: id)] + state;

      return {'success': true, 'entry': entry};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Get today's mood
  Future<MoodEntry?> getTodaysMood() async {
    if (isDummyUser) {
      return state.isNotEmpty ? state.last : null;
    }
    return await _moodService.getTodaysMood(_userId);
  }

  /// Get recent entries
  List<MoodEntry> getRecentEntries({int days = 7}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return state.where((entry) => entry.timestamp.isAfter(cutoff)).toList();
  }
}
