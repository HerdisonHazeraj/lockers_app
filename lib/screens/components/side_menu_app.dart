import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      style: SideMenuStyle(
        displayMode: SideMenuDisplayMode.open,
        selectedTitleTextStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      title: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 150,
              maxWidth: 150,
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
            indent: 8,
            endIndent: 8,
          ),
        ],
      ),
      footer: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'ceff - 2023',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      items: [
        SideMenuItem(
          priority: 0,
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
          priority: 1,
          title: 'Casiers',
          onTap: (page, _) {
            sideMenuController.changePage(page);
          },
          iconWidget: SvgPicture.asset(
            "assets/icons/locker.svg",
            height: 24,
          ),
        ),
        SideMenuItem(
          priority: 2,
          title: 'Elèves',
          onTap: (page, _) {
            sideMenuController.changePage(page);
          },
          iconWidget: SvgPicture.asset(
            "assets/icons/student.svg",
            height: 24,
          ),
        ),
        SideMenuItem(
          priority: 3,
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
