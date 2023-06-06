import 'package:flutter/material.dart';
import 'package:lockers_app/screens/students/student_details_screen.dart';

import '../../../models/student.dart';

class StudentItem extends StatefulWidget {
  final Student student;
  final Function()? showUpdateForm;
  const StudentItem({this.showUpdateForm, required this.student, super.key});

  @override
  State<StudentItem> createState() => _StudentItemState();
}

class _StudentItemState extends State<StudentItem> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(
          () {
            widget.student.isFocus = true;
          },
        );
      },
      onExit: (event) {
        setState(
          () {
            widget.student.isFocus = false;
          },
        );
      },
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            StudentDetailsScreen.routeName,
            arguments: widget.student.id,
          );
        },
        leading: Image.asset('assets/images/photoprofil.png'),
        title: Text("${widget.student.firstName} ${widget.student.lastName}"),
        subtitle: Text(widget.student.job),
        trailing: IconButton(
          onPressed: () {},
          icon: Visibility(
              visible: widget.student.isFocus, child: const Icon(Icons.edit)),
        ),
      ),
    );
  }
}
