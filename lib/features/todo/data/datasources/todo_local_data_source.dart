import 'package:cursor_test_flutter/core/utils/logger.dart';
import 'package:cursor_test_flutter/features/todo/domain/entities/todo.dart';
import 'package:hive/hive.dart';

abstract class TodoLocalDataSource {
  Future<List<Todo>> getTodos();
  Future<Todo?> getTodoById(String id);
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
  Future<void> toggleTodoStatus(String id);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final Box<Todo> todoBox;

  TodoLocalDataSourceImpl(this.todoBox);

  @override
  Future<List<Todo>> getTodos() async {
    try {
      Logger.debug('Getting todos from local storage');
      final todos = todoBox.values.toList();
      Logger.debug('Retrieved ${todos.length} todos');
      return todos;
    } catch (e, stackTrace) {
      Logger.error('Failed to get todos', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Todo?> getTodoById(String id) async {
    try {
      Logger.debug('Getting todo by id: $id');
      final todo = todoBox.get(id);
      Logger.debug('Found todo: ${todo != null ? todo.title : "null"}');
      return todo;
    } catch (e, stackTrace) {
      Logger.error('Failed to get todo by id', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> addTodo(Todo todo) async {
    try {
      Logger.debug('Adding todo to Hive box: ${todo.title}');
      await todoBox.put(todo.id, todo);
      Logger.debug('Todo added successfully');
    } catch (e, stackTrace) {
      Logger.error('Failed to add todo', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      Logger.debug('Updating todo in Hive box: ${todo.title}');
      await todoBox.put(todo.id, todo);
      Logger.debug('Todo updated successfully');
    } catch (e, stackTrace) {
      Logger.error('Failed to update todo', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      Logger.debug('Deleting todo with id: $id');
      await todoBox.delete(id);
      Logger.debug('Todo deleted successfully');
    } catch (e, stackTrace) {
      Logger.error('Failed to delete todo', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> toggleTodoStatus(String id) async {
    try {
      Logger.debug('Toggling todo status: $id');
      final todo = await getTodoById(id);
      if (todo != null) {
        Logger.debug('Found todo to toggle: ${todo.title}');
        await updateTodo(todo.copyWith(isCompleted: !todo.isCompleted));
        Logger.debug('Todo status toggled successfully');
      } else {
        Logger.debug('Todo not found for toggling');
      }
    } catch (e, stackTrace) {
      Logger.error('Failed to toggle todo status', e, stackTrace);
      rethrow;
    }
  }
}
