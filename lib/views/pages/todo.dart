import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todos/core/models/models.dart' as models;
import 'package:todos/core/services/todo_service.dart';
import 'package:todos/views/components/delete_todo_confirmation_dialog/show_delete_todo_confirmation_dialog.dart';
import 'package:todos/views/components/page_loading_indicator/page_loading_indicator.dart';
import 'package:todos/views/components/todo_toggle_button.dart';

const kAppBarTitleText = "Todo";
const kTodoNotFoundText = "Todo Not Found";

class TodoScreen extends StatefulWidget {
  final String todoId;

  const TodoScreen({
    super.key,
    required this.todoId,
  });

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    final todoService = context.watch<TodoService>();

    return StreamBuilder<models.Todo?>(
      stream: todoService.getTodo(widget.todoId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const PageLoadingIndicator();

        final todo = snapshot.data;
        if (todo == null) return const Center(child: Text(kTodoNotFoundText));

        return Scaffold(
          appBar: AppBar(
            title: const Text(kAppBarTitleText),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => showDeleteTodoConfirmationDialog(
                  context: context,
                  onConfirm: () async {
                    await todoService.deleteTodo(todo.id);

                    if (!mounted) return;
                    context.pop();
                  },
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  todo.status.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.5,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  todo.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(todo.description),
                const SizedBox(height: 24.0),
                Row(children: [
                  Expanded(
                    child: TodoToggleButton(
                      value: todo.completed,
                      onRevert: () => todoService.revertTodo(todo.id),
                      onComplete: () => todoService.completeTodo(todo.id),
                    ),
                  ),
                ])
              ],
            ),
          ),
        );
      },
    );
  }
}
