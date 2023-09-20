import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lockers_app/screens/core/widgets/divider_menu.dart';
import 'package:lockers_app/screens/desktop/dashboard/widgets/menu/historic_dashboard_menu.dart';
import 'package:lockers_app/screens/desktop/dashboard/widgets/menu/import_all_menu.dart';

import '../../../../core/theme.dart';

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
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Color(0xffececf6),
        border: Border(
          left:
              BorderSide(width: 0.3, color: LightColorTheme.secondaryTextColor),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 30,
        ),
        child: Column(
          children: [
            const HistoricDashboardMenu(),
            const dividerMenu(),
            ImportAllMenu(),
          ],
        ),
      ),
    );
  }
}
