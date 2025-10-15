// lib/features/journal/domain/repositories/journal_repository.dart

import '../entities/journal_entity.dart';

abstract class JournalRepository {
  Future<List<JournalEntity>> getJournals();
  Future<JournalEntity?> getJournalById(String id); // Changed to String
  Future<List<JournalEntity>> getJournalsByDateRange(DateTime start, DateTime end);
  Future<String> createJournal(JournalEntity journal); // Changed to String
  Future<void> updateJournal(JournalEntity journal);
  Future<void> deleteJournal(String id); // Changed to String
  Future<List<JournalEntity>> searchJournals(String query);
}