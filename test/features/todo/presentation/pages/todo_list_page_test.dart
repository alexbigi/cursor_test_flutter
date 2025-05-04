import 'package:cursor_test_flutter/core/providers/locale_provider.dart';
import 'package:cursor_test_flutter/core/providers/theme_provider.dart';
import 'package:cursor_test_flutter/features/todo/domain/repositories/todo_repository.dart';
import 'package:cursor_test_flutter/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:cursor_test_flutter/features/todo/presentation/pages/todo_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo_list_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SharedPreferences>(),
  MockSpec<TodoRepository>(),
  MockSpec<GetTodosUseCase>(),
])
class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get appTitle => 'Todo App';
  @override
  String todos(int count) => 'No todos';
  @override
  String get addTodo => 'Add Todo';
  @override
  String get add => 'Add';
  @override
  String get editTodo => 'Edit Todo';
  @override
  String get deleteTodo => 'Delete Todo';
  @override
  String get markAsCompleted => 'Mark as completed';
  @override
  String get markAsIncomplete => 'Mark as incomplete';
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
  String get error => 'Error';
  @override
  String get errorLoadingTodos => 'Error loading todos';
  @override
  String get errorSavingTodo => 'Error saving todo';
  @override
  String get errorDeletingTodo => 'Error deleting todo';
  @override
  String get noTodos => 'No todos yet';
  @override
  String get todoDeleted => 'Todo deleted';
  @override
  String get undo => 'Undo';
  @override
  String get retry => 'Retry';
  @override
  String get settings => 'Settings';
  @override
  String get language => 'Language';
  @override
  String get theme => 'Theme';
  @override
  String get systemTheme => 'System';
  @override
  String get lightTheme => 'Light';
  @override
  String get darkTheme => 'Dark';
  @override
  String get completed => 'Completed';
  @override
  String get incomplete => 'Incomplete';
  @override
  String get system => 'System';
  @override
  String get light => 'Light';
  @override
  String get dark => 'Dark';
}

void main() {
  late MockTodoRepository mockTodoRepository;
  late MockGetTodosUseCase mockGetTodosUseCase;
  late MockAppLocalizations mockAppLocalizations;
  late MockSharedPreferences mockSharedPreferences;
  late LocaleProvider localeProvider;
  late ThemeProvider themeProvider;

  setUp(() async {
    mockTodoRepository = MockTodoRepository();
    mockGetTodosUseCase = MockGetTodosUseCase();
    mockAppLocalizations = MockAppLocalizations();
    mockSharedPreferences = MockSharedPreferences();

    // Setup SharedPreferences mocks
    when(mockSharedPreferences.getString('locale')).thenReturn('en');
    when(mockSharedPreferences.setString('locale', 'en'))
        .thenAnswer((_) => Future.value(true));
    when(mockSharedPreferences.getString('theme_mode'))
        .thenReturn('ThemeMode.system');
    when(mockSharedPreferences.setString('theme_mode', 'ThemeMode.system'))
        .thenAnswer((_) => Future.value(true));

    // Initialize providers
    localeProvider = LocaleProvider(mockSharedPreferences);
    themeProvider = ThemeProvider(mockSharedPreferences);

    // Setup GetTodosUseCase mock
    when(mockGetTodosUseCase.call()).thenAnswer((_) async => []);

    // Setup GetIt
    GetIt.I.registerSingleton<GetTodosUseCase>(mockGetTodosUseCase);
    GetIt.I.registerSingleton<TodoRepository>(mockTodoRepository);
    GetIt.I.registerSingleton<AppLocalizations>(mockAppLocalizations);
    GetIt.I.registerSingleton<LocaleProvider>(localeProvider);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  testWidgets('TodoListPage smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<LocaleProvider>.value(
              value: localeProvider,
            ),
            ChangeNotifierProvider<ThemeProvider>.value(
              value: themeProvider,
            ),
          ],
          child: TodoListPage(l10n: mockAppLocalizations),
        ),
      ),
    );

    // Wait for initial load
    await tester.pumpAndSettle();

    // Verify initial state
    expect(find.text('Todo App'), findsOneWidget);
    expect(find.text('No todos yet'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
