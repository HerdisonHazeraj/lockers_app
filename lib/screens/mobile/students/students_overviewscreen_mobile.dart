import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/screens/mobile/students/widget/student_item_mobile.dart';
import 'package:provider/provider.dart';

import '../../../providers/lockers_student_provider.dart';
import '../../core/components/modal_bottomsheet.dart';
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
  late List<Student> terminauxStudentsList;

  bool isInit = false;

  late ScrollController _scrollViewController;
  bool _showSearchBar = true;
  bool isScrollingDown = false;
  bool isTerminauxListGenerated = false;

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
    terminauxStudentsList =
        Provider.of<LockerStudentProvider>(context, listen: false)
            .getAllTerminaux();
    // isTerminauxListGenerated = !terminauxStudentsList.isNotEmpty;
    if (!isInit) {
      isExpYear = List.generate(studentsByYear.length, (index) => false);
      isInit = true;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
            context: context,
            builder: (_) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Génération de liste',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 34,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isTerminauxListGenerated
                                ? Text(
                                    "Êtes-vous sûr de vouloir supprimer la liste des terminaux ?",
                                    style: TextStyle(fontSize: 16),
                                  )
                                : Text(
                                    "Êtes-vous sûre de vouloir générer la liste des terminaux ?",
                                    style: TextStyle(fontSize: 16),
                                  ),
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Colors.grey.withOpacity(0.2),
                                        ),
                                      ),
                                    ),
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20),
                                    child: ListTile(
                                      onTap: () async {
                                        if (isTerminauxListGenerated) {
                                          Provider.of<LockerStudentProvider>(
                                                  context,
                                                  listen: false)
                                              .setAllTerinauxToFalse();

                                          setState(() {
                                            isTerminauxListGenerated = false;
                                            terminauxStudentsList = Provider.of<
                                                        LockerStudentProvider>(
                                                    context,
                                                    listen: false)
                                                .getAllTerminaux();
                                          });
                                        } else {
                                          Provider.of<LockerStudentProvider>(
                                                  context,
                                                  listen: false)
                                              .setAllTerminauxList();

                                          setState(() {
                                            isTerminauxListGenerated = true;
                                            terminauxStudentsList = Provider.of<
                                                        LockerStudentProvider>(
                                                    context,
                                                    listen: false)
                                                .getAllTerminaux();
                                          });
                                        }
                                      },
                                      title: const Text("Oui"),
                                    ),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      title: const Text("Annuler"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: isTerminauxListGenerated
            ? Icon(Icons.playlist_remove_outlined)
            : Icon(Icons.format_list_bulleted_add),
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
                terminauxStudentsList.isEmpty
                    ? SizedBox(
                        width: 0,
                        height: 0,
                      )
                    : ExpansionPanelList(
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
                                  "Élèves terminaux (${terminauxStudentsList.length})",
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
                                  ...terminauxStudentsList.map(
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
