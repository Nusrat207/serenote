import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

class UpdateHabitUseCase {
  final HabitRepository repository;

  UpdateHabitUseCase(this.repository);

  Future<Either<Failure, HabitEntity>> call(HabitEntity habit) {
    return repository.updateHabit(habit);
  }
}
