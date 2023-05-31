import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

import '../../models/locker.dart';

class AssignationOverviewScreen extends StatefulWidget {
  static const routeName = '/assignation';
  const AssignationOverviewScreen({super.key});

  @override
  State<AssignationOverviewScreen> createState() =>
      _AssignationOverviewScreenState();
}

class _AssignationOverviewScreenState extends State<AssignationOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _isLoading = true;
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : const AssignListView();
  }
}

class AssignListView extends StatefulWidget {
  const AssignListView({super.key});

  @override
  State<AssignListView> createState() => _AssignListViewState();
}

class _AssignListViewState extends State<AssignListView> {
  @override
  Widget build(BuildContext context) {
    final availableLockers =
        Provider.of<LockerStudentProvider>(context).getAvailableLockers();

    final availableStudents =
        Provider.of<LockerStudentProvider>(context).getAvailableStudents();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50.0, bottom: 50.0),
            child: TextButton(
              onPressed: () {
                late Locker locker;
                late Student student;
                availableLockers.forEach((l) {
                  if (l.isSelected) {
                    locker = l;
                  }
                });
                availableStudents.forEach((s) {
                  if (s.isSelected) {
                    student = s;
                  }
                });
                Provider.of<LockerStudentProvider>(context, listen: false)
                    .attributeLocker(locker, student);

                availableLockers.forEach((e) {
                  e.isEnabled = true;
                });
                availableStudents.forEach((e) {
                  e.isEnabled = true;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Le casier ${locker.lockerNumber} a été attribué à ${student.firstName} ${student.lastName} avec succès !',
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: const Text('Confirmer'),
            ),
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: availableStudents.length,
              itemBuilder: (context, index) => Card(
                child: CheckboxListTile(
                  enabled: availableStudents[index].isEnabled,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: availableStudents[index].isSelected,
                  title: Text(
                      '${availableStudents[index].firstName}  ${availableStudents[index].lastName}'),
                  subtitle: Text(availableStudents[index].job),
                  onChanged: (newValue) {
                    setState(() {
                      availableStudents[index].isSelected = newValue!;
                      availableStudents.forEach((e) {
                        if (!newValue) {
                          e.isEnabled = true;
                        } else {
                          if (!e.isSelected) {
                            e.isEnabled = false;
                          }
                        }
                      });
                    });
                  },
                ),
              ),
            )),
            Expanded(
                child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: availableLockers.length,
              itemBuilder: (context, index) => Card(
                child: CheckboxListTile(
                  enabled: availableLockers[index].isEnabled,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: availableLockers[index].isSelected,
                  title: Text(availableLockers[index].lockerNumber.toString()),
                  subtitle: Text(
                      'Étage ${availableLockers[index].floor.toUpperCase()}'),
                  onChanged: (newValue) {
                    setState(() {
                      availableLockers[index].isSelected = newValue!;

                      availableLockers.forEach((e) {
                        if (!newValue) {
                          e.isEnabled = true;
                        } else {
                          if (!e.isSelected) {
                            e.isEnabled = false;
                          }
                        }
                      });
                    });
                  },
                ),
              ),
            )),
          ]),
        ],
      ),
    );
  }
}
