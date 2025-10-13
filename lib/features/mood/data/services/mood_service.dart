// lib/features/mood/data/services/mood_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/mood_entry.dart';

class MoodService {
  final supabase = Supabase.instance.client;

  // Add mood
  Future<int?> addMood(MoodEntry mood, String userId) async {
    final response = await supabase.from('moods').insert({
      'text': mood.text,
      'detected_mood': mood.detectedMood,
      'confidence': mood.confidence,
      'timestamp': mood.timestamp.toIso8601String(),
      'is_voice_input': mood.isVoiceInput,
      'user_id': userId,
    }).select('id').single();
    return response['id'] as int?;
  }

  // Get all moods of user
  Future<List<MoodEntry>> getMoods(String userId) async {
    final data = await supabase
        .from('moods')
        .select()
        .eq('user_id', userId)
        .order('timestamp', ascending: false) as List<dynamic>;
    return data.map((e) => MoodEntry.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  // Get today's mood
  Future<MoodEntry?> getTodaysMood(String userId) async {
    final now = DateTime.now(); 
    final data = await supabase
        .from('moods')
        .select()
        .eq('user_id', userId)
        .gte('timestamp', DateTime(now.year, now.month, now.day).toIso8601String())
        .lt('timestamp', DateTime(now.year, now.month, now.day + 1).toIso8601String())
        .order('timestamp', ascending: false)
        .limit(1)
        .maybeSingle();
    if (data == null) return null;
    return MoodEntry.fromMap(Map<String, dynamic>.from(data));
  }

  // Delete mood
  Future<void> deleteMood(int id) async {
    await supabase.from('moods').delete().eq('id', id);
  }
}
