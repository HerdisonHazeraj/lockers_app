import 'package:flutter/material.dart';

import '../../../../core/theme.dart';

// ignore: must_be_immutable
class DropDownItemWidget extends StatefulWidget {
  DropDownItemWidget(
      {super.key,
      required this.list,
      required this.controller,
      required this.hintText});

  Map<String, String> list;
  TextEditingController controller;
  String hintText;

  @override
  State<DropDownItemWidget> createState() => _DropDownItemWidgetState();
}

class _DropDownItemWidgetState extends State<DropDownItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField(
            items: widget.list.entries
                .map(
                  (e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                widget.controller.text = value!;
              });
            },
            hint: Text(
              widget.hintText,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
