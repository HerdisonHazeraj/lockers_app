import 'package:flutter/material.dart';

import '../../../../models/locker.dart';

class LockerInfoWidget extends StatelessWidget {
  LockerInfoWidget({super.key, required this.locker});
  Locker locker;

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
                const TextSpan(text: "N° de Casier : "),
                TextSpan(
                  text: locker.lockerNumber.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ])),
          RichText(
              text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                const TextSpan(text: "N° de Serrure : "),
                TextSpan(
                  text: locker.lockNumber.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ])),
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
                )
              ])),
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
                )
              ])),
          RichText(
              text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                const TextSpan(text: "Métier : "),
                TextSpan(
                  text: locker.job,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ])),
          RichText(
              text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                const TextSpan(text: "Remarque : "),
                TextSpan(
                  text: locker.remark == '' ? 'Aucune' : locker.remark,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ]))
        ]);
  }
}
