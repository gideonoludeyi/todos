import 'package:flutter_test/flutter_test.dart';
import 'package:todos/core/models/todo.model.dart' show Todo;
import 'package:todos/core/services/todo_service.dart' show AddTodoInput;
import 'package:todos/services/in_memory_todo_repo.dart' show InMemoryTodoRepo;

void main() {
  group("getTodo()", () {
    test("should return todo if it exists", () async {
      const todo = Todo(
        id: "1",
        title: "Todo#1",
        description: "first",
        completed: true,
        userId: "0",
      );

      final repo = InMemoryTodoRepo(initialTodos: [todo]);

      final result = repo.getTodo("1");

      expect(result, emits(todo));
    });

    test("should return null if id doesn't correspond to any todo", () async {
      final repo = InMemoryTodoRepo(initialTodos: []);

      final result = repo.getTodo("1");

      expect(result, emits(null));
    });
  });

  group("getTodosByUserId", () {
    test("should return only todos of specified user", () {
      const userId = "1";

      const todos = [
        Todo(
          id: "1",
          title: "Todo#1",
          description: "first",
          completed: true,
          userId: userId,
        ),
        Todo(
          id: "2",
          title: "Todo#2",
          description: "second",
          completed: true,
          userId: "2",
        ),
        Todo(
          id: "3",
          title: "Todo#3",
          description: "third",
          completed: false,
          userId: userId,
        ),
      ];

      final repo = InMemoryTodoRepo(initialTodos: todos);

      final todos$ = repo.getTodosByUserId(userId);

      assertion(Iterable<Todo> todos) =>
          todos.every((todo) => todo.userId == userId);

      expect(
        todos$,
        emits(predicate(assertion, "all todos belong to userId=$userId")),
      );
    });
  });

  group("addTodo()", () {
    test("should create an incomplete todo", () async {
      final repo = InMemoryTodoRepo(initialTodos: []);

      await repo.addTodo(
        const AddTodoInput(
          title: "New Todo",
          description: "new",
          userId: "1",
        ),
      );

      assertion(Iterable<Todo> list) => list.last.completed == false;

      expect(
        repo.getTodosByUserId("1"),
        emits(predicate(assertion, "created new todo as incomplete")),
      );
    });

    test("should update todos list when a new todo is created", () async {
      final repo = InMemoryTodoRepo();

      const input = AddTodoInput(
        title: "New Todo",
        description: "new",
        userId: "1",
      );

      await repo.addTodo(input);

      assertion(Iterable<Todo> todos) => todos.any(
            (todo) =>
                todo.title == "New Todo" &&
                todo.description == "new" &&
                todo.userId == "1",
          );

      expect(
        repo.getTodosByUserId("1"),
        emits(predicate(assertion, "successfully added todo")),
      );
    });
  });

  group("completeTodo()", () {
    test("should update an incomplete todo to completed", () async {
      const todos = [
        Todo(
          id: "1",
          title: "Todo#1",
          description: "first",
          completed: true,
          userId: "0",
        ),
        Todo(
          id: "2",
          title: "Todo to complete",
          description: "the incomplete todo to be updated to completed",
          completed: false,
          userId: "0",
        ),
      ];

      final repo = InMemoryTodoRepo(initialTodos: todos);

      await repo.completeTodo("2");

      assertion(Todo todo) => todo.completed == true;

      expect(
        repo.getTodo("2"),
        emits(predicate(assertion, "successfully completed todo")),
      );
    });
  });

  group("revertTodo()", () {
    test("should update a completed todo back to incomplete state", () async {
      const todos = [
        Todo(
          id: "1",
          title: "Todo to revert",
          description: "the completed todo to be updated back to incomplete",
          completed: true,
          userId: "0",
        ),
        Todo(
          id: "2",
          title: "Todo#1",
          description: "second",
          completed: false,
          userId: "0",
        ),
      ];
      final repo = InMemoryTodoRepo(initialTodos: todos);

      await repo.revertTodo("1");

      assertion(Todo todo) => todo.completed == false;

      expect(
        repo.getTodo("1"),
        emits(predicate(assertion, "successfully reverted todo")),
      );
    });
  });

  group("deleteTodo()", () {
    test("should remove todo from the list", () async {
      const todos = [
        Todo(
          id: "1",
          title: "Todo to remove",
          description: "the todo to remove from the list",
          completed: true,
          userId: "0",
        ),
        Todo(
          id: "2",
          title: "Todo#1",
          description: "second",
          completed: false,
          userId: "0",
        ),
      ];
      final repo = InMemoryTodoRepo(initialTodos: todos);

      await repo.deleteTodo("1");

      assertion(Iterable<Todo> todos) => todos.every((todo) => todo.id != "1");

      expect(
        repo.getTodosByUserId("0"),
        emits(predicate(assertion, "successfully deleted todo")),
      );
    });
  });
}
