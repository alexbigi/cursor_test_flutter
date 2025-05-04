import 'package:cursor_test_flutter/features/todo/domain/entities/todo.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:cursor_test_flutter/features/todo/presentation/bloc/todo_event.dart';
import 'package:cursor_test_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class AddTodoDialog extends StatelessWidget {
  const AddTodoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final bloc = context.read<TodoBloc>();

    return AlertDialog(
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
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
