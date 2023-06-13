import 'package:flutter/material.dart';

class DropDownMenu extends StatelessWidget {
  const DropDownMenu({
    super.key,
    required this.items,
    required this.defaultItem,
    required this.icon,
    required this.onChanged,
    this.defaultChoosedItem,
  });

  final Map<String, String> items;
  final String defaultItem;
  final IconData icon;
  final Function(String?) onChanged;
  final String? defaultChoosedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
      ),
      hint: Text(defaultItem),
      iconSize: 36,
      icon: const Icon(
        Icons.arrow_drop_down_outlined,
        color: Colors.black54,
      ),
      value: defaultChoosedItem,
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
