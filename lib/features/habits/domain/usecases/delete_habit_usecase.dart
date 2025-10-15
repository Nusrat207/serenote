import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/habit_repository.dart';

class DeleteHabitUseCase {
  final HabitRepository repository;

  DeleteHabitUseCase(this.repository);

  Future<Either<Failure, void>> call(String habitId) {
    return repository.deleteHabit(habitId);
  }
}
