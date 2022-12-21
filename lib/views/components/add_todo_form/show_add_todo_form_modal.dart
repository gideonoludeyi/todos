import 'dart:async';

import 'package:flutter/material.dart';

import 'add_todo_form.dart';

Future<void> showAddTodoFormModal({
  required BuildContext context,
  required void Function(AddTodoFormResponse response)? onSubmit,
}) async {
  final AddTodoFormResponse? response =
      await showModalBottomSheet<AddTodoFormResponse>(
    context: context,
    builder: (context) => AddTodoForm(
      onSubmit: (response) =>
          Navigator.pop<AddTodoFormResponse>(context, response),
    ),
  );

  if (response != null) {
    onSubmit?.call(response);
  }
}
