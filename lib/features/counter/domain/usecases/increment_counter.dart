import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

class IncrementCounter {
  final CounterRepository repository;
  IncrementCounter(this.repository);

  Future<CounterEntity> call() async {
    final current = await repository.getCounter();
    final updated = CounterEntity(current.value + 1);
    await repository.setCounter(updated);
    return updated;
  }
} 