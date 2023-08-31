import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lockers_app/core/config.dart';
import 'package:lockers_app/infrastructure/firebase_api_service.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/responsive.dart';
import 'package:lockers_app/screens/desktop/assignation/assignation_overview_screen.dart';
import 'package:lockers_app/screens/core/components/prepare_database_app.dart';
import 'package:lockers_app/screens/core/components/side_menu_app.dart';
import 'package:lockers_app/screens/desktop/auth/auth_overview_screen.dart';
import 'package:lockers_app/screens/desktop/dashboard/dashboard_overview_screen.dart';
import 'package:lockers_app/screens/desktop/lockers/lockers_overview_screen.dart';
import 'package:lockers_app/screens/desktop/students/students_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'firebase_options.dart';
import 'infrastructure/firebase_rtdb_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } else if (defaultTargetPlatform == TargetPlatform.windows) {
    setWindowMaxSize(const Size(double.infinity, 1080));
    setWindowMinSize(const Size(1280, 720));

    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: Config.apiKey,
        projectId: Config.projectId,
        messagingSenderId: Config.messagingSenderId,
        appId: Config.appId,
      ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LockerStudentProvider(kIsWeb == false
              ? ApiService.instance
              : FirebaseRTDBService.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryProvider(kIsWeb == false
              ? ApiService.instance
              : FirebaseRTDBService.instance),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Application de gestion des casiers du ceff',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xfff5f5fd),
          fontFamily: GoogleFonts.roboto().fontFamily,
        ),
        routes: {
          PrepareDatabaseScreen.routeName: (context) =>
              const PrepareDatabaseScreen(),
          DashboardOverviewScreen.routeName: (context) =>
              DashboardOverviewScreen(() => null),
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
  TextStyle styleSelected = const TextStyle(
    color: Color(0xfffb3274),
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );
  TextStyle styleUnselected = const TextStyle(
    color: Colors.black54,
    fontSize: 18,
  );

  // static final List<Widget> _widgetOptions = <Widget>[
  //   DashboardOverviewScreen(() => null),
  //   const LockersOverviewScreen(),
  //   const StudentsOverviewScreen(),
  // ];

  @override
  void initState() {
    sideMenuController.addListener((p0) {
      page.jumpToPage(p0);
    });
    super.initState();
  }

  changePage(int index) {
    setState(() {
      selectedIndex = index;
    });

    page.jumpToPage(index);
    sideMenuController.changePage(index);
  }

  int selectedIndex = 0;
  bool isLoggedTest = true;

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        // Version desktop
        ? Scaffold(
            body: isLoggedTest == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SideMenuApp(sideMenuController: sideMenuController),
                      Expanded(
                        child: PageView(
                          controller: page,
                          children: [
                            // PrepareDatabaseScreen(),
                            DashboardOverviewScreen(
                              (index) => changePage(index),
                            ),
                            const LockersOverviewScreen(),
                            const StudentsOverviewScreen(),
                            const AssignationOverviewScreen(),
                          ],
                        ),
                      ),
                    ],
                  )
                : const AuthOverviewScreen(),
          )

        // Version mobile
        : Scaffold(
            appBar: AppBar(
              actions: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: Colors.black54,
                      width: 0.3,
                    )),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: double.infinity,
                        decoration: selectedIndex == 0
                            ? const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xfffb3274),
                                    width: 3,
                                  ),
                                ),
                              )
                            : null,
                        child: TextButton(
                          child: Text(
                            "Casiers",
                            style: selectedIndex == 0
                                ? styleSelected
                                : styleUnselected,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        decoration: selectedIndex == 1
                            ? const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xfffb3274),
                                    width: 3,
                                  ),
                                ),
                              )
                            : null,
                        child: TextButton(
                          child: Text(
                            "Élèves",
                            style: selectedIndex == 1
                                ? styleSelected
                                : styleUnselected,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: selectedIndex == 0
                ? const LockersOverviewScreen()
                : const StudentsOverviewScreen(),
          );
    // : Scaffold(
    //     body: _widgetOptions.elementAt(selectedIndex),
    //     bottomNavigationBar: BottomNavigationBar(
    //       type: BottomNavigationBarType.shifting,
    //       currentIndex: selectedIndex,
    //       selectedItemColor: Colors.black,
    //       unselectedItemColor: Colors.black54,
    //       onTap: (index) => changePage(index),
    //       showSelectedLabels: false,
    //       items: [
    //         BottomNavigationBarItem(
    //           icon: SvgPicture.asset(
    //             "assets/icons/dashboard.svg",
    //             height: 24,
    //           ),
    //           tooltip: "Dashboard",
    //           label: 'Dashboard',
    //         ),
    //         BottomNavigationBarItem(
    //           icon: SvgPicture.asset(
    //             "assets/icons/locker.svg",
    //             height: 24,
    //           ),
    //           tooltip: "Casiers",
    //           label: 'Casiers',
    //         ),
    //         BottomNavigationBarItem(
    //           icon: SvgPicture.asset(
    //             "assets/icons/student.svg",
    //             height: 24,
    //           ),
    //           tooltip: "Élèves",
    //           label: 'Élèves',
    //         ),
    //       ],
    //     ),
    //   );
  }
}
