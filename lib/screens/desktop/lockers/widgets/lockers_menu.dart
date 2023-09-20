import 'package:flutter/material.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/screens/core/widgets/divider_menu.dart';
import 'package:lockers_app/screens/desktop/lockers/widgets/menu_widgets/add_locker_menu.dart';
import 'package:lockers_app/screens/desktop/lockers/widgets/menu_widgets/import_locker_menu.dart';
import 'package:lockers_app/screens/desktop/lockers/widgets/menu_widgets/search_locker_menu.dart';

import '../../../../core/theme.dart';
// import 'package:lockers_app/screens/shared/widgets/divider_menu.dart';

class LockersMenu extends StatefulWidget {
  const LockersMenu({required this.searchLockers, super.key});

  final Function(String value) searchLockers;

  @override
  State<LockersMenu> createState() => _LockersMenuState();
}

class _LockersMenuState extends State<LockersMenu> {
  // List of lockers searched
  List<Locker> searchedLockers = [];

  List<List> values = [];
  List<List> keys = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xffececf6),
            border: Border(
              left: BorderSide(
                  width: 0.3, color: LightColorTheme.secondaryTextColor),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            child: Column(
              children: [
                SearchLockerMenu(
                  searchLockers: (value) => widget.searchLockers(value),
                ),
                const dividerMenu(),
                const AddLockerMenu(),
                const dividerMenu(),
                ImportLockerMenu(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
