import 'package:cursor_test_flutter/features/todo/domain/entities/todo.dart';
import 'package:cursor_test_flutter/features/todo/domain/repositories/todo_repository.dart';
import 'package:cursor_test_flutter/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_event.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_state.dart';
import 'package:cursor_test_flutter/l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'todo_bloc_test.mocks.dart';

/// Tests for [TodoBloc] functionality.
///
/// This test suite covers all major operations of the TodoBloc:
/// - Loading todos
/// - Adding new todos
/// - Updating existing todos
/// - Deleting todos
/// - Toggling todo status
///
/// Each operation is tested for both success and error scenarios.
@GenerateMocks([TodoRepository, GetTodosUseCase])
class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get errorLoadingTodos => 'Error loading todos';

  @override
  String get errorSavingTodo => 'Error saving todo';

  @override
  String get errorDeletingTodo => 'Error deleting todo';
}

void main() {
  late TodoBloc todoBloc;
  late MockTodoRepository mockTodoRepository;
  late MockGetTodosUseCase mockGetTodosUseCase;
  late MockAppLocalizations mockL10n;

  /// Test todo item used across multiple tests
  final testTodo = Todo(
    id: '1',
    title: 'Test Todo',
    description: 'Test Description',
    isCompleted: false,
    createdAt: DateTime.now(),
  );

  /// Test todo item that is already completed
  final completedTodo = Todo(
    id: '2',
    title: 'Completed Todo',
    description: 'Completed Description',
    isCompleted: true,
    createdAt: DateTime.now(),
    completedAt: DateTime.now(),
  );

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    mockGetTodosUseCase = MockGetTodosUseCase();
    mockL10n = MockAppLocalizations();
    todoBloc = TodoBloc(
      getTodosUseCase: mockGetTodosUseCase,
      repository: mockTodoRepository,
      l10n: mockL10n,
    );
  });

  tearDown(() {
    todoBloc.close();
  });

  group('Initial State', () {
    test('should be TodoInitial', () {
      expect(todoBloc.state, isA<TodoInitial>());
    });
  });

  group('LoadTodos', () {
    test('emits [TodoLoading, TodoLoaded] when successful with empty list',
        () async {
      when(mockGetTodosUseCase.call()).thenAnswer((_) async => []);

      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoading>(),
          isA<TodoLoaded>().having((state) => state.todos, 'todos', []),
        ]),
      );

      todoBloc.add(LoadTodos());
    });

    test('emits [TodoLoading, TodoLoaded] when successful with todos',
        () async {
      when(mockGetTodosUseCase.call())
          .thenAnswer((_) async => [testTodo, completedTodo]);

      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoading>(),
          isA<TodoLoaded>().having(
            (state) => state.todos,
            'todos',
            [testTodo, completedTodo],
          ),
        ]),
      );

      todoBloc.add(LoadTodos());
    });

    test('emits [TodoLoading, TodoError] when repository throws exception',
        () async {
      when(mockGetTodosUseCase.call()).thenThrow(Exception());

      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoading>(),
          isA<TodoError>().having(
            (state) => state.message,
            'message',
            mockL10n.errorLoadingTodos,
          ),
        ]),
      );

      todoBloc.add(LoadTodos());
    });
  });

  group('AddTodo', () {
    test('emits [TodoLoaded] when successful', () async {
      // arrange
      when(mockTodoRepository.addTodo(testTodo)).thenAnswer((_) async {});
      when(mockGetTodosUseCase.call()).thenAnswer((_) async => [testTodo]);

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoaded>().having(
            (state) => state.todos,
            'todos',
            [testTodo],
          ),
        ]),
      );

      // act
      todoBloc.add(AddTodo(testTodo));
    });

    test('emits [TodoError] when repository throws exception', () async {
      // arrange
      when(mockTodoRepository.addTodo(testTodo)).thenThrow(Exception());

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoError>().having(
            (state) => state.message,
            'message',
            mockL10n.errorSavingTodo,
          ),
        ]),
      );

      // act
      todoBloc.add(AddTodo(testTodo));
    });
  });

  group('UpdateTodo', () {
    test('emits [TodoLoaded] when successful', () async {
      when(mockTodoRepository.updateTodo(testTodo)).thenAnswer((_) async {});
      when(mockGetTodosUseCase.call()).thenAnswer((_) async => [testTodo]);

      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoaded>().having(
            (state) => state.todos,
            'todos',
            [testTodo],
          ),
        ]),
      );

      todoBloc.add(UpdateTodo(testTodo));
    });

    test('emits [TodoError] when repository throws exception', () async {
      // arrange
      when(mockTodoRepository.updateTodo(testTodo)).thenThrow(Exception());

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoError>().having(
            (state) => state.message,
            'message',
            mockL10n.errorSavingTodo,
          ),
        ]),
      );

      // act
      todoBloc.add(UpdateTodo(testTodo));
    });
  });

  group('DeleteTodo', () {
    test('emits [TodoLoaded] when successful', () async {
      when(mockTodoRepository.deleteTodo(testTodo.id)).thenAnswer((_) async {});
      when(mockGetTodosUseCase.call()).thenAnswer((_) async => []);

      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoaded>().having((state) => state.todos, 'todos', []),
        ]),
      );

      todoBloc.add(DeleteTodo(testTodo.id));
    });

    test('emits [TodoError] when repository throws exception', () async {
      // arrange
      when(mockTodoRepository.deleteTodo(testTodo.id)).thenThrow(Exception());

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoError>().having(
            (state) => state.message,
            'message',
            mockL10n.errorDeletingTodo,
          ),
        ]),
      );

      // act
      todoBloc.add(DeleteTodo(testTodo.id));
    });
  });

  group('ToggleTodoStatus', () {
    test('emits [TodoLoaded] when successful with completed todo', () async {
      final updatedTodo = testTodo.copyWith(isCompleted: true);
      when(mockTodoRepository.getTodoById(testTodo.id))
          .thenAnswer((_) async => testTodo);
      when(mockTodoRepository.updateTodo(updatedTodo)).thenAnswer((_) async {});
      when(mockGetTodosUseCase.call()).thenAnswer((_) async => [updatedTodo]);

      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoaded>().having(
            (state) => state.todos,
            'todos',
            [updatedTodo],
          ),
        ]),
      );

      todoBloc.add(ToggleTodoStatus(testTodo.id));
    });

    test('emits [TodoLoaded] when successful with incomplete todo', () async {
      final updatedTodo = completedTodo.copyWith(isCompleted: false);
      when(mockTodoRepository.getTodoById(completedTodo.id))
          .thenAnswer((_) async => completedTodo);
      when(mockTodoRepository.updateTodo(updatedTodo)).thenAnswer((_) async {});
      when(mockGetTodosUseCase.call()).thenAnswer((_) async => [updatedTodo]);

      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoaded>().having(
            (state) => state.todos,
            'todos',
            [updatedTodo],
          ),
        ]),
      );

      todoBloc.add(ToggleTodoStatus(completedTodo.id));
    });

    test('emits [TodoError] when repository throws exception', () async {
      // arrange
      when(mockTodoRepository.getTodoById(testTodo.id))
          .thenAnswer((_) async => testTodo);
      when(mockTodoRepository.updateTodo(testTodo)).thenThrow(Exception());

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoError>().having(
            (state) => state.message,
            'message',
            mockL10n.errorSavingTodo,
          ),
        ]),
      );

      // act
      todoBloc.add(ToggleTodoStatus(testTodo.id));
    });
  });
}
