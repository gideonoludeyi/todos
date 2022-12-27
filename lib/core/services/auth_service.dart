import '../models/user.model.dart';

abstract class AuthService {
  Stream<User?> get activeUser$;
  AuthState get state;

  Future<void> login(AuthCredentials credentials);
  Future<void> signup(RegistrationInput input);
  Future<void> logout();
}

enum AuthState { authenticated, unauthenticated }

class AuthCredentials {
  final String email;
  final String password;

  AuthCredentials({
    required this.email,
    required this.password,
  });
}

class RegistrationInput {
  final String name;
  final String email;
  final String password;
  final String confirmedPassword;

  RegistrationInput({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmedPassword,
  });
}
