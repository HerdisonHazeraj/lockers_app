import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/models/history.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme.dart';
import '../../../../models/locker.dart';
import '../../../../models/student.dart';
import '../../../../responsive.dart';
import '../../../mobile/students/widget/student_details_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (event) => setState(() {
        widget.student.isFocus = false;
      }),
      onEnter: (event) => setState(() {
        widget.student.isFocus = false;
      }),
      onHover: (event) => setState(() {
        widget.student.isFocus = true;
      }),
      child: ListTile(
        onTap: Responsive.isMobile(context)
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        StudentDetailsScreenMobile(
                      student: widget.student,
                    ),
                  ),
                );
              }
            : null,
        enabled: !widget.student.isArchived!,
        leading: GestureDetector(
          child: Hero(
            tag: widget.student.login,
            child: CachedNetworkImage(
              imageUrl:
                  "https://intranet.ceff.ch/Image/PhotosPortraits/photos/Carré/${widget.student.login}.jpg",
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Tooltip(
                message: "L'image n'a pas réussi à se charger",
                child: Icon(
                  Icons.error_outlined,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ),
          ),
          onTap: () {
            showGeneralDialog(
              context: context,
              barrierColor: ColorTheme.thirdTextColor,
              barrierLabel: "Photo de l'élève",
              barrierDismissible: true,
              pageBuilder: (_, __, ___) => Center(
                child: Container(
                  color: Colors.transparent,
                  child: Material(
                    color: Colors.transparent,
                    child: CachedNetworkImage(
                      width: 500,
                      height: 500,
                      imageUrl:
                          "https://intranet.ceff.ch/Image/PhotosPortraits/photos/Carré/${widget.student.login}.jpg",
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Tooltip(
                        message: "L'image n'a pas réussi à se charger",
                        child: Icon(
                          Icons.error_outlined,
                          color: Colors.red,
                          size: 500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        title: Row(
          children: [
            Text("${widget.student.firstName} ${widget.student.lastName}"),
          ],
        ),
        subtitle: Text(
          widget.student.job,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Responsive.isDesktop(context)
            ? widget.student.isArchived == true
                ? Visibility(
                    visible: widget.student.isFocus,
                    child: IconButton(
                      onPressed: () {
                        widget.student.isArchived = false;
                        Provider.of<LockerStudentProvider>(context,
                                listen: false)
                            .updateStudent(widget.student);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "L'élève ${widget.student.firstName} ${widget.student.lastName} a bien été désarchivé !",
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      tooltip: "Désarchiver l'élève",
                      icon: Icon(
                        Icons.unarchive_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  )
                : Visibility(
                    visible: widget.student.isFocus,
                    child: Wrap(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await Provider.of<LockerStudentProvider>(context,
                                    listen: false)
                                .updateStudent(
                                    widget.student.copyWith(isArchived: true));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'L\'élève ${widget.student.firstName} ${widget.student.lastName} a bien été archivé !'),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            widget.refreshList!();
                          },
                          tooltip: "Archiver l'élève",
                          icon: Icon(
                            Icons.archive_outlined,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        widget.student.caution == 20
                            ? IconButton(
                                onPressed: () {
                                  Provider.of<LockerStudentProvider>(context,
                                          listen: false)
                                      .updateStudent(
                                    widget.student.copyWith(caution: 0),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'La caution de ${widget.student.firstName} ${widget.student.lastName} a bien été rendue !'),
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                },
                                tooltip: "La caution a été rendue",
                                icon: Icon(
                                  Icons.money_off_outlined,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              )
                            : IconButton(
                                onPressed: () async {
                                  await Provider.of<LockerStudentProvider>(
                                          context,
                                          listen: false)
                                      .updateStudent(
                                    widget.student.copyWith(caution: 20),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'La caution de ${widget.student.firstName} ${widget.student.lastName} a bien été payée !'),
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                  widget.refreshList!();
                                },
                                tooltip: "L'élève a payé la caution",
                                icon: Icon(
                                  Icons.attach_money_outlined,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                        widget.student.lockerNumber == 0
                            ? IconButton(
                                onPressed: () async {
                                  await Provider.of<LockerStudentProvider>(
                                          context,
                                          listen: false)
                                      .autoAttributeOneLocker(widget.student);

                                  Student updatedStudent =
                                      Provider.of<LockerStudentProvider>(
                                              context,
                                              listen: false)
                                          .getStudent(widget.student.id!);

                                  Locker locker =
                                      Provider.of<LockerStudentProvider>(
                                              context,
                                              listen: false)
                                          .getLockerByLockerNumber(
                                              updatedStudent.lockerNumber);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Le casier n°${locker.lockerNumber} a bien été attribué à l'élève ${widget.student.firstName} ${widget.student.lastName} !",
                                      ),
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                  widget.refreshList!();
                                },
                                tooltip: "Attribuer automatiquement un casier",
                                icon: Icon(
                                  Icons.bookmark_add_outlined,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              )
                            : IconButton(
                                onPressed: () async {
                                  Locker locker =
                                      Provider.of<LockerStudentProvider>(
                                              context,
                                              listen: false)
                                          .getAccessibleLocker()
                                          .where((element) =>
                                              element.lockerNumber ==
                                              widget.student.lockerNumber)
                                          .first;
                                  await Provider.of<LockerStudentProvider>(
                                          context,
                                          listen: false)
                                      .unAttributeLocker(
                                          locker, widget.student);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Le casier n°${locker.lockerNumber} a bien été désattribué à l'élève ${widget.student.firstName} ${widget.student.lastName} !",
                                      ),
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                  widget.refreshList!();
                                },
                                tooltip: "Désattribuer le casier de l'élève",
                                icon: Icon(
                                  Icons.bookmark_remove_outlined,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                        IconButton(
                          onPressed: () async {
                            String email = Uri.encodeComponent(
                                "${widget.student.firstName.replaceAll(' ', '')}.${widget.student.lastName.replaceAll(' ', '')}@ceff.ch");
                            String subject = Uri.encodeComponent(
                                "Rappel de votre casier n°${widget.student.lockerNumber}");
                            String body = Uri.encodeComponent("");
                            Uri mail = Uri.parse(
                                "mailto:$email?subject=$subject&body=$body");
                            await launchUrl(mail);
                          },
                          tooltip: "Envoyer un mail à l'élève",
                          icon: Icon(
                            Icons.mail_outlined,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outlined,
                            color: Colors.red,
                          ),
                          tooltip: "Supprimer l'élève",
                          onPressed: () async {
                            // Suppression avec une boite de dialogue qui permet de confirmer
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Supprimer un élève"),
                                    content: const Text(
                                        "Voulez-vous vraiment supprimer cet élève ?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Annuler"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await Provider.of<
                                                      LockerStudentProvider>(
                                                  context,
                                                  listen: false)
                                              .deleteStudent(
                                                  widget.student.id!);
                                          Navigator.of(context).pop();
                                          widget.refreshList!();
                                        },
                                        child: const Text("Confirmer"),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  )
            : Icon(
                Icons.abc,
                color: Colors.transparent,
              ),
      ),
    );
  }
}
