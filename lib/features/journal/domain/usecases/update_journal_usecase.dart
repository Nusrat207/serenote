import '../entities/journal_entity.dart';
import '../repositories/journal_repository.dart';

class UpdateJournalUseCase {
  final JournalRepository repository;

  UpdateJournalUseCase(this.repository);

  Future<void> call(JournalEntity journal) async {
    await repository.updateJournal(journal);
  }
}