import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
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
  List<bool> ExpList = [true, true];
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
        ),
        body: Column(children: [
          widget.student.lockerNumber != 0
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: widget.student.caution == 0
                          ? const Text(
                              'Caution non-payée',
                              style: TextStyle(color: Colors.red),
                            )
                          : const Text(
                              'Caution payée',
                              style: TextStyle(color: Colors.green),
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
                    child: Text("Données personnelles"),
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
              locker == Locker.error()
                  ? ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return Text("");
                      },
                      body: const SizedBox(
                        height: 0,
                      ))
                  : ExpansionPanel(
                      canTapOnHeader: true,
                      backgroundColor: Colors.transparent,
                      headerBuilder: (context, isExpanded) {
                        return const Text("Casier de l'élève");
                      },
                      body: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: GridView.count(
                          childAspectRatio: 4,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: [
                            Text("N° de Casier : ${locker.lockerNumber}"),
                            Text("Étage : ${locker.floor.toUpperCase()}"),
                            Text("Nombre de clés : ${locker.nbKey}"),
                          ],
                        ),
                      ),
                      isExpanded: ExpList[1],
                    ),
            ],
          )
        ]));
  }
}
