import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

import '../../models/student.dart';
import 'locker_details_screen.dart';

class LockerItem extends StatelessWidget {
  final Locker locker;
  const LockerItem(this.locker, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          LockerDetailsScreen.routeName,
          arguments: locker.id,
        );
      },
      leading: CircleAvatar(
        backgroundColor: locker.isAvailable! ? Colors.green : Colors.red,
        child: Text(
          locker.lockerNumber.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        'Étage ${locker.floor.toUpperCase()}',
      ),
      subtitle: locker.remark == ''
          ? const Text(
              '-',
            )
          : Text(
              locker.remark,
            ),
      trailing: IconButton(
        onPressed: locker.isAvailable!
            ? () {}
            : () {
                Student student =
                    Provider.of<LockerStudentProvider>(context, listen: false)
                        .getStudent(locker.idEleve!);

                Provider.of<LockerStudentProvider>(context, listen: false)
                    .updateStudent(student.copyWith(
                  lockerNumber: 0,
                ));
                Provider.of<LockerStudentProvider>(context, listen: false)
                    .updateLocker(locker.copyWith(
                  idEleve: "",
                  isAvailable: true,
                ));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Le casier ${locker.lockerNumber} a été désattribué à ${student.firstName} ${student.lastName} avec succès !',
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
        icon: SvgPicture.asset(
          'assets/icons/remove_user.svg',
          height: 24,
          color: locker.isAvailable! ? Colors.grey : Colors.black,
        ),
        tooltip: 'Désattribuer',
      ),
    );
  }
}
