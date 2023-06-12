import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/student.dart';
import 'menu_widgets/drop_down_menu.dart';

class StudentUpdate extends StatefulWidget {
  const StudentUpdate({super.key, required this.student, this.showUpdateForm});

  final Function()? showUpdateForm;
  final Student student;

  @override
  State<StudentUpdate> createState() => _StudentUpdateState();
}

class _StudentUpdateState extends State<StudentUpdate> {
  // Tools for update student
  late final firstnameController =
      TextEditingController(text: widget.student.firstName);
  late final lastnameController =
      TextEditingController(text: widget.student.lastName);
  late final mailController = TextEditingController(
      text:
          "${widget.student.firstName.replaceAll(' ', '').toLowerCase()}.${widget.student.lastName.replaceAll(' ', '').toLowerCase()}@ceff.ch");
  late final jobController = TextEditingController(text: widget.student.job);
  late final loginController =
      TextEditingController(text: widget.student.login);
  late final yearController =
      TextEditingController(text: widget.student.year.toString());
  late final classeController =
      TextEditingController(text: widget.student.classe);
  late final responsableController =
      TextEditingController(text: widget.student.responsable);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 100,
        right: 100,
        bottom: 20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: firstnameController,
                    decoration: const InputDecoration(
                      labelText: "Prénom",
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: lastnameController,
                    decoration: const InputDecoration(
                      labelText: "Nom",
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: loginController,
                    decoration: const InputDecoration(
                      labelText: "Login",
                      prefixIcon: Icon(Icons.login),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: mailController,
                    decoration: const InputDecoration(
                      labelText: "Mail",
                      prefixIcon: Icon(Icons.mail),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: classeController,
                    decoration: const InputDecoration(
                      labelText: "Classe",
                      prefixIcon: Icon(Icons.school),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: DropDownMenu(
                    items: const {
                      "1": "1ère année",
                      "2": "2ème année",
                      "3": "3ème année",
                      "4": "4ème année",
                    },
                    defaultItem: "Année...",
                    icon: Icons.calendar_today,
                    onChanged: (value) {
                      setState(() {
                        yearController.text = value!;
                      });
                    },
                    defaultChoosedItem: yearController.text,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: jobController,
                    decoration: const InputDecoration(
                      labelText: "Formation",
                      prefixIcon: Icon(Icons.work),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: responsableController,
                    decoration: const InputDecoration(
                      labelText: "Maître de classe",
                      prefixIcon: Icon(Icons.admin_panel_settings),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black54),
                    ),
                    onPressed: () {
                      widget.showUpdateForm!();
                    },
                    child: const Text("Annuler"),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black54),
                    ),
                    onPressed: () async {
                      Student student = Provider.of<LockerStudentProvider>(
                              context,
                              listen: false)
                          .getStudent(widget.student.id!);

                      await Provider.of<LockerStudentProvider>(context,
                              listen: false)
                          .updateStudent(student.copyWith(
                        firstName: firstnameController.text,
                        lastName: lastnameController.text,
                        login: loginController.text,
                        job: jobController.text,
                        classe: classeController.text,
                        manager: responsableController.text,
                        year: int.parse(yearController.text),
                      ));

                      widget.showUpdateForm!();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "L'étudiant ${student.firstName} ${student.lastName} a été modifié avec succès !"),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    child: const Text("Enregistrer"),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}