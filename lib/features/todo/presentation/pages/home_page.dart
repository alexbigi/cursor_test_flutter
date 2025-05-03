import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_state.dart';
import '../widgets/todo_list.dart';
import '../widgets/add_todo_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        centerTitle: true,
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoError) {
            return Center(child: Text(state.message));
          } else if (state is TodoLoaded) {
            return TodoList(todos: state.todos);
          }
          return const Center(child: Text('No todos yet'));
        },
      ),
      floatingActionButton: const AddTodoButton(),
    );
  }
}
