import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

import 'drop_down_menu.dart';

class AddStudentMenu extends StatefulWidget {
  const AddStudentMenu({super.key});

  @override
  State<AddStudentMenu> createState() => _AddStudentMenuState();
}

class _AddStudentMenuState extends State<AddStudentMenu> {
  // Controllers for the adding student form
  final firstnameController = TextEditingController();

  final lastnameController = TextEditingController();

  final mailController = TextEditingController();

  final jobController = TextEditingController();

  final loginController = TextEditingController();

  final yearController = TextEditingController();

  final classeController = TextEditingController();

  final responsableController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            "Ajouter un élève",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: firstnameController,
                        decoration: const InputDecoration(
                          labelText: "Prénom",
                          prefixIcon: Icon(Icons.person),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      TextField(
                        controller: loginController,
                        decoration: const InputDecoration(
                          labelText: "Login",
                          prefixIcon: Icon(Icons.login),
                        ),
                      ),
                      TextField(
                        controller: classeController,
                        decoration: const InputDecoration(
                          labelText: "Classe",
                          prefixIcon: Icon(Icons.school),
                        ),
                      ),
                      TextField(
                        controller: jobController,
                        decoration: const InputDecoration(
                          labelText: "Formation",
                          prefixIcon: Icon(Icons.work),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: lastnameController,
                        decoration: const InputDecoration(
                          labelText: "Nom",
                          prefixIcon: Icon(Icons.person),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      TextField(
                        controller: mailController,
                        decoration: const InputDecoration(
                          labelText: "Mail",
                          prefixIcon: Icon(Icons.mail),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      DropDownMenu(
                        items: const {
                          "1": "1ère année",
                          "2": "2ème année",
                          "3": "3ème année",
                          "4": "4ème année",
                        },
                        icon: Icons.calendar_today,
                        onChanged: (value) {
                          setState(() {
                            yearController.text = value!;
                          });
                        },
                      ),
                      TextField(
                        controller: responsableController,
                        decoration: const InputDecoration(
                          labelText: "Maître de classe",
                          prefixIcon: Icon(Icons.admin_panel_settings),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black54),
                ),
                onPressed: () {
                  Student student = Student(
                    firstName: firstnameController.text,
                    lastName: lastnameController.text,
                    job: jobController.text,
                    responsable: responsableController.text,
                    caution: 0,
                    lockerNumber: 0,
                    login: loginController.text,
                    year: int.parse(yearController.text),
                    classe: classeController.text,
                  );

                  Provider.of<LockerStudentProvider>(context, listen: false)
                      .addStudent(student);

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
                  responsableController.clear();
                  loginController.clear();
                  yearController.clear();
                  classeController.clear();
                  mailController.clear();
                },
                child: const Text("Ajouter"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
