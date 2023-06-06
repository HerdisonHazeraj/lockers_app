import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/students/student_item.dart';
import 'package:lockers_app/screens/students/widgets/students_menu.dart';
import 'package:provider/provider.dart';

class StudentsOverviewScreen extends StatefulWidget {
  const StudentsOverviewScreen({super.key});

  static String routeName = "/students";

  @override
  State<StudentsOverviewScreen> createState() => _StudentsOverviewScreenState();
}

class _StudentsOverviewScreenState extends State<StudentsOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: StudentsListView(),
    );
  }
}

class StudentsListView extends StatefulWidget {
  const StudentsListView({super.key});

  @override
  State<StudentsListView> createState() => _StudentsListViewState();
}

class _StudentsListViewState extends State<StudentsListView> {
  bool isInit = false;
  late List<bool> _isExps;

  @override
  Widget build(BuildContext context) {
    final students =
        Provider.of<LockerStudentProvider>(context).getStudentByYear();

    if (!isInit) {
      _isExps = List.generate(students.length, (index) => true);
      isInit = true;
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: ExpansionPanelList(
                              expansionCallback: (int index, bool isExpanded) {
                                setState(() {
                                  _isExps[index] = !_isExps[index];
                                });
                              },
                              expandedHeaderPadding: const EdgeInsets.all(6),
                              animationDuration:
                                  const Duration(milliseconds: 500),
                              children: [
                                ...students.entries.map(
                                  (e) => ExpansionPanel(
                                    isExpanded: _isExps[
                                        students.keys.toList().indexOf(e.key)],
                                    canTapOnHeader: true,
                                    headerBuilder: (context, isExpanded) {
                                      return ListTile(
                                        title: Text(
                                          'Tous les élèves de ${e.key}e année',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      );
                                    },
                                    body: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: e.value.length,
                                      itemBuilder: (context, index) => Column(
                                        children: [
                                          StudentItem(e.value[index]),
                                          const Divider(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // const Divider(),
                      // ListTile(
                      //   leading: const Icon(Icons.add),
                      //   title: const Text('Ajouter un élève'),
                      //   onTap: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) => AlertDialog(
                      //         title: const Text('Ajouter un élève'),
                      //         content: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             TextField(
                      //               controller: firstnameController,
                      //               decoration: const InputDecoration(
                      //                 labelText: "Prénom",
                      //               ),
                      //               keyboardType: TextInputType.name,
                      //             ),
                      //             TextField(
                      //               controller: lastnameController,
                      //               decoration: const InputDecoration(
                      //                 labelText: "Nom",
                      //               ),
                      //               keyboardType: TextInputType.name,
                      //             ),
                      //             TextField(
                      //               controller: jobController,
                      //               decoration: const InputDecoration(
                      //                 labelText: "Métier",
                      //               ),
                      //               keyboardType: TextInputType.name,
                      //             ),
                      //           ],
                      //         ),
                      //         actions: [
                      //           TextButton(
                      //             onPressed: () {
                      //               Navigator.of(context).pop();
                      //             },
                      //             child: const Text('Annuler'),
                      //           ),
                      //           TextButton(
                      //             onPressed: () {
                      //               Student student = Student(
                      //                 firstName: firstnameController.text,
                      //                 lastName: lastnameController.text,
                      //                 job: jobController.text,
                      //                 responsable: 'JHI',
                      //                 caution: 0,
                      //                 lockerNumber: 0,
                      //                 login: "",
                      //                 year: 0,
                      //                 classe: "",
                      //               );

                      //               Provider.of<LockerStudentProvider>(context,
                      //                       listen: false)
                      //                   .addStudent(student);

                      //               Navigator.of(context).pop();

                      //               ScaffoldMessenger.of(context).showSnackBar(
                      //                 SnackBar(
                      //                   content: Text(
                      //                       'L\'élève "${student.firstName} ${student.lastName}" a été ajouté avec succès !'),
                      //                   duration: const Duration(seconds: 3),
                      //                 ),
                      //               );

                      //               firstnameController.clear();
                      //               lastnameController.clear();
                      //               jobController.clear();
                      //             },
                      //             child: const Text('Confirmer'),
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                      // const Text(''),
                    ],
                  ),
                ),
              ),
            ),
            const StudentsMenu(),
          ],
        ),
      ),
    );
  }
}
