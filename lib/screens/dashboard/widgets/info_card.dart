import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lockers_app/responsive.dart';

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
          height: MediaQuery.of(context).size.height * 0.21 - 5,
          width: MediaQuery.of(context).size.width * 0.12,
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
                height: Responsive.isMobile(context) ? 32 : 40,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 100,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 14 : 16,
                  color: const Color(0xffa6a6a6),
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 100,
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 24 : 30,
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
