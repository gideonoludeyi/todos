import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos/core/services/auth_service.dart';
import 'package:todos/views/components/signup_form/signup_form.dart';
import 'package:todos/views/routes/unauthenticated_routes.dart' as uroutes;

const kAlreadyHaveAnAccountText = "Already have an account?";
const kLoginButtonText = "Login";

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignupForm(
              onSubmit: (input) async {
                await auth.signup(input);

                if (!mounted) return;
                uroutes.LoginRoute().go(context);
              },
            ),
            const Divider(height: 32.0),
            _loginRedirectLink(),
          ],
        ),
      ),
    );
  }

  Widget _loginRedirectLink() {
    return Text.rich(
      TextSpan(
        text: kAlreadyHaveAnAccountText,
        children: [
          WidgetSpan(
            child: TextButton(
              onPressed: () => uroutes.LoginRoute().go(context),
              child: const Text(kLoginButtonText),
            ),
            alignment: PlaceholderAlignment.middle,
          ),
        ],
      ),
    );
  }
}
