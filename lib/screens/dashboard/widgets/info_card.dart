import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lockers_app/responsive.dart';

class InfoCard extends StatelessWidget {
  const InfoCard(
    this.title,
    this.value,
    this.svgSrc, {
    super.key,
  });

  final String title;
  final String value;
  final String svgSrc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(value),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      },
      child: Container(
        height: Responsive.isMobile(context) ? 175 : 200,
        width: Responsive.isMobile(context) ? 175 : 200,
        padding: EdgeInsets.only(
          left: Responsive.isMobile(context) ? 20 : 20,
          top: Responsive.isMobile(context) ? 20 : 20,
          bottom: Responsive.isMobile(context) ? 20 : 20,
          right: Responsive.isMobile(context) ? 10 : 20,
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
    );
  }
}
