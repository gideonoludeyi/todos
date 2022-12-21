import 'package:flutter/material.dart';
import 'package:todos/core/services/auth_service.dart';
import 'package:todos/views/helper/validator.dart';

const kFormTitle = "Todo App";
const kEmailLabel = "Email";
const kPasswordLabel = "Password";
const kLoginButtonText = "Login";

const kEmailRequiredErrorText = "Email is required";
const kPasswordRequiredErrorText = "Password is required";
const kPasswordLessThan6CharactersErrorText =
    "Password must be at least 6 characters";

class LoginForm extends StatefulWidget {
  final void Function(AuthCredentials credentials)? onSubmit;

  const LoginForm({super.key, this.onSubmit});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: "_LoginFormStateGlobalKey");

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            kFormTitle,
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 32.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: kEmailLabel,
              hintText: "john@email.com",
            ),
            controller: _emailController,
            validator: _emailValidator,
            autofocus: true,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: kPasswordLabel,
              hintText: "secret",
            ),
            controller: _passwordController,
            validator: _passwordValidator,
            obscureText: true,
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text(kLoginButtonText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call(
        AuthCredentials(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  Validator get _emailValidator =>
      Validator.required(errorText: kEmailRequiredErrorText);

  Validator get _passwordValidator => Validator.compose([
        Validator.required(errorText: kPasswordRequiredErrorText),
        Validator.minLength(6,
            errorText: kPasswordLessThan6CharactersErrorText),
      ]);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
