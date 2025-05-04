import 'package:cursor_test_flutter/features/todo/domain/entities/todo.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_event.dart';
import 'package:cursor_test_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;

  const TodoList({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.read<TodoBloc>();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Dismissible(
          key: Key(todo.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            bloc.add(DeleteTodo(todo.id));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.deleteTodo),
                action: SnackBarAction(
                  label: l10n.undo,
                  onPressed: () {
                    bloc.add(AddTodo(todo));
                  },
                ),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: ListTile(
              title: Text(
                todo.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      decoration:
                          todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
              ),
              subtitle: Text(
                todo.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      bloc.add(DeleteTodo(todo.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.deleteTodo),
                          action: SnackBarAction(
                            label: l10n.undo,
                            onPressed: () {
                              bloc.add(AddTodo(todo));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) {
                      bloc.add(ToggleTodoStatus(todo.id));
                    },
                  ),
                ],
              ),
              onLongPress: () {
                _showEditTodoDialog(context, l10n, todo);
              },
            ),
          ),
        );
      },
    );
  }

  void _showEditTodoDialog(
      BuildContext context, AppLocalizations l10n, Todo todo) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description);
    final bloc = context.read<TodoBloc>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editTodo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: l10n.title,
                hintText: l10n.titleHint,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: l10n.description,
                hintText: l10n.descriptionHint,
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final description = descriptionController.text.trim();

              if (title.isNotEmpty) {
                final updatedTodo = todo.copyWith(
                  title: title,
                  description: description,
                );
                bloc.add(UpdateTodo(updatedTodo));
                Navigator.of(context).pop();
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
