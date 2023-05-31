import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:multiselect/multiselect.dart';
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
  @override
  Widget build(BuildContext context) {
    return AssignListView();
  }
}

class AssignListView extends StatefulWidget {
  AssignListView({super.key});

  @override
  State<AssignListView> createState() => _AssignListViewState();
}

class _AssignListViewState extends State<AssignListView> {
  _AssignListViewState() {}

  //Liste affichant les élèves dans l'application
  List<Student> studentsListView = [];

  bool _isAutoAttributeButtonEnabled = false;
  bool _isConfirmButtonEnabled = false;
  bool areAllchecksChecked = false;

  bool isStudentsListViewInit = false;

  final metiers = ['OIC', 'ICT', 'ICH'];
  final annees = ['1ère', '2ème', '3ème', '4ème'];
  final responsables = ['JHI', 'CGU'];
  final caution = [0, 20];

//filtres
  List metiersValues = [];
  List anneesValues = [];
  List responsablesValues = [];
  List cautionsValues = [];

  List metiersKeys = [];
  List anneesKeys = [];
  List responsablesKeys = [];
  List cautionsKeys = [];

  List values = [];
  List keys = [];

//listes des filtres sélectionné
  List selectedMetiers = [];
  List selectedAnnees = [];
  List selectedResponsables = [];
  List selectedCautions = [];

//liste contenant les élèves coché
  List<Student> selectedStudents = [];

//Liste allant recevoir les différents filtres voulus
  List<Student> filtredStudent = [];

  @override
  Widget build(BuildContext context) {
    final availableLockers =
        Provider.of<LockerStudentProvider>(context).getAvailableLockers();

    //test si studentslistview est initialisé ou que certaines options ont été appliquées
    if (!isStudentsListViewInit && values.isEmpty) {
      final availableStudents =
          Provider.of<LockerStudentProvider>(context).getAvailableStudents();
      studentsListView = availableStudents;
      isStudentsListViewInit = true;
    } else if (values.isNotEmpty) {
      isStudentsListViewInit = true;
    }

    void filterStudents(keys, RectangularRangeSliderValueIndicatorShape) {
      setState(() {
        filtredStudent =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .filterStudentsBy(keys, values);
        studentsListView = filtredStudent;
        selectedStudents.clear();
      });
    }

    _showDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Filtres'),
              content: Wrap(
                children: [
                  DropDownMultiSelect(
                      onChanged: (value) {
                        setState(() {
                          metiersValues = value;
                          metiersKeys.clear();
                          for (var v in value) {
                            metiersKeys.add('metier');
                          }
                        });
                      },
                      selectedValues: selectedMetiers,
                      options: metiers,
                      decoration: const InputDecoration(
                        labelText: 'Métier: ',
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      )),
                  DropDownMultiSelect(
                      onChanged: (value) {
                        setState(() {
                          anneesValues = value;

                          anneesKeys.clear();
                          for (var v in value) {
                            anneesKeys.add('annee');
                          }
                        });
                      },
                      selectedValues: selectedAnnees,
                      options: annees,
                      decoration: const InputDecoration(
                        labelText: 'Année: ',
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      )),
                  DropDownMultiSelect(
                      onChanged: (value) {
                        setState(() {
                          responsablesValues = value;

                          responsablesKeys.clear();
                          for (var v in value) {
                            responsablesKeys.add('manager');
                          }
                        });
                      },
                      selectedValues: selectedResponsables,
                      options: responsables,
                      decoration: const InputDecoration(
                        labelText: 'Responsable: ',
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      )),
                  DropDownMultiSelect(
                      onChanged: (value) {
                        setState(() {
                          cautionsValues = value;

                          cautionsKeys.clear();
                          for (var v in value) {
                            cautionsKeys.add('caution');
                          }
                        });
                      },
                      selectedValues: selectedCautions,
                      options: caution,
                      decoration: const InputDecoration(
                        labelText: 'Caution: ',
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      )),
                  ElevatedButton(
                    onPressed: () {
                      keys.clear();
                      keys.add(metiersKeys);
                      keys.add(anneesKeys);
                      keys.add(responsablesKeys);
                      keys.add(cautionsKeys);

                      values.clear();
                      values.add(metiersValues);
                      values.add(anneesValues);
                      values.add(responsablesValues);
                      values.add(cautionsValues);

                      filterStudents(keys, values);
                      Navigator.pop(context);
                    },
                    child: const Text('Confirmer'),
                  )
                ],
              ),
            );
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

                      availableLockers.forEach((l) {
                        if (l.isSelected) {
                          locker = l;
                        }
                      });
                      studentsListView.forEach((s) {
                        if (s.isSelected) {
                          student = s;
                        }
                      });
                      Provider.of<LockerStudentProvider>(context, listen: false)
                          .attributeLocker(locker, student);

                      availableLockers.forEach((e) {
                        e.isEnabled = true;
                      });
                      studentsListView.forEach((e) {
                        e.isEnabled = true;
                      });

                      // A changer !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
                      isStudentsListViewInit = false;
                      filterStudents('manager', selectedResponsables[0]);
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
                      value: areAllchecksChecked,
                      onChanged: (newValue) {
                        setState(() {
                          areAllchecksChecked = newValue!;
                          if (areAllchecksChecked == true) {
                            selectedStudents.clear();
                            studentsListView.forEach((student) {
                              student.isSelected = true;
                              selectedStudents.add(student);
                            });
                          } else {
                            selectedStudents.clear();
                            studentsListView.forEach((student) {
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
              itemCount: studentsListView.length,
              itemBuilder: (context, index) => Card(
                child: CheckboxListTile(
                  enabled: studentsListView[index].isEnabled,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: studentsListView[index].isSelected,
                  title: Text(
                      '${studentsListView[index].firstName}  ${studentsListView[index].lastName}'),
                  subtitle: Text(studentsListView[index].job),
                  onChanged: (newValue) {
                    setState(() {
                      studentsListView[index].isSelected = newValue!;

                      if (studentsListView[index].isSelected) {
                        selectedStudents.add(studentsListView[index]);
                      } else {
                        selectedStudents.remove(studentsListView[index]);
                        areAllchecksChecked = false;
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
