import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InfoCard extends StatelessWidget {
  const InfoCard(
    this.title,
    this.value,
    this.svgSrc,
    this.onTap, {
    super.key,
  });

  final String title;
  final String value;
  final String svgSrc;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10),
      child: InkWell(
        hoverColor: Colors.transparent,
        onTap: () {
          onTap();
        },
        child: Container(
          height: 235,
          width: 235,
          padding: const EdgeInsets.all(20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset(
                svgSrc,
                height: 40,
              ),
              const SizedBox(
                height: 10,
              ),
              Tooltip(
                message: title,
                waitDuration: const Duration(seconds: 1),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xffa6a6a6),
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
