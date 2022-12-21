import 'package:flutter/material.dart';

import 'delete_todo_confirmation_dialog.dart';

Future<void> showDeleteTodoConfirmationDialog({
  required BuildContext context,
  VoidCallback? onConfirm,
}) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => DeleteTodoConfirmationDialog(
      onConfirm: () => Navigator.pop<bool>(context, true),
      onCancel: () => Navigator.pop<bool>(context, false),
    ),
  );

  if (confirmed == true) {
    onConfirm?.call();
  }
}
