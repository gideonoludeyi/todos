import 'package:flutter/material.dart';
import 'package:todos/core/models/models.dart' as models;

import 'todo_list_item.dart' show TodoListItem;

class TodoList extends StatelessWidget {
  final Iterable<models.Todo> todos;
  final void Function(String id)? onComplete;
  final void Function(String id)? onRevert;
  final void Function(String id)? onTap;

  const TodoList({
    Key? key,
    required this.todos,
    this.onComplete,
    this.onRevert,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos.elementAt(index);
        return TodoListItem(
          key: ValueKey(todo.id),
          todo: todo,
          onComplete: () => onComplete?.call(todo.id),
          onRevert: () => onRevert?.call(todo.id),
          onTap: () => onTap?.call(todo.id),
        );
      },
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    );
  }
}
