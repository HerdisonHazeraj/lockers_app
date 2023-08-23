import 'package:flutter/material.dart';
// import 'package:lockers_app/screens/assignation/menu_widgets/dropdown_item_widget.dart';
import 'package:lockers_app/screens/assignation/menu_widgets/sort_element_widget.dart';
import 'package:lockers_app/screens/assignation/menu_widgets/filter_element.dart';
import 'package:lockers_app/screens/core/widgets/divider_menu.dart';
import '../../../models/locker.dart';
import '../../../models/student.dart';

// ignore: must_be_immutable
class ActionBarWidget extends StatefulWidget {
  ActionBarWidget(
      {super.key,
      required this.keys,
      required this.values,
      required this.availableLockers,
      required this.studentsListView,
      required this.selectedStudents,
      required this.isStudentsListViewInit,
      required this.isSortLockersShown,
      required this.filterStudentsVoid,
      required this.changeLockerListStateVoid,
      required this.isOrderCheckChecked});

  List<Locker> availableLockers;
  List<Student> studentsListView;
  List<List> keys;
  List<List> values;
  List<Student> selectedStudents;
  bool isStudentsListViewInit;
  bool isSortLockersShown;
  bool isOrderCheckChecked;

  final Function(List<List> keys, List<List> values) filterStudentsVoid;
  final Function(TextEditingController sortController, bool isOrderCheckChecked)
      changeLockerListStateVoid;

  @override
  State<ActionBarWidget> createState() => _ActionBarWidgetState();
}

class _ActionBarWidgetState extends State<ActionBarWidget> {
//filtres afficher dans les select du filtre
  Map<dynamic, String> metiers = {
    'Informaticien-ne CFC (dès 2021)': 'ICT',
    'OIC': 'OIC'
  };
  Map<dynamic, String> annees = {1: '1ère', 2: '2ème', 3: '3ème', 4: '4ème'};
  Map<dynamic, String> responsables = {
    'CGU': 'Cédric Guerdat',
    'JHI': 'Jacques Hirtzel',
    'JCM': 'Jean-Christophe Mathez',
    'JMO': 'Jean-Pierre Monbaron',
    'JOS': 'Joachim Stalder',
    'MIV': 'Michael Vogel',
    'PGA': 'Pascal Gagnebin',
    'RMU': 'Raymond Musy'
  };

  final sortList = {
    "lockerNumber": 'Numéro de casier',
    "floor": 'Étage',
    "nbKey": 'Nombre de clé(s)'
  };

  final orderList = {
    "1": 'Croissant',
    "2": 'Décroissant',
  };

  //clefs des filtres
  List metiersKeys = [];
  List anneesKeys = [];
  List responsablesKeys = [];

//listes des filtres sélectionné
  List selectedMetiers = [];
  List selectedAnnees = [];
  List selectedResponsables = [];

  List selectedResponsablesFromMap = [];
  List selectedMetiersFromMap = [];
  List selectedAnneesFromMap = [];

  final sortController = TextEditingController();
  final orderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    prepareFilterKeys() {
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

      widget.values.clear();
      selectedMetiersFromMap.clear();
      for (var metier in selectedMetiers) {
        selectedMetiersFromMap.add(metiers.keys
            .firstWhere((element) => metiers[element] == metier)
            .toString());
      }
      selectedAnneesFromMap.clear();
      for (var annee in selectedAnnees) {
        selectedAnneesFromMap.add(int.parse(annees.keys
            .firstWhere((element) => annees[element] == annee)
            .toString()));
      }
      selectedResponsablesFromMap.clear();
      for (var responsable in selectedResponsables) {
        selectedResponsablesFromMap.add(responsables.keys
            .firstWhere((element) => responsables[element] == responsable)
            .toString());
      }
      if (selectedMetiers.isNotEmpty) {
        widget.values.add(selectedMetiersFromMap);
      }
      if (selectedAnnees.isNotEmpty) {
        widget.values.add(selectedAnneesFromMap);
      }
      if (selectedResponsables.isNotEmpty) {
        widget.values.add(selectedResponsablesFromMap);
      }
      widget.filterStudentsVoid(widget.keys, widget.values);
    }

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
                Wrap(
                  children: [
                    FilterElement(
                      icon: Icons.work_outlined,
                      keys: metiersKeys,
                      dropDownList: metiers,
                      selectedFilters: selectedMetiers,
                      filterName: 'Métier(s): ',
                      filterNod: 'job',
                    ),
                    FilterElement(
                      icon: Icons.calendar_month_outlined,
                      keys: anneesKeys,
                      dropDownList: annees,
                      selectedFilters: selectedAnnees,
                      filterName: 'Année(s): ',
                      filterNod: 'year',
                    ),
                    FilterElement(
                      icon: Icons.admin_panel_settings_outlined,
                      keys: responsablesKeys,
                      dropDownList: responsables,
                      selectedFilters: selectedResponsables,
                      filterName: 'Responsable(s): ',
                      filterNod: 'manager',
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0, left: 10.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black54),
                          ),
                          onPressed: () {
                            prepareFilterKeys();
                          },
                          child: const Text('Appliquer'),
                        ),
                      ),
                    )
                  ],
                ),
                const dividerMenu(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    child: Text(
                      "Trier les casiers",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                SortElementWidget(
                  sortList: sortList,
                  orderList: orderList,
                  orderController: orderController,
                  sortController: sortController,
                  isOrderCheckChecked: widget.isOrderCheckChecked,
                  changeLockerListStateVoid:
                      (sortController, isOrderCheckChecked) =>
                          widget.changeLockerListStateVoid(
                    sortController,
                    isOrderCheckChecked,
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
