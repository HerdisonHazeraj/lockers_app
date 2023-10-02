import 'package:flutter/material.dart';

import '../../../../../core/theme.dart';

class SearchStudentMenu extends StatefulWidget {
  const SearchStudentMenu({super.key, required this.searchStudents});

  final Function(String value) searchStudents;

  @override
  State<SearchStudentMenu> createState() => _SearchStudentMenuState();
}

class _SearchStudentMenuState extends State<SearchStudentMenu> {
  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Rechercher un élève",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).textSelectionTheme.selectionColor!,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            labelText: "Rechercher...",
            prefixIcon: Icon(Icons.search_outlined),
          ),
          onChanged: (value) => widget.searchStudents(value),
        ),
        // IconButton(onPressed: () {

        // }, icon: Icon(Icons.group_off_outlined))
      ],
    );
  }
}
