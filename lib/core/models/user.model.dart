class User {
  final String id;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  bool operator ==(Object other) =>
      other is User &&
      id == other.id &&
      name == other.name &&
      email == other.email;

  @override
  int get hashCode => Object.hashAll([id, name, email]);

  @override
  String toString() => "User(id=$id, name=$name, email=$email)";
}
