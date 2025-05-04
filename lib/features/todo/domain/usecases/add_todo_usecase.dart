import 'package:cursor_test_flutter/features/todo/domain/entities/todo.dart';
import 'package:cursor_test_flutter/features/todo/domain/repositories/todo_repository.dart';

class AddTodoUseCase {
  final TodoRepository _repository;

  AddTodoUseCase(this._repository);

  Future<void> call(Todo todo) async {
    await _repository.addTodo(todo);
  }
}
