import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/core/components/modal_bottomsheet.dart';
import 'package:lockers_app/screens/mobile/lockers/widget/locker_details_mobile.dart';
import 'package:provider/provider.dart';

import '../../../../models/student.dart';

class LockerItemMobile extends StatefulWidget {
  final Locker locker;
  final bool isLockerInDefectiveList;
  final Function()? refreshList;
  const LockerItemMobile({
    super.key,
    required this.locker,
    required this.isLockerInDefectiveList,
    this.refreshList,
  });

  @override
  State<LockerItemMobile> createState() => _LockerItemMobileState();
}

class _LockerItemMobileState extends State<LockerItemMobile> {
  int indexDeletedLocker = 999999;
  Locker deletedLocker = Locker.base();
  Student student = Student.base();

  List<ListTile> importantList = [
    ListTile(
      title: const Text("Supprimer"),
      onTap: () {},
      trailing: const Icon(Icons.delete_forever_outlined),
    )
  ];

  List<ListTile> standardList = [
    ListTile(
      title: const Text('Ajouter une remarque'),
      onTap: () {},
      trailing: const Icon(Icons.airline_seat_flat_sharp),
    ),
    ListTile(
      title: const Text('Nombre de clés'),
      onTap: () {},
      trailing: const Icon(Icons.key),
    ),
  ];

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

    if (widget.locker.idEleve != "") {
      student = Provider.of<LockerStudentProvider>(context)
          .getStudentByLocker(widget.locker);
    }

    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () async {
          if (widget.locker.idEleve != "") {
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              context: context,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Casier n°${widget.locker.lockerNumber}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 34,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Ce casier appartient actuellement à ${student.firstName} ${student.lastName}. Souhaitez-vous qu'un nouveau casier lui soit attribué ?",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                              ),
                                            ),
                                          ),
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  20),
                                          child: ListTile(
                                            onTap: () async {
                                              await Provider.of<
                                                          LockerStudentProvider>(
                                                      context,
                                                      listen: false)
                                                  .setLockerToInaccessible(
                                                      widget.locker);

                                              await Provider.of<
                                                          LockerStudentProvider>(
                                                      context,
                                                      listen: false)
                                                  .updateStudent(
                                                      student.copyWith(
                                                          lockerNumber: 0));

                                              await Provider.of<
                                                          LockerStudentProvider>(
                                                      context,
                                                      listen: false)
                                                  .autoAttributeOneLocker(
                                                      student);

                                              Student newStudent = await Provider
                                                      .of<LockerStudentProvider>(
                                                          context,
                                                          listen: false)
                                                  .getStudent(student.id!);

                                              Navigator.pop(context);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Le casier n°${widget.locker.lockerNumber} est maintenant inaccessible, celui-ci peut être retrouver dans la catégorie 'Casiers inaccessibles' en bas de page.",
                                                          textAlign: TextAlign
                                                              .center)));

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "L'élève ${newStudent.firstName} ${newStudent.lastName} possède maintenant le casier n°${newStudent.lockerNumber}.")));
                                            },
                                            title: const Text("Oui"),
                                          ),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  20),
                                          child: ListTile(
                                            onTap: () async {
                                              // Mise à jour du casier
                                              await Provider.of<
                                                          LockerStudentProvider>(
                                                      context,
                                                      listen: false)
                                                  .setLockerToInaccessible(
                                                      widget.locker);

                                              // Mise à jour de l'élèves
                                              await Provider.of<
                                                          LockerStudentProvider>(
                                                      context,
                                                      listen: false)
                                                  .updateStudent(
                                                      student.copyWith(
                                                          lockerNumber: 0));

                                              Navigator.pop(context);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Le casier n°${widget.locker.lockerNumber} est maintenant inaccessible, celui-ci peut être retrouver dans la catégorie 'Casiers inaccessibles' en bas de page.",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              );
                                            },
                                            title: const Text("Non"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 0),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      title: const Text("Annuler"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            await Provider.of<LockerStudentProvider>(context, listen: false)
                .setLockerToInaccessible(widget.locker);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Le casier n°${widget.locker.lockerNumber} est maintenant inaccessible, celui-ci peut être retrouver dans la catégorie 'Casiers inaccessibles' en bas de page.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }),
        children: [
          SlidableAction(
            onPressed: (context) {
              ModalBottomSheetWidget(
                context,
                standardList,
                importantList,
                "Casier n°${widget.locker.lockerNumber}",
              );
            },
            icon: Icons.more_horiz_outlined,
            label: "Options",
            backgroundColor: Colors.black54,
          ),
          SlidableAction(
            onPressed: (context) async {
              if (widget.locker.idEleve != "") {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Casier n°${widget.locker.lockerNumber}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    size: 34,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Ce casier appartient actuellement à ${student.firstName} ${student.lastName}. Souhaitez-vous qu'un nouveau casier lui soit attribué ?",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                  ),
                                                ),
                                              ),
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2 -
                                                          20),
                                              child: ListTile(
                                                onTap: () async {
                                                  await Provider.of<
                                                              LockerStudentProvider>(
                                                          context,
                                                          listen: false)
                                                      .setLockerToInaccessible(
                                                          widget.locker);

                                                  await Provider.of<
                                                              LockerStudentProvider>(
                                                          context,
                                                          listen: false)
                                                      .updateStudent(
                                                          student.copyWith(
                                                              lockerNumber: 0));

                                                  await Provider.of<
                                                              LockerStudentProvider>(
                                                          context,
                                                          listen: false)
                                                      .autoAttributeOneLocker(
                                                          student);

                                                  Student newStudent =
                                                      await Provider.of<
                                                                  LockerStudentProvider>(
                                                              context,
                                                              listen: false)
                                                          .getStudent(
                                                              student.id!);

                                                  Navigator.pop(context);

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Le casier n°${widget.locker.lockerNumber} est maintenant inaccessible, celui-ci peut être retrouver dans la catégorie 'Casiers inaccessibles' en bas de page.",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)));

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "L'élève ${newStudent.firstName} ${newStudent.lastName} possède maintenant le casier n°${newStudent.lockerNumber}.")));
                                                },
                                                title: const Text("Oui"),
                                              ),
                                            ),
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2 -
                                                          20),
                                              child: ListTile(
                                                onTap: () async {
                                                  // Mise à jour du casier
                                                  await Provider.of<
                                                              LockerStudentProvider>(
                                                          context,
                                                          listen: false)
                                                      .setLockerToInaccessible(
                                                          widget.locker);

                                                  // Mise à jour de l'élèves
                                                  await Provider.of<
                                                              LockerStudentProvider>(
                                                          context,
                                                          listen: false)
                                                      .updateStudent(
                                                          student.copyWith(
                                                              lockerNumber: 0));

                                                  Navigator.pop(context);

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Le casier n°${widget.locker.lockerNumber} est maintenant inaccessible, celui-ci peut être retrouver dans la catégorie 'Casiers inaccessibles' en bas de page.",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                title: const Text("Non"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(height: 0),
                                        ListTile(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          title: const Text("Annuler"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                await Provider.of<LockerStudentProvider>(context, listen: false)
                    .setLockerToInaccessible(widget.locker);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Le casier n°${widget.locker.lockerNumber} est maintenant inaccessible, celui-ci peut être retrouver dans la catégorie 'Casiers inaccessibles' en bas de page.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
            icon: Icons.block_outlined,
            label: "Inaccessible",
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => LockerDetailsScreenMobile(
                locker: widget.locker,
              ),
            ),
          );
        },
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
      ),
    );
  }
}
