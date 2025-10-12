import '../repositories/journal_repository.dart';

class DeleteJournalUseCase {
  final JournalRepository repository;

  DeleteJournalUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.deleteJournal(id);
  }
}