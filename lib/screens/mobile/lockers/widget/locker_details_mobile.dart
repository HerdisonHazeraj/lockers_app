import 'package:flutter/material.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/core/components/modal_bottomsheet.dart';
import 'package:lockers_app/screens/mobile/core/shared.dart';
import 'package:lockers_app/screens/mobile/lockers/widget/locker_info_widget.dart';
import 'package:lockers_app/screens/mobile/lockers/widget/studentlocker_info_widget.dart';
import 'package:lockers_app/screens/mobile/students/widget/student_details_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LockerDetailsScreenMobile extends StatefulWidget {
  LockerDetailsScreenMobile({super.key, required this.locker});
  Locker locker;
  @override
  State<LockerDetailsScreenMobile> createState() =>
      _LockerDetailsScreenMobileState();
}

class _LockerDetailsScreenMobileState extends State<LockerDetailsScreenMobile> {
  Shared shared = Shared();
  List<bool> ExpList = [false, false, true];
  bool isInit = false;
  late int nbKey;
  late final TextEditingController remarkController =
      TextEditingController(text: widget.locker.remark);
  bool showTextFormField = false;
  @override
  Widget build(BuildContext context) {
    late Student student;
    if (widget.locker.idEleve != "") {
      student = Provider.of<LockerStudentProvider>(context, listen: false)
          .getStudentByLocker(widget.locker);
    } else {
      student = Student.error();
    }

    if (!isInit) {
      nbKey = widget.locker.nbKey;
      isInit = true;
    }

    List<ListTile> importantList = [
      ListTile(
        title: const Text("Supprimer"),
        onTap: () async {
          shared.methodInaccessibleOrDeleteLocker(
              context, widget.locker, true, true);
        },
        trailing: const Icon(Icons.delete_forever_outlined),
      )
    ];

    List<ListTile> standardList = [
      ListTile(
        title: showTextFormField
            ? const Text('Ajouter une remarque')
            : const Text('Ajouter une remarque'),
        onTap: () {
          setState(() {
            showTextFormField = true;
          });
        },
        trailing: showTextFormField
            ? const Text('')
            : const Icon(
                Icons.drive_file_rename_outline_sharp,
                size: 30,
              ),
      ),
      ListTile(
          title: const Text('Nombre de clés'),
          onTap: () {
            setState(() {
              showTextFormField = true;
            });
          },
          trailing: SizedBox(
            width: MediaQuery.of(context).size.width * 0.265,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add,
                  ),
                  onPressed: () {
                    setState(() {
                      nbKey += 1;
                      widget.locker = widget.locker
                          .copyWith(nbKey: widget.locker.nbKey + 1);
                    });
                    Provider.of<LockerStudentProvider>(context, listen: false)
                        .updateLocker(widget.locker);
                  },
                ),
                Text(nbKey.toString()),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      nbKey -= 1;
                      widget.locker = widget.locker
                          .copyWith(nbKey: widget.locker.nbKey - 1);
                    });
                    Provider.of<LockerStudentProvider>(context, listen: false)
                        .updateLocker(widget.locker);
                    // setState(() {
                    //   Provider.of<LockerStudentProvider>(context, listen: false)
                    //       .updateLocker(
                    //     widget.locker.copyWith(nbKey: widget.locker.nbKey - 1),
                    //   );
                    // });
                  },
                ),
              ],
            ),
          )),
    ];
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).iconTheme.color),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.03),
              child: IconButton(
                onPressed: () {
                  ModalBottomSheetWidget(
                    context,
                    standardList,
                    importantList,
                    "Casier n°${widget.locker.lockerNumber}",
                  );

                  // showModalBottomSheet(
                  //   shape: const RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(20),
                  //     topRight: Radius.circular(20),
                  //   )),
                  //   context: context,
                  //   builder: (_) => ModalBottomSheetWidgetTest(
                  //     importantList: importantList,
                  //     standardList: standardList,
                  //     title: "Casier n°${widget.locker.lockerNumber}",
                  //   ),
                  // );
                },
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: Theme.of(context).iconTheme.color,
                  size: 26,
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Text(
              "Casier n°${widget.locker.lockerNumber}",
              style: const TextStyle(fontSize: 20),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
                bottom: MediaQuery.of(context).size.height * 0.02,
              ),
              child: Text(
                "${widget.locker.isAvailable! ? "Disponible" : "Indisponible"}",
                style: TextStyle(
                    fontSize: 16,
                    color:
                        widget.locker.isAvailable! ? Colors.green : Colors.red),
              ),
            ),
            ExpansionPanelList(
              elevation: 0,
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  ExpList[index] = !ExpList[index];
                });
              },
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor: Colors.transparent,
                  headerBuilder: (context, isExpanded) {
                    return Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.01),
                      child: const ListTile(
                          leading: Icon(
                            Icons.person,
                            size: 30,
                          ),
                          title: Text('Informations'),
                          subtitle: Text(
                            'N° de Casier, N° de Serrure, Étage, Nombre de clés, Métier, Remarque',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                    );
                  },
                  body: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: LockerInfoWidget(
                          locker: widget.locker,
                        ),
                      )),
                  isExpanded: ExpList[0],
                ),
                // locker == Locker.error()
                //     ? ExpansionPanel(
                //         headerBuilder: (context, isExpanded) {
                //           return Text("");
                //         },
                //         body: const SizedBox(
                //           height: 0,
                //         ),
                //         isExpanded: ExpList[1],
                //       )
                //     :
                ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor: Colors.transparent,
                  headerBuilder: (context, isExpanded) {
                    return Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.01),
                      child: const ListTile(
                        leading: Icon(Icons.lock, size: 30),
                        title: Text('Locataire du casier'),
                        subtitle: Text('Prénom, Nom, Maitre de classe'),
                      ),
                    );
                  },
                  body: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05),
                        child: Column(
                          children: [
                            widget.locker.idEleve == ""
                                ? const Text(
                                    'Ce casier appartient actuellement à aucun élève')
                                : StudentLockerInfoWidget(student: student),
                            widget.locker.idEleve == ""
                                ? Text('')
                                : TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              StudentDetailsScreenMobile(
                                            student: student,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                        'Accéder au profil de ${student.firstName}'))
                          ],
                        )),
                  ),
                  isExpanded: ExpList[1],
                ),
              ],
            ),
          ]),
        ));
  }
}
