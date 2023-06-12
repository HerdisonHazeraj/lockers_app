import 'package:flutter/material.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/students/widgets/menu_widgets/drop_down_menu.dart';
import 'package:provider/provider.dart';

class LockerUpdate extends StatefulWidget {
  const LockerUpdate({super.key, required this.locker, this.showUpdateForm});

  final Function()? showUpdateForm;
  final Locker locker;

  @override
  State<LockerUpdate> createState() => _LockerUpdateState();
}

class _LockerUpdateState extends State<LockerUpdate> {
  // Tools for update locker
  late final TextEditingController lockNumberController =
      TextEditingController(text: widget.locker.lockNumber.toString());
  late final TextEditingController lockerNumberController =
      TextEditingController(text: widget.locker.lockerNumber.toString());
  late final TextEditingController nbKeyController =
      TextEditingController(text: widget.locker.nbKey.toString());
  late final TextEditingController floorController =
      TextEditingController(text: widget.locker.floor.toString());
  late final TextEditingController jobController =
      TextEditingController(text: widget.locker.job);
  late final TextEditingController remarkController =
      TextEditingController(text: widget.locker.remark);

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
                    controller: lockerNumberController,
                    decoration: const InputDecoration(
                      labelText: "N° de casier",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: lockNumberController,
                    decoration: const InputDecoration(
                      labelText: "N° de serrure",
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: DropDownMenu(
                    items: const {
                      "a": "Étage A",
                      "b": "Étage B",
                      "c": "Étage C",
                      "d": "Étage D",
                      "e": "Étage E",
                    },
                    defaultItem: "Étage...",
                    icon: Icons.location_on_outlined,
                    onChanged: (value) {
                      setState(() {
                        floorController.text = value!;
                      });
                    },
                    defaultChoosedItem: floorController.text,
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
                    controller: nbKeyController,
                    decoration: const InputDecoration(
                      labelText: "Nombre de clés",
                      prefixIcon: Icon(Icons.key),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: jobController,
                    decoration: const InputDecoration(
                      labelText: "Métier",
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
                    controller: remarkController,
                    decoration: const InputDecoration(
                      labelText: "Remarque (facultatif)",
                      prefixIcon: Icon(Icons.note),
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
                      Locker locker = Provider.of<LockerStudentProvider>(
                              context,
                              listen: false)
                          .getLocker(widget.locker.id!);

                      await Provider.of<LockerStudentProvider>(context,
                              listen: false)
                          .updateLocker(locker.copyWith(
                        lockerNumber: int.parse(lockerNumberController.text),
                        lockNumber: int.parse(lockNumberController.text),
                        nbKey: int.parse(nbKeyController.text),
                        floor: floorController.text,
                        job: jobController.text,
                        remark: remarkController.text,
                      ));

                      widget.showUpdateForm!();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Le casier n°${widget.locker.lockerNumber}  a été modifié avec succès !"),
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
