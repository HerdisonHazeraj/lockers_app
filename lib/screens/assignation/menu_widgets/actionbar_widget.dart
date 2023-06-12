import 'package:flutter/material.dart';
import 'package:lockers_app/screens/assignation/widgets/filter_element.dart';
import '../../../models/student.dart';

class ActionBarWidget extends StatefulWidget {
  ActionBarWidget(
      {super.key,
      required this.keys,
      required this.values,
      required this.availableLockers,
      required this.studentsListView,
      required this.selectedStudents,
      required this.isStudentsListViewInit,
      required this.filterStudentsVoid});

  List availableLockers;
  List studentsListView;
  List<List> keys;
  List<List> values;
  List<Student> selectedStudents;
  bool isStudentsListViewInit;

  final Function(List<List> keys, List<List> values) filterStudentsVoid;

  @override
  State<ActionBarWidget> createState() => _ActionBarWidgetState();
}

class _ActionBarWidgetState extends State<ActionBarWidget> {
//filtres afficher dans les select du filtre
  final metiers = ['Informaticien-ne CFC (dès 2021)', 'Opérateur-trice CFC'];
  // final annees = {"1ère": 1, "2ème": 2, "3ème": 3, "4ème": 4};
  final annees = [1, 2, 3, 4];
  final responsables = ['JHI', 'CGU', 'MIV', 'PGA'];
  final caution = [0, 20];

  //clefs des filtres
  List metiersKeys = [];
  List anneesKeys = [];
  List responsablesKeys = [];
  List cautionsKeys = [];

//listes des filtres sélectionné
  List selectedMetiers = [];
  List selectedAnnees = [];
  List selectedResponsables = [];
  List selectedCautions = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                  margin:
                      const EdgeInsets.only(bottom: 80.0, left: 10, top: 10.0),
                  child: Wrap(
                    children: [
                      FilterElement(
                        icon: Icons.work,
                        keys: metiersKeys,
                        dropDownList: metiers,
                        selectedFilters: selectedMetiers,
                        filterName: 'Metier(s): ',
                        filterNod: 'job',
                      ),
                      FilterElement(
                        icon: Icons.calendar_month,
                        keys: anneesKeys,
                        dropDownList: annees,
                        selectedFilters: selectedAnnees,
                        filterName: 'Année(s): ',
                        filterNod: 'year',
                      ),
                      FilterElement(
                        icon: Icons.admin_panel_settings,
                        keys: responsablesKeys,
                        dropDownList: responsables,
                        selectedFilters: selectedResponsables,
                        filterName: 'Responsable(s): ',
                        filterNod: 'manager',
                      ),
                      FilterElement(
                        icon: Icons.attach_money,
                        keys: cautionsKeys,
                        dropDownList: caution,
                        selectedFilters: selectedCautions,
                        filterName: 'Caution: ',
                        filterNod: 'caution',
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0, left: 10.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black54),
                          ),
                          onPressed: () {
                            widget.keys.clear();

                            if (metiersKeys.isNotEmpty) {
                              widget.keys.add(metiersKeys);
                            }
                            if (anneesKeys.isNotEmpty) {
                              widget.keys.add(anneesKeys);
                            }
                            if (responsablesKeys.isNotEmpty) {
                              widget.keys.add(responsablesKeys);
                            }
                            if (cautionsKeys.isNotEmpty) {
                              widget.keys.add(cautionsKeys);
                            }

                            widget.values.clear();
                            if (selectedMetiers.isNotEmpty) {
                              widget.values.add(selectedMetiers);
                            }
                            if (selectedAnnees.isNotEmpty) {
                              widget.values.add(selectedAnnees);
                            }
                            if (selectedResponsables.isNotEmpty) {
                              widget.values.add(selectedResponsables);
                            }
                            if (selectedCautions.isNotEmpty) {
                              widget.values.add(selectedCautions);
                            }

                            widget.filterStudentsVoid(
                                widget.keys, widget.values);
                          },
                          child: const Text('Appliquer'),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
