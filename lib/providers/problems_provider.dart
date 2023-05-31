import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';

import '../infrastructure/db_service.dart';
import '../models/locker.dart';

class LockerStudentProvider with ChangeNotifier {
  final List<Locker> _lockerItems = [];
  final List<Student> _studentItems = [];

  LockerStudentProvider(this.dbService);
  final DBService dbService;

  List<Locker> get lockerItems {
    return [..._lockerItems];
  }

  List<Student> get studentItems {
    return [..._studentItems];
  }

  Future<void> fetchAndSetProblems() async {
    _lockerItems.clear();
    final data = await dbService.getAllLockers();
    _lockerItems.addAll(data);
    notifyListeners();
  }

  Future<void> addProblem(Locker locker) async {
    final data = await dbService.addLocker(locker);
    _lockerItems.add(data);
    notifyListeners();
  }

  Future<void> updateProblem(Locker updatedLocker) async {
    final lockerIndex = findIndexOfProblemById(updatedLocker.id!);
    if (lockerIndex >= 0) {
      final newLocker = await dbService.updateLocker(updatedLocker);
      _lockerItems[lockerIndex] = newLocker;
      notifyListeners();
    }
  }

  Future<void> deleteProblem(String id) async {
    await dbService.deleteLocker(id);
    Locker item = _lockerItems.firstWhere((locker) => locker.id == id);

    _lockerItems.remove(item);
    notifyListeners();
  }

  int findIndexOfProblemById(String id) {
    final studentIndex =
        _studentItems.indexWhere((student) => student.id == id);
    return studentIndex;
  }
}
