import '../models/todo.model.dart';

abstract class TodoService {
  Stream<Todo?> getTodo(String id);
  Stream<Iterable<Todo>> getTodosByUserId(String userId);
  Future<void> addTodo(AddTodoInput input);
  Future<void> completeTodo(String id);
  Future<void> revertTodo(String id);
  Future<void> deleteTodo(String id);
}

class AddTodoInput {
  final String title;
  final String description;
  final String userId;

  const AddTodoInput({
    required this.title,
    required this.description,
    required this.userId,
  });
}
