import 'package:flutter/material.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/responsive.dart';
import 'package:lockers_app/screens/desktop/lockers/widgets/locker_item.dart';
import 'package:lockers_app/screens/desktop/lockers/widgets/locker_update.dart';
import 'package:lockers_app/screens/desktop/lockers/widgets/lockers_menu.dart';
import 'package:provider/provider.dart';

class LockersOverviewScreen extends StatefulWidget {
  const LockersOverviewScreen({super.key});

  static String routeName = "/lockers";
  static int pageIndex = 1;

  @override
  State<LockersOverviewScreen> createState() => _LockersOverviewScreenState();
}

class _LockersOverviewScreenState extends State<LockersOverviewScreen> {
  bool isInit = false;
  // Tools for defective lockers elias
  late bool isExpDefective = false;
  late List<Locker> defectiveLockers = [];
  // Tools for lockers by search
  late bool isExpSearch = false;
  late List<Locker> searchedLockers = [];
  late String searchValue = "";

  // Tools for lockers inaccessible
  late bool isExpInaccessible = false;
  late List<Locker> inaccessibleLockers = [];

  // Tools for lockers by year
  late List<bool> isExpFloor;
  late Map<String, List<Locker>> lockersByFloor;

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    lockersByFloor =
        Provider.of<LockerStudentProvider>(context).mapLockerByFloor();
    inaccessibleLockers =
        Provider.of<LockerStudentProvider>(context).getInaccessibleLocker();
    // defectiveLockers = Provider.of<LockerStudentProvider>(context)
    //     .getDefectiveLockers()
    //     .toList();

    if (!isInit) {
      isExpFloor = List.generate(lockersByFloor.length, (index) => true);
      defectiveLockers =
          Provider.of<LockerStudentProvider>(context, listen: false)
              .getDefectiveLockers()
              .toList();
      isInit = true;
    }

    searchLockers(String value) {
      setState(() {
        scrollController.animateTo(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn);
        searchedLockers =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .searchLockers(value);
        searchValue = value;
      });

      if (searchValue.isNotEmpty) {
        isExpSearch = true;
      } else {
        isExpSearch = false;
      }
    }

    refreshDefectiveList() async {
      // setState(() {
      defectiveLockers =
          Provider.of<LockerStudentProvider>(context, listen: false)
              .getDefectiveLockers()
              .toList();
      // });
    }

    refreshList() async {
      // setState(() async {
      searchLockers(searchValue);
      await Provider.of<LockerStudentProvider>(context, listen: false)
          .setAllLockerToDefective();
      await refreshDefectiveList();
      searchLockers(searchValue);
      // });
    }

    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                controller: scrollController,
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
                          expandedHeaderPadding: const EdgeInsets.all(6.0),
                          animationDuration: const Duration(milliseconds: 500),
                          children: [
                            ExpansionPanel(
                              isExpanded: isExpSearch,
                              canTapOnHeader: true,
                              headerBuilder: ((context, isExpanded) {
                                return ListTile(
                                  title: Text(
                                    "Résultats de recherche (${searchedLockers.length.toString()})",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                );
                              }),
                              body: searchedLockers.isEmpty
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
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black38),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ExpansionPanelList(
                                      expansionCallback:
                                          (int index, bool isExpanded) {
                                        setState(() {
                                          searchedLockers[index]
                                                  .isUpdatingSearch =
                                              !searchedLockers[index]
                                                  .isUpdatingSearch;
                                        });
                                      },
                                      expandedHeaderPadding:
                                          const EdgeInsets.all(0),
                                      animationDuration:
                                          const Duration(milliseconds: 500),
                                      children: [
                                        ...searchedLockers.map(
                                          (l) => ExpansionPanel(
                                            isExpanded: l.isUpdatingSearch,
                                            canTapOnHeader: true,
                                            headerBuilder:
                                                (context, isExpanded) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: LockerItem(
                                                  locker: l,
                                                  isLockerInDefectiveList:
                                                      false,
                                                ),
                                              );
                                            },
                                            body: l.isUpdatingSearch
                                                ? LockerUpdate(
                                                    locker: l,
                                                    showUpdateForm: () =>
                                                        setState(() {
                                                      l.isUpdatingSearch =
                                                          !l.isUpdatingSearch;
                                                    }),
                                                    updateSearchLockerList:
                                                        () => refreshList(),
                                                  )
                                                : const SizedBox(),
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              isExpDefective = !isExpDefective;
                            });
                          },
                          expandedHeaderPadding: const EdgeInsets.all(6.0),
                          animationDuration: const Duration(milliseconds: 500),
                          children: [
                            ExpansionPanel(
                              isExpanded: isExpDefective,
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
                                      itemBuilder: (context, index) =>
                                          const Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                              "Aucune tâche",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black38),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 1,
                                      itemBuilder: (context, index) => Column(
                                        children: [
                                          ...defectiveLockers.map(
                                            (l) => LockerItem(
                                              locker: l,
                                              isLockerInDefectiveList: true,
                                              refreshList: () => refreshList(),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              isExpFloor[index] = !isExpFloor[index];
                            });
                          },
                          expandedHeaderPadding: const EdgeInsets.all(6.0),
                          animationDuration: const Duration(milliseconds: 500),
                          children: [
                            ...lockersByFloor.entries.map(
                              (e) => ExpansionPanel(
                                isExpanded: isExpFloor[lockersByFloor.keys
                                    .toList()
                                    .indexOf(e.key)],
                                canTapOnHeader: true,
                                headerBuilder: (context, isExpanded) {
                                  return ListTile(
                                    title: Text(
                                      'Tous les casiers de l\'étage ${e.key.toUpperCase()}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  );
                                },
                                body: Responsive.isDesktop(context)
                                    ? ExpansionPanelList(
                                        expansionCallback:
                                            (int index, bool isExpanded) {
                                          setState(() {
                                            e.value[index].isUpdating =
                                                !e.value[index].isUpdating;
                                          });
                                        },
                                        expandedHeaderPadding:
                                            const EdgeInsets.all(0),
                                        animationDuration:
                                            const Duration(milliseconds: 500),
                                        children: [
                                          ...e.value.map(
                                            (l) => ExpansionPanel(
                                              isExpanded: l.isUpdating,
                                              canTapOnHeader: true,
                                              headerBuilder:
                                                  (context, isExpanded) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: LockerItem(
                                                    locker: l,
                                                    isLockerInDefectiveList:
                                                        false,
                                                    refreshList: () =>
                                                        refreshList(),
                                                  ),
                                                );
                                              },
                                              body: l.isUpdating == true
                                                  ? LockerUpdate(
                                                      locker: l,
                                                      showUpdateForm: () =>
                                                          setState(() {
                                                        l.isUpdating =
                                                            !l.isUpdating;
                                                      }),
                                                      updateSearchLockerList:
                                                          () => refreshList(),
                                                    )
                                                  : const SizedBox(),
                                            ),
                                          ),
                                        ],
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 1,
                                        itemBuilder: (context, index) => Column(
                                          children: [
                                            ...e.value.map(
                                              (l) => LockerItem(
                                                locker: l,
                                                isLockerInDefectiveList: false,
                                                refreshList: () =>
                                                    refreshList(),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              isExpInaccessible = !isExpInaccessible;
                            });
                          },
                          expandedHeaderPadding: const EdgeInsets.all(6.0),
                          animationDuration: const Duration(milliseconds: 500),
                          children: [
                            ExpansionPanel(
                              isExpanded: isExpInaccessible,
                              canTapOnHeader: true,
                              headerBuilder: (context, isExpanded) {
                                return ListTile(
                                  title: Text(
                                    "Casiers inaccessibles (${inaccessibleLockers.length.toString()})",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                );
                              },
                              body: inaccessibleLockers.isEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 1,
                                      itemBuilder: (context, index) =>
                                          const Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                              "Aucun casier inaccessible",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ExpansionPanelList(
                                      expansionCallback:
                                          (int index, bool isExpanded) {
                                        setState(() {
                                          inaccessibleLockers[index]
                                                  .isUpdating =
                                              !inaccessibleLockers[index]
                                                  .isUpdating;
                                        });
                                      },
                                      expandedHeaderPadding:
                                          const EdgeInsets.all(0),
                                      animationDuration:
                                          const Duration(milliseconds: 500),
                                      children: [
                                        ...inaccessibleLockers.map(
                                          (l) => ExpansionPanel(
                                            isExpanded: l.isUpdating,
                                            canTapOnHeader: true,
                                            headerBuilder:
                                                (context, isExpanded) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: LockerItem(
                                                  locker: l,
                                                  isLockerInDefectiveList:
                                                      false,
                                                ),
                                              );
                                            },
                                            body: l.isUpdating
                                                ? LockerUpdate(
                                                    locker: l,
                                                  )
                                                : const SizedBox(),
                                          ),
                                        ),
                                      ],
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
          Responsive.isDesktop(context)
              ? LockersMenu(
                  searchLockers: (value) => searchLockers(value),
                )
              : const Text(''),
        ],
      ),
    );
  }
}
