import 'package:flutter/material.dart';
import 'package:todo_list_notes_management_v1/widgets/constants.dart';

class TitleTextField extends StatelessWidget {
  final Function() buttonState;
  const TitleTextField({
    super.key,
    required TextEditingController titleController,
    required this.buttonState,
  }) : _titleController = titleController;

  final TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        cursorColor: IosColors.iosYellow,
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'Title',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          border: // no Outline border
              InputBorder.none,
        ),
        onChanged: (value) => buttonState(),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}

class DescriptionTextField extends StatelessWidget {
  final Function() buttonState;
  const DescriptionTextField({
    super.key,
    required TextEditingController descriptionController,
    required this.buttonState,
  }) : _descriptionController = descriptionController;

  final TextEditingController _descriptionController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        cursorColor: IosColors.iosYellow,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: _descriptionController,
        decoration: const InputDecoration(
          labelText: 'Description',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          border: // no Outline border
              InputBorder.none,
        ),
        onChanged: (value) => buttonState(),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}
