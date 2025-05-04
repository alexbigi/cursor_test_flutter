import 'package:cursor_test_flutter/core/widgets/settings_drawer.dart';
import 'package:cursor_test_flutter/features/todo/domain/repositories/todo_repository.dart';
import 'package:cursor_test_flutter/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_event.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_state.dart';
import 'package:cursor_test_flutter/features/todo/presentation/widgets/add_todo_dialog.dart';
import 'package:cursor_test_flutter/features/todo/presentation/widgets/language_selector.dart';
import 'package:cursor_test_flutter/features/todo/presentation/widgets/todo_list.dart';
import 'package:cursor_test_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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
          drawer: const SettingsDrawer(),
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

                return TodoList(todos: state.todos);
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
          floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
              onPressed: () {
                _showAddTodoDialog(context, l10n);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<TodoBloc>(),
        child: const AddTodoDialog(),
      ),
    );
  }
}
