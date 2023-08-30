import 'package:flutter/material.dart';

class dividerMenu extends StatelessWidget {
  const dividerMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ListBody(
      children: [
        SizedBox(
          height: 20,
        ),
        Divider(
          indent: 20,
          endIndent: 20,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
