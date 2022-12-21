import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todos/views/pages/login.dart';
import 'package:todos/views/pages/signup.dart';

part 'unauthenticated_routes.g.dart';

final router = GoRouter(
  routes: $appRoutes,
  initialLocation: '/',
);

@TypedGoRoute<RootRoute>(
  path: '/',
)
@immutable
class RootRoute extends GoRouteData {
  @override
  String redirect() => LoginRoute().location;
}

@TypedGoRoute<LoginRoute>(
  path: '/login',
)
@immutable
class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}

@TypedGoRoute<SignupRoute>(
  path: '/signup',
)
@immutable
class SignupRoute extends GoRouteData {
  @override
  Widget build(BuildContext context) {
    return const SignupScreen();
  }
}
