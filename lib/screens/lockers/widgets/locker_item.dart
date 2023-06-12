import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/student.dart';

class LockerItem extends StatefulWidget {
  final Locker locker;
  final Function()? showUpdateForm;
  final Function()? refreshList;
  const LockerItem({
    super.key,
    required this.locker,
    this.refreshList,
    this.showUpdateForm,
  });

  @override
  State<LockerItem> createState() => _LockerItemState();
}

class _LockerItemState extends State<LockerItem> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(
          () {
            widget.locker.isFocus = true;
          },
        );
      },
      onExit: (event) {
        setState(
          () {
            widget.locker.isFocus = false;
          },
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              widget.locker.isAvailable! ? Colors.green : Colors.red,
          child: Text(
            widget.locker.lockerNumber.toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          'Étage ${widget.locker.floor.toUpperCase()}',
        ),
        subtitle: widget.locker.remark == ''
            ? const Text(
                '-',
              )
            : Text(
                widget.locker.remark,
              ),
        trailing: Visibility(
          visible: widget.locker.isFocus,
          child: IconButton(
            onPressed: widget.locker.isAvailable!
                ? () {}
                : () {
                    Student student = Provider.of<LockerStudentProvider>(
                            context,
                            listen: false)
                        .getStudent(widget.locker.idEleve!);

                    Provider.of<LockerStudentProvider>(context, listen: false)
                        .updateStudent(student.copyWith(
                      lockerNumber: 0,
                    ));
                    Provider.of<LockerStudentProvider>(context, listen: false)
                        .updateLocker(widget.locker.copyWith(
                      idEleve: "",
                      isAvailable: true,
                    ));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Le casier ${widget.locker.lockerNumber} a été désattribué à ${student.firstName} ${student.lastName} avec succès !',
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
            icon: SvgPicture.asset(
              'assets/icons/remove_user.svg',
              height: 24,
              color: widget.locker.isAvailable! ? Colors.grey : Colors.black,
            ),
            tooltip: 'Désattribuer',
          ),
        ),
      ),
    );
  }
}
