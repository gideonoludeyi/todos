import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos/core/models/models.dart' as models;
import 'package:todos/core/services/auth_service.dart' show AuthService;
import 'package:todos/core/services/todo_service.dart' show TodoService;
import 'package:todos/services/in_memory_auth_service.dart'
    show InMemoryAuthService;
import 'package:todos/services/in_memory_todo_repo.dart' show InMemoryTodoRepo;
import 'package:todos/views/app.dart' show App;

void main() {
  final authService = getAuthService();
  final todoService = getTodoService();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (context) => authService),
        Provider<TodoService>(create: (context) => todoService),
      ],
      child: const App(),
    ),
  );
}

AuthService getAuthService() => InMemoryAuthService(
      initialUsers: const [
        models.User(id: "1", name: "John Doe", email: "john@email.com"),
        models.User(id: "2", name: "Mary Smith", email: "mary@email.com"),
      ],
      passwords: const {
        "1": "secret",
        "2": "password",
      },
    );

TodoService getTodoService() => InMemoryTodoRepo(
      initialTodos: const [
        models.Todo(
          id: "1",
          title: "delectus aut autem",
          description: "",
          completed: true,
          userId: "1",
        ),
        models.Todo(
          id: "2",
          title: "quis ut nam facilis et officia qui",
          description:
              "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Repellat nesciunt animi dolor a minima numquam!",
          completed: false,
          userId: "2",
        ),
        models.Todo(
          id: "3",
          title: "fugiat veniam minus",
          description: "",
          completed: false,
          userId: "1",
        ),
        models.Todo(
          id: "4",
          title: "et porro tempora",
          description: "",
          completed: true,
          userId: "2",
        ),
        models.Todo(
          id: "5",
          title:
              "laboriosam mollitia et enim quasi adipisci quia provident illum",
          description: "",
          completed: false,
          userId: "1",
        ),
      ],
    );
