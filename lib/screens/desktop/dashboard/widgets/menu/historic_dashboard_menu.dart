import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lockers_app/models/history.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/theme.dart';

class HistoricDashboardMenu extends StatefulWidget {
  const HistoricDashboardMenu({super.key});

  @override
  State<HistoricDashboardMenu> createState() => _HistoricDashboardMenuState();
}

class _HistoricDashboardMenuState extends State<HistoricDashboardMenu> {
  bool isExpandedHistoric = false;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkHistoricForm();
    });
  }

  _checkHistoricForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isExpandedHistoric = prefs.getBool("isExpandedHistoric") ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit) {
      Provider.of<HistoryProvider>(context).fetchAndSetHistory();
      _isInit = true;
    }
    List<History> histories = [];

    histories = Provider.of<HistoryProvider>(context).historyItems.toList();
    histories.sort((a, b) => a.date.compareTo(b.date));
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isExpandedHistoric", !isExpanded);
          setState(() {
            isExpandedHistoric = !isExpanded;
          });
        },
        elevation: 0,
        expandedHeaderPadding: const EdgeInsets.all(0),
        children: <ExpansionPanel>[
          ExpansionPanel(
            isExpanded: isExpandedHistoric,
            headerBuilder: (_, isExpanded) {
              return SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Text(
                      "Historique",
                      style: TextStyle(
                        color:
                            Theme.of(context).textSelectionTheme.selectionColor,
                        fontSize: 18,
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
                          child: Text(
                            "Cette historique contient toutes les actions que vous avez effectuer sur l'application. Vous pouvez les annuler ou les confirmer.",
                            style:
                                TextStyle(color: Theme.of(context).cardColor),
                          ),
                        ),
                      ),
                      preferBelow: false,
                      verticalOffset: 20,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.info_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            body: Container(
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
                                title: Tooltip(
                                  waitDuration:
                                      const Duration(milliseconds: 500),
                                  message: history.getSentence(),
                                  child: Text(
                                    history.getSentence(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                                .deleteHistory(history.id!);
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
                                        icon: Icon(
                                          Icons.done,
                                          color:
                                              Theme.of(context).iconTheme.color,
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
                                                .deleteHistory(history.id!);

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
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color:
                                              Theme.of(context).iconTheme.color,
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
                          style: TextStyle(
                              fontSize: 16, color: ColorTheme.thirdTextColor),
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
