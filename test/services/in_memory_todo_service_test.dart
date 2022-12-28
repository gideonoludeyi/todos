import 'package:flutter_test/flutter_test.dart';
import 'package:todos/core/models/todo.model.dart';
import 'package:todos/core/services/todo_service.dart';
import 'package:todos/services/in_memory_todo_service.dart';

import '../test_helper/builders/todo_builder.dart';

void main() {
  group("InMemoryTodoService", () {
    group("getTodo()", () {
      test("given an existing todo, when provided its id, should retrieve it",
          () async {
        final todo = TodoBuilder().withId("1").build();
        final service = InMemoryTodoService(initialTodos: [todo]);

        final result = await service.getTodo(todo.id);

        expect(result, todo);
      });

      test("when provided an id for an unexisting todo, should return null",
          () async {
        final todo = TodoBuilder().withId("1").build();
        final service = InMemoryTodoService(initialTodos: [todo]);

        final result = await service.getTodo("invalid-id");

        expect(result, null);
      });
    });

    group("getTodos()", () {
      test("should retrieve all existing todos", () async {
        final builder = TodoBuilder();
        final todos = [
          builder.withId("1").build(),
          builder.withId("2").build(),
          builder.withId("3").build(),
        ];
        final service = InMemoryTodoService(initialTodos: todos);

        final result = await service.getTodos();

        expect(result, todos);
      });
    });

    group("addTodo()", () {
      group("given the valid data to create a todo", () {
        test(
            "should add the new todo with the provided title, description, and userId",
            () async {
          final service = InMemoryTodoService(initialTodos: []);

          const input = AddTodoInput(
            title: "title",
            description: "description",
            userId: "1",
          );
          final String todoId = await service.addTodo(input);

          final result = await service.getTodo(todoId);
          expect(result, isNotNull);
          expect(
            result,
            predicate(
              (Todo todo) => todo.title == input.title,
              "Todo should have the given title",
            ),
          );
          expect(
            result,
            predicate(
              (Todo todo) => todo.description == input.description,
              "Todo should have the given description",
            ),
          );
          expect(
            result,
            predicate(
              (Todo todo) => todo.userId == input.userId,
              "Todo should have the given userId",
            ),
          );
        });

        test("should add the new todo in an in-progress state", () async {
          final service = InMemoryTodoService(initialTodos: []);

          const input = AddTodoInput(
            title: "title",
            description: "description",
            userId: "1",
          );
          final String todoId = await service.addTodo(input);

          expect(
            await service.getTodo(todoId),
            predicate(
              (Todo todo) => todo.completed == false,
              "Todo should be in-progress",
            ),
          );
        });
      });
    });

    group("completeTodo()", () {
      test(
          "given a todo in-progress, when provided its id, should update it to a completed state",
          () async {
        const todoId = "1";
        final service = InMemoryTodoService(
          initialTodos: [
            TodoBuilder().withId(todoId).asInProgress().build(),
          ],
        );

        await service.completeTodo(todoId);

        expect(
          await service.getTodo(todoId),
          predicate(
            (Todo? todo) => todo != null && todo.completed == true,
            "Todo should be completed",
          ),
        );
      });

      test(
          "given a completed todo, when provided its id, should remain completed",
          () async {
        const todoId = "1";
        final service = InMemoryTodoService(
          initialTodos: [
            TodoBuilder().withId(todoId).asCompleted().build(),
          ],
        );

        await service.completeTodo(todoId);

        expect(
          await service.getTodo(todoId),
          predicate(
            (Todo? todo) => todo != null && todo.completed == true,
            "Todo should remain be completed",
          ),
        );
      });
    });

    group("revertTodo()", () {
      test(
          "given a todo in-progress, when provided its id, should remain in-progress",
          () async {
        const todoId = "1";
        final service = InMemoryTodoService(
          initialTodos: [
            TodoBuilder().withId(todoId).asInProgress().build(),
          ],
        );

        await service.revertTodo(todoId);

        expect(
          await service.getTodo(todoId),
          predicate(
            (Todo? todo) => todo != null && todo.completed == false,
            "Todo should remain in-progress",
          ),
        );
      });

      test(
          "given a completed todo, when provided its id, should update it to an in-progress state",
          () async {
        const todoId = "1";
        final service = InMemoryTodoService(
          initialTodos: [
            TodoBuilder().withId(todoId).asCompleted().build(),
          ],
        );

        await service.revertTodo(todoId);

        expect(
          await service.getTodo(todoId),
          predicate(
            (Todo? todo) => todo != null && todo.completed == false,
            "Todo should be in-progress",
          ),
        );
      });
    });

    group("removeTodo()", () {
      test(
          "given an existing todo, when provided its id, should remove it from the list of todos",
          () async {
        final todo = TodoBuilder().withId("1").build();
        final service = InMemoryTodoService(initialTodos: [todo]);

        await service.removeTodo(todo.id);

        expect(await service.getTodo(todo.id), null);
      });
    });
  });
}
