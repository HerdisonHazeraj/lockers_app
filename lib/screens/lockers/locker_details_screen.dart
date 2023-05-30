import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/locker.dart';
import '../../providers/lockers_student_provider.dart';

class LockerDetailsScreen extends StatelessWidget {
  const LockerDetailsScreen({super.key});

  static String routeName = "/locker-details";

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final locker =
        Provider.of<LockerStudentProvider>(context).getLocker(id.toString());
    final student =
        Provider.of<LockerStudentProvider>(context).getStudent(locker.idEleve!);
    final students = Provider.of<LockerStudentProvider>(context).studentItems;

    final lockerNumberController =
        TextEditingController(text: locker.lockerNumber.toString());
    final floorController = TextEditingController(text: locker.floor);
    final remarkController = TextEditingController(text: locker.remark);
    final keysNumberController =
        TextEditingController(text: locker.nbKey.toString());

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Modifier ce casier'),
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
                          Locker updatedLocker = Locker(
                              id: locker.id,
                              idEleve: locker.idEleve,
                              lockNumber:
                                  int.parse(lockerNumberController.text),
                              lockerNumber:
                                  int.parse(lockerNumberController.text),
                              floor: floorController.text,
                              remark: remarkController.text,
                              nbKey: int.parse(keysNumberController.text),
                              isAvailable: true,
                              job: 'ICT');

                          Provider.of<LockerStudentProvider>(context,
                                  listen: false)
                              .updateLocker(updatedLocker);

                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Le casier numéro ${updatedLocker.lockNumber} a été modifié avec succès !'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },
                        child: const Text('Confirmer'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  'Casier n°${locker.lockerNumber}'.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                locker.remark == ''
                    ? const Text(
                        '-',
                      )
                    : Text(
                        locker.remark,
                      ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Étage ${locker.floor.toUpperCase()}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'Nombre de clés restantes : ${locker.nbKey.toString()}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                locker.isAvailable!
                    ? TextButton(
                        child: const Text(
                          'Attribuer un élève',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Attribuer un élève'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownButton(
                                    hint: const Text('Élève'),
                                    items: [
                                      for (var student in students)
                                        DropdownMenuItem(
                                          value: student.id,
                                          child: Text(
                                              '${student.firstName} ${student.lastName}'),
                                        ),
                                    ],
                                    onChanged: (String? newValue) {},
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
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Confirmer'),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Text(
                        'Propiétaire du casier : ${student.firstName} ${student.lastName}',
                        style: Theme.of(context).textTheme.headline6,
                      )
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Supprimer ce casier ?'),
                        content: const Text(
                            'Êtes-vous sûr de vouloir supprimer ce casier ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<LockerStudentProvider>(context,
                                      listen: false)
                                  .deleteLocker(locker.id!);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Confirmer',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'Supprimer le casier',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
