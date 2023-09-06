import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    desattributeLockerAndStudent(Student owner, Locker locker) async {
      await Provider.of<LockerStudentProvider>(context, listen: false)
          .updateStudent(owner.copyWith(lockerNumber: 0));

      widget.locker.isAvailable = false;
      widget.locker.isInaccessible = true;

      Provider.of<LockerStudentProvider>(context, listen: false)
          .updateLocker(widget.locker);
    }

if(widget.locker.idEleve != ""){
    student = Provider.of<LockerStudentProvider>(context)
        .getStudentByLocker(widget.locker);
        }

    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          
        }),
        children: [
          SlidableAction(
            onPressed: (context) {},
            icon: Icons.more_horiz_outlined,
            label: "Options",
            backgroundColor: Colors.black54,
          ),
          SlidableAction(
            onPressed: (context) async {
              if (widget.locker.idEleve != "") {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            "Ce casier appartient actuellement à ${student.firstName} ${student.lastName}. Voulez-vous qu'un nouveau casier lui soit attribué ?",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              // await Provider.of<LockerStudentProvider>(context)
              //     .setLockerToInaccessible(widget.locker);
            },
            icon: Icons.block_outlined,
            label: "Inaccessible",
            backgroundColor: Colors.red,
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
