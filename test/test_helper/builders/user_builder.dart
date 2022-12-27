import 'package:todos/core/models/user.model.dart';

class UserBuilder {
  final String id;
  final String name;
  final String email;

  factory UserBuilder() => const UserBuilder._(
        id: "gid://User/0",
        name: "Johnny",
        email: "john.doe@email.com",
      );

  factory UserBuilder.fromUser(User user) => UserBuilder._(
        id: user.id,
        name: user.name,
        email: user.email,
      );

  const UserBuilder._({
    required this.id,
    required this.name,
    required this.email,
  });

  UserBuilder withId(String id) => copyWith(id: id);

  UserBuilder withName(String name) => copyWith(name: name);

  UserBuilder withEmail(String email) => copyWith(email: email);

  User build() => User(
        id: id,
        name: name,
        email: email,
      );

  UserBuilder copyWith({
    id,
    name,
    email,
  }) =>
      UserBuilder._(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
      );
}
