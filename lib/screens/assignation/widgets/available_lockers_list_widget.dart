import 'package:flutter/material.dart';

import '../../../models/locker.dart';

class AvailableLockersListWidget extends StatefulWidget {
  AvailableLockersListWidget({
    super.key,
    required this.availableLockers,
    required this.isALockerSelected,
    required this.checkIfAStudentAndALockerAreSelectedVoid,
  });

  List<Locker> availableLockers;
  bool isALockerSelected;
  VoidCallback checkIfAStudentAndALockerAreSelectedVoid;

  @override
  State<AvailableLockersListWidget> createState() =>
      _AvailableLockersListWidgetState();
}

class _AvailableLockersListWidgetState
    extends State<AvailableLockersListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: widget.availableLockers.isEmpty
            ? const Center(
                heightFactor: 50, child: Text('Aucun casier disponible '))
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.availableLockers.length,
                itemBuilder: (context, index) => Card(
                  child: CheckboxListTile(
                    enabled: widget.availableLockers[index].isEnabled,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: widget.availableLockers[index].isSelected,
                    title: Text(
                        widget.availableLockers[index].lockerNumber.toString()),
                    subtitle: Text(
                        'Étage ${widget.availableLockers[index].floor.toUpperCase()}'),
                    onChanged: (newValue) {
                      setState(() {
                        widget.availableLockers[index].isSelected = newValue!;

                        for (var e in widget.availableLockers) {
                          if (!newValue) {
                            e.isEnabled = true;
                            widget.isALockerSelected = false;
                          } else {
                            if (!e.isSelected) {
                              e.isEnabled = false;
                              widget.isALockerSelected = true;
                            }
                          }
                        }
                        widget.checkIfAStudentAndALockerAreSelectedVoid;
                      });
                    },
                  ),
                ),
              ));
  }
}
