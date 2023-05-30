import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/assignation/widgets/filter_popup.dart';
import 'package:provider/provider.dart';

import '../../models/locker.dart';

class AssignationOverviewScreen extends StatefulWidget {
  static const routeName = '/assign_screen';
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
  bool _isAutoAttributeButtonEnabled = false;
  bool _isConfirmButtonEnabled = false;
  bool ischecked = false;

  List<Student> selectedStudents = [];

  @override
  Widget build(BuildContext context) {
    final availableLockers =
        Provider.of<LockerStudentProvider>(context).getAvailableLockers();

    final availableStudents =
        Provider.of<LockerStudentProvider>(context).getAvailableStudents();

    _showDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return FilterPopUp();
          });
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50.0, bottom: 25.0),
            child: ElevatedButton(
              onPressed: _isConfirmButtonEnabled
                  ? () {
                      late Locker locker;
                      late Student student;
                      // if(_isButtonDisabled!){
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
                    }
                  : null,
              child: Text('Confirmer'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: ElevatedButton(
                onPressed: _isAutoAttributeButtonEnabled
                    ? () {
                        Provider.of<LockerStudentProvider>(context,
                                listen: false)
                            .autoAttributeLocker(selectedStudents);
                      }
                    : null,
                child: Text('Attribuer automatiquement')),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_alt,
                        size: 25,
                      ),
                      onPressed: _showDialog,
                    ),
                  ),
                  Checkbox(
                      value: ischecked,
                      onChanged: (newValue) {
                        setState(() {
                          ischecked = newValue!;
                          if (ischecked == true) {
                            selectedStudents.clear();
                            availableStudents.forEach((student) {
                              student.isSelected = true;
                              selectedStudents.add(student);
                            });
                          } else {
                            selectedStudents.clear();
                            availableStudents.forEach((student) {
                              student.isSelected = false;
                            });
                          }

                          if (selectedStudents.length >= 2) {
                            _isAutoAttributeButtonEnabled = true;
                            _isConfirmButtonEnabled = false;
                            availableLockers.forEach((e) {
                              e.isEnabled = false;
                              e.isSelected = false;
                            });
                          } else {
                            availableLockers.forEach((e) {
                              e.isEnabled = true;
                              _isAutoAttributeButtonEnabled = false;
                              _isConfirmButtonEnabled = true;
                            });
                          }
                        });
                      }),
                  Text('Tout sélectionner')
                ],
              ),
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

                      if (availableStudents[index].isSelected) {
                        selectedStudents.add(availableStudents[index]);
                      } else {
                        selectedStudents.remove(availableStudents[index]);
                        ischecked = false;
                      }

                      if (selectedStudents.length >= 2) {
                        _isAutoAttributeButtonEnabled = true;
                        _isConfirmButtonEnabled = false;
                        availableLockers.forEach((e) {
                          e.isEnabled = false;
                          e.isSelected = false;
                        });
                      } else {
                        availableLockers.forEach((e) {
                          e.isEnabled = true;
                          _isAutoAttributeButtonEnabled = false;
                          _isConfirmButtonEnabled = true;
                        });
                      }
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
                  title: Text(
                      """${availableLockers[index].lockerNumber.toString()}"""),
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
