import 'package:flutter/material.dart';

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
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
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
          hint: Text(widget.hintText),
        ),
      ),
    );
  }
}
