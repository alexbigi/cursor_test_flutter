import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/features/todo/domain/entities/todo.dart';
import 'package:my_flutter_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:my_flutter_app/features/todo/presentation/bloc/todo_event.dart';
import 'package:my_flutter_app/features/todo/presentation/bloc/todo_state.dart';
import 'package:my_flutter_app/features/todo/presentation/widgets/language_selector.dart';
import 'package:my_flutter_app/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        actions: const [
          LanguageSelector(),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoInitial) {
            context.read<TodoBloc>().add(LoadTodos());
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          todo.isCompleted
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                        ),
                        onPressed: () {
                          context
                              .read<TodoBloc>()
                              .add(ToggleTodoStatus(todo.id));
                        },
                        tooltip: todo.isCompleted
                            ? context.l10n.markAsIncomplete
                            : context.l10n.markAsCompleted,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(context, todo);
                        },
                        tooltip: context.l10n.editTodo,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<TodoBloc>().add(DeleteTodo(todo.id));
                        },
                        tooltip: context.l10n.deleteTodo,
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is TodoError) {
            return Center(
              child: Text(state.message),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        tooltip: context.l10n.addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.addTodo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: context.l10n.title,
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: context.l10n.description,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                context.read<TodoBloc>().add(
                      AddTodo(
                        Todo(
                          id: const Uuid().v4(),
                          title: titleController.text,
                          description: descriptionController.text,
                          isCompleted: false,
                          createdAt: DateTime.now(),
                        ),
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Todo todo) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.editTodo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: context.l10n.title,
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: context.l10n.description,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                context.read<TodoBloc>().add(
                      UpdateTodo(
                        todo.copyWith(
                          title: titleController.text,
                          description: descriptionController.text,
                        ),
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
  }
}
