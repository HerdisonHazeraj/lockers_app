import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/providers/history_provider.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/dashboard/widgets/barchart_widget.dart';
import 'package:lockers_app/screens/dashboard/widgets/indicator.dart';
import 'package:lockers_app/screens/dashboard/widgets/info_card.dart';
import 'package:lockers_app/screens/dashboard/widgets/piechart_caution_widget.dart';
import 'package:lockers_app/screens/dashboard/widgets/piechartdashboard_widget.dart';
import 'package:lockers_app/screens/lockers/lockers_overview_screen.dart';
import 'package:lockers_app/screens/students/students_overview_screen.dart';
import 'package:provider/provider.dart';

import '../../responsive.dart';
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
        : Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      flex: 10,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: PieChartDashboard(),
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InfoCard(
                                        "Nombre total de casiers",
                                        Provider.of<LockerStudentProvider>(
                                                context)
                                            .lockerItems
                                            .length
                                            .toString(),
                                        "assets/icons/locker.svg",
                                        () => widget.changePage(
                                            LockersOverviewScreen.pageIndex),
                                      ),
                                      InfoCard(
                                        "Nombre total \nd'élèves",
                                        Provider.of<LockerStudentProvider>(
                                                context)
                                            .studentItems
                                            .length
                                            .toString(),
                                        'assets/icons/student.svg',
                                        () => widget.changePage(
                                            StudentsOverviewScreen.pageIndex),
                                      ),
                                      InfoCard(
                                        "Nombre d'élèves sans casiers",
                                        Provider.of<LockerStudentProvider>(
                                                context)
                                            .getAvailableStudents()
                                            .length
                                            .toString(),
                                        "assets/icons/student.svg",
                                        () => null,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InfoCard(
                                        "Nombre de casiers libres",
                                        Provider.of<LockerStudentProvider>(
                                                context)
                                            .getAvailableLockers()
                                            .length
                                            .toString(),
                                        "assets/icons/locker.svg",
                                        () => null,
                                      ),
                                      InfoCard(
                                        "Nombre de casiers défectueux",
                                        Provider.of<LockerStudentProvider>(
                                                context)
                                            .getDefectiveLockers()
                                            .length
                                            .toString(),
                                        "assets/icons/locker.svg",
                                        () => null,
                                      ),
                                      InfoCard(
                                        "Nombre de casiers avec clés manquantes",
                                        Provider.of<LockerStudentProvider>(
                                                context)
                                            .getLockerLessThen2Key()
                                            .length
                                            .toString(),
                                        "assets/icons/key.svg",
                                        () => null,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BarChartWidget(),
                              const CautionPieChartWidget(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Responsive.isDesktop(context)
                  ? const DashboardMenu()
                  : const Text(''),
            ],
          );
  }
}
