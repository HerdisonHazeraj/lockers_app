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
      padding: const EdgeInsets.only(top: 30, right: 30),
      child: InkWell(
        // hoverColor: Colors.transparent,
        onTap: () {
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
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
                color: Theme.of(context).iconTheme.color,
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
                    fontSize: 18,
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
                  fontSize: 26,
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
