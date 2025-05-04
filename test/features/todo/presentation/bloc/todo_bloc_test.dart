import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cursor_test_flutter/features/todo/domain/entities/todo.dart';
import 'package:cursor_test_flutter/features/todo/domain/repositories/todo_repository.dart';
import 'package:cursor_test_flutter/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_event.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_state.dart';
import 'package:cursor_test_flutter/l10n/app_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
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
@GenerateMocks([TodoRepository])
void main() {
  late TodoBloc todoBloc;
  late MockTodoRepository mockTodoRepository;
  late GetTodosUseCase getTodosUseCase;
  late AppLocalizations l10n;

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

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    getTodosUseCase = GetTodosUseCase(mockTodoRepository);
    todoBloc = TodoBloc(
      getTodosUseCase: getTodosUseCase,
      repository: mockTodoRepository,
      l10n: l10n,
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
      // arrange
      when(mockTodoRepository.getTodos()).thenAnswer((_) async => []);

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoading>(),
          isA<TodoLoaded>().having((state) => state.todos, 'todos', []),
        ]),
      );

      // act
      todoBloc.add(LoadTodos());
    });

    test('emits [TodoLoading, TodoLoaded] when successful with todos',
        () async {
      // arrange
      when(mockTodoRepository.getTodos())
          .thenAnswer((_) async => [testTodo, completedTodo]);

      // assert later
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

      // act
      todoBloc.add(LoadTodos());
    });

    test('emits [TodoLoading, TodoError] when repository throws exception',
        () async {
      // arrange
      when(mockTodoRepository.getTodos()).thenThrow(Exception());

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoading>(),
          isA<TodoError>().having(
            (state) => state.message,
            'message',
            l10n.errorLoadingTodos,
          ),
        ]),
      );

      // act
      todoBloc.add(LoadTodos());
    });
  });

  group('AddTodo', () {
    test('emits [TodoLoaded] when successful', () async {
      // arrange
      when(mockTodoRepository.addTodo(testTodo)).thenAnswer((_) async => null);
      when(mockTodoRepository.getTodos()).thenAnswer((_) async => [testTodo]);

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
            l10n.errorSavingTodo,
          ),
        ]),
      );

      // act
      todoBloc.add(AddTodo(testTodo));
    });
  });

  group('UpdateTodo', () {
    test('emits [TodoLoaded] when successful', () async {
      // arrange
      when(mockTodoRepository.updateTodo(testTodo))
          .thenAnswer((_) async => null);
      when(mockTodoRepository.getTodos()).thenAnswer((_) async => [testTodo]);

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
            l10n.errorSavingTodo,
          ),
        ]),
      );

      // act
      todoBloc.add(UpdateTodo(testTodo));
    });
  });

  group('DeleteTodo', () {
    test('emits [TodoLoaded] when successful', () async {
      // arrange
      when(mockTodoRepository.deleteTodo(testTodo.id))
          .thenAnswer((_) async => null);
      when(mockTodoRepository.getTodos()).thenAnswer((_) async => []);

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoaded>().having((state) => state.todos, 'todos', []),
        ]),
      );

      // act
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
            l10n.errorDeletingTodo,
          ),
        ]),
      );

      // act
      todoBloc.add(DeleteTodo(testTodo.id));
    });
  });

  group('ToggleTodoStatus', () {
    test('emits [TodoLoaded] when successful with completed todo', () async {
      // arrange
      when(mockTodoRepository.getTodoById(completedTodo.id))
          .thenAnswer((_) async => completedTodo);
      when(mockTodoRepository.toggleTodoStatus(completedTodo.id))
          .thenAnswer((_) async => null);
      when(mockTodoRepository.getTodos())
          .thenAnswer((_) async => [completedTodo]);

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoaded>().having(
            (state) => state.todos,
            'todos',
            [completedTodo],
          ),
        ]),
      );

      // act
      todoBloc.add(ToggleTodoStatus(completedTodo.id));
    });

    test('emits [TodoLoaded] when successful with incomplete todo', () async {
      // arrange
      when(mockTodoRepository.getTodoById(testTodo.id))
          .thenAnswer((_) async => testTodo);
      when(mockTodoRepository.toggleTodoStatus(testTodo.id))
          .thenAnswer((_) async => null);
      when(mockTodoRepository.getTodos()).thenAnswer((_) async => [testTodo]);

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
      todoBloc.add(ToggleTodoStatus(testTodo.id));
    });

    test('emits [TodoError] when repository throws exception', () async {
      // arrange
      when(mockTodoRepository.getTodoById(testTodo.id))
          .thenAnswer((_) async => testTodo);
      when(mockTodoRepository.toggleTodoStatus(testTodo.id))
          .thenThrow(Exception());

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoError>().having(
            (state) => state.message,
            'message',
            l10n.errorSavingTodo,
          ),
        ]),
      );

      // act
      todoBloc.add(ToggleTodoStatus(testTodo.id));
    });
  });
}
