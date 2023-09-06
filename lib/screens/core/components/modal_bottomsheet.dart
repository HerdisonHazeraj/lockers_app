import 'package:flutter/material.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

Future<dynamic> ModalBottomSheetWidget(
    BuildContext context, List<ListTile> standardList, Locker locker) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    )),
    context: context,
    builder: (builder) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.03),
                child: Text(
                  'Casier n°${locker.lockerNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  size: 28,
                ),
              ),
            ],
          ),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          ...standardList.map((e) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: e.onTap,
                                  title: e.title,
                                  trailing: e.trailing,
                                ),
                                if (standardList.last != e) const Divider(),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              )
              // TextFormField(
              //   onFieldSubmitted: (value) {},
              //   decoration: const InputDecoration(
              //     labelText: "Remarque",
              //     prefixIcon: Icon(Icons.edit),
              //   ),
              //   onSaved: (String? value) {
              //     Provider.of<LockerStudentProvider>(context, listen: false)
              //         .updateLocker(locker.copyWith(remark: value));
              //   },
              // ),
              )
        ]),
      );
    },
  );
}
