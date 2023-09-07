import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lockers_app/core/config.dart';
import 'package:lockers_app/firebase_options.dart';
import 'package:lockers_app/infrastructure/firebase_api_service.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/responsive.dart';
import 'package:lockers_app/screens/core/components/modal_bottomsheet.dart';
import 'package:lockers_app/screens/desktop/assignation/assignation_overview_screen.dart';
import 'package:lockers_app/screens/core/components/prepare_database_app.dart';
import 'package:lockers_app/screens/core/components/side_menu_app.dart';
import 'package:lockers_app/screens/desktop/auth/auth_overview_screen.dart';
import 'package:lockers_app/screens/desktop/dashboard/dashboard_overview_screen.dart';
import 'package:lockers_app/screens/desktop/lockers/lockers_overview_screen.dart';
import 'package:lockers_app/screens/desktop/students/students_overview_screen.dart';
import 'package:lockers_app/screens/mobile/lockers/lockers_overviewscreen_mobile.dart';
import 'package:lockers_app/screens/mobile/students/students_overviewscreen_mobile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_size/window_size.dart';

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

  if (defaultTargetPlatform == TargetPlatform.windows) {
    setWindowMaxSize(const Size(double.infinity, 1080));
    setWindowMinSize(const Size(1280, 720));
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
              DashboardOverviewScreen(
                  changePage: () => null, onSignedOut: () => null),
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
  final FirebaseAuth auth = FirebaseAuth.instance;
  final SideMenuController sideMenuController = SideMenuController();
  final PageController page = PageController();

  int selectedIndex = 0;
  bool isLogged = false;

  TextStyle styleSelected = const TextStyle(
    color: Color(0xfffb3274),
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );
  TextStyle styleUnselected = const TextStyle(
    color: Colors.black54,
    fontSize: 18,
  );

  @override
  void initState() {
    sideMenuController.addListener((p0) {
      page.jumpToPage(p0);
    });

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfIsLogged();
    });
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
    List<ListTile> standardList = [
      ListTile(
        title: const Text('Oui'),
        onTap: () {},
        trailing: const Icon(Icons.person_add_alt),
      ),
      ListTile(
        title: const Text('Non'),
        onTap: () {},
        trailing: const Icon(Icons.person_add_alt),
      ),
    ];
    return _isLoading
        ? Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xfffb3274),
              ),
            ),
          )
        : Responsive.isDesktop(context)
            // Version desktop
            ? Scaffold(
                body: isLogged == true
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
                                  changePage: (index) => changePage(index),
                                  onSignedOut: () => onSignedOut(),
                                ),
                                const LockersOverviewScreen(),
                                const StudentsOverviewScreen(),
                                const AssignationOverviewScreen(),
                              ],
                            ),
                          ),
                        ],
                      )
                    : AuthOverviewScreen(
                        onSignedIn: () => onSignedIn(),
                      ),
              )

            // Version mobile
            : Scaffold(
                appBar: AppBar(
                  toolbarHeight: MediaQuery.of(context).size.height * 0.165,
                  actions: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                          color: Colors.black54,
                          width: 0.3,
                        )),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.02,
                                  right:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(''),
                                    Row(
                                      children: [
                                        const Tooltip(
                                          waitDuration:
                                              Duration(milliseconds: 500),
                                          message:
                                              "Vous êtes connecté en tant que Herdison Hazeraj",
                                          child: Text(
                                            "Herdison Hazeraj",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Hero(
                                            tag: "Petit chat",
                                            child: PopupMenuButton<int>(
                                              elevation: 2,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              position: PopupMenuPosition.under,
                                              tooltip: "",
                                              itemBuilder: (context) => [
                                                const PopupMenuItem<int>(
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
                                                        color: Colors.black,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuDivider(
                                                    height: 1),
                                                PopupMenuItem<int>(
                                                  onTap: () {},
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
                                                        color: Colors.black,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuDivider(
                                                    height: 1),
                                                PopupMenuItem<int>(
                                                  onTap: () async {
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();

                                                    auth.signOut();
                                                    // widget.onSignedOut();
                                                    prefs.setString(
                                                        "token", "");
                                                    // Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "Déconnexion réussie !"),
                                                      ),
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
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
                                                  backgroundImage:
                                                      imageProvider,
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
                                )),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                body: selectedIndex == 0
                    ? const LockersOverviewScreenMobile()
                    : const StudentsOverviewScreenMobile(),
              );
  }
}
