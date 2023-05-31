import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';

class FilterPopUp extends StatefulWidget {
  FilterPopUp(
      {super.key, required this.availableStudents, required this.event});

  List<Student> availableStudents;

  final VoidCallback event;
  @override
  State<FilterPopUp> createState() => _FilterPopUpState();
}

class _FilterPopUpState extends State<FilterPopUp> {
  final metier = ['OIC', 'ICT', 'ICH'];
  final annee = ['1ère', '2ème', '3ème', '4ème'];
  final responsable = ['JHI'];

  late Map<String, dynamic> options;

  List selectedMetiers = [];
  List selectedAnnees = [];
  List selectedResponsables = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filtres'),
      content: Wrap(
        children: [
          DropDownMultiSelect(
              onChanged: (value) {
                setState(() {
                  selectedMetiers = value;
                });
              },
              selectedValues: selectedMetiers,
              options: metier,
              decoration: InputDecoration(
                labelText: 'Métier: ',
                floatingLabelAlignment: FloatingLabelAlignment.center,
              )),
          DropDownMultiSelect(
              onChanged: (value) {
                setState(() {
                  // options.add('')
                  selectedAnnees = value;
                });
              },
              selectedValues: selectedAnnees,
              options: annee,
              decoration: InputDecoration(
                labelText: 'Année: ',
                floatingLabelAlignment: FloatingLabelAlignment.center,
              )),
          DropDownMultiSelect(
              onChanged: (value) {
                setState(() {
                  selectedResponsables = value;
                });
              },
              selectedValues: selectedResponsables,
              options: responsable,
              decoration: InputDecoration(
                labelText: 'Responsable: ',
                floatingLabelAlignment: FloatingLabelAlignment.center,
              )),
          ElevatedButton(
              onPressed: () {
                widget.event();
                Navigator.pop(context);
              },
              child: Text('Confirmer'))
        ],
      ),
    );
  }
}
