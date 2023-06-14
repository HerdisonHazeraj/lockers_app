import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../providers/lockers_student_provider.dart';
import 'indicator.dart';

class CautionPieChartWidget extends StatefulWidget {
  const CautionPieChartWidget({super.key});

  @override
  State<CautionPieChartWidget> createState() => _CautionPieChartWidgetState();
}

class _CautionPieChartWidgetState extends State<CautionPieChartWidget> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    final paidCautionsList =
        Provider.of<LockerStudentProvider>(context, listen: false)
            .getPaidCaution()
            .length
            .toDouble();
    final unPaidCautionsList =
        Provider.of<LockerStudentProvider>(context, listen: false)
            .getNonPaidCaution()
            .length
            .toDouble();
    return InkWell(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
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
          width: MediaQuery.of(context).size.width * 0.15,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        maximumLabels: 3,
                        minimum: 0,
                        maximum: paidCautionsList + unPaidCautionsList == 0
                            ? 1
                            : paidCautionsList + unPaidCautionsList,
                        ranges: <GaugeRange>[
                          GaugeRange(
                              startWidth: 20,
                              endWidth: 20,
                              startValue: 0,
                              endValue: paidCautionsList,
                              color: const Color(0xFF01FBCF)),
                          GaugeRange(
                              startWidth: 20,
                              endWidth: 20,
                              startValue: paidCautionsList,
                              endValue: paidCautionsList + unPaidCautionsList,
                              color: const Color(0xFFFB3274)),
                        ],
                        pointers: <GaugePointer>[
                          MarkerPointer(
                            value: paidCautionsList,
                            markerHeight: 15,
                            markerOffset: 2,
                            color: Colors.black,
                          )
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            widget: Column(
                              children: [
                                Text(
                                  paidCautionsList.toString(),
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'cautions payées',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    height: 2,
                                  ),
                                ),
                              ],
                            ),
                            angle: 90,
                            positionFactor: 1.2,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 5, bottom: 5),
                  child: const Column(
                    children: [
                      Indicator(
                        color: Color(0xFF01FBCF),
                        text: 'Cautions payées',
                        isSquare: true,
                      ),
                      Indicator(
                        color: Color(0xFFFB3274),
                        text: 'Cautions non-payées',
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
    );
  }
}
