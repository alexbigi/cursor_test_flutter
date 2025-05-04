import 'package:cursor_test_flutter/features/todo/domain/repositories/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository _repository;

  DeleteTodoUseCase(this._repository);

  Future<void> call(String id) async {
    await _repository.deleteTodo(id);
  }
}
