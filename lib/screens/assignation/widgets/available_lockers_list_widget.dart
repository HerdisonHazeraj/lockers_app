import 'package:flutter/material.dart';

import '../../../models/locker.dart';

class AvailableLockersListWidget extends StatefulWidget {
  AvailableLockersListWidget(
      {super.key,
      required this.availableLockers,
      required this.isALockerSelected,
      required this.checkIfWeCanAssignVoid,
      required this.changeCheckBoxesLockerStatesVoid});

  List<Locker> availableLockers;
  bool isALockerSelected;
  final VoidCallback checkIfWeCanAssignVoid;
  final Function(int index, bool? newValue) changeCheckBoxesLockerStatesVoid;

  @override
  State<AvailableLockersListWidget> createState() =>
      _AvailableLockersListWidgetState();
}

class _AvailableLockersListWidgetState
    extends State<AvailableLockersListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: SingleChildScrollView(
            child: widget.availableLockers.isEmpty
                ? const Center(
                    heightFactor: 50, child: Text('Aucun casier disponible '))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: widget.availableLockers.length,
                        itemBuilder: (context, index) => Card(
                          child: CheckboxListTile(
                            enabled: widget.availableLockers[index].isEnabled,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: widget.availableLockers[index].isSelected,
                            title: Text(widget
                                .availableLockers[index].lockerNumber
                                .toString()),
                            subtitle: Text(
                                'Étage ${widget.availableLockers[index].floor.toUpperCase()}'),
                            onChanged: (newValue) {
                              setState(() {
                                widget.changeCheckBoxesLockerStatesVoid(
                                    index, newValue);

                                widget.checkIfWeCanAssignVoid();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
          )),
    );
  }
}
