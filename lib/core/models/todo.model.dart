class Todo {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final String userId;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.userId,
  });

  String get status => completed ? "Complete" : "In Progress";

  @override
  bool operator ==(Object other) =>
      other is Todo &&
      id == other.id &&
      title == other.title &&
      description == other.description &&
      completed == other.completed &&
      userId == other.userId;

  @override
  int get hashCode =>
      Object.hashAll([id, title, description, completed, userId]);

  @override
  String toString() =>
      "Todo(id=$id, title=$title, completed=$completed, description=$description, userId=$userId)";
}
