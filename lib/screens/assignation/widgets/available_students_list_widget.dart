import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';

class AvailableStudentsListWidget extends StatefulWidget {
  AvailableStudentsListWidget(
      {super.key,
      required this.studentsListView,
      required this.areAllchecksChecked,
      required this.selectedStudents,
      required this.checkIfWeCanAssignVoid,
      required this.checkIfWeCanAutoAssignVoid});
  List<Student> studentsListView;
  bool areAllchecksChecked;
  List<Student> selectedStudents;

  final VoidCallback checkIfWeCanAssignVoid;
  final VoidCallback checkIfWeCanAutoAssignVoid;

  @override
  State<AvailableStudentsListWidget> createState() =>
      _AvailableStudentsListWidgetState();
}

class _AvailableStudentsListWidgetState
    extends State<AvailableStudentsListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: SingleChildScrollView(
          child: widget.studentsListView.isEmpty
              ? const Center(
                  heightFactor: 50, child: Text('Aucun élève disponible'))
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
                              '${widget.studentsListView[index].firstName}  ${widget.studentsListView[index].lastName}'),
                          subtitle: Text(widget.studentsListView[index].job),
                          onChanged: (newValue) {
                            setState(() {
                              widget.studentsListView[index].isSelected =
                                  newValue!;

                              if (widget.studentsListView[index].isSelected) {
                                widget.selectedStudents
                                    .add(widget.studentsListView[index]);
                              } else {
                                widget.selectedStudents
                                    .remove(widget.studentsListView[index]);
                                widget.areAllchecksChecked = false;
                              }

                              widget.checkIfWeCanAssignVoid();
                              widget.checkIfWeCanAutoAssignVoid();
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
