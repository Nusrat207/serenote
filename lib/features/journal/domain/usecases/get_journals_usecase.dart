import '../entities/journal_entity.dart';
import '../repositories/journal_repository.dart';

class GetJournalsUseCase {
  final JournalRepository repository;

  GetJournalsUseCase(this.repository);

  Future<List<JournalEntity>> call() async {
    return await repository.getJournals();
  }
}