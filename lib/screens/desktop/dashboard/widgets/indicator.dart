import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Indicator extends StatelessWidget {
  Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 0,
  });
  final Color color;
  final String text;
  final bool isSquare;
  double size;

  @override
  Widget build(BuildContext context) {
    size = 20;
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            // color: ColorTheme.secondaryTextColor,
          ),
        )
      ],
    );
  }
}
