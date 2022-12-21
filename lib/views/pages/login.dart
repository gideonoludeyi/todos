import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos/core/services/auth_service.dart';
import 'package:todos/views/components/login_form/login_form.dart';
import 'package:todos/views/routes/unauthenticated_routes.dart' as uroutes;

const kDontHaveAnAccountText = "Don't have an account?";
const kSignUpButtonText = "Sign Up";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginForm(
              onSubmit: (credentials) => auth.login(credentials),
            ),
            const Divider(height: 32.0),
            Text.rich(
              TextSpan(
                text: kDontHaveAnAccountText,
                children: [
                  WidgetSpan(
                    child: TextButton(
                      onPressed: () => uroutes.SignupRoute().go(context),
                      child: const Text(kSignUpButtonText),
                    ),
                    alignment: PlaceholderAlignment.middle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
