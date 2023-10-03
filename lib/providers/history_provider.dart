import 'package:flutter/material.dart';
import 'package:lockers_app/models/history.dart';

import '../infrastructure/db_service.dart';

class HistoryProvider with ChangeNotifier {
  final List<History> _historyItems = [];
  // LockerStudentProvider lockerStudentProvider;

  HistoryProvider(this.dbService);
  final DBService dbService;

  List<History> get historyItems {
    return [..._historyItems];
  }

  Future<void> fetchAndSetHistory() async {
    final data = await dbService.getAllHistory();
    _historyItems.clear();
    _historyItems.addAll(data);
    notifyListeners();
  }

  Future<void> addHistory(History history) async {
    final data = await dbService.addHistory(history);
    _historyItems.add(data);
    notifyListeners();
  }

  Future<void> updateHisotry(History updatedHistory) async {
    final historyIndex = findIndexOfHistoryById(updatedHistory.id!);
    if (historyIndex >= 0) {
      final newHistory = await dbService.updateHistory(updatedHistory);
      _historyItems[historyIndex] = newHistory;
      notifyListeners();
    }
  }

  Future<void> deleteAll() async {
    //  _historyItems = [];
    for (var item in _historyItems) {
      await dbService.deleteHistory(item.id!);
    }
    _historyItems.clear();
    notifyListeners();
  }

  Future<void> deleteHistory(String id) async {
    await dbService.deleteHistory(id);
    History item = _historyItems.firstWhere((hisotry) => hisotry.id == id);

    _historyItems.remove(item);
    notifyListeners();
  }

  int findIndexOfHistoryById(String id) {
    final historyIndex =
        _historyItems.indexWhere((hisotry) => hisotry.id == id);
    return historyIndex;
  }

  // void cancelHistory(History history) {
  //   switch (history.action) {
  //     case "add":
  //       if (history.locker.isUndefinedOrNull) {
  //         lockerAndStudentProvider.deleteStudent(
  //           history.student!['id'],
  //         );
  //       } else {
  //         lockerAndStudentProvider.deleteLocker(
  //           history.locker!['id'],
  //         );
  //       }
  //       break;
  //     case "delete":
  //       if (history.locker.isUndefinedOrNull) {
  //         lockerAndStudentProvider.insertStudent(
  //           history.index!,
  //           Student.fromJson(history.student!),
  //         );
  //       } else {
  //         lockerAndStudentProvider.insertLocker(
  //           history.index!,
  //           Locker.fromJson(history.locker!),
  //         );
  //       }
  //       break;
  //     case "update":
  //       if (history.locker.isUndefinedOrNull) {
  //         lockerAndStudentProvider.updateStudent(
  //           Student.fromJson(history.student!),
  //         );
  //       } else {
  //         lockerAndStudentProvider.updateLocker(
  //           Locker.fromJson(history.locker!),
  //         );
  //       }
  //       break;
  //     case "attribution":
  //       break;
  //     case "unattribution":
  //       break;
  //   }
  // }
}
