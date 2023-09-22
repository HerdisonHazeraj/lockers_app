import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';

import '../../../../core/theme.dart';

// ignore: must_be_immutable
class AvailableStudentsListWidget extends StatefulWidget {
//liste des élèves dans la page d'attribution

  AvailableStudentsListWidget(
      {super.key,
      required this.studentsListView,
      required this.areAllchecksChecked,
      required this.selectedStudents,
      required this.checkIfWeCanAssignFunction,
      required this.checkIfWeCanAutoAssignFunction});
  List<Student> studentsListView;
  bool areAllchecksChecked;
  List<Student> selectedStudents;

  final VoidCallback checkIfWeCanAssignFunction;
  final VoidCallback checkIfWeCanAutoAssignFunction;

  @override
  State<AvailableStudentsListWidget> createState() =>
      _AvailableStudentsListWidgetState();
}

class _AvailableStudentsListWidgetState
    extends State<AvailableStudentsListWidget> {
  @override
  Widget build(BuildContext context) {
    String suffixeFinder(int) {
      switch (int) {
        case 1:
          return 'ère';
      }

      return 'ème';
    }

    return Expanded(
      child: SizedBox(
        height: 940,
        child: SingleChildScrollView(
          child: widget.studentsListView.isEmpty
              ? const Center(
                  heightFactor: 25,
                  child: Text(
                    'Aucun élève disponible',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: ColorTheme.thirdTextColor),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.studentsListView.length,
                      itemBuilder: (context, index) => Card(
                        child: CheckboxListTile(
                          enabled: widget.studentsListView[index].isEnabled,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: widget.studentsListView[index].isSelected,
                          title: Text(
                              '${widget.studentsListView[index].firstName} ${widget.studentsListView[index].lastName}'),
                          subtitle: Text(
                              '${widget.studentsListView[index].job}  ${widget.studentsListView[index].year.toString() + suffixeFinder(widget.studentsListView[index].year)}'),
                          secondary: Text(
                              '${widget.studentsListView[index].responsable}'),
                          onChanged: (newValue) {
                            setState(() {
                              widget.studentsListView[index].isSelected =
                                  newValue!;

                              // if (newValue == false &&
                              //     widget.areAllchecksChecked) {
                              //   widget.areAllchecksChecked = false;
                              // }

                              if (widget.studentsListView[index].isSelected) {
                                widget.selectedStudents
                                    .add(widget.studentsListView[index]);
                              } else {
                                widget.selectedStudents
                                    .remove(widget.studentsListView[index]);
                                widget.areAllchecksChecked = false;
                              }

                              widget.checkIfWeCanAssignFunction();
                              widget.checkIfWeCanAutoAssignFunction();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
