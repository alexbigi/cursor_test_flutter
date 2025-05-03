import '../../domain/entities/counter_entity.dart';
import '../../domain/repositories/counter_repository.dart';
import '../datasources/counter_local_data_source.dart';

class CounterRepositoryImpl implements CounterRepository {
  final CounterLocalDataSource localDataSource;
  CounterRepositoryImpl(this.localDataSource);

  @override
  Future<CounterEntity> getCounter() async {
    return CounterEntity(localDataSource.getCounter());
  }

  @override
  Future<void> setCounter(CounterEntity counter) async {
    localDataSource.setCounter(counter.value);
  }
} 