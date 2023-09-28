import 'package:flutter/material.dart';
import 'package:lockers_app/models/history.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme.dart';
import '../../../../../models/locker.dart';
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

//Focus Nodes
  final focusLockNumber = FocusNode();
  final focusLockerNumber = FocusNode();
  final focusNbKey = FocusNode();
  final focusFloor = FocusNode();
  final focusJob = FocusNode();
  final focusRemark = FocusNode();

  // Form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Ajouter un casier",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).textSelectionTheme.selectionColor,
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
                          focusNode: focusLockerNumber,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focusNbKey);
                          },
                          controller: lockerNumberController,
                          decoration: InputDecoration(
                            labelText: "N° de casier",
                            prefixIcon: Icon(Icons.lock_outlined),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                          focusNode: focusLockNumber,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focusJob);
                          },
                          controller: lockNumberController,
                          decoration: InputDecoration(
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
                          focus: focusFloor,
                          nextFocus: focusRemark,
                          enabled: true,
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
                          focusNode: focusNbKey,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(focusLockNumber);
                          },
                          controller: nbKeyController,
                          decoration: InputDecoration(
                            labelText: "Nombre de clés",
                            prefixIcon: Icon(Icons.key_outlined),
                          ),
                          keyboardType: TextInputType.number,
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
                            FocusScope.of(context).requestFocus(focusFloor);
                          },
                          controller: jobController,
                          decoration: InputDecoration(
                            labelText: "Métier",
                            prefixIcon: Icon(Icons.work_outlined),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        TextFormField(
                          focusNode: focusRemark,
                          textInputAction: TextInputAction.done,
                          controller: remarkController,
                          decoration: InputDecoration(
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
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
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
