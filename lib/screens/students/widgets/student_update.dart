import 'package:flutter/material.dart';
import 'package:lockers_app/models/history.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/student.dart';
import 'menu_widgets/drop_down_menu.dart';

class StudentUpdate extends StatefulWidget {
  const StudentUpdate(
      {super.key,
      required this.student,
      this.updateSearchStudentList,
      this.showUpdateForm});

  final Function()? showUpdateForm;
  final Function()? updateSearchStudentList;
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

  // Tools for student details
  late Locker locker;

  final focusMail = FocusNode();
  final focusClasse = FocusNode();

  // Form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (widget.student.lockerNumber != 0) {
      locker = Provider.of<LockerStudentProvider>(context)
          .getLockerByLockerNumber(widget.student.lockerNumber);
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 100,
        right: 100,
        bottom: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      enabled: !widget.student.isArchived!,
                      controller: firstnameController,
                      decoration: const InputDecoration(
                        labelText: "Prénom",
                        prefixIcon: Icon(Icons.person_outlined),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      enabled: !widget.student.isArchived!,
                      controller: lastnameController,
                      decoration: const InputDecoration(
                        labelText: "Nom",
                        prefixIcon: Icon(Icons.person_outlined),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      enabled: !widget.student.isArchived!,
                      controller: loginController,
                      decoration: const InputDecoration(
                        labelText: "Login",
                        prefixIcon: Icon(Icons.login_outlined),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focusClasse);
                      },
                      enabled: !widget.student.isArchived!,
                      controller: mailController,
                      decoration: const InputDecoration(
                        labelText: "Mail",
                        prefixIcon: Icon(Icons.mail_outlined),
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
                    child: TextFormField(
                      focusNode: focusClasse,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      enabled: !widget.student.isArchived!,
                      controller: classeController,
                      decoration: const InputDecoration(
                        labelText: "Classe",
                        prefixIcon: Icon(Icons.school_outlined),
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
                      enabled: !widget.student.isArchived!,
                      defaultItem: "Année...",
                      icon: Icons.calendar_today_outlined,
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
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      enabled: !widget.student.isArchived!,
                      controller: jobController,
                      decoration: const InputDecoration(
                        labelText: "Formation",
                        prefixIcon: Icon(Icons.work_outlined),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      enabled: !widget.student.isArchived!,
                      controller: responsableController,
                      decoration: const InputDecoration(
                        labelText: "Maître de classe",
                        prefixIcon: Icon(Icons.admin_panel_settings_outlined),
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
                      onPressed: widget.student.isArchived!
                          ? null
                          : () {
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
                      onPressed: widget.student.isArchived!
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                Student student =
                                    Provider.of<LockerStudentProvider>(context,
                                            listen: false)
                                        .getStudent(widget.student.id!);

                                await Provider.of<LockerStudentProvider>(
                                        context,
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
                                Provider.of<HistoryProvider>(context,
                                        listen: false)
                                    .addHistory(
                                  History(
                                    date: DateTime.now().toString(),
                                    action: "update",
                                    student: student.toJson(),
                                  ),
                                );

                                widget.updateSearchStudentList!();

                                widget.showUpdateForm!();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "L'étudiant ${student.firstName} ${student.lastName} a été modifié avec succès !"),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                      child: const Text("Enregistrer"),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            if (widget.student.lockerNumber != 0)
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        readOnly: true,
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                          hintText:
                              "Casier n°${locker.lockerNumber.toString()}",
                          prefixIcon:
                              const Icon(Icons.admin_panel_settings_outlined),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        readOnly: true,
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                          hintText: "Étage ${locker.floor.toUpperCase()}",
                          prefixIcon: const Icon(Icons.location_on_outlined),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        readOnly: true,
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                          hintText: "${locker.nbKey.toString()} clés",
                          prefixIcon: const Icon(Icons.vpn_key_outlined),
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
