import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/dashboard/widgets/indicator.dart';
import 'package:provider/provider.dart';

class PieChartDashboard extends StatefulWidget {
  const PieChartDashboard({super.key});

  @override
  State<StatefulWidget> createState() => _PieChartDashboardState();
}

class _PieChartDashboardState extends State<PieChartDashboard> {
  int touchedIndex = -1;
  final Duration animDuration = const Duration(milliseconds: 250);

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 485,
      width: 400,
      padding: const EdgeInsets.all(24),
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
            child: Stack(
              children: [
                Provider.of<LockerStudentProvider>(context, listen: false)
                        .lockerItems
                        .isEmpty
                    ? Container()
                    : PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          sections: showingSections(context),
                        ),
                      ),
                Align(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      Provider.of<LockerStudentProvider>(context, listen: false)
                          .lockerItems
                          .length
                          .toString(),
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Column(
            children: [
              Indicator(
                color: const Color(0x88a096),
                text: 'Casiers libres',
                isSquare: true,
              ),
              Indicator(
                color: const Color(0xFFFB3274),
                text: 'Casiers occupés',
                isSquare: true,
              ),
              Indicator(
                color: Colors.orange,
                text: 'Casiers inaccessibles',
                isSquare: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(BuildContext context) {
    return List.generate(
      3,
      (index) {
        final isTouched = index == touchedIndex;
        // final fontSize = isTouched ? 20.0 : 16.0;
        final fontSize = isTouched ? 24.0 : 20.0;

        final radius = isTouched ? 62.0 : 58.0;
        const shadows = [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
          ),
        ];
        switch (index) {
          case 0:
            // Casiers libres
            return PieChartSectionData(
              color: const Color(0xFF12eaea),
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
              color: Color(0xFFfb3274),
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
            // Casiers inaccessibles
            return PieChartSectionData(
              color: Color(0xFFffa737),
              value: Provider.of<LockerStudentProvider>(context)
                  .getInaccessibleLocker()
                  .length
                  .toDouble(),
              title: Provider.of<LockerStudentProvider>(context)
                  .getInaccessibleLocker()
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
          default:
            throw Error();
        }
      },
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
