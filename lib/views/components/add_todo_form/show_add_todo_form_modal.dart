import 'dart:async';

import 'package:flutter/material.dart';

import 'add_todo_form.dart';

Future<void> showAddTodoFormModal({
  required BuildContext context,
  required void Function(AddTodoFormResponse response)? onSubmit,
}) async {
  final response = await _showModalBottomSheetCustom(
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

/// wrapper around showModalBottomSheet
/// to resolve overlapping keyboard issue
Future<T?> _showModalBottomSheetCustom<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) =>
    showModalBottomSheet<T>(
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: builder(context),
        ),
      ),
    );
