import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/students/widgets/student_item.dart';
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

  // Tools for students by search
  late bool isExpSearch;
  late List<Student> searchedStudents;

  // Tools for students by year
  late List<bool> _isExpYear;
  late Map<String, List<Student>> studentsByYear;

  @override
  Widget build(BuildContext context) {
    studentsByYear =
        Provider.of<LockerStudentProvider>(context).getStudentByYear();

    if (!isInit) {
      _isExpYear = List.generate(studentsByYear.length, (index) => true);
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
                      searchedStudents == []
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: SingleChildScrollView(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ExpansionPanelList(
                                    expansionCallback:
                                        (int index, bool isExpanded) {
                                      setState(() {
                                        _isExpYear[index] = !_isExpYear[index];
                                      });
                                    },
                                    expandedHeaderPadding:
                                        const EdgeInsets.all(6),
                                    animationDuration:
                                        const Duration(milliseconds: 500),
                                    children: [
                                      ExpansionPanel(
                                        canTapOnHeader: true,
                                        headerBuilder: ((context, isExpanded) {
                                          return const ListTile(
                                            title: Text(
                                              'Résultats de recherche',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          );
                                        }),
                                        body: ListView.builder(
                                          itemBuilder: ((context, index) =>
                                              null),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: ExpansionPanelList(
                              expansionCallback: (int index, bool isExpanded) {
                                setState(() {
                                  _isExpYear[index] = !_isExpYear[index];
                                });
                              },
                              expandedHeaderPadding: const EdgeInsets.all(6),
                              animationDuration:
                                  const Duration(milliseconds: 500),
                              children: [
                                ...studentsByYear.entries.map(
                                  (e) => ExpansionPanel(
                                    isExpanded: _isExpYear[studentsByYear.keys
                                        .toList()
                                        .indexOf(e.key)],
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
