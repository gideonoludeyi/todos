import 'package:flutter/material.dart';
import 'package:todos/core/services/auth_service.dart';
import 'package:todos/views/helper/validator.dart';

const kFormTitle = "Todo App";
const kUsernameLabel = "Name";
const kEmailLabel = "Email";
const kPasswordLabel = "Password";
const kPasswordConfirmationLabel = "Confirm Password";
const kSignupButtonText = "Sign Up";

const kUsernameRequiredErrorText = "$kUsernameLabel is required";
const kUsernameLessThan4CharactersErrorText =
    "$kUsernameLabel must be at least 4 characters";

const kEmailRequiredErrorText = "Email is required";
const kPasswordRequiredErrorText = "Password is required";
const kPasswordLessThan6CharactersErrorText =
    "Password must be at least 6 characters";

const kPasswordConfirmationMismatchErrorText = "Password must match";

class SignupForm extends StatefulWidget {
  final void Function(RegistrationInput input)? onSubmit;

  const SignupForm({super.key, this.onSubmit});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey =
      GlobalKey<FormState>(debugLabel: "_SignupFormStateGlobalKey");

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmationController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _passwordConfirmationController = TextEditingController(text: "");
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
            decoration: const InputDecoration(labelText: kUsernameLabel),
            controller: _nameController,
            validator: _nameValidator,
            autofocus: true,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: kEmailLabel),
            controller: _emailController,
            validator: _emailValidator,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(labelText: kPasswordLabel),
            controller: _passwordController,
            validator: _passwordValidator,
            obscureText: true,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration:
                const InputDecoration(labelText: kPasswordConfirmationLabel),
            controller: _passwordConfirmationController,
            validator: _passwordConfirmationValidator,
            obscureText: true,
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onSubmit,
                  child: const Text(kSignupButtonText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call(
        RegistrationInput(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          confirmedPassword: _passwordConfirmationController.text.trim(),
        ),
      );
    }
  }

  Validator get _nameValidator => Validator.compose([
        Validator.required(errorText: kUsernameRequiredErrorText),
        Validator.minLength(4,
            errorText: kUsernameLessThan4CharactersErrorText),
      ]);

  Validator get _emailValidator =>
      Validator.required(errorText: kEmailRequiredErrorText);

  Validator get _passwordValidator => Validator.compose([
        Validator.required(errorText: kPasswordRequiredErrorText),
        Validator.minLength(6,
            errorText: kPasswordLessThan6CharactersErrorText),
      ]);

  Validator get _passwordConfirmationValidator => Validator.test(
        (value) => value == _passwordController.text,
        errorText: kPasswordConfirmationMismatchErrorText,
      );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();

    super.dispose();
  }
}
