import 'dart:async';

import 'package:rxdart/rxdart.dart' as rx;
import 'package:todos/core/models/models.dart';
import 'package:todos/core/services/todo_service.dart';

class InMemoryTodoRepo implements TodoService {
  List<Todo> _todos;
  final StreamController<List<Todo>> _controller;

  Stream<List<Todo>> get todos$ => _controller.stream;

  InMemoryTodoRepo({
    List<Todo> initialTodos = const [],
  })  : _todos = initialTodos.toList(),
        _controller = rx.BehaviorSubject.seeded(initialTodos);

  @override
  Future<void> addTodo(AddTodoInput input) async {
    final todo = Todo(
      id: "${DateTime.now().millisecondsSinceEpoch}",
      title: input.title,
      description: input.description,
      completed: false,
      userId: input.userId,
    );

    _todos.add(todo);
    _controller.add(_todos);
  }

  @override
  Future<void> completeTodo(String id) async {
    final todo = _findTodoById(id);
    if (todo == null) return;

    await _updateTodo(
      id,
      _UpdateTodoInput(
        title: todo.title,
        description: todo.description,
        completed: true,
      ),
    );
  }

  @override
  Future<void> revertTodo(String id) async {
    final todo = _findTodoById(id);
    if (todo == null) return;

    await _updateTodo(
      id,
      _UpdateTodoInput(
        title: todo.title,
        description: todo.description,
        completed: false,
      ),
    );
  }

  @override
  Future<void> deleteTodo(String id) async {
    if (!_todos.any((todo) => todo.id == id)) return;

    _todos.removeWhere((todo) => todo.id == id);
    _controller.add(_todos);
  }

  @override
  Stream<Todo?> getTodo(String id) {
    return todos$.map((todos) {
      for (final todo in todos) {
        if (todo.id == id) {
          return todo;
        }
      }

      return null;
    });
  }

  @override
  Stream<Iterable<Todo>> getTodosByUserId(String userId) {
    return todos$.map(
      (todos) => todos.where((todo) => todo.userId == userId),
    );
  }

  Future<void> _updateTodo(String id, _UpdateTodoInput input) async {
    if (!_todos.any((todo) => todo.id == id)) return;

    _todos = _todos
        .map((todo) => todo.id == id
            ? Todo(
                id: id,
                title: input.title,
                description: input.description,
                completed: input.completed,
                userId: todo.userId,
              )
            : todo)
        .toList();

    _controller.add(_todos);
  }

  Todo? _findTodoById(String id) {
    return _todos
        .cast<Todo?>()
        .firstWhere((todo) => todo?.id == id, orElse: () => null);
  }
}

class _UpdateTodoInput {
  final String title;
  final String description;
  final bool completed;

  _UpdateTodoInput({
    required this.title,
    required this.description,
    required this.completed,
  });
}
