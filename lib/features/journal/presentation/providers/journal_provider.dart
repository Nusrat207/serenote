import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/journal_entity.dart';

final journalListProvider = StateNotifierProvider<JournalListNotifier, AsyncValue<List<JournalEntity>>>((ref) {
  return JournalListNotifier();
});

class JournalListNotifier extends StateNotifier<AsyncValue<List<JournalEntity>>> {
  JournalListNotifier() : super(const AsyncValue.loading()) {
    loadJournals();
  }

  final SupabaseClient _supabase = Supabase.instance.client;

  String? get _currentUserId {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print('❌ No user logged in');
        return null;
      }
      print('✅ Current user ID: ${user.id}');
      return user.id;
    } catch (e) {
      print('❌ Error getting current user: $e');
      return null;
    }
  }

  Future<void> loadJournals() async {
    state = const AsyncValue.loading();
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User not logged in. Please sign in again.');
      }

      print('🔍 Loading journals for user: $userId');

      // Test query to see what happens without filter
      try {
        final testAll = await _supabase
            .from('journals')
            .select('id, title, user_id')
            .limit(5);
        print('🔍 Sample of all journals: $testAll');
      } catch (e) {
        print('🔍 Error fetching sample journals: $e');
      }

      // Fetch user's journals
      final response = await _supabase
          .from('journals')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      print('✅ Found ${response.length} journals for user $userId');

      if (response.isEmpty) {
        print('ℹ️ No journals found for user $userId');
      }

      final journals = (response as List).map((json) {
        return JournalEntity(
          id: json['id'] as String?,
          title: json['title'] as String,
          content: json['content'] as String,
          timestamp: DateTime.parse(json['entry_date'] as String),
          audioPath: json['audio_path'] as String?,
          linkedMood: json['linked_mood'] as String?,
          tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : [],
          imageData: json['image_data'] as String?,
        );
      }).toList();

      state = AsyncValue.data(journals);
    } catch (error, stackTrace) {
      print('❌ Error loading journals: $error');
      print('❌ Stack trace: $stackTrace');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createJournal(JournalEntity journal) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      print('📝 Creating journal for user: $userId');

      final journalData = {
        'title': journal.title,
        'content': journal.content,
        'entry_date': _formatDate(journal.timestamp),
        'audio_path': journal.audioPath,
        'linked_mood': journal.linkedMood,
        'tags': journal.tags,
        'image_data': journal.imageData,
        'user_id': userId,
      };

      print('📝 Journal data to insert: $journalData');

      final result = await _supabase
          .from('journals')
          .insert(journalData)
          .select()
          .single();

      print('✅ Journal created successfully: $result');

      await loadJournals();
    } catch (error, stackTrace) {
      print('❌ Error creating journal: $error');
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateJournal(JournalEntity journal) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      if (journal.id == null) {
        throw Exception('Cannot update journal without ID');
      }

      print('📝 Updating journal ${journal.id} for user: $userId');

      final journalData = {
        'title': journal.title,
        'content': journal.content,
        'entry_date': _formatDate(journal.timestamp),
        'audio_path': journal.audioPath,
        'linked_mood': journal.linkedMood,
        'tags': journal.tags,
        'image_data': journal.imageData,
      };

      final result = await _supabase
          .from('journals')
          .update(journalData)
          .eq('id', journal.id!)
          .eq('user_id', userId);

      print('✅ Journal updated successfully: $result');

      await loadJournals();
    } catch (error, stackTrace) {
      print('❌ Error updating journal: $error');
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteJournal(String id) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      print('🗑️ Deleting journal $id for user: $userId');

      final result = await _supabase
          .from('journals')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);

      print('✅ Journal deleted successfully: $result');

      await loadJournals();
    } catch (error, stackTrace) {
      print('❌ Error deleting journal: $error');
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}