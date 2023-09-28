import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/core/widgets/divider_menu.dart';
import 'package:lockers_app/screens/mobile/core/shared.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../models/history.dart';

class UpdateExpansionPanel extends StatefulWidget {
  const UpdateExpansionPanel({
    super.key,
    required this.history,
  });

  final History history;
  // final dynamic oldItem;
  // final dynamic newItem;
  @override
  State<UpdateExpansionPanel> createState() => _UpdateExpansionPanelState();
}

class _UpdateExpansionPanelState extends State<UpdateExpansionPanel> {
  Shared shared = Shared();

  bool isItemExpanded = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) async {
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setBool("isExpandedHistoric", !isExpanded);
          setState(() {
            isItemExpanded = !isExpanded;
          });
        },
        elevation: 0,
        expandedHeaderPadding: const EdgeInsets.all(0),
        children: <ExpansionPanel>[
          ExpansionPanel(
              isExpanded: isItemExpanded,
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  dense: false,
                  title: Tooltip(
                    waitDuration: const Duration(milliseconds: 500),
                    message: widget.history.getSentence(),
                    child: Text(
                      widget.history.getSentence(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat("dd.MM.yyyy", "fr")
                        .format(DateTime.parse(widget.history.date)),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  trailing: Visibility(
                    visible: widget.history.isFocus,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              Provider.of<HistoryProvider>(context,
                                      listen: false)
                                  .deleteHistory(widget.history.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
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
                            color: Theme.of(context).iconTheme.color,
                          ),
                          tooltip: "Confirmer",
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              Provider.of<LockerStudentProvider>(context,
                                      listen: false)
                                  .cancelHistory(widget.history);
                              Provider.of<HistoryProvider>(context,
                                      listen: false)
                                  .deleteHistory(widget.history.id!);

                              ScaffoldMessenger.of(context).showSnackBar(
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
                            color: Theme.of(context).iconTheme.color,
                          ),
                          tooltip: "Annuler",
                        )
                      ],
                    ),
                  ),
                );
              },
              body: widget.history.locker != null
                  ? DataTable(columns: [
                      // DataColumn(label: Text('-')),
                      DataColumn(
                        label: Text(
                          'Ancien',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text('Nouveau',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ], rows: [
                      ...shared.createTableDataRows(widget.history.oldLocker!,
                          widget.history.locker!, true),
                    ])
                  : DataTable(columns: [
                      // DataColumn(label: Text('-')),
                      DataColumn(
                        label: Text('Ancien',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Nouveau',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ], rows: [
                      ...shared.createTableDataRows(widget.history.oldStudent!,
                          widget.history.student!, false),
                    ]))
        ]);
  }
}
