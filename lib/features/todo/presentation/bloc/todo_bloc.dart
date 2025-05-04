import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import 'todo_event.dart';
import 'todo_state.dart';

/// BLoC for managing todo list state and operations
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase getTodosUseCase;
  final TodoRepository repository;
  final AppLocalizations l10n;

  TodoBloc({
    required this.getTodosUseCase,
    required this.repository,
    required this.l10n,
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

  /// Factory constructor that creates a TodoBloc with localization from context
  factory TodoBloc.fromContext(
    BuildContext context, {
    required GetTodosUseCase getTodosUseCase,
    required TodoRepository repository,
  }) {
    return TodoBloc(
      getTodosUseCase: getTodosUseCase,
      repository: repository,
      l10n: AppLocalizations.of(context)!,
    );
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
      emit(TodoError(l10n.errorLoadingTodos));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      await repository.addTodo(event.todo);
      final todos = await getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(l10n.errorSavingTodo));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      await repository.updateTodo(event.todo);
      final todos = await getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(l10n.errorSavingTodo));
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
      emit(TodoError(l10n.errorDeletingTodo));
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
      emit(TodoError(l10n.errorSavingTodo));
    }
  }
}
