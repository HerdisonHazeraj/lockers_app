import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

import '../../../../models/locker.dart';
import '../../../students/widgets/menu_widgets/drop_down_menu.dart';

class AddLockerMenu extends StatefulWidget {
  const AddLockerMenu({super.key});

  @override
  State<AddLockerMenu> createState() => _AddLockerMenuState();
}

class _AddLockerMenuState extends State<AddLockerMenu> {
  // Controllers for the adding student form
  final lockNumberController = TextEditingController();
  final lockerNumberController = TextEditingController();
  final nbKeyController = TextEditingController();
  final floorController = TextEditingController();
  final jobController = TextEditingController();
  final remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            "Ajouter un casier",
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
                        controller: lockerNumberController,
                        decoration: const InputDecoration(
                          labelText: "N° de casier",
                          prefixIcon: Icon(Icons.lock_outlined),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: lockNumberController,
                        decoration: const InputDecoration(
                          labelText: "N° de serrure",
                          prefixIcon: Icon(Icons.numbers_outlined),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      DropDownMenu(
                        items: const {
                          "b": "Étage B",
                          "c": "Étage C",
                          "d": "Étage D",
                          "e": "Étage E",
                        },
                        defaultItem: "Étage...",
                        icon: Icons.calendar_today_outlined,
                        onChanged: (value) {
                          setState(() {
                            floorController.text = value!;
                          });
                        },
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
                        controller: nbKeyController,
                        decoration: const InputDecoration(
                          labelText: "Nombre de clés",
                          prefixIcon: Icon(Icons.key_outlined),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: jobController,
                        decoration: const InputDecoration(
                          labelText: "Métier",
                          prefixIcon: Icon(Icons.work_outlined),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      TextField(
                        controller: remarkController,
                        decoration: const InputDecoration(
                          labelText: "Remarque (facultatif)",
                          prefixIcon: Icon(Icons.note_outlined),
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
                  Locker locker = Locker(
                    lockNumber: int.parse(lockNumberController.text),
                    lockerNumber: int.parse(lockerNumberController.text),
                    nbKey: int.parse(nbKeyController.text),
                    floor: floorController.text,
                    job: jobController.text,
                    remark: remarkController.text,
                    isAvailable: true,
                  );

                  Provider.of<LockerStudentProvider>(context, listen: false)
                      .addLocker(locker);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Le casier n°${locker.lockerNumber} a été ajouté avec succès !'),
                      duration: const Duration(seconds: 3),
                    ),
                  );

                  lockNumberController.clear();
                  lockerNumberController.clear();
                  nbKeyController.clear();
                  floorController.clear();
                  jobController.clear();
                  remarkController.clear();
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
