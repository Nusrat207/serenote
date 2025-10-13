import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serenote/features/mood/data/models/mood_entry.dart';
import 'package:serenote/features/mood/data/services/sentiment_service.dart';
import 'package:serenote/core/database/database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/mood_service.dart';
final sentimentServiceProvider = Provider((ref) => SentimentService());
final moodServiceProvider = Provider((ref) => MoodService());

final moodEntriesProvider = StateNotifierProvider<MoodEntriesNotifier, List<MoodEntry>>(
  (ref) => MoodEntriesNotifier(
    ref.read(sentimentServiceProvider),
    ref.read(moodServiceProvider),
  ),
);

class MoodEntriesNotifier extends StateNotifier<List<MoodEntry>> {
  final SentimentService _sentimentService;
  final MoodService _moodService;
  //final String _userId = Supabase.instance.client.auth.currentUser!.id;
  final String _userId = Supabase.instance.client.auth.currentUser?.id ?? '11111111-1111-1111-1111-111111111111';



  MoodEntriesNotifier(this._sentimentService, this._moodService) : super([]) {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      final moods = await _moodService.getMoods(_userId);
      state = moods;
    } catch (e) {
      print('Error loading moods: $e');
    }
  }

  /// NEW: refresh method for UI buttons or after analyze
  Future<void> refreshEntries() async {
    await _loadEntries();
  }

  Future<Map<String, dynamic>> analyzeMood(String text, {bool isVoiceInput = false}) async {
    try {
      final result = await _sentimentService.analyzeEmotions(text);

      if (!result['success']) {
        return {'success': false, 'error': result['error'] ?? 'Failed to analyze mood'};
      }

      final mood = MoodEntry.mapSentimentToMood(result['label']);
      final entry = MoodEntry(
        text: text,
        detectedMood: mood,
        confidence: result['confidence'],
        timestamp: DateTime.now(),
        isVoiceInput: isVoiceInput,
      );

      final id = await _moodService.addMood(entry, _userId);
      if (id != null) {
        state = [entry.copyWith(id: id)] + state;
      }

      return {'success': true, 'entry': entry};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<MoodEntry?> getTodaysMood() async {
    return await _moodService.getTodaysMood(_userId);
  }

  List<MoodEntry> getRecentEntries({int days = 7}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return state.where((entry) => entry.timestamp.isAfter(cutoff)).toList();
  }
}
