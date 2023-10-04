import 'package:flutter/material.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

class Shared {
  List<DataRow> createTableDataRows(
      BuildContext context, firstList, secondList, bool locker) {
    late List list;

    if (locker) {
      list = [
        'lockerNumber',
        'lockNumber',
        'floor',
        'nbKey',
        'remark',
        'isAvailable',
        'isInaccessible'
      ];
    } else {
      list = [
        'caution',
        'classe',
        'firstName',
        'isArchived',
        'job',
        'lastName',
        'login',
        'manager',
        'year',
      ];
    }
    List modifications =
        Provider.of<LockerStudentProvider>(context, listen: false)
            .getModificationsOldNewList(firstList, secondList, list);
    return [
      // for (var i = 0; i < list.length; i++)
      //   DataRow(cells: [
      //     // DataCell(Text(changeText(list[i]))),0
      //     DataCell(Text(firstList[list[i]].toString())),
      //     DataCell(Text(secondList[list[i]].toString())),
      //   ]),

      for (var i = 0; i < modifications.length; i += 2)
        DataRow(cells: [
          // DataCell(Text(changeText(list[i]))),0
          DataCell(
            Text(modifications[i].toString()),
          ),
          DataCell(Text(modifications[i + 1].toString())),
        ]),
    ];
  }

  String changeText(String text) {
    switch (text) {
      case 'lockerNumber':
        return 'N° Casier';
      case 'lockNumber':
        return 'N° Serrure';
      case 'floor':
        return 'Étage';
      case 'nbKey':
        return 'Nb de clés';
      case 'remark':
        return 'Remarque';
      case 'firstName':
        return 'Prénom';
      case 'lastName':
        return 'Nom';
      case 'classe':
        return 'Classe';
      case 'job':
        return 'Métier';
      case 'year':
        return 'Année';
      case 'login':
        return 'Login';
      case 'manager':
        return 'Responsable';
      case 'caution':
        return 'Caution';
      default:
        return '-';
    }
  }

  void methodInaccessibleOrDeleteLocker(BuildContext context, Locker locker,
      bool isForDelete, bool inDetails) async {
    if (locker.idEleve != "") {
      Student student =
          Provider.of<LockerStudentProvider>(context, listen: false)
              .getStudentByLocker(locker);

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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Casier n°${locker.lockerNumber}',
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
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Colors.grey.withOpacity(0.2),
                                        ),
                                      ),
                                    ),
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20),
                                    child: ListTile(
                                      onTap: () async {
                                        if (isForDelete) {
                                          await Provider.of<
                                                      LockerStudentProvider>(
                                                  context,
                                                  listen: false)
                                              .deleteLocker(
                                                  locker.id.toString());
                                        } else {
                                          await Provider.of<
                                                      LockerStudentProvider>(
                                                  context,
                                                  listen: false)
                                              .setLockerToInaccessible(locker);
                                        }

                                        await Provider.of<
                                                    LockerStudentProvider>(
                                                context,
                                                listen: false)
                                            .updateStudent(
                                                student.copyWith(
                                                    lockerNumber: 0),
                                                historic: false);

                                        await Provider.of<
                                                    LockerStudentProvider>(
                                                context,
                                                listen: false)
                                            .autoAttributeOneLocker(student);

                                        Student newStudent = await Provider.of<
                                                    LockerStudentProvider>(
                                                context,
                                                listen: false)
                                            .getStudent(student.id!);

                                        Navigator.pop(context);
                                        if (isForDelete) Navigator.pop(context);
                                        if (inDetails) Navigator.pop(context);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: isForDelete
                                                    ? Text(
                                                        "Le casier n°${locker.lockerNumber} a bien été supprimé.")
                                                    : Text(
                                                        "Le casier n°${locker.lockerNumber} est maintenant inaccessible, celui-ci peut être retrouver dans la catégorie 'Casiers inaccessibles' en bas de page.")));

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
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20),
                                    child: ListTile(
                                      onTap: () async {
                                        // Mise à jour du casier
                                        if (isForDelete) {
                                          await Provider.of<
                                                      LockerStudentProvider>(
                                                  context,
                                                  listen: false)
                                              .deleteLocker(
                                                  locker.id.toString());
                                        } else {
                                          await Provider.of<
                                                      LockerStudentProvider>(
                                                  context,
                                                  listen: false)
                                              .setLockerToInaccessible(locker);
                                        }
                                        // Mise à jour de l'élèves
                                        await Provider.of<
                                                    LockerStudentProvider>(
                                                context,
                                                listen: false)
                                            .updateStudent(student.copyWith(
                                                lockerNumber: 0));

                                        Navigator.pop(context);
                                        if (isForDelete) Navigator.pop(context);
                                        if (inDetails) Navigator.pop(context);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: isForDelete
                                                    ? Text(
                                                        "Le casier n°${locker.lockerNumber} a bien été supprimé.")
                                                    : Text(
                                                        "Le casier n°${locker.lockerNumber} est maintenant inaccessible, celui-ci peut être retrouver dans la catégorie 'Casiers inaccessibles' en bas de page.")));
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
      if (isForDelete) {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
          context: context,
          builder: (_) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Casier n°${locker.lockerNumber}',
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
                          const Text(
                            "Êtes-vous sûre de vouloir supprimer ce casier ?",
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width /
                                                  2 -
                                              20),
                                  child: ListTile(
                                    onTap: () async {
                                      if (locker.idEleve != 0 &&
                                          locker.idEleve != "") {
                                        Student student = await Provider.of<
                                                    LockerStudentProvider>(
                                                context,
                                                listen: false)
                                            .getStudent(
                                                locker.idEleve.toString());
                                        await Provider.of<
                                                    LockerStudentProvider>(
                                                context,
                                                listen: false)
                                            .updateStudent(student.copyWith(
                                          lockerNumber: 0,
                                        ));
                                      }

                                      await Provider.of<LockerStudentProvider>(
                                              context,
                                              listen: false)
                                          .deleteLocker(locker.id.toString());

                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      if (inDetails)
                                        Navigator.of(context).pop();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Le casier n°${locker.lockerNumber} a bien été supprimé.")));
                                    },
                                    title: const Text("Oui"),
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width /
                                                  2 -
                                              20),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    title: const Text("Annuler"),
                                  ),
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
        // await Provider.of<LockerStudentProvider>(context, listen: false)
        //     .deleteLocker(locker.id.toString());

        // Navigator.pop(context);
        // if (inDetails) Navigator.pop(context);
      } else {
        await Provider.of<LockerStudentProvider>(context, listen: false)
            .setLockerToInaccessible(locker);
      }

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: isForDelete
      //         ? Text("Le casier n°${locker.lockerNumber} a bien été supprimé.")
      //         : Text(
      //             "Le casier n°${locker.lockerNumber} est maintenant inaccessible, celui-ci peut être retrouver dans la catégorie 'Casiers inaccessibles' en bas de page.")));
    }
  }

  void methodArchivedOrDeleteStudent(BuildContext context, Student student,
      bool isForDelete, bool inDetails) async {
    if (isForDelete) {
      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        context: context,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${student.firstName} ${student.lastName}',
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
                        const Text(
                          "Êtes-vous sûre de vouloir supprimer cet élève ?",
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                  ),
                                ),
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width / 2 -
                                            20),
                                child: ListTile(
                                  onTap: () async {
                                    if (student.lockerNumber != 0) {
                                      Locker locker = await Provider.of<
                                                  LockerStudentProvider>(
                                              context,
                                              listen: false)
                                          .getLockerByLockerNumber(
                                              student.lockerNumber);
                                      await Provider.of<LockerStudentProvider>(
                                              context,
                                              listen: false)
                                          .updateLocker(locker.copyWith(
                                        idEleve: "",
                                      ));
                                    }

                                    await Provider.of<LockerStudentProvider>(
                                            context,
                                            listen: false)
                                        .deleteStudent(student.id.toString());

                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    if (inDetails) Navigator.of(context).pop();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "L'élève ${student.firstName} ${student.lastName} a bien été supprimé.")));
                                  },
                                  title: const Text("Oui"),
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width / 2 -
                                            20),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  title: const Text("Annuler"),
                                ),
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
      // await Provider.of<LockerStudentProvider>(context, listen: false)
      //     .deleteLocker(locker.id.toString());

      // Navigator.pop(context);
      // if (inDetails) Navigator.pop(context);
    } else {
      await Provider.of<LockerStudentProvider>(context, listen: false)
          .updateStudent(student.copyWith(
              lockerNumber: 0, isArchived: true, isTerminal: false));

      Navigator.of(context).pop();
      if (inDetails) Navigator.of(context).pop();
    }

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: isForDelete
    //         ? Text(
    //             "L'élève ${student.firstName} ${student.lastName} a bien été supprimé.")
    //         : Text(
    //             "L'élève ${student.firstName} ${student.lastName} est maintenant archivé.")));
  }
}
