import 'package:flutter/material.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/lockers/widgets/lockers_menu.dart';
import 'package:provider/provider.dart';

class LockersOverviewScreen extends StatefulWidget {
  const LockersOverviewScreen({super.key});

  static String routeName = "/lockers";

  @override
  State<LockersOverviewScreen> createState() => _LockersOverviewScreenState();
}

class _LockersOverviewScreenState extends State<LockersOverviewScreen> {
// Tools for lockers by search
  late bool isExpSearch = false;
  late List<Locker> searchedLockers = [];
  late String searchValue = "";

  // Tools for lockers by year
  late List<bool> isExpFloor;
  late Map<String, List<Locker>> lockersByFloor;

  @override
  Widget build(BuildContext context) {
    lockersByFloor =
        Provider.of<LockerStudentProvider>(context).mapLockerByFloor();

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
                              expandedHeaderPadding: const EdgeInsets.all(6.0),
                              animationDuration:
                                  const Duration(milliseconds: 500),
                              children: [
                                ExpansionPanel(
                                  isExpanded: isExpSearch,
                                  canTapOnHeader: true,
                                  headerBuilder: (context, isExpanded) {
                                    return ListTile(
                                      title: Text(
                                        "Résultats de recherche (${searchedLockers.length.toString()})",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    );
                                  },
                                  body: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: "Rechercher",
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  searchValue = "";
                                                  searchedLockers = [];
                                                });
                                              },
                                              icon: const Icon(Icons.clear),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              searchValue = value;
                                              searchedLockers = Provider.of<
                                                          LockerStudentProvider>(
                                                      context)
                                                  .searchLockers(value);
                                            });
                                          },
                                        ),
                                      ),
                                      if (searchedLockers.isNotEmpty)
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: searchedLockers.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                searchedLockers[index]
                                                    .lockerNumber
                                                    .toString(),
                                              ),
                                              subtitle: Text(
                                                searchedLockers[index]
                                                    .floor
                                                    .toString(),
                                              ),
                                            );
                                          },
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
            ),
            LockersMenu(),
          ],
        ),
      ),
    );
  }
}
