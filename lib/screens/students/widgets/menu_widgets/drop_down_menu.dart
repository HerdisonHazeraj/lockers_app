import 'package:flutter/material.dart';

class DropDownMenu extends StatelessWidget {
  const DropDownMenu({
    super.key,
    required this.items,
    required this.icon,
    required this.onChanged,
    this.defaultItem,
  });

  final Map<String, String> items;
  final String? defaultItem;
  final IconData icon;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
      ),
      hint: const Text("Choisir..."),
      iconSize: 36,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black54,
      ),
      value: defaultItem,
      isExpanded: true,
      items: items.entries
          .map(
            (e) => DropdownMenuItem(
              value: e.key,
              child: Text(e.value),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
