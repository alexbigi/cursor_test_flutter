import 'package:cursor_test_flutter/core/providers/locale_provider.dart';
import 'package:cursor_test_flutter/core/providers/theme_provider.dart';
import 'package:cursor_test_flutter/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:cursor_test_flutter/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:cursor_test_flutter/features/todo/domain/entities/todo.dart';
import 'package:cursor_test_flutter/features/todo/domain/repositories/todo_repository.dart';
import 'package:cursor_test_flutter/features/todo/domain/usecases/add_todo_usecase.dart';
import 'package:cursor_test_flutter/features/todo/domain/usecases/delete_todo_usecase.dart';
import 'package:cursor_test_flutter/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:cursor_test_flutter/features/todo/domain/usecases/update_todo_usecase.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  if (kDebugMode) {
    print('Starting dependency initialization...');
  }

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  if (kDebugMode) {
    print('SharedPreferences initialized');
  }

  // Hive
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TodoAdapter());
  }
  final todoBox = await Hive.openBox<Todo>('todos');
  if (kDebugMode) {
    print('Hive initialized');
  }

  // Providers
  sl.registerLazySingleton<ThemeProvider>(
    () => ThemeProvider(sharedPreferences),
  );
  sl.registerLazySingleton<LocaleProvider>(
    () => LocaleProvider(sharedPreferences),
  );
  if (kDebugMode) {
    print('Providers registered');
  }

  // Data sources
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(todoBox),
  );
  if (kDebugMode) {
    print('Data sources registered');
  }

  // Repositories
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      localDataSource: sl<TodoLocalDataSource>(),
    ),
  );
  if (kDebugMode) {
    print('Repositories registered');
  }

  // Use cases
  sl.registerLazySingleton<GetTodosUseCase>(
    () => GetTodosUseCase(sl<TodoRepository>()),
  );
  sl.registerLazySingleton<AddTodoUseCase>(
    () => AddTodoUseCase(sl<TodoRepository>()),
  );
  sl.registerLazySingleton<UpdateTodoUseCase>(
    () => UpdateTodoUseCase(sl<TodoRepository>()),
  );
  sl.registerLazySingleton<DeleteTodoUseCase>(
    () => DeleteTodoUseCase(sl<TodoRepository>()),
  );
  if (kDebugMode) {
    print('Use cases registered');
  }

  // Blocs
  sl.registerFactory<TodoBloc>(
    () => TodoBloc(
      getTodosUseCase: sl<GetTodosUseCase>(),
      repository: sl<TodoRepository>(),
    ),
  );
  if (kDebugMode) {
    print('Blocs registered');
    print('All dependencies initialized successfully');
  }
}
