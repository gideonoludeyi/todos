import 'package:flutter/material.dart';

const kMarkAsInProgress = "Mark as In Progress";
const kMarkAsComplete = "Mark as Complete";


class TodoToggleButton extends StatelessWidget {
  final bool value;
  final VoidCallback? onComplete;
  final VoidCallback? onRevert;

  const TodoToggleButton({
    Key? key,
    required this.value,
    required this.onComplete,
    required this.onRevert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value) {
      return OutlinedButton(
        onPressed: onRevert,
        child: const Text(kMarkAsInProgress),
      );
    } else {
      return ElevatedButton(
        onPressed: onComplete,
        child: const Text(kMarkAsComplete),
      );
    }
  }
}
