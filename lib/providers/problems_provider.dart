import 'package:flutter/material.dart';
import 'package:lockers_app/models/problems.dart';

import '../infrastructure/db_service.dart';

class ProblemProvider with ChangeNotifier {
  final List<Problem> _problemItems = [];
  // LockerStudentProvider lockerStudentProvider;

  ProblemProvider(this.dbService);
  final DBService dbService;

  List<Problem> get problemItems {
    return [..._problemItems];
  }

  Future<void> fetchAndSetProblems() async {
    _problemItems.clear();
    final data = await dbService.getAllProblems();
    _problemItems.addAll(data);
    notifyListeners();
  }

  Future<void> addProblem(Problem problem, String lockerId) async {
    final data = await dbService.addProblem(problem);
    _problemItems.add(data);
    // Locker locker = lockerStudentProvider.lockerItems
    //     .firstWhere((element) => element.id == lockerId);
    // locker.copyWith(isDamaged: true);
    notifyListeners();
  }

  Future<void> updateProblem(Problem updatedProblem) async {
    final lockerIndex = findIndexOfProblemById(updatedProblem.id!);
    if (lockerIndex >= 0) {
      final newProblem = await dbService.updateProblem(updatedProblem);
      _problemItems[lockerIndex] = newProblem;
      notifyListeners();
    }
  }

  Future<void> deleteProblem(String id) async {
    await dbService.deleteProblem(id);
    Problem item = _problemItems.firstWhere((problem) => problem.id == id);

    _problemItems.remove(item);
    notifyListeners();
  }

  int findIndexOfProblemById(String id) {
    final problemIndex =
        _problemItems.indexWhere((problem) => problem.id == id);
    return problemIndex;
  }
}
