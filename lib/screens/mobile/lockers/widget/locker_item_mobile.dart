import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/core/components/modal_bottomsheet.dart';
import 'package:lockers_app/screens/mobile/core/shared.dart';
import 'package:lockers_app/screens/mobile/lockers/widget/locker_details_mobile.dart';
import 'package:provider/provider.dart';

import '../../../../models/student.dart';

class LockerItemMobile extends StatefulWidget {
  final Locker locker;
  final bool isLockerInDefectiveList;
  final Function()? refreshList;
  const LockerItemMobile({
    super.key,
    required this.locker,
    required this.isLockerInDefectiveList,
    this.refreshList,
  });

  @override
  State<LockerItemMobile> createState() => _LockerItemMobileState();
}

class _LockerItemMobileState extends State<LockerItemMobile> {
  int indexDeletedLocker = 999999;
  Locker deletedLocker = Locker.base();
  Student student = Student.base();
  Shared shared = Shared();

  @override
  Widget build(BuildContext context) {
    List<ListTile> standardList = [
      ListTile(
        title: const Text('Ajouter une remarque'),
        onTap: () {},
        trailing: const Icon(Icons.airline_seat_flat_sharp),
      ),
      ListTile(
        title: const Text('Nombre de clés'),
        onTap: () {},
        trailing: const Icon(Icons.key),
      ),
    ];

    List<ListTile> importantList = [
      ListTile(
        title: const Text("Supprimer"),
        onTap: () {
          shared.methodInaccessibleOrDeleteLocker(
              context, widget.locker, true, false);
        },
        trailing: const Icon(Icons.delete_forever_outlined),
      )
    ];

    return Slidable(
      key: ValueKey(widget.locker.id),
      startActionPane: widget.locker.isDefective!
          ? ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(
                motion: const ScrollMotion(),
                onDismissed: () {
                  if (widget.locker.nbKey < 2) {
                    Provider.of<LockerStudentProvider>(context, listen: false)
                        .setLockerToUnDefectiveKeys(widget.locker);
                  } else if (widget.locker.remark != "") {
                    Provider.of<LockerStudentProvider>(context, listen: false)
                        .setLockerToUnDefectiveRemarks(widget.locker);
                  }
                },
              ),
              children: [
                widget.locker.nbKey < 2
                    ? SlidableAction(
                        onPressed: (_) {
                          Provider.of<LockerStudentProvider>(context,
                                  listen: false)
                              .setLockerToUnDefectiveKeys(widget.locker);
                        },
                        icon: Icons.vpn_key_outlined,
                        label: 'Ajouter les clés manquantes',
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      )
                    : SizedBox(),
                widget.locker.remark != ""
                    ? SlidableAction(
                        onPressed: (_) {
                          Provider.of<LockerStudentProvider>(context,
                                  listen: false)
                              .setLockerToUnDefectiveRemarks(widget.locker);
                        },
                        icon: Icons.task_alt_outlined,
                        label: 'Supprimer la remarque',
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white,
                      )
                    : SizedBox(),
              ],
            )
          : null,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          closeOnCancel: true,
          onDismissed: () {
            shared.methodInaccessibleOrDeleteLocker(
                context, widget.locker, false, false);
          },
        ),
        children: [
          SlidableAction(
            onPressed: (_) {
              ModalBottomSheetWidget(
                context,
                standardList,
                importantList,
                'Casier n°${widget.locker.lockerNumber}',
              );
            },
            icon: Icons.more_horiz_outlined,
            label: "Options",
            backgroundColor: Theme.of(context).iconTheme.color!,
          ),
          SlidableAction(
            onPressed: (_) {
              shared.methodInaccessibleOrDeleteLocker(
                  context, widget.locker, false, false);
            },
            icon: Icons.block_outlined,
            label: "Inaccessible",
            backgroundColor: Colors.deepOrange,
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => LockerDetailsScreenMobile(
                locker: widget.locker,
              ),
            ),
          );
        },
        enabled: widget.locker.isInaccessible == false ? true : false,
        leading: widget.locker.isDefective == true
            ? const Icon(
                Icons.lock_outlined,
                color: Colors.orange,
                size: 40,
              )
            : widget.locker.isAvailable == true
                ? const Icon(
                    Icons.lock_open_outlined,
                    color: Colors.green,
                    size: 40,
                  )
                : const Icon(
                    Icons.lock_outlined,
                    color: Colors.red,
                    size: 40,
                  ),
        title: Text(
          'Casier n°${widget.locker.lockerNumber}',
        ),
        subtitle: widget.locker.isDefective == true
            ? widget.locker.nbKey < 2 && widget.locker.remark == ""
                ? Text(
                    'Le casier ne possède plus que ${widget.locker.nbKey} clé(s)',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : widget.locker.remark != "" && widget.locker.nbKey < 2
                    ? Text(
                        '${widget.locker.remark} et ne possède plus que ${widget.locker.nbKey} clé(s)',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        widget.locker.remark,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
            : const Text(
                'Aucune remarque',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }
}
