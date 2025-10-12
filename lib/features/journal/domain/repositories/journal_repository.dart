// lib/features/journal/domain/repositories/journal_repository.dart

import '../entities/journal_entity.dart';

abstract class JournalRepository {
  Future<List<JournalEntity>> getJournals();
  Future<JournalEntity?> getJournalById(int id);
  Future<List<JournalEntity>> getJournalsByDateRange(DateTime start, DateTime end);
  Future<int> createJournal(JournalEntity journal);
  Future<void> updateJournal(JournalEntity journal);
  Future<void> deleteJournal(int id);
  Future<List<JournalEntity>> searchJournals(String query);
}