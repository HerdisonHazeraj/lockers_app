import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/students/student_item.dart';
import 'package:provider/provider.dart';

class StudentsOverviewScreen extends StatefulWidget {
  const StudentsOverviewScreen({super.key});

  static String routeName = "/students";

  @override
  State<StudentsOverviewScreen> createState() => _StudentsOverviewScreenState();
}

class _StudentsOverviewScreenState extends State<StudentsOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: StudentsListView());
  }
}

class StudentsListView extends StatelessWidget {
  StudentsListView({super.key});

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final students = Provider.of<LockerStudentProvider>(context).studentItems;
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      StudentItem(students[index]),
                      const Divider(),
                    ],
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Ajouter un élève'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Ajouter un élève'),
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
                            Student student = Student(
                              firstName: firstnameController.text,
                              lastName: lastnameController.text,
                              job: jobController.text,
                              responsable: 'JHI',
                              caution: 0,
                              lockerNumber: 0,
                            );

                            Provider.of<LockerStudentProvider>(context,
                                    listen: false)
                                .addStudent(student);

                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'L\'élève "${student.firstName} ${student.lastName}" a été ajouté avec succès !'),
                                duration: const Duration(seconds: 3),
                              ),
                            );

                            firstnameController.clear();
                            lastnameController.clear();
                            jobController.clear();
                          },
                          child: const Text('Confirmer'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Text('')
            ],
          ),
        ),
      ],
    );
  }
}
