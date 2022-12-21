import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todos/views/pages/home.dart';
import 'package:todos/views/pages/todo.dart';

part 'routes.g.dart';

final router = GoRouter(
  routes: $appRoutes,
  initialLocation: '/',
);

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<TodoRoute>(
      path: 'todo/:todoId',
    ),
  ],
)
@immutable
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}

@immutable
class TodoRoute extends GoRouteData {
  final String todoId;

  const TodoRoute({
    required this.todoId,
  });

  @override
  Widget build(BuildContext context) {
    return TodoScreen(todoId: todoId);
  }
}

@TypedGoRoute<_LoginRoute>(
  path: '/login',
)
@immutable
class _LoginRoute extends GoRouteData {
  @override
  String redirect() => HomeRoute().location;
}

@TypedGoRoute<_SignupRoute>(
  path: '/signup',
)
@immutable
class _SignupRoute extends GoRouteData {
  @override
  String redirect() => HomeRoute().location;
}
