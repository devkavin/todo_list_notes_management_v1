import 'package:flutter/material.dart';
import '../widgets/constants.dart';

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
        cursorColor: IosColors.iosYellow,
        controller: controller,
        decoration: const InputDecoration(
            hintText: 'Search here..',
            hintStyle: TextStyle(
              color: IosColors.iosLightGrey,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: IosColors.iosYellow,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: IosColors.iosYellow, width: 2),
            )),
        onChanged: onChanged,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}
