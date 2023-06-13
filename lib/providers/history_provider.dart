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
    _historyItems.clear();
    final data = await dbService.getAllHistory();
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

  Future<void> deleteHisotry(String id) async {
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
}
