import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/core/config.dart';
import 'package:lockers_app/core/theme.dart';
import 'package:lockers_app/firebase_options.dart';
import 'package:lockers_app/infrastructure/firebase_api_service.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/responsive.dart';
import 'package:lockers_app/screens/desktop/assignation/assignation_overview_screen.dart';
import 'package:lockers_app/screens/core/components/prepare_database_app.dart';
import 'package:lockers_app/screens/core/components/side_menu_app.dart';
import 'package:lockers_app/screens/desktop/dashboard/dashboard_overview_screen.dart';
import 'package:lockers_app/screens/desktop/lockers/lockers_overview_screen.dart';
import 'package:lockers_app/screens/desktop/students/students_overview_screen.dart';
import 'package:lockers_app/screens/mobile/lockers/lockers_overviewscreen_mobile.dart';
import 'package:lockers_app/screens/mobile/students/students_overviewscreen_mobile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'infrastructure/firebase_rtdb_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: Config.apiKey,
        projectId: Config.projectId,
        messagingSenderId: Config.messagingSenderId,
        appId: Config.appId,
      ),
    );
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTheme();
    });
  }

  _getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
  }

  changeTheme() async {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

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
        theme: Styles.themeData(isDarkTheme, context),
        routes: {
          PrepareDatabaseScreen.routeName: (context) =>
              const PrepareDatabaseScreen(),
          DashboardOverviewScreen.routeName: (context) =>
              DashboardOverviewScreen(
                changePage: () => null,
                onSignedOut: () => null,
                changeTheme: () => null,
              ),
          LockersOverviewScreen.routeName: (context) =>
              const LockersOverviewScreen(),
          AssignationOverviewScreen.routeName: (context) =>
              const AssignationOverviewScreen(),
          StudentsOverviewScreen.routeName: (context) =>
              const StudentsOverviewScreen(),
        },
        home: MyWidget(
          changeTheme: () => changeTheme(),
          isDarkTheme: isDarkTheme,
          getTheme: () => _getTheme,
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget(
      {required this.changeTheme,
      super.key,
      required this.isDarkTheme,
      required this.getTheme});
  final bool isDarkTheme;
  final Function getTheme;
  final Function changeTheme;

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final SideMenuController sideMenuController = SideMenuController();
  final PageController page = PageController();

  int selectedIndex = 0;
  bool isLogged = false;

  TextStyle styleSelected = const TextStyle(
    color: ColorTheme.primary,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  @override
  void initState() {
    sideMenuController.addListener((p0) {
      page.jumpToPage(p0);
    });

    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _checkIfIsLogged();
    // });
  }

  _checkIfIsLogged() async {
    String token = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getString("token")!);
    if (token != "") {
      auth.signInWithCustomToken(token);
      onSignedIn();
    } else {
      onSignedOut();
    }
  }

  var _isInit = true;
  var _isLoading = false;
  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      _isLoading = true;
      widget.getTheme();
      await Provider.of<LockerStudentProvider>(context, listen: false)
          .fetchAndSetLockers();
      await Provider.of<LockerStudentProvider>(context, listen: false)
          .fetchAndSetStudents();
      await Provider.of<HistoryProvider>(context, listen: false)
          .fetchAndSetHistory();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  changePage(int index) {
    setState(() {
      selectedIndex = index;
    });

    page.jumpToPage(index);
    sideMenuController.changePage(index);
  }

  onSignedIn() {
    setState(() {
      isLogged = true;
    });
  }

  onSignedOut() {
    setState(() {
      isLogged = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            color: Theme.of(context).cardColor,
            child: const Center(
              child: CircularProgressIndicator(
                color: ColorTheme.primary,
              ),
            ),
          )
        : Responsive.isDesktop(context)
            // Version desktop
            ? Scaffold(
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SideMenuApp(sideMenuController: sideMenuController),
                    Expanded(
                      child: PageView(
                        controller: page,
                        children: [
                          // PrepareDatabaseScreen(),
                          DashboardOverviewScreen(
                            changePage: (index) => changePage(index),
                            onSignedOut: () => onSignedOut(),
                            changeTheme: () => widget.changeTheme(),
                          ),
                          const LockersOverviewScreen(),
                          const StudentsOverviewScreen(),
                          const AssignationOverviewScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              )

            // Version mobile
            : Scaffold(
                appBar: AppBar(
                  toolbarHeight: 100.3,
                  actions: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 0.3,
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(''),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                          top: 10,
                                        ),
                                        child: Hero(
                                          tag: "Petit chat",
                                          child: PopupMenuButton<int>(
                                            elevation: 2,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            position: PopupMenuPosition.under,
                                            tooltip: "",
                                            itemBuilder: (context) => [
                                              PopupMenuItem<int>(
                                                onTap: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Cette fonctionnalité n'est pas encore disponible.")));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Profil",
                                                    ),
                                                    Icon(
                                                      Icons.person_outline,
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const PopupMenuDivider(height: 1),
                                              PopupMenuItem<int>(
                                                onTap: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Cette fonctionnalité n'est pas encore disponible.")));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Paramètres',
                                                    ),
                                                    Icon(
                                                      Icons.settings_outlined,
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const PopupMenuDivider(height: 1),
                                              PopupMenuItem<int>(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Thème sombre"),
                                                    Switch(
                                                      value: widget.isDarkTheme,
                                                      onChanged: (value) {
                                                        Navigator.pop(context);
                                                        // widget.changeTheme();
                                                        setState(() {
                                                          widget.changeTheme();
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                onTap: () async {
                                                  // widget.changeTheme();
                                                  widget.changeTheme();
                                                },
                                              ),
                                              const PopupMenuDivider(height: 1),
                                              PopupMenuItem<int>(
                                                onTap: () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();

                                                  auth.signOut();
                                                  // widget.onSignedOut();
                                                  prefs.setString("token", "");
                                                  // Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Déconnexion réussie !"),
                                                    ),
                                                  );
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Déconnexion",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    Icon(
                                                      Icons.logout,
                                                      color: Colors.red,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://ik.imagekit.io/yynn3ntzglc/cms/medium_Accroche_chat_poil_long_96efb37bbd_4ma1xrsmu.jpg",
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      CircleAvatar(
                                                backgroundImage: imageProvider,
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Tooltip(
                                                message:
                                                    "L'image n'a pas réussi à se charger",
                                                child: Icon(
                                                  Icons.error_outlined,
                                                  color: Colors.red,
                                                  size: 40,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: Align(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: double.infinity,
                                      decoration: selectedIndex == 0
                                          ? const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: ColorTheme.primary,
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
                                              : TextStyle(
                                                  color: Theme.of(context)
                                                      .textSelectionTheme
                                                      .selectionColor,
                                                  fontSize: 18,
                                                ),
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
                                                  color: ColorTheme.primary,
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
                                              : TextStyle(
                                                  color: Theme.of(context)
                                                      .textSelectionTheme
                                                      .selectionColor,
                                                  fontSize: 18,
                                                ),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  elevation: 0,
                  backgroundColor: Theme.of(context).canvasColor,
                ),
                body: selectedIndex == 0
                    ? const LockersOverviewScreenMobile()
                    : const StudentsOverviewScreenMobile(),
              );
  }
}
