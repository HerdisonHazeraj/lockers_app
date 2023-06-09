import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lockers_app/models/history.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/core/widgets/divider_menu.dart';
import 'package:lockers_app/screens/dashboard/widgets/import_all_menu.dart';
import 'package:provider/provider.dart';

class DashboardMenu extends StatefulWidget {
  const DashboardMenu({super.key});

  @override
  State<DashboardMenu> createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {
  // @override
  // void initState() {
  //   histories = Provider.of<HistoryProvider>(context, listen: false)
  //       .historyItems
  //       .toList();
  //   histories.sort((a, b) => a.date.compareTo(b.date));
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    List<History> histories = [];

    histories = Provider.of<HistoryProvider>(context).historyItems.toList();
    histories.sort((a, b) => a.date.compareTo(b.date));

    return Expanded(
      flex: 4,
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xffececf6),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Historique",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: SingleChildScrollView(
                      child: histories.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ...histories.reversed.map(
                                  (history) => MouseRegion(
                                    onExit: (event) => setState(() {
                                      history.isFocus = false;
                                    }),
                                    onEnter: (event) => setState(() {
                                      history.isFocus = false;
                                    }),
                                    onHover: (event) => setState(() {
                                      history.isFocus = true;
                                    }),
                                    child: ListTile(
                                      title: Text(
                                        history.getSentence(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(
                                        DateFormat('MMM. dd, yyyy').format(
                                            DateTime.parse(history.date)),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      trailing: Visibility(
                                        visible: history.isFocus,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  Provider.of<HistoryProvider>(
                                                          context,
                                                          listen: false)
                                                      .deleteHisotry(
                                                          history.id!);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'L\'action à été confirmer avec succès !'),
                                                      duration:
                                                          Duration(seconds: 3),
                                                    ),
                                                  );
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.done,
                                                color: Colors.black54,
                                              ),
                                              tooltip: "Confirmer",
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  Provider.of<LockerStudentProvider>(
                                                          context,
                                                          listen: false)
                                                      .cancelHistory(history);
                                                  Provider.of<HistoryProvider>(
                                                          context,
                                                          listen: false)
                                                      .deleteHisotry(
                                                          history.id!);

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'L\'action à été annuler avec succès !'),
                                                      duration:
                                                          Duration(seconds: 3),
                                                    ),
                                                  );
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.close_outlined,
                                                color: Colors.black54,
                                              ),
                                              tooltip: "Annuler",
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const Text("Historique Vide")),
                ),
                dividerMenu(),
                ImportAllMenu()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
