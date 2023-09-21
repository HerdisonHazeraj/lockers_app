import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/desktop/assignation/assignation_overview_screen.dart';
import 'package:lockers_app/screens/desktop/dashboard/dashboard_overview_screen.dart';
import 'package:lockers_app/screens/desktop/lockers/lockers_overview_screen.dart';
import 'package:lockers_app/screens/desktop/students/students_overview_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/theme.dart';

class SideMenuApp extends StatefulWidget {
  const SideMenuApp({
    super.key,
    required this.sideMenuController,
  });

  final SideMenuController sideMenuController;

  @override
  State<SideMenuApp> createState() => _SideMenuAppState();
}

class _SideMenuAppState extends State<SideMenuApp> {
  @override
  Widget build(BuildContext context) {
    return SideMenu(
      controller: widget.sideMenuController,
      collapseWidth: 1,
      style: SideMenuStyle(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.3,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        itemBorderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
        itemOuterPadding: const EdgeInsets.only(left: 10),
        openSideMenuWidth: 275,
        compactSideMenuWidth: 60,
        displayMode: MediaQuery.of(context).size.width > 1560
            ? SideMenuDisplayMode.open
            : SideMenuDisplayMode.compact,
      ),
      title: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 100,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Image.asset(
                'assets/images/logoceff.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Divider(
            indent: 50,
            endIndent: 50,
          ),
        ],
      ),
      footer: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () {
            setState(() {
              // LightColorTheme.setTheme(true);
            });
          },
          child: const Text(
            'ceff - 2023',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
      items: [
        SideMenuItem(
          badgeContent: const Text(
            '3',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          priority: DashboardOverviewScreen.pageIndex,
          title: 'Dashboard',
          builder: (context, displayMode) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SvgPicture.asset(
                    "assets/icons/dashboard.svg",
                    height: 24,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Dashboard',
                    style: TextStyle(
                        color:
                            Theme.of(context).textSelectionTheme.selectionColor,
                        fontSize: 16),
                  ),
                ),
              ],
            );
          },
          onTap: (page, _) {
            widget.sideMenuController.changePage(page);
          },
        ),
        SideMenuItem(
          badgeContent: const Text(
            '3',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          // badgeColor: constLightColorTheme.primary,
          priority: LockersOverviewScreen.pageIndex,

          builder: (context, displayMode) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SvgPicture.asset(
                    "assets/icons/locker.svg",
                    height: 24,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Casiers',
                    style: TextStyle(
                        color:
                            Theme.of(context).textSelectionTheme.selectionColor,
                        fontSize: 16),
                  ),
                ),
              ],
            );
          },
          trailing: Provider.of<LockerStudentProvider>(context)
                  .getDefectiveLockers()
                  .isNotEmpty
              ? Tooltip(
                  message:
                      "Vous avez ${Provider.of<LockerStudentProvider>(context).getDefectiveLockers().length} tâches à effectuer",
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 3),
                        child: Text(
                          Provider.of<LockerStudentProvider>(context)
                              .getDefectiveLockers()
                              .length
                              .toString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[800],
                          ),
                        ),
                      )),
                )
              : const Text(''),
          onTap: (page, _) {
            widget.sideMenuController.changePage(page);
          },
        ),
        SideMenuItem(
          priority: StudentsOverviewScreen.pageIndex,
          builder: (context, displayMode) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SvgPicture.asset(
                    "assets/icons/student.svg",
                    height: 24,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Élèves',
                    style: TextStyle(
                        color:
                            Theme.of(context).textSelectionTheme.selectionColor,
                        fontSize: 16),
                  ),
                ),
              ],
            );
          },
          trailing: Provider.of<LockerStudentProvider>(context)
                  .getNonPaidCaution()
                  .isNotEmpty
              ? Tooltip(
                  message:
                      "Vous avez ${Provider.of<LockerStudentProvider>(context).getNonPaidCaution().length} cautions à récupérer",
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 3),
                        child: Text(
                          Provider.of<LockerStudentProvider>(context)
                              .getNonPaidCaution()
                              .length
                              .toString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[800],
                          ),
                        ),
                      )),
                )
              : const Text(''),
          onTap: (page, _) {
            widget.sideMenuController.changePage(page);
          },
        ),
        SideMenuItem(
          priority: AssignationOverviewScreen.pageIndex,
          builder: (context, displayMode) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SvgPicture.asset(
                    "assets/icons/assign.svg",
                    height: 24,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Attributions',
                    style: TextStyle(
                        color:
                            Theme.of(context).textSelectionTheme.selectionColor,
                        fontSize: 16),
                  ),
                ),
              ],
            );
          },
          onTap: (page, _) {
            widget.sideMenuController.changePage(page);
          },
        ),
      ],
    );
  }
}
