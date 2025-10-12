// lib/features/journal/presentation/providers/journal_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/journal_local_datasource.dart';
import '../../data/repositories/journal_repository_impl.dart';
import '../../domain/entities/journal_entity.dart';
import '../../domain/repositories/journal_repository.dart';
import '../../domain/usecases/create_journal_usecase.dart';
import '../../domain/usecases/delete_journal_usecase.dart';
import '../../domain/usecases/get_journals_usecase.dart';
import '../../domain/usecases/update_journal_usecase.dart';

// Data source provider
final journalLocalDataSourceProvider = Provider<JournalLocalDataSource>((ref) {
  return JournalLocalDataSourceImpl();
});

// Repository provider
final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepositoryImpl(
    localDataSource: ref.watch(journalLocalDataSourceProvider),
  );
});

// Use case providers
final getJournalsUseCaseProvider = Provider<GetJournalsUseCase>((ref) {
  return GetJournalsUseCase(ref.watch(journalRepositoryProvider));
});

final createJournalUseCaseProvider = Provider<CreateJournalUseCase>((ref) {
  return CreateJournalUseCase(ref.watch(journalRepositoryProvider));
});

final updateJournalUseCaseProvider = Provider<UpdateJournalUseCase>((ref) {
  return UpdateJournalUseCase(ref.watch(journalRepositoryProvider));
});

final deleteJournalUseCaseProvider = Provider<DeleteJournalUseCase>((ref) {
  return DeleteJournalUseCase(ref.watch(journalRepositoryProvider));
});

// State notifier for journal management
class JournalNotifier extends StateNotifier<AsyncValue<List<JournalEntity>>> {
  final GetJournalsUseCase getJournalsUseCase;
  final CreateJournalUseCase createJournalUseCase;
  final UpdateJournalUseCase updateJournalUseCase;
  final DeleteJournalUseCase deleteJournalUseCase;

  JournalNotifier({
    required this.getJournalsUseCase,
    required this.createJournalUseCase,
    required this.updateJournalUseCase,
    required this.deleteJournalUseCase,
  }) : super(const AsyncValue.loading()) {
    loadJournals();
  }

  Future<void> loadJournals() async {
    state = const AsyncValue.loading();
    try {
      final journals = await getJournalsUseCase();
      state = AsyncValue.data(journals);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createJournal(JournalEntity journal) async {
    try {
      await createJournalUseCase(journal);
      await loadJournals();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateJournal(JournalEntity journal) async {
    try {
      await updateJournalUseCase(journal);
      await loadJournals();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteJournal(int id) async {
    try {
      await deleteJournalUseCase(id);
      await loadJournals();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Main journal provider
final journalProvider = StateNotifierProvider<JournalNotifier, AsyncValue<List<JournalEntity>>>((ref) {
  return JournalNotifier(
    getJournalsUseCase: ref.watch(getJournalsUseCaseProvider),
    createJournalUseCase: ref.watch(createJournalUseCaseProvider),
    updateJournalUseCase: ref.watch(updateJournalUseCaseProvider),
    deleteJournalUseCase: ref.watch(deleteJournalUseCaseProvider),
  );
});