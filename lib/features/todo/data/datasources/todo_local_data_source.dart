import 'package:hive/hive.dart';
import 'package:my_flutter_app/features/todo/domain/entities/todo.dart';

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
    return todoBox.values.toList();
  }

  @override
  Future<Todo?> getTodoById(String id) async {
    return todoBox.get(id);
  }

  @override
  Future<void> addTodo(Todo todo) async {
    await todoBox.put(todo.id, todo);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await todoBox.put(todo.id, todo);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await todoBox.delete(id);
  }

  @override
  Future<void> toggleTodoStatus(String id) async {
    final todo = await getTodoById(id);
    if (todo != null) {
      await updateTodo(todo.copyWith(isCompleted: !todo.isCompleted));
    }
  }
}
