import 'package:flutter_test/flutter_test.dart';

import 'package:todos/core/models/todo.model.dart' show Todo;

void main() {
  group("Todo completed status", () {
    test("A non-completed todo should have a status of 'In Progress'", () {
      const todo = Todo(
        id: "1",
        title: "Todo#1",
        description: "first",
        completed: false,
        userId: "0",
      );

      expect(todo.status, equals("In Progress"));
    });

    test("A completed todo should have a status of 'Complete'", () {
      const todo = Todo(
        id: "1",
        title: "Todo#1",
        description: "first",
        completed: true,
        userId: "0",
      );

      expect(todo.status, equals("Complete"));
    });
  });
}
