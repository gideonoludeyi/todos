import 'package:flutter/material.dart';
import 'package:todos/core/models/models.dart' as models;

class TodoListItem extends StatelessWidget {
  final models.Todo todo;
  final VoidCallback? onComplete;
  final VoidCallback? onRevert;
  final VoidCallback? onTap;

  const TodoListItem({
    Key? key,
    required this.todo,
    this.onComplete,
    this.onRevert,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(todo.title, overflow: TextOverflow.ellipsis),
        subtitle: Text(todo.status),
        leading: Checkbox(
          value: todo.completed,
          onChanged: (value) =>
              value == true ? onComplete?.call() : onRevert?.call(),
        ),
        onTap: onTap,
      ),
    );
  }
}
