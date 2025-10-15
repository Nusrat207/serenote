import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

class TrackHabitUseCase {
  final HabitRepository repository;

  TrackHabitUseCase(this.repository);

  Future<Either<Failure, HabitEntity>> call({
    required String habitId,
    required bool isCompleting,
    required DateTime date,
  }) {
    return repository.trackHabit(
      habitId: habitId,
      isCompleting: isCompleting,
      date: date,
    );
  }
}
