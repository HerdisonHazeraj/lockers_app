import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

// ignore: must_be_immutable
class FilterElement extends StatefulWidget {
  FilterElement(
      {super.key,
      required this.keys,
      required this.dropDownList,
      required this.selectedFilters,
      required this.filterName,
      required this.filterNod,
      required this.icon});

  List keys;

  List dropDownList;
  List selectedFilters;
  String filterName;
  String filterNod;
  IconData icon;

  @override
  State<FilterElement> createState() => _FilterElementState();
}

class _FilterElementState extends State<FilterElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 30.0),
      width: MediaQuery.of(context).size.width * 0.3,
      child: DropDownMultiSelect(
          onChanged: (value) {
            setState(() {
              widget.keys.clear();
              for (var v in value) {
                widget.keys.add(widget.filterNod);
              }
            });
          },
          selectedValues: widget.selectedFilters,
          options: widget.dropDownList,
          decoration: InputDecoration(
              labelText: widget.filterName,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              contentPadding: const EdgeInsets.only(
                  left: 35.0, top: 10.0, right: 10.0, bottom: 10.0),
              floatingLabelAlignment: FloatingLabelAlignment.center,
              icon: Icon(widget.icon))),
    );
  }
}
