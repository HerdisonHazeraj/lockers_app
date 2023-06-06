import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/components/prepare_database_app.dart';
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
      footer: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(PrepareDatabaseScreen.routeName);
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
        SideMenuItem(
          priority: 4,
          title: 'Promotion',
          onTap: (page, _) {
            sideMenuController.changePage(page);
          },
          iconWidget: SvgPicture.asset(
            "assets/icons/assign.svg",
            height: 24,
          ),
        ),
        SideMenuItem(
          priority: 5,
          title: 'Importations',
          onTap: (page, _) async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['csv'],
            );
            final error =
                await Provider.of<LockerStudentProvider>(context, listen: false)
                    .importStudentsWithCSV(result);
            if (error != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error)));
            }
          },
          iconWidget: SvgPicture.asset(
            "assets/icons/import.svg",
            height: 24,
          ),
        ),
        SideMenuItem(
          priority: 5,
          title: 'Importations Casiers',
          onTap: (page, _) async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['csv'],
            );
            final error =
                await Provider.of<LockerStudentProvider>(context, listen: false)
                    .importLockersWithCSV(result);
            if (error != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error)));
            }
          },
          iconWidget: SvgPicture.asset(
            "assets/icons/import.svg",
            height: 24,
          ),
        ),
      ],
    );
  }
}
