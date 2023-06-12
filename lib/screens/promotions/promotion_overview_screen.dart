import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/student.dart';
import '../../providers/lockers_student_provider.dart';
import '../assignation/widgets/filter_element.dart';

class PromotionOverviewScreen extends StatefulWidget {
  const PromotionOverviewScreen({super.key});
  static String routeName = "/promotion";

  @override
  State<PromotionOverviewScreen> createState() =>
      _PromotionOverviewScreenState();
}

class _PromotionOverviewScreenState extends State<PromotionOverviewScreen> {
  List<Student> studentsListView = [];

  bool areAllchecksChecked = false;

  bool isExpandedVisible = false;

  bool isPromoteButtonEnabled = false;

  bool isStudentsListViewInit = false;

  final metiers = ['Informaticien-ne CFC (dès 2021)', 'Opérateur-trice CFC'];
  final annees = [1, 2, 3, 4];
  final responsables = ['JHI', 'CGU', 'MIV', 'PGA'];

  //filtres
  List metiersKeys = [];
  List anneesKeys = [];
  List responsablesKeys = [];

//listes des filtres sélectionné
  List selectedMetiers = [];
  List selectedAnnees = [];
  List selectedResponsables = [];

  List<List> values = [];
  List<List> keys = [];

  List<Student> selectedStudents = [];

  //Liste allant recevoir les différents filtres voulus
  List<Student> filtredStudent = [];
  @override
  Widget build(BuildContext context) {
    void filterStudents(keys, values) {
      setState(() {
        filtredStudent = Provider.of<LockerStudentProvider>(context,
                listen: false)
            .filterStudentsBy(keys, values,
                startList:
                    Provider.of<LockerStudentProvider>(context, listen: false)
                        .studentItems);
        studentsListView = filtredStudent;
        selectedStudents.clear();
      });
    }

    if (!isStudentsListViewInit && values.isEmpty) {
      final students = Provider.of<LockerStudentProvider>(context).studentItems;
      studentsListView = students;
      isStudentsListViewInit = true;
    } else if (values.isNotEmpty && !isStudentsListViewInit) {
      isStudentsListViewInit = true;
      filterStudents(keys, values);
    }

    void checkAllChecks(newValue) {
      areAllchecksChecked = newValue!;
      //controle si toutes les checkbox ont été checké (checkbox tout selectionner)
      if (areAllchecksChecked == true) {
        selectedStudents.clear();
        studentsListView.forEach((student) {
          student.isSelected = true;
          selectedStudents.add(student);
        });
        isPromoteButtonEnabled = true;
      } else {
        selectedStudents.clear();
        studentsListView.forEach((student) {
          student.isSelected = false;
        });
        isPromoteButtonEnabled = false;
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
                                    checkAllChecks(newValue);
                                  });
                                }),
                            Text('Tout sélectionner'),
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
                                          enabled:
                                              studentsListView[index].isEnabled,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          value: studentsListView[index]
                                              .isSelected,
                                          title: Text(
                                              '${studentsListView[index].firstName}  ${studentsListView[index].lastName}'),
                                          subtitle: Text(
                                              '  ${studentsListView[index].year} -->  ${studentsListView[index].year + 1}'),
                                          onChanged: (newValue) {
                                            setState(() {
                                              studentsListView[index]
                                                  .isSelected = newValue!;

                                              if (studentsListView[index]
                                                  .isSelected) {
                                                selectedStudents.add(
                                                    studentsListView[index]);
                                                isPromoteButtonEnabled = true;
                                              } else {
                                                selectedStudents.remove(
                                                    studentsListView[index]);
                                                areAllchecksChecked = false;
                                                if (selectedStudents.isEmpty) {
                                                  isPromoteButtonEnabled =
                                                      false;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
                          margin: EdgeInsets.only(
                              bottom: 80.0, left: 10.0, top: 10.0),
                          child: Wrap(
                            children: [
                              FilterElement(
                                icon: Icons.calendar_today_outlined,
                                keys: anneesKeys,
                                dropDownList: annees,
                                selectedFilters: selectedAnnees,
                                filterName: 'Année: ',
                                filterNod: 'year',
                              ),
                              FilterElement(
                                icon: Icons.work_outlined,
                                keys: metiersKeys,
                                dropDownList: metiers,
                                selectedFilters: selectedMetiers,
                                filterName: 'Metiers: ',
                                filterNod: 'metier',
                              ),
                              FilterElement(
                                icon: Icons.admin_panel_settings_outlined,
                                keys: responsablesKeys,
                                dropDownList: responsables,
                                selectedFilters: selectedResponsables,
                                filterName: 'Responsable: ',
                                filterNod: 'manager',
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0, left: 10.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black54),
                                    ),
                                    onPressed: () {
                                      keys.clear();
                                      if (metiersKeys.isNotEmpty)
                                        keys.add(metiersKeys);
                                      if (anneesKeys.isNotEmpty)
                                        keys.add(anneesKeys);
                                      if (responsablesKeys.isNotEmpty)
                                        keys.add(responsablesKeys);

                                      values.clear();
                                      if (selectedMetiers.isNotEmpty)
                                        values.add(selectedMetiers);
                                      if (selectedAnnees.isNotEmpty)
                                        values.add(selectedAnnees);
                                      if (selectedResponsables.isNotEmpty)
                                        values.add(selectedResponsables);

                                      filterStudents(keys, values);
                                    },
                                    child: const Text('Appliquer'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                            icon: const Icon(Icons.done_outlined),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: isPromoteButtonEnabled
                                ? () {
                                    setState(() {
                                      Provider.of<LockerStudentProvider>(
                                              context,
                                              listen: false)
                                          .promoteStudent(selectedStudents);
                                      isStudentsListViewInit = false;
                                      isPromoteButtonEnabled = false;
                                      areAllchecksChecked = false;
                                    });
                                  }
                                : null,
                            label: Text('Promouvoir')),
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
