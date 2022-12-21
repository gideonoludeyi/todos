import 'package:flutter/material.dart';
import 'package:todos/views/helper/validator.dart' show Validator;

import 'add_todo_form_response.dart' show AddTodoFormResponse;

export 'add_todo_form_response.dart';

const kFormTitle = "New Todo";
const kTitleLabel = "Title";
const kDescriptionLabel = "Description";
const kSubmitText = "Add Todo";

const kMissingTitleErrorText = "Title is required";
const kTitleLessThan3CharactersErrorText =
    "Title must be at least 3 characters";

class AddTodoForm extends StatefulWidget {
  final void Function(AddTodoFormResponse data)? onSubmit;

  const AddTodoForm({super.key, this.onSubmit});

  @override
  State<AddTodoForm> createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {
  final _formKey =
      GlobalKey<FormState>(debugLabel: "_AddTodoFormStateGlobalKey");

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: "");
    _descriptionController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              kFormTitle,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: kTitleLabel),
              controller: _titleController,
              validator: _titleValidator,
              autofocus: true,
            ),
            const SizedBox(height: 24.0),
            TextFormField(
              decoration: const InputDecoration(labelText: kDescriptionLabel),
              controller: _descriptionController,
              minLines: 1,
              maxLines: 4,
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _onSubmit,
                  child: const Text(kSubmitText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call(
        AddTodoFormResponse(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        ),
      );
    }
  }

  Validator get _titleValidator => Validator.compose([
        Validator.required(errorText: kMissingTitleErrorText),
        Validator.minLength(3, errorText: kTitleLessThan3CharactersErrorText),
      ]);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }
}
