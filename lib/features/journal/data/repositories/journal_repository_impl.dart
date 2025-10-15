// lib/features/journal/data/datasources/journal_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/journal_model.dart';

abstract class JournalRemoteDataSource {
  // Add userId parameter to all methods that need user filtering
  Future<List<JournalModel>> getJournals(String userId);
  Future<JournalModel?> getJournalById(String id, String userId);
  Future<List<JournalModel>> getJournalsByDateRange(DateTime start, DateTime end, String userId);
  Future<String> createJournal(JournalModel journal);
  Future<void> updateJournal(JournalModel journal);
  Future<void> deleteJournal(String id, String userId);
  Future<List<JournalModel>> searchJournals(String query, String userId);
  Future<List<JournalModel>> getJournalsByDate(DateTime date, String userId);
}

class JournalRemoteDataSourceImpl implements JournalRemoteDataSource {
  final SupabaseClient supabaseClient;

  JournalRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<JournalModel>> getJournals(String userId) async {
    print('📚 Fetching journals for user: $userId');
    
    final response = await supabaseClient
        .from('journals')
        .select()
        .eq('user_id', userId) // Filter by user_id
        .order('created_at', ascending: false);

    print('📚 Found ${response.length} journals for user $userId');
    return (response as List).map((json) => JournalModel.fromJson(json)).toList();
  }

  @override
  Future<JournalModel?> getJournalById(String id, String userId) async {
    final response = await supabaseClient
        .from('journals')
        .select()
        .eq('id', id)
        .eq('user_id', userId) // Ensure user owns this journal
        .single();

    return response != null ? JournalModel.fromJson(response) : null;
  }

  @override
  Future<List<JournalModel>> getJournalsByDateRange(DateTime start, DateTime end, String userId) async {
    final startDate = _formatDate(start);
    final endDate = _formatDate(end);

    final response = await supabaseClient
        .from('journals')
        .select()
        .eq('user_id', userId) // Filter by user_id
        .gte('entry_date', startDate)
        .lte('entry_date', endDate)
        .order('entry_date', ascending: false);

    return (response as List).map((json) => JournalModel.fromJson(json)).toList();
  }

  @override
  Future<List<JournalModel>> getJournalsByDate(DateTime date, String userId) async {
    final formattedDate = _formatDate(date);

    final response = await supabaseClient
        .from('journals')
        .select()
        .eq('user_id', userId) // Filter by user_id
        .eq('entry_date', formattedDate)
        .order('created_at', ascending: false);

    return (response as List).map((json) => JournalModel.fromJson(json)).toList();
  }

  @override
  Future<String> createJournal(JournalModel journal) async {
    print('📝 Creating journal for user: ${journal.userId}');
    
    final journalData = journal.toJson();
    
    final response = await supabaseClient
        .from('journals')
        .insert(journalData)
        .select()
        .single();

    final newJournalId = response['id'] as String;
    print('✅ Journal created with ID: $newJournalId for user: ${journal.userId}');
    
    return newJournalId;
  }

  @override
  Future<void> updateJournal(JournalModel journal) async {
    if (journal.id == null) {
      throw Exception('Cannot update journal without ID');
    }
    
    print('📝 Updating journal ${journal.id} for user: ${journal.userId}');
    
    final journalData = journal.toJson();
    journalData['id'] = journal.id;
    
    await supabaseClient
        .from('journals')
        .update(journalData)
        .eq('id', journal.id!)
        .eq('user_id', journal.userId); // Ensure user owns this journal
    
    print('✅ Journal updated: ${journal.id}');
  }

  @override
  Future<void> deleteJournal(String id, String userId) async {
    print('🗑️ Deleting journal $id for user: $userId');
    
    await supabaseClient
        .from('journals')
        .delete()
        .eq('id', id)
        .eq('user_id', userId); // Ensure user owns this journal
    
    print('✅ Journal deleted: $id');
  }

  @override
  Future<List<JournalModel>> searchJournals(String query, String userId) async {
    final response = await supabaseClient
        .from('journals')
        .select()
        .eq('user_id', userId) // Filter by user_id
        .textSearch('title', query)
        .order('created_at', ascending: false);

    return (response as List).map((json) => JournalModel.fromJson(json)).toList();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}