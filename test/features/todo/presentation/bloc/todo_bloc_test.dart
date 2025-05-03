import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/features/todo/domain/entities/todo.dart';
import 'package:my_flutter_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:my_flutter_app/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:my_flutter_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:my_flutter_app/features/todo/presentation/bloc/todo_event.dart';
import 'package:my_flutter_app/features/todo/presentation/bloc/todo_state.dart';
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
    getTodosUseCase = GetTodosUseCase(mockTodoRepository);
    todoBloc = TodoBloc(
      getTodosUseCase: getTodosUseCase,
      repository: mockTodoRepository,
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

    test('emits [TodoLoading, TodoError] when error occurs', () async {
      // arrange
      when(mockTodoRepository.getTodos())
          .thenThrow(Exception('Error loading todos'));

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoading>(),
          isA<TodoError>().having(
            (state) => state.message,
            'error message',
            'Exception: Error loading todos',
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
      when(mockTodoRepository.addTodo(any)).thenAnswer((_) async {});
      when(mockTodoRepository.getTodos()).thenAnswer((_) async => [testTodo]);

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoaded>().having((state) => state.todos, 'todos', [testTodo]),
        ]),
      );

      // act
      todoBloc.add(AddTodo(testTodo));
    });

    test('emits [TodoError] when error occurs', () async {
      // arrange
      when(mockTodoRepository.addTodo(any))
          .thenThrow(Exception('Error adding todo'));

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoError>().having(
            (state) => state.message,
            'error message',
            'Exception: Error adding todo',
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
      when(mockTodoRepository.updateTodo(any)).thenAnswer((_) async {});
      when(mockTodoRepository.getTodos()).thenAnswer((_) async => [testTodo]);

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoaded>().having((state) => state.todos, 'todos', [testTodo]),
        ]),
      );

      // act
      todoBloc.add(UpdateTodo(testTodo));
    });

    test('emits [TodoError] when error occurs', () async {
      // arrange
      when(mockTodoRepository.updateTodo(any))
          .thenThrow(Exception('Error updating todo'));

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoError>().having(
            (state) => state.message,
            'error message',
            'Exception: Error updating todo',
          ),
        ]),
      );

      // act
      todoBloc.add(UpdateTodo(testTodo));
    });
  });

  group('DeleteTodo', () {
    test('emits [TodoLoaded] when successful with empty list', () async {
      // arrange
      when(mockTodoRepository.deleteTodo(any)).thenAnswer((_) async {});
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

    test('emits [TodoLoaded] when successful with remaining todos', () async {
      // arrange
      when(mockTodoRepository.deleteTodo(any)).thenAnswer((_) async {});
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
      todoBloc.add(DeleteTodo(testTodo.id));
    });

    test('emits [TodoError] when error occurs', () async {
      // arrange
      when(mockTodoRepository.deleteTodo(any))
          .thenThrow(Exception('Error deleting todo'));

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoError>().having(
            (state) => state.message,
            'error message',
            'Exception: Error deleting todo',
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
      when(mockTodoRepository.toggleTodoStatus(any)).thenAnswer((_) async {});
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
      when(mockTodoRepository.toggleTodoStatus(any)).thenAnswer((_) async {});
      when(mockTodoRepository.getTodos()).thenAnswer((_) async => [testTodo]);

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoaded>().having((state) => state.todos, 'todos', [testTodo]),
        ]),
      );

      // act
      todoBloc.add(ToggleTodoStatus(testTodo.id));
    });

    test('emits [TodoError] when error occurs', () async {
      // arrange
      when(mockTodoRepository.toggleTodoStatus(any))
          .thenThrow(Exception('Error toggling todo status'));

      // assert later
      expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoError>().having(
            (state) => state.message,
            'error message',
            'Exception: Error toggling todo status',
          ),
        ]),
      );

      // act
      todoBloc.add(ToggleTodoStatus(testTodo.id));
    });
  });
}
