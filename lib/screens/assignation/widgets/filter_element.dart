import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class FilterElement extends StatefulWidget {
  FilterElement(
      {super.key,
      required this.keys,
      required this.dropDownList,
      required this.selectedFilters,
      required this.filterName,
      required this.filterNod});

  List keys;

  List dropDownList;
  List selectedFilters;
  String filterName;
  String filterNod;

  @override
  State<FilterElement> createState() => _FilterElementState();
}

class _FilterElementState extends State<FilterElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 30.0, left: 30.0),
      width: MediaQuery.of(context).size.width * 0.36,
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
            floatingLabelAlignment: FloatingLabelAlignment.center,
          )),
    );
  }
}
