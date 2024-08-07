import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({Key? key, required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Task',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      content: Text('Are you sure you want to delete this task?'),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Delete'),
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.error,
            onPrimary: Colors.white,
          ),
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
