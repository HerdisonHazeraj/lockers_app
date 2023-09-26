import 'package:flutter/material.dart';
import 'package:lockers_app/models/history.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/responsive.dart';
import 'package:lockers_app/screens/mobile/lockers/widget/locker_details_mobile.dart';
import 'package:provider/provider.dart';

import '../../../../models/student.dart';

class LockerItem extends StatefulWidget {
  final Locker locker;
  final bool isLockerInDefectiveList;
  final Function()? showUpdateForm;
  final Function()? refreshList;
  const LockerItem({
    super.key,
    required this.locker,
    required this.isLockerInDefectiveList,
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
    desattributeLockerAndStudent(Student owner, Locker locker) async {
      await Provider.of<LockerStudentProvider>(context, listen: false)
          .updateStudent(owner.copyWith(lockerNumber: 0));

      widget.locker.isAvailable = false;
      widget.locker.isInaccessible = true;

      Provider.of<LockerStudentProvider>(context, listen: false)
          .updateLocker(widget.locker);
    }

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
        onTap: Responsive.isMobile(context)
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        LockerDetailsScreenMobile(
                      locker: widget.locker,
                    ),
                  ),
                );
              }
            : null,
        enabled: widget.locker.isInaccessible == false ? true : false,
        leading: widget.locker.isDefective == true
            ? const Icon(
                Icons.lock_outlined,
                color: Colors.orange,
                size: 40,
              )
            : widget.locker.isAvailable == true
                ? const Icon(
                    Icons.lock_open_outlined,
                    color: Colors.green,
                    size: 40,
                  )
                : const Icon(
                    Icons.lock_outlined,
                    color: Colors.red,
                    size: 40,
                  ),
        title: Text(
          'Casier n°${widget.locker.lockerNumber}',
        ),
        subtitle: widget.locker.isDefective == true
            ? widget.locker.nbKey < 2 && widget.locker.remark == ""
                ? Text(
                    'Le casier ne possède plus que ${widget.locker.nbKey} clé(s)',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : widget.locker.remark != "" && widget.locker.nbKey < 2
                    ? Text(
                        '${widget.locker.remark} et ne possède plus que ${widget.locker.nbKey} clé(s)',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        widget.locker.remark,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
            : const Text(
                'Aucune remarque',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
        trailing: Responsive.isDesktop(context)
            ? widget.locker.isInaccessible == true
                ? Visibility(
                    visible: widget.locker.isFocus,
                    child: IconButton(
                      onPressed: () {
                        widget.locker.isAvailable = true;
                        widget.locker.isInaccessible = false;
                        Provider.of<LockerStudentProvider>(context,
                                listen: false)
                            .updateLocker(widget.locker);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Le casier n°${widget.locker.lockerNumber} est à nouveau accessible !",
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      tooltip: "Rendre ce casier à nouveau accessible",
                      icon: Icon(
                        Icons.switch_access_shortcut_add_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  )
                : Visibility(
                    visible: widget.locker.isFocus,
                    child: Wrap(
                      children: [
                        widget.isLockerInDefectiveList
                            ? Wrap(children: [
                                widget.locker.nbKey < 2
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() async {
                                            await Provider.of<
                                                        LockerStudentProvider>(
                                                    context,
                                                    listen: false)
                                                .setLockerToUnDefectiveKeys(
                                                    widget.locker);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Le casier n°${widget.locker.lockerNumber} a bien été mis à jour !",
                                                ),
                                                duration:
                                                    const Duration(seconds: 2),
                                              ),
                                            );
                                            widget.refreshList!();
                                          });
                                        },
                                        tooltip: "Rajouter les clés manquantes",
                                        icon: Icon(
                                          Icons.vpn_key_outlined,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                      )
                                    : const Text(''),
                                widget.locker.remark != ''
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() async {
                                            await Provider.of<
                                                        LockerStudentProvider>(
                                                    context,
                                                    listen: false)
                                                .setLockerToUnDefectiveRemarks(
                                                    widget.locker);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                "Le casier n°${widget.locker.lockerNumber} a bien été mis à jour !",
                                              ),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ));
                                            widget.refreshList!();
                                          });
                                        },
                                        tooltip: "Supprimer la remarque",
                                        icon: Icon(
                                          Icons.task_alt_outlined,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ))
                                    : const Text('')
                              ])
                            : const Text(''),
                        IconButton(
                          onPressed: () async {
                            if (widget.locker.isAvailable == false) {
                              Student owner =
                                  Provider.of<LockerStudentProvider>(context,
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
                                            desattributeLockerAndStudent(
                                                owner, widget.locker);

                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Non'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            desattributeLockerAndStudent(
                                                owner, widget.locker);

                                            Provider.of<LockerStudentProvider>(
                                                    context,
                                                    listen: false)
                                                .autoAttributeOneLocker(owner);

                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Confirmer'),
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              widget.locker.isAvailable = false;
                              widget.locker.isInaccessible = true;

                              Provider.of<LockerStudentProvider>(context,
                                      listen: false)
                                  .updateLocker(widget.locker);
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Le casier n°${widget.locker.lockerNumber} est maintenant inaccessible, celui-ci peut être retrouver dans la catégorie 'Casiers inaccessibles' en bas de page !",
                                ),
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          },
                          tooltip: "Rendre le casier inaccessible",
                          icon: Icon(
                            Icons.block_outlined,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (widget.locker.isAvailable == false) {
                              Student owner =
                                  Provider.of<LockerStudentProvider>(context,
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
                                          },
                                          child: const Text('Confirmer'),
                                        ),
                                      ],
                                    );
                                  });
                              Provider.of<LockerStudentProvider>(context,
                                      listen: false)
                                  .updateStudent(
                                      owner.copyWith(lockerNumber: 0));
                            }

                            // Suppression avec une snackbar qui permet de cancel la suppression
                            // Locker locker = widget.locker;
                            // Student updatedStudent = Student.base();
                            // if (locker.isAvailable == false) {
                            //   updatedStudent = Provider.of<LockerStudentProvider>(
                            //           context,
                            //           listen: false)
                            //       .getStudentByLocker(locker);
                            // }
                            // indexDeletedLocker = Provider.of<LockerStudentProvider>(
                            //         context,
                            //         listen: false)
                            //     .findIndexOfLockerById(locker.id!);
                            // deletedLocker = locker;

                            // await Provider.of<LockerStudentProvider>(context,
                            //         listen: false)
                            //     .deleteLocker(locker.id!);

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text(
                            //       "Le casier n°${locker.lockerNumber} a bien été supprimé !",
                            //     ),
                            //     duration: const Duration(seconds: 3),
                            //     action: SnackBarAction(
                            //         label: "Annuler",
                            //         onPressed: () async {
                            //           await Provider.of<LockerStudentProvider>(
                            //                   context,
                            //                   listen: false)
                            //               .insertLocker(
                            //             indexDeletedLocker,
                            //             deletedLocker,
                            //           );

                            //           if (deletedLocker.isAvailable == false) {
                            //             Provider.of<LockerStudentProvider>(context,
                            //                     listen: false)
                            //                 .updateStudent(updatedStudent.copyWith(
                            //                     lockerNumber:
                            //                         deletedLocker.lockerNumber));
                            //           }

                            //           widget.refreshList!();

                            //           locker.isFocus = false;
                            //         }),
                            //   ),
                            // );

                            // Suppression avec une boite de dialogue qui permet de confirmer
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Supprimer un casier'),
                                  content: Text(
                                      'Êtes-vous sûr de vouloir supprimer le casier n°${widget.locker.lockerNumber} ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Annuler'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await Provider.of<
                                                    LockerStudentProvider>(
                                                context,
                                                listen: false)
                                            .deleteLocker(widget.locker.id!);
                                        Provider.of<HistoryProvider>(context,
                                                listen: false)
                                            .addHistory(History(
                                          date: DateTime.now().toString(),
                                          action: "delete",
                                          locker: widget.locker.toJson(),
                                          index: Provider.of<
                                                      LockerStudentProvider>(
                                                  context,
                                                  listen: false)
                                              .findIndexOfLockerById(
                                                  widget.locker.id!),
                                        ));
                                        widget.refreshList!();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Supprimer'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          tooltip: "Supprimer le casier",
                          icon: const Icon(
                            Icons.delete_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )
            : Icon(
                Icons.more_vert,
              ),
      ),
    );
  }
}
