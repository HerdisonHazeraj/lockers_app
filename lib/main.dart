import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/responsive.dart';
import 'package:lockers_app/screens/assignation/assignation_overview_screen.dart';
import 'package:lockers_app/screens/core/components/drawer_app.dart';
import 'package:lockers_app/screens/core/components/prepare_database_app.dart';
import 'package:lockers_app/screens/core/components/side_menu_app.dart';
import 'package:lockers_app/screens/dashboard/dashboard_overview_screen.dart';
import 'package:lockers_app/screens/lockers/lockers_overview_screen.dart';
import 'package:lockers_app/screens/students/students_overview_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'infrastructure/firebase_rtdb_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // if(kIsWeb)

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              LockerStudentProvider(FirebaseRTDBService.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryProvider(FirebaseRTDBService.instance),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LockersApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xfff5f5fd),
        ),
        routes: {
          PrepareDatabaseScreen.routeName: (context) =>
              const PrepareDatabaseScreen(),
          DashboardOverviewScreen.routeName: (context) =>
              const DashboardOverviewScreen(),
          LockersOverviewScreen.routeName: (context) =>
              const LockersOverviewScreen(),
          AssignationOverviewScreen.routeName: (context) =>
              const AssignationOverviewScreen(),
          StudentsOverviewScreen.routeName: (context) =>
              const StudentsOverviewScreen(),
        },
        home: const MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  SideMenuController sideMenuController = SideMenuController();
  PageController page = PageController();

  @override
  void initState() {
    sideMenuController.addListener((p0) {
      page.jumpToPage(p0);
    });
    super.initState();
  }

  List<Widget> views = const [
    DashboardOverviewScreen(),
    LockersOverviewScreen(),
    StudentsOverviewScreen(),
    AssignationOverviewScreen(),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        // Version desktop
        ? Scaffold(
            body: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SideMenuApp(sideMenuController: sideMenuController),
                Expanded(
                  child: PageView(
                    controller: page,
                    children: const [
                      // PrepareDatabaseScreen(),
                      DashboardOverviewScreen(),
                      LockersOverviewScreen(),
                      StudentsOverviewScreen(),
                      AssignationOverviewScreen(),
                    ],
                  ),
                ),
              ],
            ),
          )

        // Version mobile
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            drawer: const DrawerApp(),
            body: const DashboardOverviewScreen(),
          );
  }
}
