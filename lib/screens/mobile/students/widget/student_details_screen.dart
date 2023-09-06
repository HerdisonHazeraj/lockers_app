import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/core/components/modal_bottomsheet.dart';
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
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
                  // ModalBottomSheetWidget(
                  //   context,
                  //   standardList,
                  //   widget.locker,
                  // );
                },
                icon: const Icon(
                  Icons.info_outline,
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
            widget.student.lockerNumber != 0
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: widget.student.caution == 0
                            ? const Text(
                                'Caution non-payée',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              )
                            : const Text(
                                'Caution payée',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 16),
                              )),
                  )
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
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.05),
                      child: locker != Locker.error()
                          ? LockerStudentInfoWidget(locker: locker)
                          : const Text(
                              'L\'élève ne possède pas de casier',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                    ),
                  ),
                  isExpanded: ExpList[1],
                ),
              ],
            ),
            TextButton(
                onPressed: () {},
                child: const Text(
                  'Changer de casier',
                  style: TextStyle(fontSize: 16),
                )),
            TextButton(
                onPressed: () {
                  setState(() async {
                    await Provider.of<LockerStudentProvider>(context,
                            listen: false)
                        .unAttributeLocker(locker, widget.student);
                  });
                },
                child: const Text(
                  'Désattribuer le casier',
                  style: TextStyle(fontSize: 16),
                )),
          ]),
        ));
  }
}
