// lib/features/journal/data/datasources/journal_local_datasource.dart

import '../models/journal_model.dart';

abstract class JournalLocalDataSource {
  Future<List<JournalModel>> getJournals();
  Future<JournalModel?> getJournalById(int id);
  Future<List<JournalModel>> getJournalsByDateRange(DateTime start, DateTime end);
  Future<int> insertJournal(JournalModel journal);
  Future<void> updateJournal(JournalModel journal);
  Future<void> deleteJournal(int id);
  Future<List<JournalModel>> searchJournals(String query);
}

class JournalLocalDataSourceImpl implements JournalLocalDataSource {
  // In a real app, you'd use sqflite or hive here
  // For now, using in-memory storage
  final List<JournalModel> _journals = [];
  int _nextId = 1;

  @override
  Future<List<JournalModel>> getJournals() async {
    return List.from(_journals)..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<JournalModel?> getJournalById(int id) async {
    try {
      return _journals.firstWhere((j) => j.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<JournalModel>> getJournalsByDateRange(DateTime start, DateTime end) async {
    return _journals.where((j) {
      return j.timestamp.isAfter(start) && j.timestamp.isBefore(end);
    }).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<int> insertJournal(JournalModel journal) async {
    final newJournal = JournalModel(
      id: _nextId++,
      title: journal.title,
      content: journal.content,
      timestamp: journal.timestamp,
      audioPath: journal.audioPath,
      linkedMood: journal.linkedMood,
      tags: journal.tags,
    );
    _journals.add(newJournal);
    return newJournal.id!;
  }

  @override
  Future<void> updateJournal(JournalModel journal) async {
    final index = _journals.indexWhere((j) => j.id == journal.id);
    if (index != -1) {
      _journals[index] = journal;
    }
  }

  @override
  Future<void> deleteJournal(int id) async {
    _journals.removeWhere((j) => j.id == id);
  }

  @override
  Future<List<JournalModel>> searchJournals(String query) async {
    final lowerQuery = query.toLowerCase();
    return _journals.where((j) {
      return j.title.toLowerCase().contains(lowerQuery) ||
             j.content.toLowerCase().contains(lowerQuery) ||
             j.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
}