import 'package:flutter/material.dart';

import '../SQL/sql_helper.dart';

class DeleteIconButton extends StatelessWidget {
  final Function() onChanged;
  const DeleteIconButton({
    super.key,
    required this.note,
    required this.onChanged,
  });

  final Map<String, dynamic> note;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        // confirmation box
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete this Note?'),
            content: const Text(
                'Are you sure you want to delete this note? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () {
                  SQLHelper.deleteNote(note['id']);
                  onChanged();
                  // if on the edit page, pop the page to go back to the list page else just close the dialog
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
            ],
          ),
        );
      },
    );
  }
}
