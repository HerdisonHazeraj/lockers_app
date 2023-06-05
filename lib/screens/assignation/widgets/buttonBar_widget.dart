import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/lockers_student_provider.dart';
import '../../../responsive.dart';

class ButtonBarWidget extends StatelessWidget {
  const ButtonBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.33,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xffececf6),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
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
    // : const SizedBox();
  }
}
