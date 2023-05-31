import 'package:flutter/material.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/responsive.dart';
import 'package:lockers_app/screens/components/drawer_app.dart';
import 'package:lockers_app/screens/lockers/locker_item.dart';
import 'package:provider/provider.dart';

import '../../providers/lockers_student_provider.dart';

class LockersOverviewScreen extends StatefulWidget {
  const LockersOverviewScreen({super.key});

  static String routeName = "/lockers";

  @override
  State<LockersOverviewScreen> createState() => _LockersOverviewScreenState();
}

class _LockersOverviewScreenState extends State<LockersOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LockersListView(),
    );
  }
}

class LockersListView extends StatelessWidget {
  LockersListView({super.key});

  final lockerNumberController = TextEditingController();
  final floorController = TextEditingController();
  final remarkController = TextEditingController();
  final keysNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final lockers = Provider.of<LockerStudentProvider>(context).lockerItems;
    return Scaffold(
      appBar: Responsive.isMobile(context)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            )
          : null,
      drawer: const DrawerApp(),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: lockers.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        LockerItem(lockers[index]),
                        const Divider(),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Ajouter un casier'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Ajouter un casier'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: lockerNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Numéro du casier',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            TextField(
                              controller: floorController,
                              decoration: const InputDecoration(
                                labelText: 'Étage',
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            TextField(
                              controller: remarkController,
                              decoration: const InputDecoration(
                                labelText: 'Remarque (facultatif)',
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            TextField(
                              controller: keysNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre de clés',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              Locker locker = Locker(
                                  lockerNumber:
                                      int.parse(lockerNumberController.text),
                                  lockNumber:
                                      int.parse(lockerNumberController.text),
                                  floor: floorController.text,
                                  remark: remarkController.text,
                                  nbKey: int.parse(keysNumberController.text),
                                  isAvailable: true,
                                  job: 'ICT');

                              Provider.of<LockerStudentProvider>(context,
                                      listen: false)
                                  .addLocker(locker);

                              Navigator.of(context).pop();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Le casier numéro ${locker.lockNumber} a été ajouté avec succès !'),
                                  duration: const Duration(seconds: 3),
                                ),
                              );

                              lockerNumberController.clear();
                              floorController.clear();
                              remarkController.clear();
                              keysNumberController.clear();
                            },
                            child: const Text('Confirmer'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Text('')
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Provider.of<LockersProvider>(context).deletedLocker == null
          //       ? const Text('')
          //       : Center(
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Text(
          //                 "Le casier n°${Provider.of<LockersProvider>(context).deletedLocker.lockNumber} a bien été supprimé.",
          //               ),
          //               TextButton(
          //                 child: const Text(
          //                   "Annuler",
          //                 ),
          //                 onPressed: () {
          //                   Provider.of<LockersProvider>(context, listen: false)
          //                       .insertLocker(
          //                           Provider.of<LockersProvider>(context,
          //                                   listen: false)
          //                               .deletedLockerIndex,
          //                           Provider.of<LockersProvider>(context,
          //                                   listen: false)
          //                               .deletedLocker);
          //                   Provider.of<LockersProvider>(context, listen: false)
          //                       .deletedLocker = null;
          //                 },
          //               ),
          //             ],
          //           ),
          //         ),
          // ),
        ],
      ),
    );
  }
}
