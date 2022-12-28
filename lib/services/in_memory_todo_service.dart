import 'package:todos/core/models/todo.model.dart';
import 'package:todos/core/services/todo_service.dart';

class InMemoryTodoService implements ITodoService {
  final List<Todo> _todos;

  InMemoryTodoService({
    Iterable<Todo> initialTodos = const [],
  }) : _todos = List.from(initialTodos);

  @override
  Future<Todo?> getTodo(String id) async {
    return _todos
        .cast<Todo?>()
        .firstWhere((todo) => todo?.id == id, orElse: () => null);
  }

  @override
  Future<Iterable<Todo>> getTodos() async {
    return _todos;
  }

  @override
  Future<String> addTodo(AddTodoInput input) async {
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: input.title,
      description: input.description,
      completed: false,
      userId: input.userId,
    );
    _todos.add(todo);

    return todo.id;
  }

  @override
  Future<void> completeTodo(String id) async {
    final todo = await getTodo(id);
    if (todo == null) return;

    _todos.remove(todo);
    _todos.add(
      Todo(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        userId: todo.userId,
        completed: true,
      ),
    );
  }

  @override
  Future<void> revertTodo(String id) async {
    final todo = await getTodo(id);
    if (todo == null) return;

    _todos.remove(todo);
    _todos.add(
      Todo(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        userId: todo.userId,
        completed: false,
      ),
    );
  }

  @override
  Future<void> removeTodo(String id) async {
    final todo = await getTodo(id);
    if (todo == null) return;

    _todos.remove(todo);
  }
}
