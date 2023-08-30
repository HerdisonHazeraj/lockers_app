import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
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
  @override
  void initState() {
    super.initState();

    initializeDateFormatting("fr");
  }

  @override
  Widget build(BuildContext context) {
    List<History> histories = [];

    histories = Provider.of<HistoryProvider>(context).historyItems.toList();
    histories.sort((a, b) => a.date.compareTo(b.date));

    return Container(
      width: MediaQuery.of(context).size.width / 4,
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
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  const Text(
                    "Historique",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  Tooltip(
                    richMessage: WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: const Text(
                          "Cette historique contient toutes les actions que vous avez effectuer sur l'application. Vous pouvez les annuler ou les confirmer.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    preferBelow: false,
                    verticalOffset: 20,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.info_outlined,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              constraints: const BoxConstraints(
                minHeight: 0,
                maxHeight: 400,
              ),
              child: SingleChildScrollView(
                child: histories.isNotEmpty
                    ? Column(
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
                                contentPadding: const EdgeInsets.all(0),
                                dense: false,
                                title: Text(
                                  history.getSentence(),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat("dd.MM.yyyy", "fr")
                                      .format(DateTime.parse(history.date)),
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
                                                .deleteHisotry(history.id!);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'L\'action à été confirmer avec succès !'),
                                                duration: Duration(seconds: 3),
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
                                                .deleteHisotry(history.id!);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'L\'action à été annuler avec succès !'),
                                                duration: Duration(seconds: 3),
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
                    : const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "Votre historique est vide",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black38),
                        ),
                      ),
              ),
            ),
            const dividerMenu(),
            ImportAllMenu()
          ],
        ),
      ),
    );
  }
}
