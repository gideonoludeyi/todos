import 'package:todos/core/models/todo.model.dart' show Todo;

class TodoBuilder {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final String userId;

  factory TodoBuilder() => const TodoBuilder._(
        id: "gid://Todo/0",
        title: "the title",
        description: "the description",
        completed: false,
        userId: "gid://User/0",
      );

  factory TodoBuilder.fromTodo(Todo todo) => TodoBuilder._(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        completed: todo.completed,
        userId: todo.userId,
      );

  const TodoBuilder._({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.userId,
  });

  TodoBuilder withId(String id) => copyWith(id: id);

  TodoBuilder withTitle(String title) => copyWith(title: title);

  TodoBuilder withDescription(String description) =>
      copyWith(description: description);

  TodoBuilder asCompleted() => copyWith(completed: true);

  TodoBuilder asInProgress() => copyWith(completed: false);

  TodoBuilder byUser(String userId) => copyWith(userId: userId);

  Todo build() => Todo(
        id: id,
        title: title,
        description: description,
        completed: completed,
        userId: userId,
      );

  TodoBuilder copyWith({
    id,
    title,
    description,
    completed,
    userId,
  }) =>
      TodoBuilder._(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        completed: completed ?? this.completed,
        userId: userId ?? this.userId,
      );
}
