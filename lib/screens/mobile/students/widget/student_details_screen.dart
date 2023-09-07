import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/core/components/modal_bottomsheet.dart';
import 'package:lockers_app/screens/mobile/lockers/widget/locker_details_mobile.dart';
import 'package:lockers_app/screens/mobile/students/widget/lockerstudent_info_widget.dart';
import 'package:lockers_app/screens/mobile/students/widget/students_info_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/locker.dart';
import '../../../../models/student.dart';

class StudentDetailsScreenMobile extends StatefulWidget {
  StudentDetailsScreenMobile({
    super.key,
    required this.student,
  });
  Student student;

  @override
  State<StudentDetailsScreenMobile> createState() =>
      _StudentDetailsScreenMobileState();
}

class _StudentDetailsScreenMobileState
    extends State<StudentDetailsScreenMobile> {
  List<bool> ExpList = [false, false];
  // bool IsLockerDataExp = true;
  @override
  Widget build(BuildContext context) {
    late Locker locker;
    if (widget.student.lockerNumber != 0) {
      locker = Provider.of<LockerStudentProvider>(context, listen: false)
          .getLockerByLockerNumber(widget.student.lockerNumber);
    } else {
      locker = Locker.error();
    }

    List<ListTile> importantList = [
      ListTile(
        title: const Text("Supprimer"),
        onTap: () {},
        trailing: const Icon(Icons.delete_forever_outlined),
      )
    ];

    List<ListTile> standardList = [
      ListTile(
        title: const Text('Changer de casier'),
        onTap: () {},
        trailing: const Icon(
          Icons.lock_reset_outlined,
          size: 30,
        ),
      ),
      ListTile(
        title: const Text('Désattribuer le casier'),
        onTap: () {},
        trailing: const Icon(
          Icons.remove_circle_outline,
          size: 30,
        ),
      ),
    ];

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            // widget.locker.isDefective!
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.03),
              child: IconButton(
                onPressed: () {
                  ModalBottomSheetWidget(
                    context,
                    standardList,
                    importantList,
                    '${widget.student.firstName} ${widget.student.lastName}',
                  );
                },
                icon: const Icon(
                  Icons.more_vert_outlined,
                  color: Colors.black,
                  size: 26,
                ),
              ),
            )
            //  const Text('')
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.25,
              backgroundImage: const AssetImage(
                'assets/images/cp-20ahb.jpg',
              ),
            ),

            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.1),
              child: Text(
                "${widget.student.firstName} ${widget.student.lastName}",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            widget.student.lockerNumber != 0
                ? Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01,
                        bottom: MediaQuery.of(context).size.height * 0.02),
                    child: widget.student.caution == 0
                        ? const Text(
                            'Caution non-payée',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          )
                        : const Text(
                            'Caution payée',
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ))
                : const Text(''),
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
                          title: Text('Données personnelles'),
                          subtitle: Text(
                            'Nom, Prénom, Login, Email, Classe, Année, Formation, Maître de classe',
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
                        child: StudentsInfo(
                          student: widget.student,
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
                        title: Text('Casier de l\'élève'),
                        subtitle: Text('N° de Casier, Étage, Nombre de clés'),
                      ),
                    );
                  },
                  body: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05),
                        child: Column(children: [
                          locker != Locker.error()
                              ? LockerStudentInfoWidget(locker: locker)
                              : const Text(
                                  'L\'élève ne possède pas de casier',
                                  // style: TextStyle(
                                  //     fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                          locker != Locker.error()
                              ? TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            LockerDetailsScreenMobile(
                                          locker: locker,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                      'Accéder au casier de ${widget.student.firstName}'))
                              : Text(''),
                        ]),
                      )),
                  isExpanded: ExpList[1],
                ),
              ],
            ),
            // TextButton(
            //     onPressed: () {},
            //     child: const Text(
            //       'Changer de casier',
            //       style: TextStyle(fontSize: 16),
            //     )),
            // TextButton(
            //     onPressed: () {
            //       setState(() async {
            //         await Provider.of<LockerStudentProvider>(context,
            //                 listen: false)
            //             .unAttributeLocker(locker, widget.student);
            //       });
            //     },
            //     child: const Text(
            //       'Désattribuer le casier',
            //       style: TextStyle(fontSize: 16),
            //     )),
          ]),
        ));
  }
}
