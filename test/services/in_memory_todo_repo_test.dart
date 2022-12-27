import 'package:flutter_test/flutter_test.dart';
import 'package:todos/core/models/todo.model.dart' show Todo;
import 'package:todos/core/services/todo_service.dart' show AddTodoInput;
import 'package:todos/services/in_memory_todo_repo.dart' show InMemoryTodoRepo;

import '../test_helper/builders/todo_builder.dart';

void main() {
  group("getTodo()", () {
    test("should return todo if it exists", () async {
      const todoId = "1";
      final todo = TodoBuilder().withId(todoId).build();

      final repo = InMemoryTodoRepo(initialTodos: [todo]);

      final result = repo.getTodo(todoId);

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

      final builder = TodoBuilder().byUser(userId);

      final repo = InMemoryTodoRepo(initialTodos: [
        builder.withId("1").build(),
        builder.withId("2").build(),
        TodoBuilder().withId("3").byUser("2").build(),
      ]);

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
      const userId = "1";

      final repo = InMemoryTodoRepo(initialTodos: []);

      await repo.addTodo(
        const AddTodoInput(
          title: "New Todo",
          description: "new",
          userId: userId,
        ),
      );

      assertion(Iterable<Todo> todos) => todos.any(
            (todo) =>
                todo.title == "New Todo" &&
                todo.description == "new" &&
                todo.userId == userId,
          );

      expect(
        repo.getTodosByUserId(userId),
        emits(predicate(assertion, "successfully added todo")),
      );
    });
  });

  group("completeTodo()", () {
    test("should update an incomplete todo to completed", () async {
      const todoId = "2";

      final repo = InMemoryTodoRepo(initialTodos: [
        TodoBuilder()
            .withId(todoId)
            .withTitle("Todo to complete")
            .withDescription("the incomplete todo to be updated to completed")
            .asInProgress()
            .build(),
      ]);

      await repo.completeTodo(todoId);

      assertion(Todo todo) => todo.completed == true;

      expect(
        repo.getTodo(todoId),
        emits(predicate(assertion, "successfully completed todo")),
      );
    });
  });

  group("revertTodo()", () {
    test("should revert a completed todo back to in-progress", () async {
      const todoId = "1";
      final repo = InMemoryTodoRepo(initialTodos: [
        TodoBuilder()
            .withId(todoId)
            .withTitle("Todo to revert")
            .withDescription(
              "the completed todo to be updated back to incomplete",
            )
            .asCompleted()
            .build(),
      ]);

      await repo.revertTodo(todoId);

      assertion(Todo todo) => todo.completed == false;

      expect(
        repo.getTodo(todoId),
        emits(predicate(assertion, "successfully reverted todo")),
      );
    });
  });

  group("deleteTodo()", () {
    test("should remove todo from repo", () async {
      const todoId = "1";
      final repo = InMemoryTodoRepo(initialTodos: [
        TodoBuilder()
            .withId(todoId)
            .withTitle("Todo to remove")
            .withDescription("the todo to remove from the list")
            .build(),
      ]);

      await repo.deleteTodo(todoId);

      assertion(Todo? todo) => todo == null;

      expect(
        repo.getTodo(todoId),
        emits(predicate(assertion, "successfully deleted todo")),
      );
    });
  });
}
