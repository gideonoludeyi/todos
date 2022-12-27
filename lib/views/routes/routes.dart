import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todos/core/services/auth_service.dart';
import 'package:todos/views/pages/home.dart';
import 'package:todos/views/pages/login.dart';
import 'package:todos/views/pages/signup.dart';
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
  Widget build(BuildContext context, GoRouterState state) {
    return const Home();
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    var authService = context.read<AuthService>();
    switch (authService.state) {
      case AuthState.unauthenticated:
        return LoginRoute().location;
      default:
        return null;
    }
  }
}

@immutable
class TodoRoute extends GoRouteData {
  final String todoId;

  const TodoRoute({
    required this.todoId,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TodoScreen(todoId: todoId);
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    var authService = context.read<AuthService>();
    switch (authService.state) {
      case AuthState.unauthenticated:
        return LoginRoute().location;
      default:
        return null;
    }
  }
}

@TypedGoRoute<LoginRoute>(
  path: '/login',
)
@immutable
class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    var authService = context.read<AuthService>();
    switch (authService.state) {
      case AuthState.authenticated:
        return HomeRoute().location;
      default:
        return null;
    }
  }
}

@TypedGoRoute<SignupRoute>(
  path: '/signup',
)
@immutable
class SignupRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignupScreen();
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    var authService = context.read<AuthService>();
    switch (authService.state) {
      case AuthState.authenticated:
        return HomeRoute().location;
      default:
        return null;
    }
  }
}
