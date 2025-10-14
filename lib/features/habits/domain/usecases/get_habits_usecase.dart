import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository repository;

  GetHabitsUseCase(this.repository);

  Future<Either<Failure, List<HabitEntity>>> call({
    bool activeOnly = true,
    String? forMood,
  }) {
    return repository.getHabits(activeOnly: activeOnly, forMood: forMood);
  }
}
