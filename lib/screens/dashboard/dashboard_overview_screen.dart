import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/dashboard/widgets/indicator.dart';
import 'package:lockers_app/screens/dashboard/widgets/info_card.dart';
import 'package:provider/provider.dart';

import '../../responsive.dart';
import 'widgets/dashboard_menu.dart';

class DashboardOverviewScreen extends StatefulWidget {
  const DashboardOverviewScreen({super.key});

  static String routeName = "/dashboard";

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
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 10,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Container(
                                    height: Responsive.isMobile(context)
                                        ? 350
                                        : 420,
                                    width: Responsive.isMobile(context)
                                        ? 350
                                        : 420,
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      left: 20,
                                      right: 20,
                                      bottom: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: PieChart(
                                            PieChartData(
                                              pieTouchData: PieTouchData(
                                                touchCallback:
                                                    (FlTouchEvent event,
                                                        pieTouchResponse) {
                                                  setState(() {
                                                    if (!event
                                                            .isInterestedForInteractions ||
                                                        pieTouchResponse ==
                                                            null ||
                                                        pieTouchResponse
                                                                .touchedSection ==
                                                            null) {
                                                      touchedIndex = -1;
                                                      return;
                                                    }
                                                    touchedIndex =
                                                        pieTouchResponse
                                                            .touchedSection!
                                                            .touchedSectionIndex;
                                                  });
                                                },
                                              ),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              sections:
                                                  showingSections(context),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        const Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              children: [
                                                Indicator(
                                                  color: Colors.green,
                                                  text: 'Casiers libres',
                                                  isSquare: true,
                                                ),
                                                Indicator(
                                                  color: Colors.red,
                                                  text: 'Casiers occupés',
                                                  isSquare: true,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Indicator(
                                                  color: Colors.yellow,
                                                  text: 'Clés manquantes',
                                                  isSquare: true,
                                                ),
                                                Indicator(
                                                  color: Colors.purple,
                                                  text: 'Casiers défectueux',
                                                  isSquare: true,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Wrap(
                                    spacing:
                                        Responsive.isMobile(context) ? 8 : 20,
                                    runSpacing:
                                        Responsive.isMobile(context) ? 8 : 20,
                                    children: [
                                      InfoCard(
                                        "Nombre total de casiers",
                                        Provider.of<LockerStudentProvider>(
                                                context)
                                            .lockerItems
                                            .length
                                            .toString(),
                                        "assets/icons/locker.svg",
                                      ),
                                      InfoCard(
                                        "Nombre total   d'élèves",
                                        Provider.of<LockerStudentProvider>(
                                                context)
                                            .studentItems
                                            .length
                                            .toString(),
                                        'assets/icons/student.svg',
                                      ),
                                      InfoCard(
                                        "Nombre d'élèves sans casiers",
                                        Provider.of<LockerStudentProvider>(
                                                context)
                                            .getAvailableStudents()
                                            .length
                                            .toString(),
                                        "assets/icons/student.svg",
                                      ),
                                      InfoCard(
                                        "Nombre de casiers libres",
                                        Provider.of<LockerStudentProvider>(
                                                context)
                                            .getAvailableLockers()
                                            .length
                                            .toString(),
                                        "assets/icons/locker.svg",
                                      ),
                                      const InfoCard(
                                        "Nombre de casiers défectueux",
                                        "1",
                                        "assets/icons/locker.svg",
                                      ),
                                      const InfoCard(
                                        "Nombre de casiers avec clés manquantes",
                                        "2",
                                        "assets/icons/key.svg",
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Responsive.isDesktop(context)
                      ? const DashboardMenu()
                      : const Text(''),
                ],
              ),
            ),
          );
  }

  List<PieChartSectionData> showingSections(BuildContext context) {
    return List.generate(
      4,
      (index) {
        final isTouched = index == touchedIndex;
        final fontSize = isTouched ? 20.0 : 16.0;
        final radius = isTouched ? 56.0 : 50.0;
        const shadows = [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
          ),
        ];
        switch (index) {
          case 0:
            // Casiers libres
            return PieChartSectionData(
              color: Colors.green,
              value: Provider.of<LockerStudentProvider>(context)
                  .getAvailableLockers()
                  .length
                  .toDouble(),
              title: Provider.of<LockerStudentProvider>(context)
                  .getAvailableLockers()
                  .length
                  .toString(),
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          case 1:
            // Casiers occupés
            return PieChartSectionData(
              color: Colors.red,
              value: Provider.of<LockerStudentProvider>(context)
                  .getUnAvailableLockers()
                  .length
                  .toDouble(),
              title: Provider.of<LockerStudentProvider>(context)
                  .getUnAvailableLockers()
                  .length
                  .toString(),
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          case 2:
            // Casiers qui possèdent des clés manquantes
            return PieChartSectionData(
              color: Colors.yellow,
              value: Provider.of<LockerStudentProvider>(context)
                  .getLockerLessThen2Key()
                  .length
                  .toDouble(),
              title: Provider.of<LockerStudentProvider>(context)
                  .getLockerLessThen2Key()
                  .length
                  .toString(),
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          case 3:
            // Casiers défectueux
            return PieChartSectionData(
              color: Colors.purple,
              value: 2,
              title: "2",
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          default:
            throw Error();
        }
      },
    );
  }
}
