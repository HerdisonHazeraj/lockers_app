import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:multiselect/multiselect.dart';
=======
import 'package:lockers_app/providers/lockers_student_provider.dart';
// import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';
>>>>>>> 1d88bebc4e9df91e1b3edb4f171d213795f81a7f

class FilterPopUp extends StatefulWidget {
  const FilterPopUp({super.key});

  @override
  State<FilterPopUp> createState() => _FilterPopUpState();
}

class _FilterPopUpState extends State<FilterPopUp> {
  final metier = ['OIC', 'ICT', 'ICH'];
  final annee = ['1ère', '2ème', '3ème', '4ème'];
  final responsable = ['JHI'];

  late List options = [];

  List selectedMetiers = [];
  List selectedAnnees = [];
  List selectedResponsables = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
<<<<<<< HEAD
      title: const Text('Filtres'),
      content: Wrap(
        children: [
          DropDownMultiSelect(
            onChanged: (value) {
              setState(() {
                options.add(value);
              });
            },
            selectedValues: selectedMetiers,
            options: metier,
            decoration: const InputDecoration(
              labelText: 'Métier: ',
              floatingLabelAlignment: FloatingLabelAlignment.center,
            ),
          ),
          DropDownMultiSelect(
            onChanged: (value) {
              setState(() {
                options.add(value);
              });
            },
            selectedValues: selectedAnnees,
            options: annee,
            decoration: const InputDecoration(
              labelText: 'Année: ',
              floatingLabelAlignment: FloatingLabelAlignment.center,
            ),
          ),
          DropDownMultiSelect(
            onChanged: (value) {
              setState(() {
                options.add(value);
              });
            },
            selectedValues: selectedResponsables,
            options: responsable,
            decoration: const InputDecoration(
              labelText: 'Responsable: ',
              floatingLabelAlignment: FloatingLabelAlignment.center,
            ),
          ),
        ],
      ),
=======
      // title: Text('Filtres'),
      // content: Wrap(
      //   children: [
      //     // DropDownMultiSelect(
      //         // onChanged: (value) {
      //           setState(() {
      //             options.add(value);
      //           });
      //         },
      //         selectedValues: selectedMetiers,
      //         options: metier,
      //         decoration: InputDecoration(
      //           labelText: 'Métier: ',
      //           floatingLabelAlignment: FloatingLabelAlignment.center,
      //         )),
      //     DropDownMultiSelect(
      //         onChanged: (value) {
      //           setState(() {
      //             options.add(value);
      //           });
      //         },
      //         selectedValues: selectedAnnees,
      //         options: annee,
      //         decoration: InputDecoration(
      //           labelText: 'Année: ',
      //           floatingLabelAlignment: FloatingLabelAlignment.center,
      //         )),
      //     DropDownMultiSelect(
      //         onChanged: (value) {
      //           setState(() {
      //             options.add(value);
      //           });
      //         },
      //         selectedValues: selectedResponsables,
      //         options: responsable,
      //         decoration: InputDecoration(
      //           labelText: 'Responsable: ',
      //           floatingLabelAlignment: FloatingLabelAlignment.center,
      //         )),
      //   ],
      // ),
>>>>>>> 1d88bebc4e9df91e1b3edb4f171d213795f81a7f
    );
  }
}
