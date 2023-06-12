import 'package:flutter/material.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

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
  int indexDeletedLocker = 999999;
  Locker deletedLocker = Locker.base();
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
        leading: Icon(
          widget.locker.isAvailable == true
              ? Icons.lock_open_outlined
              : Icons.lock_outlined,
          color: Colors.black,
          size: 40,
        ),
        title: Text(
          'Casier n°${widget.locker.lockerNumber}',
        ),
        subtitle: widget.locker.remark == ''
            ? const Text('Aucune remarque')
            : Text(widget.locker.remark),
        trailing: Visibility(
          visible: widget.locker.isFocus,
          child: Wrap(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.info_outlined,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () async {
                  // Suppression avec une snackbar qui permet de cancel la suppression
                  Locker locker = widget.locker;
                  indexDeletedLocker =
                      Provider.of<LockerStudentProvider>(context, listen: false)
                          .findIndexOfLockerById(locker.id!);
                  deletedLocker = locker;

                  await Provider.of<LockerStudentProvider>(context,
                          listen: false)
                      .deleteLocker(locker.id!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Le casier n°${locker.lockerNumber} a bien été supprimé !",
                      ),
                      duration: const Duration(seconds: 3),
                      action: SnackBarAction(
                          label: "Annuler",
                          onPressed: () async {
                            await Provider.of<LockerStudentProvider>(context,
                                    listen: false)
                                .insertLocker(
                              indexDeletedLocker,
                              deletedLocker,
                            );

                            widget.refreshList!();

                            locker.isFocus = false;
                          }),
                    ),
                  );

                  // Suppression avec une boite de dialogue qui permet de confirmer
                  // showDialog(
                  //   context: context,
                  //   builder: (context) {
                  //     return AlertDialog(
                  //       title: const Text('Supprimer un casier'),
                  //       content: Text(
                  //           'Êtes-vous sûr de vouloir supprimer le casier n°${widget.locker.lockerNumber} ?'),
                  //       actions: [
                  //         TextButton(
                  //           onPressed: () {
                  //             Navigator.of(context).pop();
                  //           },
                  //           child: const Text('Annuler'),
                  //         ),
                  //         TextButton(
                  //           onPressed: () {
                  //             Provider.of<LockerStudentProvider>(context,
                  //                     listen: false)
                  //                 .deleteLocker(widget.locker.id!);
                  //             Navigator.of(context).pop();
                  //             widget.refreshList!();
                  //           },
                  //           child: const Text('Supprimer'),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // );
                },
                tooltip: "Supprimer le casier",
                icon: const Icon(
                  Icons.delete_outlined,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          // child: IconButton(
          //   onPressed: widget.locker.isAvailable!
          //       ? () {}
          //       : () {
          //           Student student = Provider.of<LockerStudentProvider>(
          //                   context,
          //                   listen: false)
          //               .getStudent(widget.locker.idEleve!);

          //           Provider.of<LockerStudentProvider>(context, listen: false)
          //               .updateStudent(student.copyWith(
          //             lockerNumber: 0,
          //           ));
          //           Provider.of<LockerStudentProvider>(context, listen: false)
          //               .updateLocker(widget.locker.copyWith(
          //             idEleve: "",
          //             isAvailable: true,
          //           ));

          //           ScaffoldMessenger.of(context).showSnackBar(
          //             SnackBar(
          //               content: Text(
          //                 'Le casier ${widget.locker.lockerNumber} a été désattribué à ${student.firstName} ${student.lastName} avec succès !',
          //               ),
          //               duration: const Duration(seconds: 3),
          //             ),
          //           );
          //         },
          //   icon: SvgPicture.asset(
          //     'assets/icons/remove_user.svg',
          //     height: 24,
          //     color: widget.locker.isAvailable! ? Colors.grey : Colors.black,
          //   ),
          //   tooltip: 'Désattribuer',
          // ),
        ),
      ),
    );
  }
}
