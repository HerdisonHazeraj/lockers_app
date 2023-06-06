// import 'package:flutter/material.dart';
// import 'package:lockers_app/screens/assignation/widgets/filter_element.dart';
// import 'package:provider/provider.dart';

// import '../../../providers/lockers_student_provider.dart';
// import '../../../responsive.dart';

// class ActionBarWidget extends StatefulWidget {
//   const ActionBarWidget(void filterStudents, {super.key});
// void filterStudents()
//   @override
//   State<ActionBarWidget> createState() => _ActionBarWidgetState();
// }

// class _ActionBarWidgetState extends State<ActionBarWidget> {
//     bool _isAutoAttributeButtonEnabled = false;
//   bool _isConfirmButtonEnabled = false;

//   final metiers = ['Informaticien-ne CFC (dès 2021)', 'Opérateur-trice CFC'];
//   // final annees = {"1ère": 1, "2ème": 2, "3ème": 3, "4ème": 4};
//   final annees = [1, 2, 3, 4];
//   final responsables = ['JHI', 'CGU', 'MIV', 'PGA'];
//   final caution = [0, 20];

//   //filtres
//   List metiersKeys = [];
//   List anneesKeys = [];
//   List responsablesKeys = [];
//   List cautionsKeys = [];

// //listes des filtres sélectionné
//   List selectedMetiers = [];
//   List selectedAnnees = [];
//   List selectedResponsables = [];
//   List selectedCautions = [];

// //listes des filtres complets
//   List<List> values = [];
//   List<List> keys = [];
//   @override
//   Widget build(BuildContext context) {

    
//     return Expanded(
//               flex: 4,
//               child: SafeArea(
//                 child: Container(
//                   height: MediaQuery.of(context).size.height,
//                   decoration: const BoxDecoration(
//                     color: Color(0xffececf6),
//                   ),
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 30,
//                       horizontal: 30,
//                     ),
//                     child: Column(
//                       children: [
//                         const Align(
//                           alignment: Alignment.centerLeft,
//                           child: SizedBox(
//                             child: Text(
//                               "Filtrer les élèves",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.black54,
//                                 fontWeight: FontWeight.w500,
//                                 height: 1.3,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(
//                               bottom: 80.0, left: 10, top: 10.0),
//                           child: Wrap(
//                             children: [
//                               FilterElement(
//                                 icon: Icons.work,
//                                 keys: metiersKeys,
//                                 dropDownList: metiers,
//                                 selectedFilters: selectedMetiers,
//                                 filterName: 'Metier(s): ',
//                                 filterNod: 'job',
//                               ),
//                               FilterElement(
//                                 icon: Icons.calendar_month,
//                                 keys: anneesKeys,
//                                 dropDownList: annees,
//                                 selectedFilters: selectedAnnees,
//                                 filterName: 'Année(s): ',
//                                 filterNod: 'year',
//                               ),
//                               FilterElement(
//                                 icon: Icons.admin_panel_settings,
//                                 keys: responsablesKeys,
//                                 dropDownList: responsables,
//                                 selectedFilters: selectedResponsables,
//                                 filterName: 'Responsable(s): ',
//                                 filterNod: 'manager',
//                               ),
//                               FilterElement(
//                                 icon: Icons.attach_money,
//                                 keys: cautionsKeys,
//                                 dropDownList: caution,
//                                 selectedFilters: selectedCautions,
//                                 filterName: 'Caution: ',
//                                 filterNod: 'caution',
//                               ),
//                               Container(
//                                 margin: const EdgeInsets.only(
//                                     top: 20.0, left: 10.0),
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     keys.clear();
//                                     if (metiersKeys.isNotEmpty)
//                                       keys.add(metiersKeys);
//                                     if (anneesKeys.isNotEmpty)
//                                       keys.add(anneesKeys);
//                                     if (responsablesKeys.isNotEmpty)
//                                       keys.add(responsablesKeys);
//                                     if (cautionsKeys.isNotEmpty)
//                                       keys.add(cautionsKeys);

//                                     values.clear();
//                                     if (selectedMetiers.isNotEmpty)
//                                       values.add(selectedMetiers);
//                                     if (selectedAnnees.isNotEmpty)
//                                       values.add(selectedAnnees);
//                                     if (selectedResponsables.isNotEmpty)
//                                       values.add(selectedResponsables);
//                                     if (selectedCautions.isNotEmpty)
//                                       values.add(selectedCautions);

//                                     filterStudents(keys, values);
//                                   },
//                                   child: const Text('Appliquer'),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         const Align(
//                           alignment: Alignment.centerLeft,
//                           child: SizedBox(
//                             child: Text(
//                               "Boutons d'attribution",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.black54,
//                                 fontWeight: FontWeight.w500,
//                                 height: 1.3,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               margin: const EdgeInsets.only(
//                                   bottom: 20.0, top: 30.0),
//                               child: ElevatedButton.icon(
//                                 icon: const Icon(Icons.done),
//                                 label: const Text('Attribuer'),
//                                 onPressed: _isConfirmButtonEnabled
//                                     ? () {
//                                         late Locker locker;
//                                         late Student student;

//                                         for (var l in availableLockers) {
//                                           if (l.isSelected) {
//                                             locker = l;
//                                           }
//                                         }
//                                         for (var s in studentsListView) {
//                                           if (s.isSelected) {
//                                             student = s;
//                                           }
//                                         }
//                                         Provider.of<LockerStudentProvider>(
//                                                 context,
//                                                 listen: false)
//                                             .attributeLocker(locker, student);

//                                         for (var e in availableLockers) {
//                                           e.isEnabled = true;
//                                         }
//                                         for (var e in studentsListView) {
//                                           e.isEnabled = true;
//                                         }

//                                         setState(() {
//                                           // A changer
//                                           isStudentsListViewInit = false;
//                                           filterStudents(keys, values);
//                                         });
//                                       }
//                                     : null,
//                               ),
//                             ),
//                             ElevatedButton.icon(
//                               label: const Text('Attribuer Automatiquement'),
//                               icon: const Icon(Icons.done_all),
//                               onPressed: _isAutoAttributeButtonEnabled
//                                   ? () {
//                                       Provider.of<LockerStudentProvider>(
//                                               context,
//                                               listen: false)
//                                           .autoAttributeLocker(
//                                               selectedStudents);
//                                       setState(() {
//                                         isStudentsListViewInit = false;
//                                         filterStudents(keys, values);
//                                       });
//                                     }
//                                   : null,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//   }
// }
