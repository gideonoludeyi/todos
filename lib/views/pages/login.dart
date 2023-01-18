import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos/core/services/auth_service.dart';
import 'package:todos/views/components/login_form/login_form.dart';
import 'package:todos/views/routes/routes.dart' as routes;

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginForm(
                onSubmit: (credentials) async {
                  await auth.login(credentials);

                  if (!mounted) return;
                  routes.HomeRoute().go(context);
                },
              ),
              const Divider(height: 32.0),
              _signUpRedirectLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signUpRedirectLink() {
    return Text.rich(
      TextSpan(
        text: kDontHaveAnAccountText,
        children: [
          WidgetSpan(
            child: TextButton(
              onPressed: () => routes.SignupRoute().go(context),
              child: const Text(kSignUpButtonText),
            ),
            alignment: PlaceholderAlignment.middle,
          ),
        ],
      ),
    );
  }
}
