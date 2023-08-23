import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:lockers_app/screens/assignation/assignation_overview_screen.dart';
import 'package:lockers_app/screens/dashboard/dashboard_overview_screen.dart';
import 'package:lockers_app/screens/lockers/lockers_overview_screen.dart';
import 'package:lockers_app/screens/students/students_overview_screen.dart';

class ConfigScreen {
  SideMenuController sideMenuController = SideMenuController();

  changePage(String page) {
    switch (page) {
      case 'dashboard':
        sideMenuController.changePage(DashboardOverviewScreen.pageIndex);
        break;
      case 'lockers':
        sideMenuController.changePage(LockersOverviewScreen.pageIndex);
        break;
      case 'students':
        sideMenuController.changePage(StudentsOverviewScreen.pageIndex);
        break;
      case 'assignation':
        sideMenuController.changePage(AssignationOverviewScreen.pageIndex);
        break;
    }
  }
}
