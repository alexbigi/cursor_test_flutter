import 'package:cursor_test_flutter/core/utils/logger.dart';
import 'package:cursor_test_flutter/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:cursor_test_flutter/features/todo/domain/entities/todo.dart';
import 'package:cursor_test_flutter/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Todo>> getTodos() async {
    try {
      Logger.debug('Repository: Getting todos from local data source');
      final todos = await localDataSource.getTodos();
      Logger.debug('Repository: Retrieved ${todos.length} todos');
      return todos;
    } catch (e, stackTrace) {
      Logger.error('Repository: Failed to get todos', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Todo?> getTodoById(String id) async {
    try {
      Logger.debug('Repository: Getting todo by id: $id');
      final todo = await localDataSource.getTodoById(id);
      Logger.debug('Repository: Found todo: ${todo?.title ?? "null"}');
      return todo;
    } catch (e, stackTrace) {
      Logger.error('Repository: Failed to get todo by id', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> addTodo(Todo todo) async {
    try {
      Logger.debug('Repository: Adding todo: ${todo.title}');
      await localDataSource.addTodo(todo);
      Logger.debug('Repository: Todo added successfully');
    } catch (e, stackTrace) {
      Logger.error('Repository: Failed to add todo', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      Logger.debug('Repository: Updating todo: ${todo.title}');
      await localDataSource.updateTodo(todo);
      Logger.debug('Repository: Todo updated successfully');
    } catch (e, stackTrace) {
      Logger.error('Repository: Failed to update todo', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      Logger.debug('Repository: Deleting todo with id: $id');
      await localDataSource.deleteTodo(id);
      Logger.debug('Repository: Todo deleted successfully');
    } catch (e, stackTrace) {
      Logger.error('Repository: Failed to delete todo', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> toggleTodoStatus(String id) async {
    try {
      Logger.debug('Repository: Toggling todo status for id: $id');
      await localDataSource.toggleTodoStatus(id);
      Logger.debug('Repository: Todo status toggled successfully');
    } catch (e, stackTrace) {
      Logger.error('Repository: Failed to toggle todo status', e, stackTrace);
      rethrow;
    }
  }
}
