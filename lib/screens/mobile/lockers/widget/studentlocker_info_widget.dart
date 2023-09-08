import 'package:fluent_ui/fluent_ui.dart';

import '../../../../models/student.dart';

class StudentLockerInfoWidget extends StatelessWidget {
  StudentLockerInfoWidget({super.key, required this.student});
  Student student;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 4,
        shrinkWrap: true,
        crossAxisCount: 2,
        children: [
          RichText(
              text: TextSpan(
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              const TextSpan(text: "Prenom : "),
              TextSpan(
                text: student.firstName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )),
          RichText(
              text: TextSpan(
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              const TextSpan(text: "Nom : "),
              TextSpan(
                text: student.lastName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )),
          RichText(
              text: TextSpan(
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              const TextSpan(text: "Maitre de classe : "),
              TextSpan(
                text: student.responsable,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )),
        ]);
  }
}
