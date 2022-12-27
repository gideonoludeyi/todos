import 'package:flutter_test/flutter_test.dart';
import 'package:todos/core/models/todo.model.dart' show Todo;

import '../../test_helper/builders/todo_builder.dart' show TodoBuilder;

void main() {
  group("Todo completed status", () {
    test("A non-completed todo should have a status of 'In Progress'", () {
      final Todo todo = TodoBuilder().asInProgress().build();

      expect(todo.status, equals("In Progress"));
    });

    test("A completed todo should have a status of 'Complete'", () {
      final Todo todo = TodoBuilder().asCompleted().build();

      expect(todo.status, equals("Complete"));
    });
  });
}
