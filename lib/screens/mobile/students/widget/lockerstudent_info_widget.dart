import 'package:flutter/material.dart';

import '../../../../models/locker.dart';

class LockerStudentInfoWidget extends StatelessWidget {
  LockerStudentInfoWidget({super.key, required this.locker});
  Locker locker;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 4,
      scrollDirection: Axis.vertical,
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
              const TextSpan(text: "N° de Casier : "),
              TextSpan(
                text: locker.lockerNumber.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              const TextSpan(text: "Étage : "),
              TextSpan(
                text: locker.floor.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              const TextSpan(text: "Nombre de clés : "),
              TextSpan(
                text: locker.nbKey.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
