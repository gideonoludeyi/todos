import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos/core/models/models.dart' as models;
import 'package:todos/core/services/auth_service.dart';
import 'package:todos/core/services/todo_service.dart';
import 'package:todos/views/components/add_todo_form/show_add_todo_form_modal.dart'
    show showAddTodoFormModal;
import 'package:todos/views/components/page_loading_indicator/page_loading_indicator.dart';
import 'package:todos/views/components/todo_list/todo_list.dart';
import 'package:todos/views/routes/routes.dart' as routes;

const kLogoutText = "Logout";
const kUserNotFoundText = "User Not Found";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final todoService = context.watch<TodoService>();

    return StreamBuilder<models.User?>(
      stream: authService.activeUser$,
      initialData: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const PageLoadingIndicator();

        final user = snapshot.data;
        if (user == null) return const Center(child: Text(kUserNotFoundText));

        return Scaffold(
          appBar: AppBar(
            title: Text(user.name),
            actions: [
              TextButton(
                onPressed: () => authService.logout(),
                child: const Text(
                  kLogoutText,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          body: StreamBuilder<Iterable<models.Todo>>(
            stream: todoService.getTodosByUserId(user.id),
            initialData: const [],
            builder: (context, snapshot) {
              return TodoList(
                todos: snapshot.data ?? const [],
                onComplete: (id) => todoService.completeTodo(id),
                onRevert: (id) => todoService.revertTodo(id),
                onTap: (id) => routes.TodoRoute(todoId: id).go(context),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showAddTodoFormModal(
              context: context,
              onSubmit: (response) => todoService.addTodo(
                AddTodoInput(
                  title: response.title,
                  description: response.description,
                  userId: user.id,
                ),
              ),
            ),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
