import 'package:flutter/material.dart';
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
  int indexDeletedLocker = 999999;
  Locker deletedLocker = Locker.base();
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (event) => setState(() {
        widget.locker.isFocus = false;
      }),
      onEnter: (event) => setState(() {
        widget.locker.isFocus = false;
      }),
      onHover: (event) => setState(() {
        widget.locker.isFocus = true;
      }),
      child: ListTile(
        enabled: widget.locker.isInaccessible == false ? true : false,
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
        trailing: widget.locker.isInaccessible == true
            ? Visibility(
                visible: widget.locker.isFocus,
                child: IconButton(
                  onPressed: () {
                    widget.locker.isAvailable = true;
                    widget.locker.isInaccessible = false;
                    Provider.of<LockerStudentProvider>(context, listen: false)
                        .updateLocker(widget.locker);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Le casier n°${widget.locker.lockerNumber} est de nouveau accessible !",
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  tooltip: "Rendre ce casier à nouveau accessible",
                  icon: const Icon(
                    Icons.switch_access_shortcut_add_outlined,
                    color: Colors.black,
                  ),
                ),
              )
            : Visibility(
                visible: widget.locker.isFocus,
                child: Wrap(
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (widget.locker.isAvailable == false) {
                          Student owner = Provider.of<LockerStudentProvider>(
                                  context,
                                  listen: false)
                              .getStudentByLocker(widget.locker);
                          await showDialog(
                              context: context,
                              builder: (builder) {
                                return AlertDialog(
                                  title: const Text('Attention !'),
                                  content: Text(
                                      "Ce casier appartient actuellement à '${owner.firstName} ${owner.lastName}', voulez-vous qu'un nouveau casier lui soit attribué ?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Non'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        // Mettre en place que celui qui possède le casier en reçoit un nouveau
                                      },
                                      child: const Text('Confirmer'),
                                    ),
                                  ],
                                );
                              });
                          Provider.of<LockerStudentProvider>(context,
                                  listen: false)
                              .updateStudent(owner.copyWith(lockerNumber: 0));
                        }

                        widget.locker.isAvailable = false;
                        widget.locker.isInaccessible = true;
                        Provider.of<LockerStudentProvider>(context,
                                listen: false)
                            .updateLocker(widget.locker);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Le casier n°${widget.locker.lockerNumber} est maintenant inaccessible, celui-ci peut être retrouver dans la catégorie 'Casiers inaccessibles' en bas de page !",
                            ),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      },
                      tooltip: "Rendre le casier indisponible",
                      icon: const Icon(
                        Icons.block_outlined,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      tooltip: "Ajouter une remarque",
                      icon: const Icon(
                        Icons.add_comment_outlined,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (widget.locker.isAvailable == false) {
                          Student owner = Provider.of<LockerStudentProvider>(
                                  context,
                                  listen: false)
                              .getStudentByLocker(widget.locker);
                          await showDialog(
                              context: context,
                              builder: (builder) {
                                return AlertDialog(
                                  title: const Text('Attention !'),
                                  content: Text(
                                      "Ce casier appartient actuellement à '${owner.firstName} ${owner.lastName}', voulez-vous qu'un nouveau casier lui soit attribué ?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Non'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        // Mettre en place que celui qui possède le casier en reçoit un nouveau
                                      },
                                      child: const Text('Confirmer'),
                                    ),
                                  ],
                                );
                              });
                          Provider.of<LockerStudentProvider>(context,
                                  listen: false)
                              .updateStudent(owner.copyWith(lockerNumber: 0));
                        }

                        // Suppression avec une snackbar qui permet de cancel la suppression
                        Locker locker = widget.locker;
                        indexDeletedLocker = Provider.of<LockerStudentProvider>(
                                context,
                                listen: false)
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
                                  await Provider.of<LockerStudentProvider>(
                                          context,
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
              ),
      ),
    );
  }
}
