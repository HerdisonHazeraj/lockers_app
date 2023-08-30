import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/desktop/dashboard/widgets/barchart_widget.dart';
import 'package:lockers_app/screens/desktop/dashboard/widgets/info_card.dart';
import 'package:lockers_app/screens/desktop/dashboard/widgets/piechart_caution_widget.dart';
import 'package:lockers_app/screens/desktop/dashboard/widgets/piechartdashboard_widget.dart';
import 'package:lockers_app/screens/desktop/lockers/lockers_overview_screen.dart';
import 'package:lockers_app/screens/desktop/students/students_overview_screen.dart';
import 'package:provider/provider.dart';

import '../../../responsive.dart';
import 'widgets/dashboard_menu.dart';

class DashboardOverviewScreen extends StatefulWidget {
  const DashboardOverviewScreen(this.changePage, {super.key});

  final Function changePage;

  static String routeName = "/dashboard";
  static int pageIndex = 0;

  @override
  State<DashboardOverviewScreen> createState() =>
      _DashboardOverviewScreenState();
}

class _DashboardOverviewScreenState extends State<DashboardOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;
  int touchedIndex = -1;

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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black54,
                              width: 0.3,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Bonjour,",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Text(
                                    "Bienvenue sur l'application de gestion des casiers",
                                    style: TextStyle(color: Colors.black54),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Tooltip(
                                    waitDuration: Duration(milliseconds: 500),
                                    message:
                                        "Vous êtes connecté en tant que Herdison Hazeraj",
                                    child: Text(
                                      "Herdison Hazeraj",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
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
                                          const PopupMenuItem<int>(
                                            child: Text(
                                              "Profil",
                                            ),
                                          ),
                                          const PopupMenuDivider(height: 1),
                                          const PopupMenuItem<int>(
                                            child: Text(
                                              "Déconnexion",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          )
                                        ],
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://ik.imagekit.io/yynn3ntzglc/cms/medium_Accroche_chat_poil_long_96efb37bbd_4ma1xrsmu.jpg",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  CircleAvatar(
                                            backgroundImage: imageProvider,
                                            backgroundColor: Colors.transparent,
                                          ),
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
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
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(30),
                            child: PieChartDashboard(),
                          ),
                          Expanded(
                            child: GridView.count(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              children: [
                                InfoCard(
                                  "Nombre total de casiers",
                                  Provider.of<LockerStudentProvider>(context)
                                      .lockerItems
                                      .length
                                      .toString(),
                                  "assets/icons/locker.svg",
                                  () => widget.changePage(
                                      LockersOverviewScreen.pageIndex),
                                ),
                                InfoCard(
                                  "Nombre total \nd'élèves",
                                  Provider.of<LockerStudentProvider>(context)
                                      .studentItems
                                      .length
                                      .toString(),
                                  'assets/icons/student.svg',
                                  () => widget.changePage(
                                      StudentsOverviewScreen.pageIndex),
                                ),
                                InfoCard(
                                  "Nombre d'élèves sans casiers",
                                  Provider.of<LockerStudentProvider>(context)
                                      .getAvailableStudents()
                                      .length
                                      .toString(),
                                  "assets/icons/student.svg",
                                  () => null,
                                ),
                                InfoCard(
                                  "Nombre de casiers libres",
                                  Provider.of<LockerStudentProvider>(context)
                                      .getAvailableLockers()
                                      .length
                                      .toString(),
                                  "assets/icons/locker.svg",
                                  () => null,
                                ),
                                InfoCard(
                                  "Nombre de casiers défectueux",
                                  Provider.of<LockerStudentProvider>(context)
                                      .getDefectiveLockers()
                                      .length
                                      .toString(),
                                  "assets/icons/locker.svg",
                                  () => null,
                                ),
                                InfoCard(
                                  "Nombre de casiers avec des clés manquantes",
                                  Provider.of<LockerStudentProvider>(context)
                                      .getLockerLessThen2Key()
                                      .length
                                      .toString(),
                                  "assets/icons/key.svg",
                                  () => null,
                                ),
                              ],
                            ),
                          ),

                          //     // Column(
                          //     //   children: [
                          //     //     Row(
                          //     //       mainAxisAlignment:
                          //     //           MainAxisAlignment.spaceBetween,
                          //     //       children: [
                          //     //         InfoCard(
                          //     //           "Nombre total de casiers",
                          //     //           Provider.of<LockerStudentProvider>(context)
                          //     //               .lockerItems
                          //     //               .length
                          //     //               .toString(),
                          //     //           "assets/icons/locker.svg",
                          //     //           () => widget.changePage(
                          //     //               LockersOverviewScreen.pageIndex),
                          //     //         ),
                          //     //         InfoCard(
                          //     //           "Nombre total \nd'élèves",
                          //     //           Provider.of<LockerStudentProvider>(context)
                          //     //               .studentItems
                          //     //               .length
                          //     //               .toString(),
                          //     //           'assets/icons/student.svg',
                          //     //           () => widget.changePage(
                          //     //               StudentsOverviewScreen.pageIndex),
                          //     //         ),
                          //     //         InfoCard(
                          //     //           "Nombre d'élèves sans casiers",
                          //     //           Provider.of<LockerStudentProvider>(context)
                          //     //               .getAvailableStudents()
                          //     //               .length
                          //     //               .toString(),
                          //     //           "assets/icons/student.svg",
                          //     //           () => null,
                          //     //         ),
                          //     //       ],
                          //     //     ),
                          //     //     Row(
                          //     //       children: [
                          //     //         InfoCard(
                          //     //           "Nombre de casiers libres",
                          //     //           Provider.of<LockerStudentProvider>(context)
                          //     //               .getAvailableLockers()
                          //     //               .length
                          //     //               .toString(),
                          //     //           "assets/icons/locker.svg",
                          //     //           () => null,
                          //     //         ),
                          //     //         InfoCard(
                          //     //           "Nombre de casiers défectueux",
                          //     //           Provider.of<LockerStudentProvider>(context)
                          //     //               .getDefectiveLockers()
                          //     //               .length
                          //     //               .toString(),
                          //     //           "assets/icons/locker.svg",
                          //     //           () => null,
                          //     //         ),
                          //     //         InfoCard(
                          //     //           "Nombre de casiers avec des clés manquantes",
                          //     //           Provider.of<LockerStudentProvider>(context)
                          //     //               .getLockerLessThen2Key()
                          //     //               .length
                          //     //               .toString(),
                          //     //           "assets/icons/key.svg",
                          //     //           () => null,
                          //     //         ),
                          //     //       ],
                          //     //     ),
                          //     //   ],
                          //     // ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BarChartWidget(),
                          Expanded(child: CautionPieChartWidget()),
                        ],
                      ),
                    ],
                  ),
                ),
                Responsive.isDesktop(context)
                    ? const DashboardMenu()
                    : const Text(''),
              ],
            ),
          );
  }
}
