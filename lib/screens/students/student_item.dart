import 'package:flutter/material.dart';
import 'package:lockers_app/screens/students/student_details_screen.dart';

import '../../models/student.dart';

class StudentItem extends StatelessWidget {
  final Student student;
  const StudentItem(this.student, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          StudentDetailsScreen.routeName,
          arguments: student.id,
        );
      },
      leading: Image.asset('assets/images/photoprofil.png'),
      title: Text("${student.firstName} ${student.lastName}"),
      subtitle: Text(student.job),
    );
  }
}
