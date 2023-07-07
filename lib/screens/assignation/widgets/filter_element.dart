// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

//affichage d'un élément de filtre

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

  Map<dynamic, String> dropDownList;
  List selectedFilters;
  String filterName;
  String filterNod;
  IconData icon;

  @override
  State<FilterElement> createState() => _FilterElementState();
}

class _FilterElementState extends State<FilterElement> {
  List selectedFiltersMap = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 30.0),
      width: MediaQuery.of(context).size.width * 0.3,
      child: DropDownMultiSelect(
        onChanged: (value) {
          setState(() {
            widget.keys.clear();
            for (var i = 0; i < value.length; i++) {
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
          icon: Icon(widget.icon),
        ),
      ),
    );
  }
}
