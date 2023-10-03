import 'package:flutter/material.dart';
import 'package:lockers_app/models/locker.dart';

// ignore: must_be_immutable
class LockersTasksWidget extends StatelessWidget {
  LockersTasksWidget({super.key, required this.locker});
  Locker locker;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        childAspectRatio: 4,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        crossAxisCount: 2,
        children: [
          locker.nbKey < 2
              ? Text('Nombre de clés : ${locker.nbKey}')
              : const Text(''),
          locker.nbKey < 2
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.vpn_key_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                )
              : const Text(''),
          locker.remark != ''
              ? Text('Remarque : ${locker.remark}')
              : const Text(''),
          locker.remark != ''
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.task_alt_outlined,
                    color: Colors.black,
                  ),
                )
              : const Text(''),
          locker.nbKey < 2 || locker.remark != ''
              ? Text('')
              : Text('Pas de tâche sur ce casier')
        ]);
  }
}
