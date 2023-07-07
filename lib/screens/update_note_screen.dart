import 'package:flutter/material.dart';
import '../widgets/buttons.dart';

import '../SQL/sql_helper.dart';
import '../widgets/constants.dart';
import '../widgets/text_fields.dart';

class EditNotesPage extends StatefulWidget {
  final int id;
  final String? title;
  final String? description;
  final String getTimeNow;
  final Map<String, dynamic> note;
  final Function() onChanged;

  const EditNotesPage({
    Key? key,
    required this.id,
    this.title,
    this.description,
    required this.getTimeNow,
    required this.note,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<EditNotesPage> createState() => _EditNotesPageState();
}

class _EditNotesPageState extends State<EditNotesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String get title => _titleController.text;
  String get description => _descriptionController.text;
  String get getTimeNow => widget.getTimeNow;

  void _buttonState() {
    setState(() {
      if (title.isEmpty || description.isEmpty) {
        const Text('Please fill the fields');
      } else {
        const Text('Update');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title!;
    _descriptionController.text = widget.description!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: IosColors.iosYellow,
        ),
        title: const Text('Edit Note'),
        actions: [
          DeleteIconButton(
            note: widget.note,
            onChanged: widget.onChanged,
          ),
        ],
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
              child: (_titleController.text.isEmpty ||
                      _descriptionController.text.isEmpty)
                  ? TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please fill the fields',
                              style: TextStyle(color: IosColors.iosYellow),
                            ),
                            backgroundColor: IosColors.iosGrey,
                          ),
                        );
                        _buttonState();
                      },
                      child: const Text('Please fill the fields'),
                      style: TextButton.styleFrom(
                        foregroundColor: IosColors.iosYellow,
                        backgroundColor: IosColors.iosGrey,
                      ))
                  : ElevatedButton(
                      onPressed: () async {
                        try {
                          if (_titleController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  'Title cannot be empty',
                                  style: TextStyle(color: IosColors.iosYellow),
                                ),
                                backgroundColor: IosColors.iosGrey,
                              ),
                            );
                          }
                          if (_descriptionController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  'Description cannot be empty',
                                  style: TextStyle(color: IosColors.iosYellow),
                                ),
                                backgroundColor: IosColors.iosGrey,
                              ),
                            );
                          } else {
                            await SQLHelper.updateNote(
                              widget.id,
                              title,
                              description,
                              getTimeNow,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  'Successfully updated!',
                                  style: TextStyle(color: IosColors.iosYellow),
                                ),
                                backgroundColor: IosColors.iosGrey,
                              ),
                            );
                            widget.onChanged();
                            // pop to previous screen
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      child: const Text('Update'),
                      style: TextButton.styleFrom(
                        foregroundColor: IosColors.iosYellow,
                        backgroundColor: IosColors.iosGrey,
                      ))),
        ],
      ),
    );
  }
}
