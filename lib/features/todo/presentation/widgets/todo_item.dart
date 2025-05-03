import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  void _handleToggle(BuildContext context) {
    if (!context.mounted) return;
    context.read<TodoBloc>().add(ToggleTodoStatus(todo.id));
  }

  void _handleDelete(BuildContext context) {
    if (!context.mounted) return;
    context.read<TodoBloc>().add(DeleteTodo(todo.id));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (value) => _handleToggle(context),
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(todo.description),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _handleDelete(context),
      ),
    );
  }
}
