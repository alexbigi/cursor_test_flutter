import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/features/todo/domain/entities/todo.dart';
import 'package:my_flutter_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:my_flutter_app/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:my_flutter_app/features/todo/presentation/bloc/todo_event.dart';
import 'package:my_flutter_app/features/todo/presentation/bloc/todo_state.dart';
import 'package:my_flutter_app/l10n/app_localizations.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase getTodosUseCase;
  final TodoRepository repository;
  final BuildContext context;

  TodoBloc({
    required this.getTodosUseCase,
    required this.repository,
    required this.context,
  }) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodoStatus>(_onToggleTodoStatus);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoading());
      final todos = await getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(context.l10n.errorLoadingTodos));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      await repository.addTodo(event.todo);
      final todos = await getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(context.l10n.errorSavingTodo));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      await repository.updateTodo(event.todo);
      final todos = await getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(context.l10n.errorSavingTodo));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      await repository.deleteTodo(event.id);
      final todos = await getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(context.l10n.errorDeletingTodo));
    }
  }

  Future<void> _onToggleTodoStatus(
      ToggleTodoStatus event, Emitter<TodoState> emit) async {
    try {
      final todo = await repository.getTodoById(event.id);
      if (todo != null) {
        await repository.toggleTodoStatus(event.id);
        final todos = await getTodosUseCase();
        emit(TodoLoaded(todos));
      }
    } catch (e) {
      emit(TodoError(context.l10n.errorSavingTodo));
    }
  }
}
