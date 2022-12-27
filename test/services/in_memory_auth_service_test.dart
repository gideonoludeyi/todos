import 'package:flutter_test/flutter_test.dart';
import 'package:todos/core/services/auth_service.dart';
import 'package:todos/services/in_memory_auth_service.dart'
    show InMemoryAuthService;

import '../test_helper/builders/user_builder.dart';

void main() {
  group("InMemoryAuthService", () {
    group("login()", () {
      test("should authenticate if credentials match an existing account",
          () async {
        const email = "user1@email.com";
        const password = "password";
        final user = UserBuilder().withId("1").withEmail(email).build();

        final authService = InMemoryAuthService(
          initialUsers: [user],
          passwords: {user.id: password},
        );

        await authService.login(
          AuthCredentials(email: email, password: password),
        );

        expect(authService.state, AuthState.authenticated);
        expect(authService.activeUser$, emits(user));
      });

      test(
          "should not authenticate if credentials do not match any existing account",
          () async {
        const email = "user1@email.com";
        final user = UserBuilder().withId("1").withEmail(email).build();

        final authService = InMemoryAuthService(
          initialUsers: [user],
          passwords: {user.id: "password"},
        );

        await authService.login(
          AuthCredentials(email: email, password: "wrong_password"),
        );

        expect(authService.state, AuthState.unauthenticated);
        expect(authService.activeUser$, emits(null));
      });

      test(
          "should not authenticate account, if there's an existing authenticated account",
          () async {
        final authenticatedUser = UserBuilder()
            .withId("1")
            .withEmail("user1@email.com")
            .withName("Authenticated User")
            .build();

        final userAttemptingToAuthenticate = UserBuilder()
            .withId("2")
            .withEmail("user2@email.com")
            .withName("User attempting to authenticate")
            .build();

        final passwords = {
          authenticatedUser.id: "password",
          userAttemptingToAuthenticate.id: "secret"
        };

        final authService = InMemoryAuthService(
          initialUsers: [authenticatedUser, userAttemptingToAuthenticate],
          passwords: passwords,
        );

        await authService.login(
          AuthCredentials(
            email: authenticatedUser.email,
            password: passwords[authenticatedUser.id]!,
          ),
        );

        await authService.login(
          AuthCredentials(
            email: userAttemptingToAuthenticate.email,
            password: passwords[userAttemptingToAuthenticate.id]!,
          ),
        );

        expect(authService.state, AuthState.authenticated);
        expect(authService.activeUser$, emits(authenticatedUser));
      });
    });

    group("logout()", () {
      test("should sign out of the authenticated account session", () async {
        final user = UserBuilder()
            .withId("1")
            .withEmail("user@email.com")
            .withName("Authenticated User")
            .build();

        final passwords = {user.id: "password"};

        final authService = InMemoryAuthService(
          initialUsers: [user],
          passwords: passwords,
        );
        await authService.login(
          AuthCredentials(email: user.email, password: passwords[user.id]!),
        );

        await authService.logout();

        expect(authService.state, AuthState.unauthenticated);
        expect(authService.activeUser$, emits(null));
      });
    });

    group("signup()", () {
      test("should create a new account without authenticating", () async {
        final authService = InMemoryAuthService();

        await authService.signup(
          RegistrationInput(
            name: "John",
            email: "john@email.com",
            password: "password",
            confirmedPassword: "password",
          ),
        );

        expect(authService.state, AuthState.unauthenticated);
      });
    });
  });
}
