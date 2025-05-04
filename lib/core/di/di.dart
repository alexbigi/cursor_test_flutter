import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cursor_test_flutter/core/utils/logger.dart';
import 'package:cursor_test_flutter/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:cursor_test_flutter/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:cursor_test_flutter/features/todo/domain/repositories/todo_repository.dart';
import 'package:cursor_test_flutter/features/todo/domain/entities/todo.dart';
import 'package:cursor_test_flutter/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:cursor_test_flutter/features/todo/presentation/providers/locale_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Initialize Hive
  await _initHive();
  final todoBox = await Hive.openBox<Todo>('todos');

  // Providers
  sl.registerLazySingleton(() => LocaleProvider(sl<SharedPreferences>()));

  // Data sources
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(todoBox),
  );

  // Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTodosUseCase(sl()));
}

TodoBloc createTodoBloc(BuildContext context) {
  return TodoBloc(
    getTodosUseCase: sl(),
    repository: sl(),
    l10n: AppLocalizations.of(context)!,
  );
}

Future<void> _initHive() async {
  try {
    await Hive.initFlutter();
    Logger.info('Hive initialized successfully');
  } catch (e, stackTrace) {
    Logger.error('Failed to initialize Hive', e, stackTrace);
    rethrow;
  }
}
