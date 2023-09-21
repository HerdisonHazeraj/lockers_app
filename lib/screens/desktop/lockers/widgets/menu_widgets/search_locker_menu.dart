import 'package:flutter/material.dart';

import '../../../../../core/theme.dart';

class SearchLockerMenu extends StatefulWidget {
  const SearchLockerMenu({super.key, required this.searchLockers});

  final Function(String value) searchLockers;

  @override
  State<SearchLockerMenu> createState() => _SearchLockerMenuState();
}

class _SearchLockerMenuState extends State<SearchLockerMenu> {
  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Rechercher un casier",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            labelText: "Rechercher...",
            prefixIcon: Icon(
              Icons.search_outlined,
            ),
          ),
          onChanged: (value) => widget.searchLockers(value),
        ),
      ],
    );
  }
}
