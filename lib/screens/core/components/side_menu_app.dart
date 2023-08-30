import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/desktop/assignation/assignation_overview_screen.dart';
import 'package:lockers_app/screens/desktop/dashboard/dashboard_overview_screen.dart';
import 'package:lockers_app/screens/desktop/lockers/lockers_overview_screen.dart';
import 'package:lockers_app/screens/desktop/students/students_overview_screen.dart';
import 'package:provider/provider.dart';

class SideMenuApp extends StatelessWidget {
  const SideMenuApp({
    super.key,
    required this.sideMenuController,
  });

  final SideMenuController sideMenuController;

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      controller: sideMenuController,
      collapseWidth: 1,
      style: SideMenuStyle(
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.black54,
              width: 0.3,
            ),
          ),
        ),
        backgroundColor: Colors.white,
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
            // Navigator.of(context).pushNamed(PrepareDatabaseScreen.routeName);
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
          onTap: (page, _) {
            sideMenuController.changePage(page);
          },
          iconWidget: SvgPicture.asset(
            "assets/icons/dashboard.svg",
            height: 24,
          ),
        ),
        SideMenuItem(
          badgeContent: const Text(
            '3',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          // badgeColor: const Color(0xFFFB3274),
          priority: LockersOverviewScreen.pageIndex,
          title: 'Casiers',
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
            sideMenuController.changePage(page);
          },
          iconWidget: SvgPicture.asset(
            "assets/icons/locker.svg",
            height: 24,
          ),
        ),
        SideMenuItem(
          priority: StudentsOverviewScreen.pageIndex,
          title: 'Élèves',
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
            sideMenuController.changePage(page);
          },
          iconWidget: SvgPicture.asset(
            "assets/icons/student.svg",
            height: 24,
          ),
        ),
        SideMenuItem(
          priority: AssignationOverviewScreen.pageIndex,
          title: 'Attributions',
          onTap: (page, _) {
            sideMenuController.changePage(page);
          },
          iconWidget: SvgPicture.asset(
            "assets/icons/assign.svg",
            height: 24,
          ),
        ),
      ],
    );
  }
}
