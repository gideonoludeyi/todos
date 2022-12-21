import 'package:flutter/material.dart';

const kDialogTitle = "Delete Todo?";
const kDialogContent = "Do you wish to delete this task?";
const kCancelButtonText = "Cancel";
const kConfirmButtonText = "Confirm";

class DeleteTodoConfirmationDialog extends StatelessWidget {
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const DeleteTodoConfirmationDialog({
    Key? key,
    this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        kDialogTitle,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
      content: const Text(kDialogContent),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text(kCancelButtonText),
        ),
        TextButton(
          onPressed: onConfirm,
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all(Theme.of(context).colorScheme.error),
          ),
          child: const Text(kConfirmButtonText),
        ),
      ],
    );
  }
}
