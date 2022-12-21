import 'package:flutter_test/flutter_test.dart';
import 'package:todos/core/models/user.model.dart' show User;
import 'package:todos/core/services/auth_service.dart';
import 'package:todos/services/in_memory_auth_service.dart'
    show InMemoryAuthService;

void main() {
  group("InMemoryAuthService", () {
    group("login()", () {
      test("should authenticate if credentials match an existing account",
          () async {
        const user1 = User(id: "1", name: "User#1", email: "user1@email.com");

        final authService = InMemoryAuthService(
          initialUsers: [user1],
          passwords: {"1": "password"},
        );

        await authService.login(
          AuthCredentials(email: "user1@email.com", password: "password"),
        );

        expect(authService.state, AuthState.authenticated);
        expect(authService.activeUser$, emits(user1));
      });

      test(
          "should not authenticate if credentials do not match any existing account",
          () async {
        const users = [
          User(id: "1", name: "User#1", email: "user1@email.com"),
        ];

        final authService = InMemoryAuthService(
          initialUsers: users,
          passwords: {"1": "password"},
        );

        await authService.login(
          AuthCredentials(email: "user1@email.com", password: "wrong_password"),
        );

        expect(authService.state, AuthState.unauthenticated);
        expect(authService.activeUser$, emits(null));
      });

      test(
          "should not authenticate account, if there's an existing authenticated account",
          () async {
        const user1 = User(
          id: "1",
          name: "Authenticated user",
          email: "user1@email.com",
        );

        const user2 = User(
          id: "2",
          name: "User attempting to authenticate",
          email: "user2@email.com",
        );

        const passwords = {"1": "password", "2": "secret"};

        final authService = InMemoryAuthService(
          initialUsers: [user1, user2],
          passwords: passwords,
        );

        await authService.login(
          AuthCredentials(email: user1.email, password: passwords[user1.id]!),
        );

        await authService.login(
          AuthCredentials(email: user2.email, password: passwords[user2.id]!),
        );

        expect(authService.state, AuthState.authenticated);
        expect(authService.activeUser$, emits(user1));
      });
    });

    group("logout()", () {
      test("should sign out of the authenticated account session", () async {
        const user1 = User(
          id: "1",
          name: "Authenticated user",
          email: "user1@email.com",
        );

        const passwords = {"1": "password"};

        final authService = InMemoryAuthService(
          initialUsers: [user1],
          passwords: passwords,
        );
        await authService.login(
          AuthCredentials(email: user1.email, password: passwords[user1.id]!),
        );

        await authService.logout();

        expect(authService.state, AuthState.unauthenticated);
        expect(authService.activeUser$, emits(null));
      });
    });

    group("signup()", () {
      test(
          "should create a new account, without authenticating as the active account",
          () async {
        final authService = InMemoryAuthService();

        final successful = await authService.signup(
          RegistrationInput(
            name: "John",
            email: "john@email.com",
            password: "password",
            confirmedPassword: "password",
          ),
        );

        expect(
          successful,
          predicate((value) => value == true, "successfully signed up"),
        );
        expect(authService.state, AuthState.unauthenticated);
      });
    });
  });
}
