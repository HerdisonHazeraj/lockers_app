import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/dashboard/widgets/indicator.dart';
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
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        child: Container(
          margin:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.028),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 30,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: BarChart(BarChartData(
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.blueGrey,
                          tooltipHorizontalAlignment:
                              FLHorizontalAlignment.right,
                          tooltipMargin: -10,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            String etage;
                            switch (group.x) {
                              case 0:
                                etage = 'b';
                                break;
                              case 1:
                                etage = 'c';
                                break;
                              case 2:
                                etage = 'd';
                                break;
                              case 3:
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
                            touchedIndex =
                                barTouchResponse.spot!.touchedBarGroupIndex;
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
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Column(
                      children: [
                        Indicator(
                          color: Color(0xFF01FBCF),
                          text: 'Casiers totaux par étage',
                          isSquare: true,
                        ),
                        Indicator(
                          color: Color(0xFFFB3274),
                          text: 'Casiers occupés par étage',
                          isSquare: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y1,
    double y2, {
    double toY = 0,
    bool isTouched = false,
    Color? barColor,
    double width = 30,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y1 + 1 : y1,
          color: isTouched ? const Color(0xFF01FBCF) : const Color(0xFF01FBCF),
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Color(0xFFDAE9F2))
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: toY,
            color: const Color(0xFFF2F2F2),
          ),
        ),
        BarChartRodData(
          toY: isTouched ? y2 + 1 : y2,
          color: isTouched ? const Color(0xFFFB3274) : const Color(0xFFFB3274),
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Color(0xFFDAE9F2))
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: toY,
            color: const Color(0xFFF2F2F2),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(4, (i) {
        final lockers =
            Provider.of<LockerStudentProvider>(context, listen: false)
                .mapLockerByFloor();
        final toY = Provider.of<LockerStudentProvider>(context, listen: false)
                .getLengthFromLargestFloor() +
            1;

        switch (i) {
          case 0:
            return makeGroupData(
              0,
              lockers['b']!.length.toDouble(),
              lockers['b']!
                  .where((element) => element.isAvailable == false)
                  .length
                  .toDouble(),
              toY: toY.toDouble(),
              isTouched: i == touchedIndex,
            );
          case 1:
            return makeGroupData(
              i,
              lockers['c']!.length.toDouble(),
              lockers['c']!
                  .where((element) => element.isAvailable == false)
                  .length
                  .toDouble(),
              toY: toY.toDouble(),
              isTouched: i == touchedIndex,
            );
          case 2:
            return makeGroupData(
              2,
              lockers['d']!.length.toDouble(),
              lockers['d']!
                  .where((element) => element.isAvailable == false)
                  .length
                  .toDouble(),
              toY: toY.toDouble(),
              isTouched: i == touchedIndex,
            );
          case 3:
            return makeGroupData(
              3,
              lockers['e']!.length.toDouble(),
              lockers['e']!
                  .where((element) => element.isAvailable == false)
                  .length
                  .toDouble(),
              toY: toY.toDouble(),
              isTouched: i == touchedIndex,
            );

          default:
            return makeGroupData(0, 0, 0, isTouched: i == touchedIndex);
        }
      });

  Widget getBottomTitles(double value, TitleMeta meta) {
    final titles = <String>['B', 'C', 'D', 'E'];
    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
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

    if (value % 4 == 0) {
      text = value.toString();
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
