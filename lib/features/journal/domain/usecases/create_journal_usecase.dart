import '../entities/journal_entity.dart';
import '../repositories/journal_repository.dart';

class CreateJournalUseCase {
  final JournalRepository repository;

  CreateJournalUseCase(this.repository);

  Future<int> call(JournalEntity journal) async {
    return await repository.createJournal(journal);
  }
}
