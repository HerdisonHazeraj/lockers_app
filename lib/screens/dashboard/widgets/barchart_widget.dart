import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

class BarChartWidget extends StatefulWidget {
  BarChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Container(
            margin: EdgeInsets.all(20),
            child: BarChart(BarChartData(
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.blueGrey,
                  tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                  tooltipMargin: -10,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String etage;
                    switch (group.x) {
                      case 0:
                        etage = 'a';
                        break;
                      case 1:
                        etage = 'b';
                        break;
                      case 2:
                        etage = 'c';
                        break;
                      case 3:
                        etage = 'd';
                        break;
                      case 4:
                        etage = 'e';
                        break;

                      default:
                        throw Error();
                    }
                    return BarTooltipItem(
                      '$etage\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: (rod.toY - 1).toString(),
                          style: TextStyle(
                            color: Colors.green[100],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getBottomTitles,
                    reservedSize: 38,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getLeftTitles,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: showingGroups(),
              gridData: FlGridData(show: false),
            )),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y1,
    double y2, {
    bool isTouched1 = false,
    bool isTouched2 = false,
    Color? barColor,
    double width = 32,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched1 ? y1 + 1 : y1,
          color: isTouched1 ? Color(0xFF01FBCF) : Color(0xFF01FBCF),
          width: width,
          borderSide: isTouched1
              ? BorderSide(color: Color(0xFFDAE9F2))
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 40,
            color: Color(0xFFF2F2F2),
          ),
        ),
        BarChartRodData(
          toY: isTouched2 ? y2 + 1 : y2,
          color: isTouched2 ? Color(0xFFFB3274) : Color(0xFFFB3274),
          width: width,
          borderSide: isTouched2
              ? BorderSide(color: Color(0xFFDAE9F2))
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 40,
            color: Color(0xFFF2F2F2),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(5, (i) {
        final aLockers =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .getLockerbyFloor('a');
        final bLockers =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .getLockerbyFloor('b');
        final cLockers =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .getLockerbyFloor('c');
        final dLockers =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .getLockerbyFloor('d');
        final eLockers =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .getLockerbyFloor('e');
        final aLockersAvailable =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .getLockerbyFloor('a');
        final bLockersAvailable =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .getLockerbyFloor('b');
        final cLockersAvailable =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .getLockerbyFloor('c');
        final dLockersAvailable =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .getLockerbyFloor('d');
        final eLockersAvailable =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .getLockerbyFloor('e');
        switch (i) {
          case 0:
            return makeGroupData(
              0,
              aLockers.length.toDouble(),
              aLockersAvailable.length.toDouble(),
              isTouched1: i == touchedIndex,
              isTouched2: i == touchedIndex,
            );
          case 1:
            return makeGroupData(
              1,
              bLockers.length.toDouble(),
              bLockersAvailable.length.toDouble(),
              isTouched1: i == touchedIndex,
              isTouched2: i == touchedIndex,
            );
          case 2:
            return makeGroupData(
              2,
              cLockers.length.toDouble(),
              cLockersAvailable.length.toDouble(),
              isTouched1: i == touchedIndex,
              isTouched2: i == touchedIndex,
            );
          case 3:
            return makeGroupData(
              3,
              dLockers.length.toDouble(),
              dLockersAvailable.length.toDouble(),
              isTouched1: i == touchedIndex,
              isTouched2: i == touchedIndex,
            );
          case 4:
            return makeGroupData(
              4,
              eLockers.length.toDouble(),
              eLockersAvailable.length.toDouble(),
              isTouched1: i == touchedIndex,
              isTouched2: i == touchedIndex,
            );

          default:
            return makeGroupData(0, 0, 0, isTouched1: i == touchedIndex);
        }
      });

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('a', style: style);
        break;
      case 1:
        text = const Text('b', style: style);
        break;
      case 2:
        text = const Text('c', style: style);
        break;
      case 3:
        text = const Text('d', style: style);
        break;
      case 4:
        text = const Text('e', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;

    if (value % 10 == 1) {
      text = '10';
    } else {
      return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
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
