import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/screens/desktop/students/widgets/student_item.dart';
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
  late Map<String, List<Student>> studentsByYear;

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
    if (!isInit) {
      isExpYear = List.generate(studentsByYear.length, (index) => true);
      isInit = true;
    }

    return SizedBox(
        child: Column(children: [
      AnimatedContainer(
        height: _showSearchBar ? 56.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
            color: Colors.white,
            child: const SearchBarWidget(
              isLockerPage: false,
            )),
      ),
      Expanded(
        child: SingleChildScrollView(
          controller: _scrollViewController,
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                isExpYear[index] = !isExpYear[index];
              });
            },
            children: [
              ...studentsByYear.entries.map((e) => ExpansionPanel(
                    isExpanded:
                        isExpYear[studentsByYear.keys.toList().indexOf(e.key)],
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
                            (s) => StudentItem(
                              student: s,
                              // isLockerInDefectiveList: false,
                              // refreshList: () => refreshList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      )
    ]));
  }
}
