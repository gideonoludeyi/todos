import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos/core/services/auth_service.dart';
import 'package:todos/views/components/page_loading_indicator/page_loading_indicator.dart';

import 'routes/routes.dart' as routes;
import 'routes/unauthenticated_routes.dart' as uroutes;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    return StreamBuilder<bool>(
      stream: authService.activeUser$.map((user) => user != null).distinct(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const PageLoadingIndicator();

        final isAuthenticated = snapshot.data!;
        final router = isAuthenticated ? routes.router : uroutes.router;

        return MaterialApp.router(
          routerConfig: router,
        );
      },
    );
  }
}
