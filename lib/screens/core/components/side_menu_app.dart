import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lockers_app/screens/core/components/prepare_database_app.dart';
import 'package:url_launcher/url_launcher.dart';

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
        displayMode: SideMenuDisplayMode.auto,
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
            // Navigator.of(context).pushNamed(PrepareDatabaseScreen.routeName);
            showGeneralDialog(
              context: context,
              barrierColor: Colors.black38,
              barrierLabel: "Photo de l'élève",
              barrierDismissible: true,
              pageBuilder: (_, __, ___) => Center(
                child: Container(
                  color: Colors.transparent,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 340,
                      height: 340,
                      decoration: const BoxDecoration(
                        color: Color(0xffececf6),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(
                                child: Text(
                                  "Ce projet a été réalisé par : \n\nElias Tormos \nHerdison Hazeraj \nFabio Leite Serra \nTimo Portal",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Projet réalisé dans le cadre d'un projet du CEFF - 2023",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
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
          title: 'Élèves',
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
        // SideMenuItem(
        //   priority: 4,
        //   title: 'Promotion',
        //   onTap: (page, _) {
        //     sideMenuController.changePage(page);
        //   },
        //   iconWidget: SvgPicture.asset(
        //     "assets/icons/assign.svg",
        //     height: 24,
        //   ),
        // ),
      ],
    );
  }
}
