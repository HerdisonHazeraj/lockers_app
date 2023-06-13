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
    return InkWell(
      child: Container(
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
          width: MediaQuery.of(context).size.width * 0.14,
          height: MediaQuery.of(context).size.height * 0.32,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: SfRadialGauge(axes: <RadialAxis>[
                    RadialAxis(
                        maximumLabels: 5,
                        minimum: 0,
                        maximum: 33,
                        ranges: <GaugeRange>[
                          GaugeRange(
                              startWidth: 20,
                              endWidth: 20,
                              startValue: 0,
                              endValue: 25,
                              color: const Color(0xFF01FBCF)),
                          GaugeRange(
                              startWidth: 20,
                              endWidth: 20,
                              startValue: 25,
                              endValue: 33,
                              color: Color(0xFFFB3274)),
                        ],
                        pointers: const <GaugePointer>[
                          MarkerPointer(
                            value: 25,
                            markerHeight: 15,
                            markerOffset: 2,
                            color: Colors.black,
                          )
                        ],
                        annotations: const <GaugeAnnotation>[
                          GaugeAnnotation(
                              widget: Column(children: [
                                Text('25',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text('caution payées',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      height: 1.3,
                                    ))
                              ]),
                              angle: 90,
                              positionFactor: 1)
                        ])
                  ]),
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
