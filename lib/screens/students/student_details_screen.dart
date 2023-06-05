import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

import '../../models/student.dart';

class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({super.key});

  static String routeName = "/student-details";

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final student =
        Provider.of<LockerStudentProvider>(context).getStudent(id.toString());

    final firstnameController = TextEditingController(text: student.firstName);
    final lastnameController = TextEditingController(text: student.lastName);
    final jobController = TextEditingController(text: student.job);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Modifier cet élève'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: firstnameController,
                        decoration: const InputDecoration(
                          labelText: "Prénom",
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      TextField(
                        controller: lastnameController,
                        decoration: const InputDecoration(
                          labelText: "Nom",
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      TextField(
                        controller: jobController,
                        decoration: const InputDecoration(
                          labelText: "Métier",
                        ),
                        keyboardType: TextInputType.name,
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
                        Student updatedStudent = Student(
                          id: student.id.toString(),
                          firstName: firstnameController.text,
                          lastName: lastnameController.text,
                          job: jobController.text,
                          responsable: 'JHI',
                          caution: 0,
                          lockerNumber: 0,
                        );

                        Provider.of<LockerStudentProvider>(context,
                                listen: false)
                            .updateStudent(updatedStudent);

                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'L\'élève "${updatedStudent.firstName} ${updatedStudent.lastName}" a été modifié avec succès !'),
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  '${student.firstName} ${student.lastName}'.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  student.job,
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'test',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'test',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'test',
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
                        title: const Text('Supprimer cet élève ?'),
                        content: const Text(
                            'Êtes-vous sûr de vouloir supprimer cet élève ?'),
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
                                  .deleteStudent(student.id!);
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
                    'Supprimer l\'élève',
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
