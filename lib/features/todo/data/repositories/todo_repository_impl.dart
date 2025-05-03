import 'package:my_flutter_app/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:my_flutter_app/features/todo/domain/entities/todo.dart';
import 'package:my_flutter_app/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl(this.localDataSource);

  @override
  Future<List<Todo>> getTodos() async {
    return await localDataSource.getTodos();
  }

  @override
  Future<Todo?> getTodoById(String id) async {
    return await localDataSource.getTodoById(id);
  }

  @override
  Future<void> addTodo(Todo todo) async {
    await localDataSource.addTodo(todo);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await localDataSource.updateTodo(todo);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await localDataSource.deleteTodo(id);
  }

  @override
  Future<void> toggleTodoStatus(String id) async {
    await localDataSource.toggleTodoStatus(id);
  }
}
