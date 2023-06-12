import 'package:flutter/material.dart';

class LockersMenu extends StatefulWidget {
  const LockersMenu({super.key});

  @override
  State<LockersMenu> createState() => _LockersMenuState();
}

class _LockersMenuState extends State<LockersMenu> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xffececf6),
          ),
          child: const SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
