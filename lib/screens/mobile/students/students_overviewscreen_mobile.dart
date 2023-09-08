import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/screens/mobile/students/widget/student_item_mobile.dart';
import 'package:provider/provider.dart';

import '../../../providers/lockers_student_provider.dart';
import '../lockers/widget/search_bar_widget.dart';

class StudentsOverviewScreenMobile extends StatefulWidget {
  const StudentsOverviewScreenMobile({super.key});

  @override
  State<StudentsOverviewScreenMobile> createState() =>
      _StudentsOverviewScreenMobileState();
}

class _StudentsOverviewScreenMobileState
    extends State<StudentsOverviewScreenMobile> {
  late List<bool> isExpYear;
  bool isNoCautionExp = true;
  late Map<String, List<Student>> studentsByYear;
  late List<Student> unPaidCautionsStudentsList;

  bool isInit = false;

  late ScrollController _scrollViewController;
  bool _showSearchBar = true;
  bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showSearchBar = false;
          setState(() {
            FocusManager.instance.primaryFocus?.unfocus();
          });
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showSearchBar = true;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    studentsByYear =
        Provider.of<LockerStudentProvider>(context).mapStudentByYear();
    unPaidCautionsStudentsList =
        Provider.of<LockerStudentProvider>(context, listen: false)
            .getNonPaidCaution();
    if (!isInit) {
      isExpYear = List.generate(studentsByYear.length, (index) => false);
      isInit = true;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,

          // );
        },
        child: Icon(Icons.format_list_bulleted_add),
        backgroundColor: Color(0xfffb3274),
        shape: CircleBorder(),
      ),
      body: SizedBox(
          child: Column(children: [
        AnimatedContainer(
            height: _showSearchBar ? 56.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              color: Colors.white,
              child:
                  // Column(
                  // children: [
                  // TextButton(
                  //     onPressed: () {}, child: Text("Générer liste terminaux")),
                  SearchBarWidget(
                isLockerPage: false,
              ),
              // ],
            )
            // ),
            ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollViewController,
            child: Column(
              children: [
                ExpansionPanelList(
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      isNoCautionExp = !isNoCautionExp;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      isExpanded: isNoCautionExp,
                      canTapOnHeader: true,
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          title: Text(
                            "Cautions non payées (${Provider.of<LockerStudentProvider>(context, listen: false).getDefectiveLockers().length})",
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      },
                      body: unPaidCautionsStudentsList.isEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: 1,
                              itemBuilder: (context, index) => const Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      "Aucun élève n'a pas payé ses caution",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black38),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 1,
                              itemBuilder: (context, index) => Column(
                                children: [
                                  ...unPaidCautionsStudentsList.map(
                                    (l) => StudentItemMobile(
                                      student: l,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      isExpYear[index] = !isExpYear[index];
                    });
                  },
                  children: [
                    ...studentsByYear.entries.map(
                      (e) => ExpansionPanel(
                        isExpanded: isExpYear[
                            studentsByYear.keys.toList().indexOf(e.key)],
                        canTapOnHeader: true,
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: Text(
                              'Tous les élèves de ${e.key.toUpperCase()}e année',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        },
                        body: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, index) => Column(
                            children: [
                              ...e.value.map(
                                (s) => StudentItemMobile(
                                  student: s,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ])),
    );
  }
}
