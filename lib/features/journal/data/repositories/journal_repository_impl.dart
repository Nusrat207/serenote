// lib/features/journal/data/repositories/journal_repository_impl.dart

import '../../domain/entities/journal_entity.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasources/journal_local_datasource.dart';
import '../models/journal_model.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalLocalDataSource localDataSource;

  JournalRepositoryImpl({required this.localDataSource});

  @override
  Future<List<JournalEntity>> getJournals() async {
    return await localDataSource.getJournals();
  }

  @override
  Future<JournalEntity?> getJournalById(int id) async {
    return await localDataSource.getJournalById(id);
  }

  @override
  Future<List<JournalEntity>> getJournalsByDateRange(DateTime start, DateTime end) async {
    return await localDataSource.getJournalsByDateRange(start, end);
  }

  @override
  Future<int> createJournal(JournalEntity journal) async {
    final model = JournalModel.fromEntity(journal);
    return await localDataSource.insertJournal(model);
  }

  @override
  Future<void> updateJournal(JournalEntity journal) async {
    final model = JournalModel.fromEntity(journal);
    await localDataSource.updateJournal(model);
  }

  @override
  Future<void> deleteJournal(int id) async {
    await localDataSource.deleteJournal(id);
  }

  @override
  Future<List<JournalEntity>> searchJournals(String query) async {
    return await localDataSource.searchJournals(query);
  }
}