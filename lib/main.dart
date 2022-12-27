import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos/core/services/auth_service.dart' show AuthService;
import 'package:todos/core/services/todo_service.dart' show TodoService;
import 'package:todos/services/in_memory_auth_service.dart'
    show InMemoryAuthService;
import 'package:todos/services/in_memory_todo_repo.dart' show InMemoryTodoRepo;
import 'package:todos/views/app.dart' show App;

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (context) => InMemoryAuthService()),
        Provider<TodoService>(create: (context) => InMemoryTodoRepo()),
      ],
      child: const App(),
    ),
  );
}
