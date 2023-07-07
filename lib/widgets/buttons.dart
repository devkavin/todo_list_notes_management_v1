import 'package:flutter/material.dart';
import 'package:todo_list_notes_management_v1/widgets/constants.dart';

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
      color: Color.fromRGBO(255, 213, 46, 1),
      icon: const Icon(Icons.delete),
      onPressed: () async {
        // confirmation box
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: IosColors.iosGrey,
            title: const Text(
              'Delete this Note?',
              style: TextStyle(color: IosColors.iosYellow),
            ),
            content: const Text(
                'Are you sure you want to delete this note? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () {
                  SQLHelper.deleteNote(note['id']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Note Deleted!',
                        style: TextStyle(color: IosColors.iosYellow),
                      ),
                      backgroundColor: IosColors.iosGrey,
                    ),
                  );
                  onChanged();
                  // if on the edit page, pop the page to go back to the list page else just close the dialog
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Yes',
                    style: TextStyle(color: IosColors.iosYellow)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No',
                    style: TextStyle(color: IosColors.iosLightGrey)),
              ),
            ],
          ),
        );
      },
    );
  }
}
