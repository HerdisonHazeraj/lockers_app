import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/mobile/lockers/widget/locker_info_widget.dart';
import 'package:lockers_app/screens/mobile/lockers/widget/lockers_tasks_widget.dart';
import 'package:provider/provider.dart';

class LockerDetailsScreenMobile extends StatefulWidget {
  LockerDetailsScreenMobile({super.key, required this.locker});
  Locker locker;
  @override
  State<LockerDetailsScreenMobile> createState() =>
      _LockerDetailsScreenMobileState();
}

class _LockerDetailsScreenMobileState extends State<LockerDetailsScreenMobile> {
  List<bool> ExpList = [false, false, true];
  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          child: Column(children: [
            Text(
              "Casier ${widget.locker.lockerNumber}",
              style: TextStyle(fontSize: 20),
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
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.05),
                      // child:
                    ),
                  ),
                  isExpanded: ExpList[1],
                ),
                ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor: Colors.transparent,
                  headerBuilder: (context, isExpanded) {
                    return Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.01),
                      child: const ListTile(
                        leading: Icon(Icons.lock, size: 30),
                        title: Text('Tâches'),
                        subtitle: Text('Clés manquante(s), Remarque(s)'),
                      ),
                    );
                  },
                  body: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.05),
                      child: LockersTasksWidget(
                        locker: widget.locker,
                      ),
                    ),
                  ),
                  isExpanded: ExpList[2],
                ),
              ],
            ),
          ]),
        ));
  }
}
