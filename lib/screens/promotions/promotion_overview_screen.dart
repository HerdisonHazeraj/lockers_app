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
  bool areAllchecksChecked = false;

  bool isExpandedVisible = false;

  bool isPromoteButtonEnabled = false;

  final metiers = ['OIC', 'ICT', 'ICH'];
  final annees = ['1ère', '2ème', '3ème', '4ème'];
  final responsables = ['JHI', 'CGU'];

  //filtres
  List metiersKeys = [];
  List anneesKeys = [];
  List responsablesKeys = [];

//listes des filtres sélectionné
  List selectedMetiers = [];
  List selectedAnnees = [];
  List selectedResponsables = [];

  List<Student> selectedStudents = [];
  @override
  Widget build(BuildContext context) {
    final students = Provider.of<LockerStudentProvider>(context).studentItems;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.filter_alt,
                        size: 25,
                      ),
                      onPressed: () {
                        setState(() {
                          isExpandedVisible = !isExpandedVisible;
                        });
                      },
                    ),
                    Checkbox(
                        value: areAllchecksChecked,
                        onChanged: (newValue) {
                          setState(() {
                            areAllchecksChecked = newValue!;
                            //controle si toutes les checkbox ont été checké (checkbox tout selectionner)
                            if (areAllchecksChecked == true) {
                              selectedStudents.clear();
                              students.forEach((student) {
                                student.isSelected = true;
                                selectedStudents.add(student);
                              });
                            } else {
                              selectedStudents.clear();
                              students.forEach((student) {
                                student.isSelected = false;
                              });
                            }
                          });
                        }),
                    Text('Tout sélectionner'),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {},
                        child: Text('Promouvoir'))),
              ],
            ),
          ),
          Visibility(
            visible: isExpandedVisible,
            child: Container(
              margin: EdgeInsets.only(bottom: 50.0, left: 10.0),
              child: Wrap(
                children: [
                  FilterElement(
                    keys: anneesKeys,
                    dropDownList: annees,
                    selectedFilters: selectedAnnees,
                    filterName: 'Année: ',
                    filterNod: 'annee',
                  ),
                  FilterElement(
                    keys: metiersKeys,
                    dropDownList: metiers,
                    selectedFilters: selectedMetiers,
                    filterName: 'Métier: ',
                    filterNod: 'metier',
                  ),
                  FilterElement(
                    keys: responsablesKeys,
                    dropDownList: responsables,
                    selectedFilters: selectedResponsables,
                    filterName: 'Responsable: ',
                    filterNod: 'manager',
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0, left: 10.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Appliquer'),
                    ),
                  )
                ],
              ),
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: students.length,
            itemBuilder: (context, index) => Card(
              child: CheckboxListTile(
                enabled: students[index].isEnabled,
                controlAffinity: ListTileControlAffinity.leading,
                value: students[index].isSelected,
                title: Text(
                    '${students[index].firstName}  ${students[index].lastName}'),
                subtitle: Text(students[index].job),
                onChanged: (newValue) {
                  setState(() {
                    students[index].isSelected = newValue!;

                    if (students[index].isSelected) {
                      selectedStudents.add(students[index]);
                      isPromoteButtonEnabled = true;
                    } else {
                      selectedStudents.remove(students[index]);
                      areAllchecksChecked = false;
                      if (selectedStudents.length == 0) {
                        isPromoteButtonEnabled = false;
                      }
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
