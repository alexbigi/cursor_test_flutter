import '../entities/counter_entity.dart';

abstract class CounterRepository {
  Future<CounterEntity> getCounter();
  Future<void> setCounter(CounterEntity counter);
} 