import '../repositories/todo_repository.dart';
import '../entities/todo.dart';

class GetTodosUseCase {
  final TodoRepository repository;

  GetTodosUseCase(this.repository);

  Future<List<Todo>> call() async {
    return await repository.getTodos();
  }
}
