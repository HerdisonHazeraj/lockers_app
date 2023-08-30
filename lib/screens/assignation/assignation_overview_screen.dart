import 'package:flutter/material.dart';
import 'package:lockers_app/models/history.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/responsive.dart';
import 'package:lockers_app/screens/assignation/menu_widgets/actionBar_widget.dart';
import 'package:lockers_app/screens/assignation/widgets/available_lockers_list_widget.dart';
import 'package:lockers_app/screens/assignation/widgets/available_students_list_widget.dart';

import 'package:provider/provider.dart';

import '../../models/locker.dart';
import '../../providers/history_provider.dart';
// import 'menu_widgets/sort_element_widget.dart';

class AssignationOverviewScreen extends StatefulWidget {
  static const routeName = '/assignation';
  static const pageIndex = 3;
  const AssignationOverviewScreen({super.key});

  @override
  State<AssignationOverviewScreen> createState() =>
      _AssignationOverviewScreenState();
}

class _AssignationOverviewScreenState extends State<AssignationOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return const AssignListView();
  }
}

class AssignListView extends StatefulWidget {
  const AssignListView({super.key});

  @override
  State<AssignListView> createState() => _AssignListViewState();
}

class _AssignListViewState extends State<AssignListView> {
  _AssignListViewState();

  //Liste affichant les élèves et les casiers dans l'application
  List<Student> studentsListView = [];
  List<Locker> lockersListView = [];

  bool _isAutoAttributeButtonEnabled = false;
  bool _isConfirmButtonEnabled = false;
  bool areAllchecksChecked = false;
  bool isALockerSelected = false;
  bool isSortLockersShown = false;
  bool isSortStudentsShown = false;

  bool isOrderCheckChecked = true;

  bool isStudentsListViewInit = false;
  bool isLockersListViewInit = false;

  bool isExpandedVisible = false;

//listes des filtres complets qui vont être envoyé au provider
  List<List> values = [];
  List<List> keys = [];

//liste contenant les élèves cochés
  List<Student> selectedStudents = [];

//Liste allant recevoir les différents filtres voulus
//les listview vont jongler entre ces différentes listes pour choisir quoi affciher (exemple: élèves de base ou élèves filtrés)
  List<Student> filtredStudent = [];
  List<Student> sortedLockers = [];

  @override
  Widget build(BuildContext context) {
//permet l'affichage de la liste filtré
    void filterStudents(keys, values) {
      setState(() {
        filtredStudent = Provider.of<LockerStudentProvider>(context,
                listen: false)
            .filterStudentsBy(keys, values,
                startList:
                    Provider.of<LockerStudentProvider>(context, listen: false)
                        .getAvailableStudents());
        studentsListView = filtredStudent;
        selectedStudents.clear();
      });
    }

    //test si lockerslistview est initialisé
    if (!isLockersListViewInit) {
      final availableLockers =
          Provider.of<LockerStudentProvider>(context).getAvailableLockers();
      lockersListView = availableLockers;
      isLockersListViewInit = true;
    }

    //test si studentslistview est initialisé ou que certaines options ont été appliquées
    if (!isStudentsListViewInit && values.isEmpty) {
      final availableStudents =
          Provider.of<LockerStudentProvider>(context).getAvailableStudents();
      studentsListView = availableStudents;
      isStudentsListViewInit = true;
    } else if (values.isNotEmpty && !isStudentsListViewInit) {
      isStudentsListViewInit = true;
      filterStudents(
        keys,
        values,
      );
    }

    //check si 2 checkbox ont été checké
    //si oui on peut attribuer automatiquement des casiers
    void checkIfWeCanAutoAssign() {
      setState(() {
        if (selectedStudents.length >= 2) {
          _isAutoAttributeButtonEnabled = true;
          _isConfirmButtonEnabled = false;
          isALockerSelected = false;
          for (var locker in lockersListView) {
            locker.isEnabled = false;
            locker.isSelected = false;
          }
        } else if (selectedStudents.length < 2 && !isALockerSelected) {
          for (var locker in lockersListView) {
            // if(lock)

            locker.isEnabled = true;
          }
          _isAutoAttributeButtonEnabled = false;
        }
      });
    }

    //check si 1 élève et un casier ont été checké
    //si oui on peut attribuer l'élève au casier
    void checkIfWeCanAssign() {
      setState(() {
        if (isALockerSelected && selectedStudents.length == 1) {
          _isConfirmButtonEnabled = true;
          _isAutoAttributeButtonEnabled = false;
        } else {
          _isConfirmButtonEnabled = false;
          _isAutoAttributeButtonEnabled = false;
        }
      });
    }

//permet de changer l'état des checkbox
//(permet de changer l'état de la page depuis une autre page)
    void changeCheckBoxesLockerStates(index, newValue) {
      setState(() {
        lockersListView[index].isSelected = newValue!;

        for (var locker in lockersListView) {
          if (!newValue) {
            locker.isEnabled = true;
            isALockerSelected = false;
          } else {
            if (!locker.isSelected) {
              locker.isEnabled = false;
              isALockerSelected = true;
            }
          }
        }
      });
    }

//permet de changer l'état de la liste de casier
//(permet de changer l'état de la page depuis une autre page)
    void changeLockerListState(sortController, isOrderCheckChecked) {
      setState(() {
        lockersListView =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .sortLockerBy(
                    sortController.text, isOrderCheckChecked, lockersListView);
      });
    }

//gère la fonctionnalité de pouvoir tout sélectionner
    void checkAllChecks(newValue) {
      areAllchecksChecked = newValue!;
      //controle si toutes les checkbox ont été checké (checkbox tout selectionner)
      if (areAllchecksChecked == true) {
        selectedStudents.clear();
        for (var student in studentsListView) {
          student.isSelected = true;
          selectedStudents.add(student);
        }
      } else {
        selectedStudents.clear();
        for (var student in studentsListView) {
          student.isSelected = false;
        }
      }
      checkIfWeCanAutoAssign();
    }

    void showSnackBarMessage(
      String text,
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            text,
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    void autoAttribute() {
      if (areAllchecksChecked) {
        areAllchecksChecked = false;
      }
      int count = Provider.of<LockerStudentProvider>(context, listen: false)
          .autoAttributeLocker(selectedStudents);

      showSnackBarMessage(
          'Casiers attribués avec succès (${count.toString()}x)');
    }

    void attribute() {
      late Locker locker;
      late Student student;

      for (var l in lockersListView) {
        if (l.isSelected) {
          locker = l;
        }
      }
      for (var s in studentsListView) {
        if (s.isSelected) {
          student = s;
        }
      }
      Provider.of<LockerStudentProvider>(context, listen: false)
          .attributeLocker(locker, student);
      Provider.of<HistoryProvider>(context, listen: false).addHistory(
        History(
            date: DateTime.now().toString(),
            action: "attribution",
            locker: locker.toJson(),
            student: student.toJson()),
      );

      showSnackBarMessage(
          'L\'élève ${student.firstName} ${student.lastName} a été attribué avec succès au casier n°${locker.lockerNumber.toString()}');
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  value: areAllchecksChecked,
                                  onChanged: (newValue) {
                                    setState(() {
                                      checkAllChecks(newValue);
                                    });
                                  }),
                              const Text('Tout sélectionner'),
                            ],
                          ),
                          ElevatedButton.icon(
                            label: const Text('Attribuer'),
                            icon: const Icon(Icons.done_all_outlined),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black54),
                            ),
                            onPressed: _isAutoAttributeButtonEnabled ||
                                    _isConfirmButtonEnabled
                                ? () {
                                    if (_isAutoAttributeButtonEnabled) {
                                      autoAttribute();
                                    } else if (_isConfirmButtonEnabled) {
                                      attribute();
                                    }
                                    setState(() {
                                      for (var e in lockersListView) {
                                        e.isEnabled = true;
                                      }
                                      _isAutoAttributeButtonEnabled = false;
                                      _isConfirmButtonEnabled = false;

                                      isLockersListViewInit = false;

                                      isStudentsListViewInit = false;
                                      filterStudents(keys, values);
                                    });
                                  }
                                : null,
                          )
                        ],
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AvailableStudentsListWidget(
                              studentsListView: studentsListView,
                              areAllchecksChecked: areAllchecksChecked,
                              selectedStudents: selectedStudents,
                              checkIfWeCanAssignFunction: checkIfWeCanAssign,
                              checkIfWeCanAutoAssignFunction:
                                  checkIfWeCanAutoAssign,
                            ),
                            AvailableLockersListWidget(
                                availableLockers: lockersListView,
                                isALockerSelected: isALockerSelected,
                                checkIfWeCanAssignVoid: checkIfWeCanAssign,
                                changeCheckBoxesLockerStatesVoid:
                                    (index, newValue) =>
                                        changeCheckBoxesLockerStates(
                                            index, newValue))
                          ]),
                    ],
                  ),
                ),
              ),
            ),
            Responsive.isDesktop(context)
                ? ActionBarWidget(
                    keys: keys,
                    values: values,
                    availableLockers: lockersListView,
                    studentsListView: studentsListView,
                    selectedStudents: selectedStudents,
                    isStudentsListViewInit: isStudentsListViewInit,
                    isSortLockersShown: isSortLockersShown,
                    isOrderCheckChecked: isOrderCheckChecked,
                    filterStudentsVoid: (keys, values) =>
                        filterStudents(keys, values),
                    changeLockerListStateVoid:
                        (sortController, isOrderCheckChecked) =>
                            changeLockerListState(
                                sortController, isOrderCheckChecked))
                : const Text(""),
          ],
        ),
      ),
    );
  }
}
