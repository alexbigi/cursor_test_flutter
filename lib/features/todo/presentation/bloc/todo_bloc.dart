import 'package:cursor_test_flutter/features/todo/domain/repositories/todo_repository.dart';
import 'package:cursor_test_flutter/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'todo_event.dart';
import 'todo_state.dart';

/// BLoC for managing todo list state and operations
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase getTodosUseCase;
  final TodoRepository repository;

  TodoBloc({
    required this.getTodosUseCase,
    required this.repository,
  }) : super(TodoInitial()) {
    if (kDebugMode) {
      print('TodoBloc initialized');
    }
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodoStatus>(_onToggleTodoStatus);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    if (kDebugMode) {
      print('Loading todos...');
    }
    emit(TodoLoading());
    try {
      final todos = await getTodosUseCase();
      if (kDebugMode) {
        print('Todos loaded: ${todos.length} items');
      }
      emit(TodoLoaded(todos));
    } catch (e) {
      if (kDebugMode) {
        print('Error loading todos: $e');
      }
      emit(const TodoError('Error loading todos'));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      await repository.addTodo(event.todo);
      final todos = await getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(const TodoError('Error saving todo'));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      await repository.updateTodo(event.todo);
      final todos = await getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(const TodoError('Error saving todo'));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (kDebugMode) {
      print('Deleting todo with id: ${event.id}');
    }
    try {
      await repository.deleteTodo(event.id);
      if (kDebugMode) {
        print('Todo deleted successfully');
      }
      final todos = await getTodosUseCase();
      if (kDebugMode) {
        print('Reloaded todos after deletion: ${todos.length} items');
      }
      emit(TodoLoaded(todos));
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting todo: $e');
      }
      emit(const TodoError('Error deleting todo'));
    }
  }

  Future<void> _onToggleTodoStatus(
      ToggleTodoStatus event, Emitter<TodoState> emit) async {
    try {
      final todo = await repository.getTodoById(event.id);
      if (todo != null) {
        final updatedTodo = todo.copyWith(
          isCompleted: !todo.isCompleted,
          completedAt: !todo.isCompleted ? DateTime.now() : null,
        );
        await repository.updateTodo(updatedTodo);
        final todos = await getTodosUseCase();
        emit(TodoLoaded(todos));
      }
    } catch (e) {
      emit(const TodoError('Error saving todo'));
    }
  }
}
