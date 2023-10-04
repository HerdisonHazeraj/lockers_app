import 'package:flutter/material.dart';

class DropDownMenu extends StatelessWidget {
  const DropDownMenu({
    super.key,
    required this.items,
    required this.defaultItem,
    required this.icon,
    required this.onChanged,
    required this.enabled,
    this.defaultChoosedItem,
    this.focus,
    this.nextFocus,
  });

  final Map<String, String> items;
  final String defaultItem;
  final IconData icon;
  final Function(String?) onChanged;
  final String? defaultChoosedItem;
  final bool enabled;
  final FocusNode? focus;
  final FocusNode? nextFocus;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      onSaved: (v) {
        FocusScope.of(context).requestFocus(nextFocus);
      },
      focusNode: focus,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez remplir ce champ';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
      ),
      hint: Text(
        defaultItem,
      ),
      iconSize: 36,
      icon: Icon(
        Icons.arrow_drop_down_outlined,
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
      onChanged: enabled ? onChanged : null,
    );
  }
}
