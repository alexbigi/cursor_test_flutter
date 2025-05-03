import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_flutter_app/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:my_flutter_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:my_flutter_app/features/todo/domain/entities/todo.dart';
import 'package:my_flutter_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:my_flutter_app/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:my_flutter_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:my_flutter_app/features/todo/presentation/pages/todo_list_page.dart';
import 'package:my_flutter_app/features/todo/presentation/providers/locale_provider.dart';
import 'package:my_flutter_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize GetIt
  final getIt = GetIt.instance;

  // Register dependencies
  getIt.registerSingleton<TodoLocalDataSource>(
    TodoLocalDataSourceImpl(Hive.box<Todo>('todos')),
  );
  getIt.registerSingleton<TodoRepository>(
    TodoRepositoryImpl(getIt<TodoLocalDataSource>()),
  );
  getIt.registerSingleton<GetTodosUseCase>(
    GetTodosUseCase(getIt<TodoRepository>()),
  );
  getIt.registerSingleton<TodoBloc>(
    TodoBloc(
      getTodosUseCase: getIt<GetTodosUseCase>(),
      repository: getIt<TodoRepository>(),
    ),
  );

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider(prefs),
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return BlocProvider(
            create: (_) => GetIt.instance<TodoBloc>(),
            child: MaterialApp(
              title: 'Todo App',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              locale: localeProvider.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'), // English
                Locale('ru'), // Russian
                Locale('be'), // Belarusian
              ],
              home: const TodoListPage(),
            ),
          );
        },
      ),
    );
  }
}
