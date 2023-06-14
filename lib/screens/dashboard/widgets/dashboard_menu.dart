import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lockers_app/models/history.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:provider/provider.dart';

class DashboardMenu extends StatefulWidget {
  const DashboardMenu({super.key});

  @override
  State<DashboardMenu> createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {
  List<History> histories = [];

  @override
  void initState() {
    histories = Provider.of<HistoryProvider>(context, listen: false)
        .historyItems
        .toList();
    histories.sort((a, b) => a.date.compareTo(b.date));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                ...histories.map(
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
                                        history.action,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(
                                        history.date.toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      trailing: Visibility(
                                        visible: history.isFocus,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // IconButton(
                                            //   onPressed: () {
                                            //     setState(() {
                                            //       students.remove(student);

                                            //       ScaffoldMessenger.of(context)
                                            //           .showSnackBar(
                                            //         SnackBar(
                                            //           content: Text(
                                            //               'L\'ajout de l\'élève ${student.firstName} ${student.lastName} à été confirmer avec succès!'),
                                            //           duration:
                                            //               const Duration(seconds: 3),
                                            //         ),
                                            //       );
                                            //     });
                                            //   },
                                            //   icon: const Icon(
                                            //     Icons.check_outlined,
                                            //     color: Colors.black54,
                                            //   ),
                                            // ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  histories.remove(history);

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
