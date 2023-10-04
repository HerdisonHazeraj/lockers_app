import 'package:flutter/material.dart';
import 'package:lockers_app/screens/desktop/students/widgets/menu_widgets/drop_down_menu.dart';

// ignore: must_be_immutable
class SortLockersMenu extends StatefulWidget {
  SortLockersMenu({
    super.key,
  });

  @override
  State<SortLockersMenu> createState() => _SortLockersMenuState();
}

class _SortLockersMenuState extends State<SortLockersMenu> {
//filtres afficher dans les select du filtre

  List selectednbrClefsFromMap = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 80.0, left: 10, top: 10.0),
      child: Wrap(
        children: [
          DropDownMenu(
              items: const {'0': '0', '1': '1', '2': '2', '3': '3', '4': '4'},
              defaultItem: "Nombre de Clés...",
              icon: Icons.key_outlined,
              onChanged: (value) {},
              enabled: true),
          Container(
            margin: const EdgeInsets.only(top: 20.0, left: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Appliquer'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
