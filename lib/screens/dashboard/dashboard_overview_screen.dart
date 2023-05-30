import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:lockers_app/screens/dashboard/widgets/info_card.dart';
import 'package:provider/provider.dart';

import '../../responsive.dart';

class DashboardOverviewScreen extends StatefulWidget {
  const DashboardOverviewScreen({super.key});

  static String routeName = "/dashboard";

  @override
  State<DashboardOverviewScreen> createState() =>
      _DashboardOverviewScreenState();
}

class _DashboardOverviewScreenState extends State<DashboardOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;
  int touchedIndex = -1;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      _isLoading = true;
      await Provider.of<LockerStudentProvider>(context, listen: false)
          .fetchAndSetLockers();
      await Provider.of<LockerStudentProvider>(context, listen: false)
          .fetchAndSetStudents();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 10,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                children: [
                                  InfoCard(
                                    "Nombre total de casiers",
                                    Provider.of<LockerStudentProvider>(context)
                                        .lockerItems
                                        .length
                                        .toString(),
                                    "assets/icons/locker.svg",
                                  ),
                                  InfoCard(
                                    "Nombre total   d'élèves",
                                    Provider.of<LockerStudentProvider>(context)
                                        .studentItems
                                        .length
                                        .toString(),
                                    'assets/icons/student.svg',
                                  ),
                                  const InfoCard(
                                    "Nombre d'élèves sans casiers",
                                    "2",
                                    "assets/icons/student.svg",
                                  ),
                                  const InfoCard(
                                    "Nombre de casiers libres",
                                    "2",
                                    "assets/icons/locker.svg",
                                  ),
                                  const InfoCard(
                                    "Nombre de casiers défectueux",
                                    "1",
                                    "assets/icons/locker.svg",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Responsive.isMobile(context)
                      ? const SizedBox()
                      : Expanded(
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
  }
}
