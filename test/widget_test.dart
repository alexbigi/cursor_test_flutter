// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:cursor_test_flutter/features/todo/presentation/providers/locale_provider.dart';
import 'package:cursor_test_flutter/features/counter/presentation/provider/counter_provider.dart';
import 'package:cursor_test_flutter/features/todo/presentation/pages/todo_list_page.dart';
import 'package:cursor_test_flutter/features/counter/domain/usecases/increment_counter.dart';
import 'package:cursor_test_flutter/features/counter/domain/repositories/counter_repository.dart';
import 'package:cursor_test_flutter/features/counter/domain/entities/counter_entity.dart';
import 'package:cursor_test_flutter/features/todo/domain/repositories/todo_repository.dart';
import 'package:cursor_test_flutter/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:cursor_test_flutter/features/todo/domain/entities/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

class MockCounterRepository extends Mock implements CounterRepository {
  @override
  Future<CounterEntity> getCounter() async => const CounterEntity(0);
}

class MockIncrementCounter extends Mock implements IncrementCounter {
  @override
  final CounterRepository repository;

  MockIncrementCounter(this.repository);

  @override
  Future<CounterEntity> call() async => const CounterEntity(0);
}

class MockTodoRepository extends Mock implements TodoRepository {
  @override
  Future<List<Todo>> getTodos() async => [];
}

class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get appTitle => 'Todo List';

  @override
  String get noTodos => 'No todos';

  @override
  String get errorLoadingTodos => 'Error loading todos';

  @override
  String get errorSavingTodo => 'Error saving todo';

  @override
  String get errorDeletingTodo => 'Error deleting todo';

  @override
  String get addTodo => 'Add Todo';

  @override
  String get title => 'Title';

  @override
  String get titleHint => 'Enter todo title';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint => 'Enter todo description';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get completed => 'Completed';

  @override
  String get incomplete => 'Incomplete';

  @override
  String get todoDeleted => 'Todo deleted';

  @override
  String get undo => 'Undo';

  @override
  String get retry => 'Retry';
}

class MockLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  final AppLocalizations localizations;

  MockLocalizationsDelegate(this.localizations);

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async => localizations;

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

void main() {
  late MockAppLocalizations mockLocalizations;
  late LocaleProvider localeProvider;
  late CounterProvider counterProvider;
  late MockCounterRepository mockCounterRepository;
  late MockIncrementCounter mockIncrementCounter;
  late MockTodoRepository mockTodoRepository;
  late GetTodosUseCase getTodosUseCase;
  late SharedPreferences prefs;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({'locale': 'en'});
    prefs = await SharedPreferences.getInstance();

    mockLocalizations = MockAppLocalizations();
    localeProvider = LocaleProvider(prefs);
    mockCounterRepository = MockCounterRepository();
    mockIncrementCounter = MockIncrementCounter(mockCounterRepository);
    counterProvider = CounterProvider(mockIncrementCounter);
    mockTodoRepository = MockTodoRepository();
    getTodosUseCase = GetTodosUseCase(mockTodoRepository);

    // Reset GetIt before each test
    if (GetIt.I.isRegistered<GetTodosUseCase>()) {
      await GetIt.I.reset();
    }

    // Initialize GetIt
    final sl = GetIt.I;
    sl.registerLazySingleton<GetTodosUseCase>(() => getTodosUseCase);
    sl.registerLazySingleton<TodoRepository>(() => mockTodoRepository);
    sl.registerLazySingleton<LocaleProvider>(() => localeProvider);
    sl.registerLazySingleton<CounterProvider>(() => counterProvider);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  group('LocaleProvider Tests', () {
    test('should load default locale when no locale is stored', () async {
      await prefs.remove('locale');
      final provider = LocaleProvider(prefs);
      expect(provider.locale.languageCode, equals('en'));
    });

    test('should load stored locale', () async {
      await prefs.setString('locale', 'es');
      final provider = LocaleProvider(prefs);
      expect(provider.locale.languageCode, equals('es'));
    });

    test('should update locale', () async {
      final newLocale = const Locale('fr');
      await localeProvider.setLocale(newLocale);
      expect(localeProvider.locale, equals(newLocale));
      expect(prefs.getString('locale'), equals('fr'));
    });

    test('should clear locale to default', () {
      localeProvider.clearLocale();
      expect(localeProvider.locale.languageCode, equals('en'));
    });
  });

  group('Widget Tests', () {
    testWidgets('App smoke test', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: localeProvider,
              ),
              ChangeNotifierProvider.value(
                value: counterProvider,
              ),
            ],
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  if (l10n == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return TodoListPage(l10n: l10n);
                },
              ),
              locale: const Locale('en'),
              localizationsDelegates: [
                MockLocalizationsDelegate(mockLocalizations),
                AppLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('es'),
                Locale('fr'),
              ],
            ),
          ),
        );

        // Wait for all animations and async operations to complete
        await tester.pumpAndSettle();
      });

      // Verify that the app title is present in the AppBar
      expect(find.text('Todo List'), findsOneWidget);
    });
  });
}
