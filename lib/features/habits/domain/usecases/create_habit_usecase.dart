import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

class CreateHabitUseCase {
  final HabitRepository repository;

  CreateHabitUseCase(this.repository);

  Future<Either<Failure, HabitEntity>> call({
    required String name,
    String? description,
    required String icon,
    required String color,
    required int targetDaysPerWeek,
    String? linkedMood,
    List<int>? assignedDays,
  }) {
    return repository.createHabit(
      name: name,
      description: description,
      icon: icon,
      color: color,
      targetDaysPerWeek: targetDaysPerWeek,
      linkedMood: linkedMood,
      assignedDays: assignedDays,
    );
  }
}
