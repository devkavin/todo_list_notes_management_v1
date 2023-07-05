import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const Search({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
            labelText: 'Search here..',
            suffixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            )),
        onChanged: onChanged,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}
