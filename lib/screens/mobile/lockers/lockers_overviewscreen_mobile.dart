import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lockers_app/screens/mobile/lockers/widget/search_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../../models/locker.dart';
import '../../../providers/lockers_student_provider.dart';
import '../../desktop/lockers/widgets/locker_item.dart';

class LockersOverviewScreenMobile extends StatefulWidget {
  const LockersOverviewScreenMobile({super.key});

  @override
  State<LockersOverviewScreenMobile> createState() =>
      _LockersOverviewScreenMobileState();
}

class _LockersOverviewScreenMobileState
    extends State<LockersOverviewScreenMobile> {
  late List<bool> isExpFloor = [true, false, false, false, false];
  bool isTasksLisExp = true;
  late Map<String, List<Locker>> lockersByFloor;
  late List<Locker> defectiveLockers = [];

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
    lockersByFloor =
        Provider.of<LockerStudentProvider>(context).mapLockerByFloor();
    defectiveLockers =
        Provider.of<LockerStudentProvider>(context, listen: false)
            .getDefectiveLockers()
            .toList();

    // if (!isInit) {
    //   isExpFloor = List.generate(lockersByFloor.length, (index) => false);
    //   // defectiveLockers =
    //   //     Provider.of<LockerStudentProvider>(context, listen: false)
    //   //         .getDefectiveLockers()
    //   //         .toList();
    //   isInit = true;
    // }

    return SizedBox(
        // child: SingleChildScrollView(
        //   controller: _scrollViewController,
        child: Column(children: [
      //barre de recherche
      AnimatedContainer(
        height: _showSearchBar ? 56.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
            color: Colors.white,
            child: const SearchBarWidget(
              isLockerPage: true,
            )),
      ),

      Expanded(
        child: SingleChildScrollView(
          controller: _scrollViewController,
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                isExpFloor[index] = !isExpFloor[index];
              });
            },
            children: [
              ExpansionPanel(
                isExpanded: isExpFloor[0],
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text(
                      "Tâches (${Provider.of<LockerStudentProvider>(context, listen: false).getDefectiveLockers().length})",
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                },
                body: defectiveLockers.isEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) => const Column(
                          children: [
                            ListTile(
                              title: Text(
                                "Aucune tâche",
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
                            ...defectiveLockers.map(
                              (l) => LockerItem(
                                locker: l,
                                isLockerInDefectiveList: true,
                                // refreshList: () => refreshList(),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              ...lockersByFloor.entries.map((e) => ExpansionPanel(
                    isExpanded:
                        isExpFloor[lockersByFloor.keys.toList().indexOf(e.key)],
                    canTapOnHeader: true,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: Text(
                          'Tous les casiers de l\'étage ${e.key.toUpperCase()}',
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
                            (l) => LockerItem(
                              locker: l,
                              isLockerInDefectiveList: false,
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
    //   ),
    // );
  }
}
