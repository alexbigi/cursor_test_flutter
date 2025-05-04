import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:cursor_test_flutter/features/todo/domain/repositories/todo_repository.dart';
import 'package:cursor_test_flutter/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:cursor_test_flutter/features/todo/domain/entities/todo.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_event.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_state.dart';
import 'package:cursor_test_flutter/features/todo/presentation/widgets/language_selector.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TodoListPage extends StatelessWidget {
  final AppLocalizations l10n;

  const TodoListPage({
    super.key,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => TodoBloc(
        getTodosUseCase: GetIt.I<GetTodosUseCase>(),
        repository: GetIt.I<TodoRepository>(),
        l10n: l10n,
      ),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.appTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: const [
              LanguageSelector(),
            ],
            elevation: 0,
            scrolledUnderElevation: 4,
          ),
          body: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              final bloc = context.read<TodoBloc>();

              if (state is TodoInitial) {
                bloc.add(LoadTodos());
                return const Center(child: CircularProgressIndicator());
              } else if (state is TodoLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TodoLoaded) {
                if (state.todos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 64,
                          color: Colors.grey.withValues(alpha: 128),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noTodos,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.grey.withValues(alpha: 128),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.todos.length,
                  itemBuilder: (context, index) {
                    final todo = state.todos[index];
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
                            content: Text(l10n.todoDeleted),
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
                            style: theme.textTheme.titleMedium?.copyWith(
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            todo.description,
                            style: theme.textTheme.bodyMedium,
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
                                      content: Text(l10n.todoDeleted),
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
              } else if (state is TodoError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey.withValues(alpha: 128),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.grey.withValues(alpha: 128),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          bloc.add(LoadTodos());
                        },
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAddTodoDialog(context, l10n);
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, AppLocalizations l10n) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final bloc = context.read<TodoBloc>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addTodo),
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
                final todo = Todo(
                  id: const Uuid().v4(),
                  title: title,
                  description: description,
                  isCompleted: false,
                  createdAt: DateTime.now(),
                );
                bloc.add(AddTodo(todo));
                Navigator.of(context).pop();
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
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
