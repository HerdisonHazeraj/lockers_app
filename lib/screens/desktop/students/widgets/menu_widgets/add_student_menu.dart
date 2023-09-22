import 'package:flutter/material.dart';
import 'package:lockers_app/models/history.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme.dart';
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

  // Form key
  final _formKey = GlobalKey<FormState>();

  final focusFirstName = FocusNode();
  final focusLastName = FocusNode();
  final focusMail = FocusNode();
  final focusJob = FocusNode();
  final focusLogin = FocusNode();
  final focusYear = FocusNode();
  final focusClasse = FocusNode();
  final focusResponsable = FocusNode();
  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Ajouter un élève",
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                          focusNode: focusFirstName,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focusLastName);
                          },
                          controller: firstnameController,
                          decoration: InputDecoration(
                            labelText: "Prénom",
                            prefixIcon: Icon(Icons.person_outlined),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                          focusNode: focusLogin,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focusMail);
                          },
                          controller: loginController,
                          decoration: InputDecoration(
                            labelText: "Login",
                            prefixIcon: Icon(Icons.login_outlined),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                          focusNode: focusClasse,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focusYear);
                          },
                          controller: classeController,
                          decoration: InputDecoration(
                            labelText: "Classe",
                            prefixIcon: Icon(Icons.school_outlined),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                          focusNode: focusJob,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(focusResponsable);
                          },
                          controller: jobController,
                          decoration: InputDecoration(
                            labelText: "Formation",
                            prefixIcon: Icon(Icons.work_outlined),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 38,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                          focusNode: focusLastName,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focusLogin);
                          },
                          controller: lastnameController,
                          decoration: InputDecoration(
                            labelText: "Nom",
                            prefixIcon: Icon(Icons.person_outlined),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                          focusNode: focusMail,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focusClasse);
                          },
                          controller: mailController,
                          decoration: InputDecoration(
                            labelText: "Mail",
                            prefixIcon: Icon(Icons.mail_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        DropDownMenu(
                          focus: focusYear,
                          nextFocus: focusJob,
                          enabled: true,
                          items: const {
                            "1": "1ère année",
                            "2": "2ème année",
                            "3": "3ème année",
                            "4": "4ème année",
                          },
                          defaultItem: "Année...",
                          icon: Icons.calendar_today_outlined,
                          onChanged: (value) {
                            setState(() {
                              yearController.text = value!;
                            });
                          },
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                          focusNode: focusResponsable,
                          textInputAction: TextInputAction.done,
                          controller: responsableController,
                          decoration: InputDecoration(
                            labelText: "Maître de classe",
                            prefixIcon:
                                Icon(Icons.admin_panel_settings_outlined),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
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
                      Provider.of<HistoryProvider>(context, listen: false)
                          .addHistory(
                        History(
                          date: DateTime.now().toString(),
                          action: "add",
                          student: student.toJson(),
                        ),
                      );

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
                    }
                  },
                  child: const Text("Ajouter"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
