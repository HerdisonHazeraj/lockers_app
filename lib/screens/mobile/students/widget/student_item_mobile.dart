import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/core/components/modal_bottomsheet.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme.dart';
import '../../../../models/student.dart';
import '../../../mobile/students/widget/student_details_screen.dart';

class StudentItemMobile extends StatefulWidget {
  final Student student;
  final Function()? refreshList;
  const StudentItemMobile({
    this.refreshList,
    required this.student,
    super.key,
  });

  @override
  State<StudentItemMobile> createState() => _StudentItemMobileState();
}

class _StudentItemMobileState extends State<StudentItemMobile> {
  @override
  Widget build(BuildContext context) {
    List<ListTile> standardList = [
      ListTile(
        title: const Text("Attribuer automatiquement un casier"),
        onTap: () async {
          if (widget.student.lockerNumber == 0) {
            await Provider.of<LockerStudentProvider>(context, listen: false)
                .autoAttributeOneLocker(widget.student);

            Student newStudent =
                await Provider.of<LockerStudentProvider>(context, listen: false)
                    .getStudent(widget.student.id.toString());

            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "L'élève ${widget.student.firstName} ${widget.student.lastName} a reçu le casier n°${newStudent.lockerNumber}.")));
          } else {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "L'élève ${widget.student.firstName} ${widget.student.lastName} possède déjà un casier.")));
          }
        },
        trailing: const Icon(
          Icons.auto_fix_normal_outlined,
          size: 30,
        ),
      ),
      ListTile(
        title: const Text('Changer de casier'),
        onTap: () async {},
        trailing: const Icon(
          Icons.lock_reset_outlined,
          size: 30,
        ),
      ),
      ListTile(
        title: const Text('Désattribuer le casier'),
        onTap: () async {
          if (widget.student.lockerNumber != 0) {
            Locker locker =
                await Provider.of<LockerStudentProvider>(context, listen: false)
                    .getLockerByLockerNumber(widget.student.lockerNumber);
            await Provider.of<LockerStudentProvider>(context, listen: false)
                .unAttributeLocker(locker, widget.student);

            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Le casier n°${locker.lockerNumber} a bien été désattribué à l'élève ${widget.student.firstName} ${widget.student.lastName}.")));
          } else {
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "L'élève ${widget.student.firstName} ${widget.student.lastName} ne possède pas de casier.")));
          }
        },
        trailing: const Icon(
          Icons.remove_circle_outline,
          size: 30,
        ),
      ),
    ];
    List<ListTile> importantList = [
      ListTile(
        title: const Text("Supprimer"),
        onTap: () async {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
            context: context,
            builder: (_) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.student.firstName} ${widget.student.lastName}',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 34,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Êtes-vous sûre de vouloir supprimer cet élève ?",
                              style: TextStyle(fontSize: 16),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Colors.grey.withOpacity(0.2),
                                        ),
                                      ),
                                    ),
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20),
                                    child: ListTile(
                                      onTap: () async {
                                        if (widget.student.lockerNumber != 0) {
                                          Locker locker = await Provider.of<
                                                      LockerStudentProvider>(
                                                  context,
                                                  listen: false)
                                              .getLockerByLockerNumber(
                                                  widget.student.lockerNumber);
                                          await Provider.of<
                                                      LockerStudentProvider>(
                                                  context,
                                                  listen: false)
                                              .updateLocker(locker.copyWith(
                                                  idEleve: "",
                                                  isAvailable: true));
                                        }

                                        await Provider.of<
                                                    LockerStudentProvider>(
                                                context,
                                                listen: false)
                                            .deleteStudent(
                                                widget.student.id.toString());

                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "L'élève ${widget.student.firstName} ${widget.student.lastName} a bien été supprimé.")));
                                      },
                                      title: const Text("Oui"),
                                    ),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      title: const Text("Annuler"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
        trailing: const Icon(Icons.delete_forever_outlined),
      )
    ];

    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {},
        ),
        children: [
          SlidableAction(
            onPressed: (_) {},
            icon: Icons.arrow_circle_down,
            label: 'Caution rendue',
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        // dismissible: DismissiblePane(
        //   onDismissed: () {},
        // ),
        children: [
          SlidableAction(
            onPressed: (_) {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
                context: context,
                builder: (_) => ModalBottomSheetWidgetTest(
                  title:
                      "${widget.student.firstName} ${widget.student.lastName}",
                  standardList: standardList,
                  importantList: importantList,
                ),
              );
            },
            icon: Icons.more_horiz_outlined,
            label: "Options",
            backgroundColor: Theme.of(context).iconTheme.color!,
          ),
          SlidableAction(
            onPressed: (_) async {
              if (widget.student.lockerNumber != 0 &&
                  widget.student.lockerNumber != "") {
                Locker locker = await Provider.of<LockerStudentProvider>(
                        context,
                        listen: false)
                    .getLockerByLockerNumber(widget.student.lockerNumber);
                await Provider.of<LockerStudentProvider>(context, listen: false)
                    .updateLocker(
                        locker.copyWith(idEleve: "", isAvailable: true));
              }

              await Provider.of<LockerStudentProvider>(context, listen: false)
                  .updateStudent(widget.student
                      .copyWith(isArchived: true, lockerNumber: 0));

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "L'élève ${widget.student.firstName} ${widget.student.lastName} a bien été archivé.")));
            },
            icon: Icons.archive_outlined,
            label: "Archiver",
            backgroundColor: Colors.deepOrange,
          )
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => StudentDetailsScreenMobile(
                student: widget.student,
              ),
            ),
          );
        },
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
              barrierColor:
                  Theme.of(context).textSelectionTheme.selectionColor!,
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
      ),
    );
  }
}
