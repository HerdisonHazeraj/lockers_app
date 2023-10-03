import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../core/theme.dart';
import '../../../../providers/lockers_student_provider.dart';
import 'indicator.dart';

class CautionPieChartWidget extends StatefulWidget {
  const CautionPieChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CautionPieChartWidgetState();
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
    return Container(
      padding: const EdgeInsets.only(right: 30),
      // width: 300,
      height: 400,
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 1,
                blurRadius: 30,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      axisLabelStyle: GaugeTextStyle(
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionColor),
                      maximumLabels: 3,
                      minimum: 0,
                      maximum: paidCautionsList + unPaidCautionsList == 0
                          ? 1
                          : paidCautionsList + unPaidCautionsList,
                      majorTickStyle: MajorTickStyle(
                          length: 17,
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionColor),
                      minorTickStyle: MinorTickStyle(
                          length: 11,
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionColor),
                      ranges: <GaugeRange>[
                        GaugeRange(
                            startWidth: 20,
                            endWidth: 20,
                            startValue: 0,
                            endValue: paidCautionsList,
                            color: ColorTheme.secondary),
                        GaugeRange(
                            startWidth: 20,
                            endWidth: 20,
                            startValue: paidCautionsList,
                            endValue: paidCautionsList + unPaidCautionsList,
                            color: ColorTheme.primary),
                      ],
                      pointers: <GaugePointer>[
                        MarkerPointer(
                          borderColor: Theme.of(context).dividerColor,
                          enableAnimation: true,
                          animationType: AnimationType.ease,
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
                                paidCautionsList.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
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
                          positionFactor: 1,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 5, bottom: 5),
                child: Column(
                  children: [
                    Indicator(
                      color: ColorTheme.secondary,
                      text: 'Cautions payées',
                      isSquare: true,
                    ),
                    Indicator(
                      color: ColorTheme.primary,
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
    );
  }
}
