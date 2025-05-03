import 'package:get_it/get_it.dart';
import '../../features/counter/data/datasources/counter_local_data_source.dart';
import '../../features/counter/data/repositories/counter_repository_impl.dart';
import '../../features/counter/domain/repositories/counter_repository.dart';
import '../../features/counter/domain/usecases/increment_counter.dart';
import '../../features/counter/presentation/provider/counter_provider.dart';

final sl = GetIt.instance;

void init() {
  // Data sources
  sl.registerLazySingleton(() => CounterLocalDataSource());

  // Repository
  sl.registerLazySingleton<CounterRepository>(
    () => CounterRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => IncrementCounter(sl()));

  // Providers
  sl.registerFactory(() => CounterProvider(sl()));
} 