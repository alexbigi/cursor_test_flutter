import 'package:cursor_test_flutter/features/todo/domain/entities/todo.dart';
import 'package:cursor_test_flutter/features/todo/domain/repositories/todo_repository.dart';
import 'package:cursor_test_flutter/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_event.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_state.dart';
import 'package:cursor_test_flutter/l10n/app_localizations.dart';
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
  late TodoBloc bloc;
  late MockTodoRepository mockRepository;
  late MockGetTodosUseCase mockGetTodosUseCase;
  late MockAppLocalizations mockL10n;

  setUp(() {
    mockRepository = MockTodoRepository();
    mockGetTodosUseCase = MockGetTodosUseCase();
    mockL10n = MockAppLocalizations();

    bloc = TodoBloc(
      repository: mockRepository,
      getTodosUseCase: mockGetTodosUseCase,
      l10n: mockL10n,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('TodoBloc', () {
    test('initial state is TodoInitial', () {
      expect(bloc.state, isA<TodoInitial>());
    });

    group('LoadTodos', () {
      final tTodos = [
        Todo(
          id: '1',
          title: 'Test Todo 1',
          description: 'Test Description 1',
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
        Todo(
          id: '2',
          title: 'Test Todo 2',
          description: 'Test Description 2',
          isCompleted: true,
          createdAt: DateTime.now(),
        ),
      ];

      test('emits [TodoLoading, TodoLoaded] when todos are loaded successfully',
          () async {
        // arrange
        when(mockGetTodosUseCase()).thenAnswer((_) async => tTodos);

        // act
        bloc.add(LoadTodos());

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TodoLoading>(),
            isA<TodoLoaded>(),
          ]),
        );

        verify(mockGetTodosUseCase()).called(1);
      });

      test('emits [TodoLoading, TodoError] when loading fails', () async {
        // arrange
        when(mockGetTodosUseCase()).thenThrow(Exception());

        // act
        bloc.add(LoadTodos());

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TodoLoading>(),
            isA<TodoError>(),
          ]),
        );

        verify(mockGetTodosUseCase()).called(1);
      });
    });

    group('AddTodo', () {
      final tTodo = Todo(
        id: '1',
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      test('emits [TodoLoaded] when todo is added successfully', () async {
        // arrange
        when(mockRepository.addTodo(any)).thenAnswer((_) async => {});
        when(mockGetTodosUseCase()).thenAnswer((_) async => [tTodo]);

        // act
        bloc.add(AddTodo(tTodo));

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TodoLoaded>(),
          ]),
        );

        verify(mockRepository.addTodo(tTodo)).called(1);
        verify(mockGetTodosUseCase()).called(1);
      });

      test('emits [TodoError] when adding todo fails', () async {
        // arrange
        when(mockRepository.addTodo(any)).thenThrow(Exception());

        // act
        bloc.add(AddTodo(tTodo));

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TodoError>(),
          ]),
        );

        verify(mockRepository.addTodo(tTodo)).called(1);
        verifyNever(mockGetTodosUseCase());
      });
    });

    group('UpdateTodo', () {
      final tTodo = Todo(
        id: '1',
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      test('emits [TodoLoaded] when todo is updated successfully', () async {
        // arrange
        when(mockRepository.updateTodo(any)).thenAnswer((_) async => {});
        when(mockGetTodosUseCase()).thenAnswer((_) async => [tTodo]);

        // act
        bloc.add(UpdateTodo(tTodo));

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TodoLoaded>(),
          ]),
        );

        verify(mockRepository.updateTodo(tTodo)).called(1);
        verify(mockGetTodosUseCase()).called(1);
      });

      test('emits [TodoError] when updating todo fails', () async {
        // arrange
        when(mockRepository.updateTodo(any)).thenThrow(Exception());

        // act
        bloc.add(UpdateTodo(tTodo));

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TodoError>(),
          ]),
        );

        verify(mockRepository.updateTodo(tTodo)).called(1);
        verifyNever(mockGetTodosUseCase());
      });
    });

    group('DeleteTodo', () {
      const tId = '1';

      test('emits [TodoLoaded] when todo is deleted successfully', () async {
        // arrange
        when(mockRepository.deleteTodo(any)).thenAnswer((_) async => {});
        when(mockGetTodosUseCase()).thenAnswer((_) async => []);

        // act
        bloc.add(const DeleteTodo(tId));

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TodoLoaded>(),
          ]),
        );

        verify(mockRepository.deleteTodo(tId)).called(1);
        verify(mockGetTodosUseCase()).called(1);
      });

      test('emits [TodoError] when deleting todo fails', () async {
        // arrange
        when(mockRepository.deleteTodo(any)).thenThrow(Exception());

        // act
        bloc.add(const DeleteTodo(tId));

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TodoError>(),
          ]),
        );

        verify(mockRepository.deleteTodo(tId)).called(1);
        verifyNever(mockGetTodosUseCase());
      });
    });

    group('ToggleTodoStatus', () {
      const tId = '1';
      final tTodo = Todo(
        id: tId,
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      test('emits [TodoLoaded] when todo status is toggled successfully',
          () async {
        // arrange
        when(mockRepository.getTodoById(any)).thenAnswer((_) async => tTodo);
        when(mockRepository.updateTodo(any)).thenAnswer((_) async => {});
        when(mockGetTodosUseCase()).thenAnswer((_) async => [tTodo]);

        // act
        bloc.add(const ToggleTodoStatus(tId));

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TodoLoaded>(),
          ]),
        );

        verify(mockRepository.getTodoById(tId)).called(1);
        verify(mockRepository.updateTodo(any)).called(1);
        verify(mockGetTodosUseCase()).called(1);
      });

      test('emits [TodoError] when toggling todo status fails', () async {
        // arrange
        when(mockRepository.getTodoById(any)).thenThrow(Exception());

        // act
        bloc.add(const ToggleTodoStatus(tId));

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TodoError>(),
          ]),
        );

        verify(mockRepository.getTodoById(tId)).called(1);
        verifyNever(mockRepository.updateTodo(any));
        verifyNever(mockGetTodosUseCase());
      });
    });
  });
}
