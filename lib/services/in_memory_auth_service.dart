import 'dart:async';

import 'package:rxdart/rxdart.dart' as rx;
import 'package:todos/core/models/user.model.dart';
import 'package:todos/core/services/auth_service.dart';

class InMemoryAuthService implements AuthService {
  final List<User> _users;
  final Map<String, String> _passwords;

  User? _activeUser;
  final StreamController<User?> _activeUserStreamController;
  bool get _isAuthenticated => _activeUser != null;

  @override
  AuthState get state =>
      _isAuthenticated ? AuthState.authenticated : AuthState.unauthenticated;

  @override
  Stream<User?> get activeUser$ => _activeUserStreamController.stream;

  InMemoryAuthService({
    List<User> initialUsers = const [],
    Map<String, String> passwords = const {},
  })  : _users = List.from(initialUsers),
        _passwords = Map.from(passwords),
        _activeUserStreamController = rx.BehaviorSubject.seeded(null);

  @override
  Future<void> login(AuthCredentials credentials) async {
    if (_isAuthenticated) return;

    for (final user in _users) {
      if (user.email == credentials.email) {
        if (_passwords[user.id] == credentials.password) {
          _setActiveUser(user);
          break;
        }
      }
    }
  }

  @override
  Future<void> logout() async {
    if (!_isAuthenticated) return;

    _setActiveUser(null);
  }

  @override
  Future<bool> signup(RegistrationInput input) async {
    final user = User(
      id: "${DateTime.now().millisecondsSinceEpoch}",
      name: input.name,
      email: input.email,
    );

    _users.add(user);
    _passwords[user.id] = input.password;

    return true;
  }

  void _setActiveUser(User? userOrNull) {
    _activeUser = userOrNull;
    _activeUserStreamController.add(userOrNull);
  }
}
