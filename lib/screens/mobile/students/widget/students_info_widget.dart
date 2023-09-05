import 'package:flutter/material.dart';

import '../../../../models/student.dart';

class StudentsInfo extends StatelessWidget {
  StudentsInfo({super.key, required this.student});
  Student student;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 4,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: [
        Text("Prenom : ${student.firstName}"),
        Text("Nom : ${student.lastName}"),
        Text("Login : ${student.login}"),
        Text(
            "Mail : ${student.firstName.trim()}.${student.lastName.trim()}@ceff.ch"),
        Text("Classe : ${student.classe}"),
        Text("Année : ${student.year}e"),
        Text("Formation : ${student.job}"),
        Text("Maître de classe : ${student.responsable}"),
      ],
    );
  }
}
