import 'package:flutter/material.dart';

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
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'Title',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        onChanged: (value) => buttonState(),
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
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: _descriptionController,
        decoration: const InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        onChanged: (value) => buttonState(),
      ),
    );
  }
}
