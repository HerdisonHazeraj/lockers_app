import 'package:flutter/material.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/shared/widgets/divider_menu.dart';
import 'package:provider/provider.dart';

class DashboardMenu extends StatefulWidget {
  const DashboardMenu({super.key});

  @override
  State<DashboardMenu> createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {
  bool isFocus = false;
  List<Locker> lockers = [];
  List<Student> students = [];

  @override
  void initState() {
    lockers =
        Provider.of<LockerStudentProvider>(context, listen: false).lockerItems;
    students =
        Provider.of<LockerStudentProvider>(context, listen: false).studentItems;
    super.initState();
  }

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Derniers élèves ajoutés",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ...students.map(
                          (student) => MouseRegion(
                            onEnter: (event) => setState(() {
                              student.isFocus = true;
                            }),
                            onExit: (event) => setState(() {
                              student.isFocus = false;
                            }),
                            child: ListTile(
                              title: Text(
                                "${student.firstName} ${student.lastName}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                student.job,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              trailing: Visibility(
                                visible: student.isFocus,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          students.remove(student);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'L\'ajout de l\'élève ${student.firstName} ${student.lastName} à été confirmer avec succès!'),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          students.remove(student);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'L\'ajout de l\'élève ${student.firstName} ${student.lastName} à été annuler avec succès !'),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.black54,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const dividerMenu(),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Derniers casiers ajoutés",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ...lockers.map(
                          (locker) => MouseRegion(
                            onEnter: (event) => setState(() {
                              locker.isFocus = true;
                            }),
                            onExit: (event) => setState(() {
                              locker.isFocus = false;
                            }),
                            child: ListTile(
                              title: Text(
                                "Casier n°${locker.lockerNumber} (Étage ${locker.floor.toUpperCase()})",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                locker.remark == ''
                                    ? '-'
                                    : locker.remark.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Visibility(
                                visible: locker.isFocus,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          lockers.remove(locker);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'L\'ajout du casier numéro ${locker.lockerNumber} à été confirmer avec succès!'),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          lockers.remove(locker);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'L\'ajout du casier numéro ${locker.lockerNumber} à été annuler avec succès !'),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.black54,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
