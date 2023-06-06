import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
// import 'package:lockers_app/screens/assignation/widgets/buttonBar_widget.dart';

import 'package:lockers_app/screens/assignation/widgets/filter_element.dart';

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

  //Liste affichant les élèves dans l'application
  List<Student> studentsListView = [];

  bool _isAutoAttributeButtonEnabled = false;
  bool _isConfirmButtonEnabled = false;
  bool areAllchecksChecked = false;
  bool isALockerSelected = false;

  bool isStudentsListViewInit = false;

  bool isExpandedVisible = false;

  final metiers = ['Informaticien-ne CFC (dès 2021)', 'Opérateur-trice CFC'];
  // final annees = {"1ère": 1, "2ème": 2, "3ème": 3, "4ème": 4};
  final annees = [1, 2, 3, 4];
  final responsables = ['JHI', 'CGU'];
  final caution = [0, 20];

//filtres
  List metiersKeys = [];
  List anneesKeys = [];
  List responsablesKeys = [];
  List cautionsKeys = [];

//listes des filtres sélectionné
  List selectedMetiers = [];
  List selectedAnnees = [];
  List selectedResponsables = [];
  List selectedCautions = [];

//listes des filtres complets
  List<List> values = [];
  List<List> keys = [];

//liste contenant les élèves cochés
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

    void filterStudents(keys, values) {
      setState(() {
        filtredStudent =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .filterStudentsBy(keys, values);
        studentsListView = filtredStudent;
        selectedStudents.clear();
      });
    }

    //check si 2 checkbox ont été checké
    //si oui on peut attribuer automatiquement des casiers
    void checkIf2CheckBoxesAreChecked(availableLockers) {
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
        });
        _isAutoAttributeButtonEnabled = false;
      }
    }

    void checkIfAStudentAndALockerAreSelected() {
      if (isALockerSelected && selectedStudents.length == 1) {
        _isConfirmButtonEnabled = true;
        _isAutoAttributeButtonEnabled = false;
      } else {
        _isConfirmButtonEnabled = false;
        _isAutoAttributeButtonEnabled = false;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 10,
              child: SafeArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    margin: const EdgeInsets.all(55),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: areAllchecksChecked,
                                onChanged: (newValue) {
                                  setState(() {
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

                                    checkIf2CheckBoxesAreChecked(
                                        availableLockers);
                                  });
                                }),
                            const Text('Tout sélectionner'),
                          ],
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: studentsListView.length,
                                        itemBuilder: (context, index) => Card(
                                          child: CheckboxListTile(
                                            enabled: studentsListView[index]
                                                .isEnabled,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            value: studentsListView[index]
                                                .isSelected,
                                            title: Text(
                                                '${studentsListView[index].firstName}  ${studentsListView[index].lastName}'),
                                            subtitle: Text(
                                                studentsListView[index].job),
                                            onChanged: (newValue) {
                                              setState(() {
                                                studentsListView[index]
                                                    .isSelected = newValue!;

                                                if (studentsListView[index]
                                                    .isSelected) {
                                                  selectedStudents.add(
                                                      studentsListView[index]);
                                                } else {
                                                  selectedStudents.remove(
                                                      studentsListView[index]);
                                                  areAllchecksChecked = false;
                                                }

                                                checkIfAStudentAndALockerAreSelected();
                                                checkIf2CheckBoxesAreChecked(
                                                    availableLockers);
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: availableLockers.length,
                                itemBuilder: (context, index) => Card(
                                  child: CheckboxListTile(
                                    enabled: availableLockers[index].isEnabled,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value: availableLockers[index].isSelected,
                                    title: Text(availableLockers[index]
                                        .lockerNumber
                                        .toString()),
                                    subtitle: Text(
                                        'Étage ${availableLockers[index].floor.toUpperCase()}'),
                                    onChanged: (newValue) {
                                      setState(() {
                                        availableLockers[index].isSelected =
                                            newValue!;

                                        for (var e in availableLockers) {
                                          if (!newValue) {
                                            e.isEnabled = true;
                                            isALockerSelected = false;
                                          } else {
                                            if (!e.isSelected) {
                                              e.isEnabled = false;
                                              isALockerSelected = true;
                                            }
                                          }
                                        }
                                        checkIfAStudentAndALockerAreSelected();
                                      });
                                    },
                                  ),
                                ),
                              )),
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Color(0xffececf6),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 30,
                    ),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            child: Text(
                              "Filtrer les élèves",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 80.0, left: 10, top: 10.0),
                          child: Wrap(
                            children: [
                              FilterElement(
                                keys: metiersKeys,
                                dropDownList: metiers,
                                selectedFilters: selectedMetiers,
                                filterName: 'Metier(s): ',
                                filterNod: 'job',
                              ),
                              FilterElement(
                                keys: anneesKeys,
                                dropDownList: annees,
                                selectedFilters: selectedAnnees,
                                filterName: 'Année(s): ',
                                filterNod: 'year',
                              ),
                              FilterElement(
                                keys: responsablesKeys,
                                dropDownList: responsables,
                                selectedFilters: selectedResponsables,
                                filterName: 'Responsable(s): ',
                                filterNod: 'manager',
                              ),
                              FilterElement(
                                keys: cautionsKeys,
                                dropDownList: caution,
                                selectedFilters: selectedCautions,
                                filterName: 'Caution: ',
                                filterNod: 'caution',
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 20.0, left: 10.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    keys.clear();
                                    if (metiersKeys.isNotEmpty)
                                      keys.add(metiersKeys);
                                    if (anneesKeys.isNotEmpty)
                                      keys.add(anneesKeys);
                                    if (responsablesKeys.isNotEmpty)
                                      keys.add(responsablesKeys);
                                    if (cautionsKeys.isNotEmpty)
                                      keys.add(cautionsKeys);

                                    values.clear();
                                    if (selectedMetiers.isNotEmpty)
                                      values.add(selectedMetiers);
                                    if (selectedAnnees.isNotEmpty)
                                      values.add(selectedAnnees);
                                    if (selectedResponsables.isNotEmpty)
                                      values.add(selectedResponsables);
                                    if (selectedCautions.isNotEmpty)
                                      values.add(selectedCautions);

                                    filterStudents(keys, values);
                                  },
                                  child: const Text('Appliquer'),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            child: Text(
                              "Boutons d'attribution",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  bottom: 20.0, top: 30.0),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.done),
                                label: const Text('Attribuer'),
                                onPressed: _isConfirmButtonEnabled
                                    ? () {
                                        late Locker locker;
                                        late Student student;

                                        for (var l in availableLockers) {
                                          if (l.isSelected) {
                                            locker = l;
                                          }
                                        }
                                        for (var s in studentsListView) {
                                          if (s.isSelected) {
                                            student = s;
                                          }
                                        }
                                        Provider.of<LockerStudentProvider>(
                                                context,
                                                listen: false)
                                            .attributeLocker(locker, student);

                                        for (var e in availableLockers) {
                                          e.isEnabled = true;
                                        }
                                        for (var e in studentsListView) {
                                          e.isEnabled = true;
                                        }

                                        setState(() {
                                          // A changer
                                          isStudentsListViewInit = false;
                                          filterStudents(keys, values);
                                        });
                                      }
                                    : null,
                              ),
                            ),
                            ElevatedButton.icon(
                              label: const Text('Attribuer Automatiquement'),
                              icon: const Icon(Icons.done_all),
                              onPressed: _isAutoAttributeButtonEnabled
                                  ? () {
                                      Provider.of<LockerStudentProvider>(
                                              context,
                                              listen: false)
                                          .autoAttributeLocker(
                                              selectedStudents);
                                      setState(() {
                                        isStudentsListViewInit = false;
                                        filterStudents(keys, values);
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
