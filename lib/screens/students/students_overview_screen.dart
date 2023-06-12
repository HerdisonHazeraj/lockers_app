import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/students/widgets/student_item.dart';
import 'package:lockers_app/screens/students/widgets/student_update.dart';
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

  // Tools for update student
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final mailController = TextEditingController();
  final jobController = TextEditingController();
  final loginController = TextEditingController();
  final yearController = TextEditingController();
  final classeController = TextEditingController();
  final responsableController = TextEditingController();

  // Tools for students by search
  late bool isExpSearch = false;
  late List<Student> searchedStudents = [];
  late String searchValue = "";

  // Tools for students by year
  late List<bool> isExpYear;
  late Map<String, List<Student>> studentsByYear;

  @override
  Widget build(BuildContext context) {
    studentsByYear =
        Provider.of<LockerStudentProvider>(context).getStudentByYear();

    if (!isInit) {
      isExpYear = List.generate(studentsByYear.length, (index) => true);
      isInit = true;
    }

    showUpdateForm(Student s) {
      setState(() {
        s.isUpdating = !s.isUpdating;
      });
    }

    searchStudents(String value) {
      setState(() {
        searchedStudents =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .searchStudents(value);
        searchValue = value;
      });

      if (searchValue.isNotEmpty) {
        isExpSearch = true;
      } else {
        isExpSearch = false;
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: ExpansionPanelList(
                              expansionCallback: (int index, bool isExpanded) {
                                setState(() {
                                  isExpSearch = !isExpSearch;
                                });
                              },
                              expandedHeaderPadding: const EdgeInsets.all(6),
                              animationDuration:
                                  const Duration(milliseconds: 500),
                              children: [
                                ExpansionPanel(
                                  isExpanded: isExpSearch,
                                  canTapOnHeader: true,
                                  headerBuilder: ((context, isExpanded) {
                                    return ListTile(
                                      title: Text(
                                        "Résultats de recherche (${searchedStudents.length.toString()})",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    );
                                  }),
                                  body: searchedStudents.isEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: 1,
                                          itemBuilder: (context, index) =>
                                              const Column(
                                            children: [
                                              ListTile(
                                                title: Text(
                                                  "Aucun résultat",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: searchedStudents.length,
                                          itemBuilder: (context, index) =>
                                              Column(
                                            children: [
                                              StudentItem(
                                                  student:
                                                      searchedStudents[index]),
                                              const Divider(),
                                              searchedStudents[index]
                                                          .isUpdating ==
                                                      true
                                                  ? StudentUpdate(
                                                      student: searchedStudents[
                                                          index],
                                                      showUpdateForm: () =>
                                                          showUpdateForm(
                                                        searchedStudents[index],
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: ExpansionPanelList(
                              expansionCallback: (int index, bool isExpanded) {
                                setState(() {
                                  isExpYear[index] = !isExpYear[index];
                                });
                              },
                              expandedHeaderPadding: const EdgeInsets.all(6),
                              animationDuration:
                                  const Duration(milliseconds: 800),
                              children: [
                                ...studentsByYear.entries.map(
                                  (e) => ExpansionPanel(
                                    isExpanded: isExpYear[studentsByYear.keys
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
                                          StudentItem(
                                            showUpdateForm: () =>
                                                showUpdateForm(e.value[index]),
                                            student: e.value[index],
                                          ),
                                          const Divider(),
                                          e.value[index].isUpdating == true
                                              ? StudentUpdate(
                                                  student: e.value[index],
                                                  showUpdateForm: () =>
                                                      showUpdateForm(
                                                          e.value[index]),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            StudentsMenu(
              searchStudents: (value) => searchStudents(value),
            ),
          ],
        ),
      ),
    );
  }
}
