import 'package:flutter/material.dart';

class dividerMenu extends StatelessWidget {
  const dividerMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        const Divider(
          indent: 20,
          endIndent: 20,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
      ],
    );
  }
}
