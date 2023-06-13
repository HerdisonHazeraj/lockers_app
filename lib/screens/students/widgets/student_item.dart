import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/student.dart';

class StudentItem extends StatefulWidget {
  final Student student;
  final Function()? showUpdateForm;
  final Function()? refreshList;
  const StudentItem({
    this.refreshList,
    this.showUpdateForm,
    required this.student,
    super.key,
  });

  @override
  State<StudentItem> createState() => _StudentItemState();
}

class _StudentItemState extends State<StudentItem> {
  int indexDeletedStudent = 999999;
  Student deletedStudent = Student.base();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(
          () {
            widget.student.isFocus = true;
          },
        );
      },
      onExit: (event) {
        setState(
          () {
            widget.student.isFocus = false;
          },
        );
      },
      child: ListTile(
        leading: Image.asset(
          'assets/images/photoprofil.png',
          width: 40,
          height: 40,
        ),
        title: Text("${widget.student.firstName} ${widget.student.lastName}"),
        subtitle: Text(widget.student.job),
        trailing: Visibility(
          visible: widget.student.isFocus,
          child: Wrap(
            children: [
              IconButton(
                onPressed: () async {
                  String email = Uri.encodeComponent(
                      "${widget.student.firstName.replaceAll(' ', '')}.${widget.student.lastName.replaceAll(' ', '')}@ceff.ch");
                  String subject = Uri.encodeComponent(
                      "Rappel de votre casier n°${widget.student.lockerNumber}");
                  String body = Uri.encodeComponent("");
                  Uri mail =
                      Uri.parse("mailto:$email?subject=$subject&body=$body");
                  await launchUrl(mail);
                },
                tooltip: "Envoyer un mail à l'élève",
                icon: const Icon(
                  Icons.mail_outlined,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outlined,
                  color: Colors.red,
                ),
                tooltip: "Supprimer l'élève",
                onPressed: () async {
                  // Suppression avec une snackbar qui permet de cancel la suppression
                  Student student = widget.student;

                  indexDeletedStudent =
                      Provider.of<LockerStudentProvider>(context, listen: false)
                          .findIndexOfStudentById(student.id!);
                  deletedStudent = student;

                  await Provider.of<LockerStudentProvider>(context,
                          listen: false)
                      .deleteStudent(student.id!);

                  widget.refreshList!();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "L'élève ${student.firstName} ${student.lastName} a bien été supprimé !",
                      ),
                      duration: const Duration(seconds: 3),
                      action: SnackBarAction(
                          label: "Annuler",
                          onPressed: () async {
                            await Provider.of<LockerStudentProvider>(context,
                                    listen: false)
                                .insertStudent(
                              indexDeletedStudent,
                              deletedStudent,
                            );

                            widget.refreshList!();

                            student.isFocus = false;
                          }),
                    ),
                  );

                  // Suppression avec une boite de dialogue qui permet de confirmer
                  //   showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return AlertDialog(
                  //           title: const Text("Supprimer un élève"),
                  //           content: const Text(
                  //               "Voulez-vous vraiment supprimer cet élève ?"),
                  //           actions: [
                  //             TextButton(
                  //               onPressed: () {
                  //                 Navigator.of(context).pop();
                  //               },
                  //               child: const Text("Annuler"),
                  //             ),
                  //             TextButton(
                  //               onPressed: () {
                  //                 Provider.of<LockerStudentProvider>(context,
                  //                         listen: false)
                  //                     .deleteStudent(widget.student.id!);

                  //                 ScaffoldMessenger.of(context).showSnackBar(
                  //                   SnackBar(
                  //                     content: Text(
                  //                       "L'élève ${widget.student.firstName} ${widget.student.lastName} a bien été supprimé !",
                  //                     ),
                  //                     duration: const Duration(seconds: 2),
                  //                   ),
                  //                 );

                  //                 Navigator.of(context).pop();
                  //               },
                  //               child: const Text("Supprimer"),
                  //             ),
                  //           ],
                  //         );
                  //       });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
