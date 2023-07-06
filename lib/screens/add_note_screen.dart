import 'package:flutter/material.dart';

import '../SQL/sql_helper.dart';
import '../widgets/constants.dart';
import '../widgets/text_fields.dart';

class AddNotesPage extends StatefulWidget {
  final int? id;
  final String? title;
  final String? description;
  final String? getTimeNow;
  final Function() buttonState;
  final Function() onChanged;
  const AddNotesPage({
    Key? key,
    this.id,
    this.title,
    this.description,
    this.getTimeNow,
    required this.buttonState,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<AddNotesPage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {
  void _buttonState() {
    setState(() {
      if (_titleController.text.isEmpty ||
          _descriptionController.text.isEmpty) {
        const Text('Please fill the fields');
      } else {
        const Text('Update');
      }
    });
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // final TextEditingController _timeNowController = TextEditingController();

  String get title => _titleController.text;
  String get description => _descriptionController.text;
  String get getTimeNow => widget.getTimeNow!;

  @override
  void initState() {
    super.initState();
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: IosColors.iosYellow,
        ),
        title: const Text('Add Note'),
      ),
      body: Column(
        children: [
          TitleTextField(
              titleController: _titleController, buttonState: _buttonState),
          DescriptionTextField(
              descriptionController: _descriptionController,
              buttonState: _buttonState),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  try {
                    if (_titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Title cannot be empty'),
                            // from top to bottom
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            )),
                      );
                    }
                    if (_descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Description cannot be empty'),
                          // from top to bottom
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      );
                    } else {
                      await SQLHelper.createNote(
                          title, description, getTimeNow);
                      widget.onChanged();
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    }
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: (_titleController.text.isEmpty ||
                        _descriptionController.text.isEmpty)
                    ? const Text('Please fill the fields')
                    : const Text('Create'),
                style: TextButton.styleFrom(
                  foregroundColor: IosColors.iosYellow,
                  backgroundColor: IosColors.iosGrey,
                )),
          ),
        ],
      ),
    );
  }
}
