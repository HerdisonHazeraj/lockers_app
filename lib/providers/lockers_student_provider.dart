import 'dart:async';
import 'dart:convert';
// import 'dart:js_interop';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/history_provider.dart';

import '../infrastructure/db_service.dart';
import '../models/history.dart';
import '../models/locker.dart';

class LockerStudentProvider with ChangeNotifier {
  final List<Locker> _lockerItems = [];
  final List<Student> _studentItems = [];

  LockerStudentProvider(this.dbService);
  final DBService dbService;
  late HistoryProvider historyProvider = HistoryProvider(dbService);

  List<Locker> get lockerItems {
    return [..._lockerItems];
  }

  List<Student> get studentItems {
    return [..._studentItems];
  }

  Map<String, int> index = {
    "d": 1,
    "c": 2,
    "b": 3,
    "e": 4,
  };

  Future<void> fetchAndSetLockers() async {
    final data = await dbService.getAllLockers();
    _lockerItems.clear();
    _lockerItems.addAll(data);
    setAllLockerToDefective();
    notifyListeners();
  }

  Future<void> addLocker(Locker locker) async {
    final data = await dbService.addLocker(locker);
    _lockerItems.add(data);

    historyProvider.addHistory(History(
      date: DateTime.now().toString(),
      action: "add",
      locker: locker.toJson(),
    ));
    notifyListeners();
  }

  Future<void> updateLocker(Locker updatedLocker,
      {bool historic = true}) async {
    final Locker oldLocker = getLocker(updatedLocker.id!);
    final lockerIndex = findIndexOfLockerById(updatedLocker.id!);

    if (lockerIndex >= 0) {
      if (historic) {
        historyProvider.addHistory(History(
          action: "update",
          date: DateTime.now().toString(),
          locker: updatedLocker.toJson(),
          oldLocker: oldLocker.toJson(),
        ));
      }
      final newLocker = await dbService.updateLocker(updatedLocker);
      _lockerItems[lockerIndex] = newLocker;
      notifyListeners();
    }
  }

  Map<dynamic, String> findFilters(String node) {
    List<Student> students = getNotArchivedStudent();
    Map<dynamic, String> filters = {};

    for (var student in students) {
      switch (node) {
        case 'job':
          filters.addEntries([MapEntry(student.job, student.job)]);
          break;

        case 'responsable':
          if (student.responsable == "") {
            filters.addEntries(
                [MapEntry(student.responsable, "Aucun responsable")]);
          } else {
            filters.addEntries([
              MapEntry(
                  student.responsable.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
                  student.responsable)
            ]);
          }
          break;
      }
    }

    // return students;
    return filters;
  }

  Future<void> deleteLocker(String id) async {
    await dbService.deleteLocker(id);
    historyProvider.addHistory(History(
        date: DateTime.now().toString(),
        action: "delete",
        locker: getLocker(id)
            .copyWith(idEleve: "", isAvailable: true, job: "")
            .toJson(),
        index: findIndexOfLockerById(id)));
    Locker item = _lockerItems.firstWhere((locker) => locker.id == id);

    _lockerItems.remove(item);

    notifyListeners();
  }

  List<Student> getAllTerminaux() {
    List<Student> terminaux = getNotArchivedStudent()
        .where((element) => element.isTerminal == true && element.caution != 0)
        .toList();
    return terminaux;
  }

  bool checkIfTheresTerminaux() {
    List<Student> terminaux =
        _studentItems.where((element) => element.isTerminal == true).toList();
    return terminaux.isNotEmpty;
  }

  void setAllTerminauxToFalse() {
    final students = getAllTerminaux();

    students.forEach((student) {
      student.isTerminal = false;
      dbService.updateStudent(student);
    });
  }

  Future<void> setAllTerminauxList() async {
    final students = getNotArchivedStudent();

    // students.where((element) => false)
    students.forEach((student) {
      if (student.classe.toLowerCase().contains('oic3') ||
          student.classe.toLowerCase().contains('ict4') ||
          (student.classe.toLowerCase().contains('ict3') &&
              student.classe.toLowerCase().contains('p3')) ||
          (student.classe.toLowerCase().contains('ich3') &&
              student.classe.toLowerCase().contains('p3'))) {
        student.isTerminal = true;
        dbService.updateStudent(student);
      }

      // switch(student.classe){
      //   case .contains('oic3'):

      //   break;
      // }
    });
  }

  Future<void> insertLocker(int index, Locker locker) async {
    await dbService.addLocker(locker);
    _lockerItems.insert(index, locker);
    notifyListeners();
  }

  Locker getLocker(String id) {
    final lockerIndex = findIndexOfLockerById(id);
    return lockerIndex == -1 ? Locker.error() : _lockerItems[lockerIndex];
  }

  Locker getLockerByLockerNumber(int lockerNumber) {
    Locker locker = getAccessibleLocker()
        .firstWhere((locker) => locker.lockerNumber == lockerNumber);
    return locker;
  }

  List<Locker> getAvailableLockers() {
    List<Locker> availableItem = getAccessibleLocker()
        .where((element) => element.isAvailable == true)
        .toList();
    return availableItem;
  }

  List<Locker> getUnAvailableLockers() {
    List<Locker> unavailableItem = getAccessibleLocker()
        .where((element) => element.isAvailable == false)
        .toList();
    return unavailableItem;
  }

  int findIndexOfLockerById(String id) {
    final lockerIndex = _lockerItems.indexWhere((locker) => locker.id == id);
    return lockerIndex;
  }

  Future<void> fetchAndSetStudents() async {
    final data = await dbService.getAllStudents();
    _studentItems.clear();
    _studentItems.addAll(data);
    notifyListeners();
  }

  Future<void> addStudent(Student student) async {
    final data = await dbService.addStudent(student);
    _studentItems.add(data);
    historyProvider.addHistory(History(
      date: DateTime.now().toString(),
      action: "add",
      student: student.toJson(),
    ));
    notifyListeners();
  }

  Future<void> updateStudent(Student updatedStudent,
      {bool historic = true}) async {
    final studentIndex = findIndexOfStudentById(updatedStudent.id!);
    final Student oldStudent = getStudent(updatedStudent.id!);
    if (studentIndex >= 0) {
      if (historic) {
        historyProvider.addHistory(History(
            id: updatedStudent.id,
            student: updatedStudent.toJson(),
            oldStudent: oldStudent.toJson(),
            date: DateTime.now().toString(),
            action: "update"));
      }
      final newStudent = await dbService.updateStudent(updatedStudent);
      _studentItems[studentIndex] = newStudent;
      notifyListeners();
    }
  }

  Future<void> deleteStudent(String id) async {
    Student student = getStudent(id);
    await dbService.deleteStudent(id);

    if (student.lockerNumber != 0) {
      Locker locker = getLockerByLockerNumber(student.lockerNumber);
      unAttributeLocker(locker, student, historic: false);
    }

    historyProvider.addHistory(History(
        date: DateTime.now().toString(),
        action: "delete",
        //enlever le copywith pour tenter de réattribuer le casier après sa suppression
        student: getStudent(id).copyWith(lockerNumber: 0).toJson(),
        index: findIndexOfStudentById(id)));

    _studentItems.removeWhere((student) => student.id == id);

    notifyListeners();
  }

  Future<void> insertStudent(Student student) async {
    await dbService.addStudent(student);
    _studentItems.add(student);
    notifyListeners();
  }

  Student getStudent(String id) {
    if (id == "") return Student.base();

    final studentIndex =
        _studentItems.indexWhere((student) => student.id == id);
    return _studentItems[studentIndex];
  }

  Student getStudentByLocker(Locker locker) {
    List<Student> test = getNotArchivedStudent();
    Student student = test
        .firstWhere((element) => element.lockerNumber == locker.lockerNumber);
    return student;
  }

  List<Student> getAvailableStudents() {
    List<Student> availableItem = getNotArchivedStudent()
        .where((element) => element.lockerNumber == 0)
        .toList();
    return availableItem;
  }

  Map<String, List<Student>> mapStudentByYear() {
    Map<String, List<Student>> map = {};
    map['1'] =
        getNotArchivedStudent().where((element) => element.year == 1).toList();
    map['2'] =
        getNotArchivedStudent().where((element) => element.year == 2).toList();
    map['3'] =
        getNotArchivedStudent().where((element) => element.year == 3).toList();
    map['4'] =
        getNotArchivedStudent().where((element) => element.year == 4).toList();
    return map;
  }

  List<Student> getUnavailableStudents() {
    List<Student> unavailableItem = getNotArchivedStudent()
        .where((element) => element.lockerNumber != 0)
        .toList();
    return unavailableItem;
  }

//permegt de renvoyer la liste des modifications effectuées entre l'ancien et le nouvel élève ou casier
  List getModificationsOldNewList(oldItem, newItem, textList) {
    List modifications = [];
    for (var i = 0; i < textList.length; i++) {
      if (oldItem[textList[i]] != newItem[textList[i]]) {
        switch (textList[i]) {
          // formattage élève
          case 'isArchived':
            formatModifications(modifications, oldItem, textList, i,
                'élève archivé', 'élève non-archivé');
          case 'caution':
            formatModifications(modifications, oldItem, textList, i,
                'caution non-payée', 'caution payée');

          case 'year':
            if (oldItem[textList[i]] == 1) {
              modifications.addAll({
                '${oldItem[textList[i]]}ère',
              });
              modifications.addAll({
                '${newItem[textList[i]]}ème',
              });
            } else if (newItem[textList[i]] == 1) {
              modifications.addAll({
                '${oldItem[textList[i]]}ème',
              });
              modifications.addAll({
                '${newItem[textList[i]]}ère',
              });
            } else {
              modifications.addAll({
                '${oldItem[textList[i]]}ème',
              });
              modifications.addAll({
                '${newItem[textList[i]]}ème',
              });
            }
          //formattage casier
          case 'isAvailable':
            formatModifications(modifications, oldItem, textList, i,
                'Casier disponible', 'Casier indisponible');
          case 'isInaccessible':
            formatModifications(modifications, oldItem, textList, i,
                'Casier inaccessible', 'Casier accessible');
          case 'nbKey':
            modifications.addAll({
              '${oldItem[textList[i]]} clé(s)',
            });
            modifications.addAll({
              '${newItem[textList[i]]} clé(s)',
            });

          default:
            modifications.addAll({
              oldItem[textList[i]],
            });
            modifications.addAll({
              newItem[textList[i]],
            });
        }
      }
    }
    return modifications;
  }

//permet de formater les textes qui vont être affichés dans les modifs
//pour ne pas juste avoir des textes true false
  void formatModifications(
      List modifications, oldItem, textList, i, textTrue, textFalse) {
    if (oldItem[textList[i]] == false || oldItem[textList[i]] == 20) {
      modifications.addAll({textFalse});
      modifications.addAll({textTrue});
    } else {
      modifications.addAll({textTrue});
      modifications.addAll({textFalse});
    }
  }

  List<Student> getArchivedStudent() {
    List<Student> availableItem =
        _studentItems.where((element) => element.isArchived == true).toList();
    return availableItem;
  }

  List<Student> getNotArchivedStudent() {
    List<Student> availableItem =
        _studentItems.where((element) => element.isArchived == false).toList();
    return availableItem;
  }

  int findIndexOfStudentById(String id) {
    final studentIndex =
        _studentItems.indexWhere((student) => student.id == id);
    return studentIndex;
  }

  Future<void> attributeLocker(Locker locker, Student student,
      {bool historic = true}) async {
    await updateLocker(
      locker.copyWith(
        isAvailable: false,
        idEleve: student.id,
      ),
      historic: false,
    );

    await updateStudent(
        student.copyWith(
          lockerNumber: locker.lockerNumber,
        ),
        historic: false);

    if (historic) {
      historyProvider.addHistory(
        History(
          date: DateTime.now().toString(),
          action: "attribution",
          locker: locker.toJson(),
          student: student.toJson(),
        ),
      );
    }
  }

  Future<void> unAttributeLocker(Locker locker, Student student,
      {bool historic = true}) async {
    await updateLocker(
        locker.copyWith(
          isAvailable: true,
          idEleve: "",
        ),
        historic: false);

    await updateStudent(
        student.copyWith(
          lockerNumber: 0,
        ),
        historic: false);

    if (historic) {
      historyProvider.addHistory(
        History(
          date: DateTime.now().toString(),
          action: "unattribution",
          locker: locker.toJson(),
          student: student.toJson(),
        ),
      );
    }
  }

  int autoAttributeLocker(List<Student> students) {
    final lockers = getAvailableLockers();
    int count = 0;
    lockers.sort(
      (a, b) => index[a.floor.toLowerCase()]!
          .compareTo(index[b.floor.toLowerCase()]!),
    );
    for (var i = 0; i < students.length; i++) {
      if (i >= lockers.length) {
        break;
      }
      attributeLocker(lockers[i], students[i]);

      count++;
    }

    return count;
  }

  Future<void> autoAttributeOneLocker(Student student) async {
    final lockers = getAvailableLockers();
    lockers.sort(
      (a, b) => index[a.floor.toLowerCase()]!
          .compareTo(index[b.floor.toLowerCase()]!),
    );
    Locker firstLocker = lockers.first;
    await attributeLocker(firstLocker, student);
  }

  Map<String, List<Locker>> mapLockerByFloor() {
    Map<String, List<Locker>> map = {};

    List<Locker> lockers = [];
    List<Locker> filtredLocker = [];
    lockers = getAccessibleLocker();

    filtredLocker +=
        lockers.where((element) => element.isDefective == true).toList();
    filtredLocker += lockers
        .where((element) =>
            element.isAvailable == true && element.isDefective == false)
        .toList();
    filtredLocker += lockers
        .where((element) =>
            element.isAvailable == false && element.isDefective == false)
        .toList();

    map["d"] = filtredLocker
        .where((element) => element.floor.toLowerCase() == "d")
        .toList();
    map["c"] = filtredLocker
        .where((element) => element.floor.toLowerCase() == "c")
        .toList();
    map["b"] = filtredLocker
        .where((element) => element.floor.toLowerCase() == "b")
        .toList();
    map["e"] = filtredLocker
        .where((element) => element.floor.toLowerCase() == "e")
        .toList();
    return map;
  }

  List<Student> getPaidCaution() {
    List<Student> students = getUnavailableStudents()
        .where((element) => element.caution == 20)
        .toList();
    return students;
  }

  List<Locker> getLockersWithRemarks() {
    List<Locker> lockers =
        getAccessibleLocker().where((element) => element.remark != "").toList();
    return lockers;
  }

  List<Student> getNonPaidCaution() {
    List<Student> students = getUnavailableStudents()
        .where((element) => element.caution == 0 && element.lockerNumber != 0)
        .toList();
    return students;
  }

  List<Locker> getLockerLessThen2Key() {
    List<Locker> lockers =
        getAccessibleLocker().where((element) => element.nbKey < 2).toList();
    return lockers;
  }

  List<Locker> getLockerbyFloor(String floor) {
    List<Locker> lockers = getAccessibleLocker()
        .where((element) => element.floor.toLowerCase() == floor.toLowerCase())
        .toList();
    return lockers;
  }

  List<Locker> getUnavailableLockerbyFloor(String floor) {
    List<Locker> lockers = getUnAvailableLockers()
        .where((element) => element.floor.toLowerCase() == floor.toLowerCase())
        .toList();
    return lockers;
  }

  List<Locker> getInaccessibleLocker() {
    List<Locker> lockers = _lockerItems
        .where((element) => element.isInaccessible == true)
        .toList();
    return lockers;
  }

  List<Locker> getAccessibleLocker() {
    List<Locker> lockers = _lockerItems
        .where((element) => element.isInaccessible == false)
        .toList();
    return lockers;
  }

  List<Locker> getNonDefectiveLockers() {
    List<Locker> lockers = getAccessibleLocker()
        .where((element) => element.isDefective == true)
        .toList();
    return lockers;
  }

  List<Locker> getDefectiveLockers() {
    List<Locker> lockers = getAccessibleLocker()
        .where((element) => element.isDefective == true)
        .toList();
    return lockers;
  }

  Future<void> setAllLockerToDefective() async {
    for (var locker in _lockerItems) {
      if (locker.nbKey < 2 || locker.remark != "") {
        await setLockerToDefective(locker);
      }
    }
  }

  Future<void> setAllLockerToUnDefective() async {
    for (var locker in _lockerItems) {
      if (locker.nbKey >= 2 || locker.remark == "") {
        await setLockerToUnDefective(locker);
      }
    }
  }

  Future<void> setLockerToUnDefectiveKeys(Locker locker) async {
    if (locker.nbKey <= 2) {
      if (locker.remark == "") {
        await updateLocker(
          locker.copyWith(
            nbKey: 2,
            isDefective: false,
          ),
        );
      } else {
        await updateLocker(
          locker.copyWith(
            nbKey: 2,
            isDefective: true,
          ),
        );
      }
    }
  }

  Future<void> setLockerToUnDefectiveRemarks(Locker locker) async {
    if (locker.remark != "") {
      if (locker.nbKey >= 2) {
        await updateLocker(
          locker.copyWith(
            remark: "",
            isDefective: false,
          ),
        );
      } else {
        await updateLocker(
          locker.copyWith(
            remark: "",
            isDefective: true,
          ),
        );
      }
    }
  }

  Future<void> setLockerToUnDefective(Locker locker) async {
    await updateLocker(
        locker.copyWith(
          isDefective: false,
        ),
        historic: false);
  }

  Future<void> setLockerToDefective(Locker locker) async {
    await updateLocker(
        locker.copyWith(
          isDefective: true,
        ),
        historic: false);
  }

  Future<void> setNumberOfLockerKey(Locker locker, int nbKey) async {
    await updateLocker(
      locker.copyWith(
        nbKey: nbKey,
      ),
    );
  }

  Future<void> unSetLockerToDefective(Locker locker) async {
    await updateLocker(
      locker.copyWith(
        isDefective: false,
      ),
    );
  }

  Future<void> setLockerToInaccessible(Locker locker) async {
    await updateLocker(
      locker.copyWith(
        isInaccessible: true,
        isAvailable: false,
      ),
    );
  }

  Future<void> unSetLockerToAccessible(Locker locker) async {
    await updateLocker(
      locker.copyWith(
        isInaccessible: false,
        isAvailable: true,
      ),
    );
  }

  int getLengthFromLargestFloor() {
    int floorLength = 0;
    mapLockerByFloor().forEach((key, value) {
      if (value.length > floorLength) floorLength = value.length;
    });

    return floorLength;
  }

  List<Student> filterStudentsBy(List<List> key, List<List> value,
      {List<Student> startList = const []}) {
    List<Student> students = [];
    List<Student> filtredStudent = [];
    if (key.isNotEmpty && value.isNotEmpty) {
      students = getAvailableStudents();
      for (var i = 0; i < key.length; i++) {
        for (var j = 0; j < key[i].length; j++) {
          filtredStudent += students
              .where((element) => element.toJson()[key[i][j]] == value[i][j])
              .toList();
        }
        students = filtredStudent;
      }
      return filtredStudent;
    }
    return startList;
  }

  List<Locker> sortLockerBy(String key, bool value, List<Locker> lockers) {
    List<Locker> sortedLocker = lockers;
    if (key.isNotEmpty) {
      if (value) {
        sortedLocker.sort((a, b) => int.tryParse(a.toJson()[key].toString()) ==
                null
            ? a.toJson()[key].toString().compareTo(b.toJson()[key].toString())
            : int.parse(a.toJson()[key].toString())
                .compareTo(int.parse(b.toJson()[key].toString())));
      } else {
        sortedLocker.sort((a, b) => int.tryParse(a.toJson()[key].toString()) ==
                null
            ? -a.toJson()[key].toString().compareTo(b.toJson()[key].toString())
            : -int.parse(a.toJson()[key].toString())
                .compareTo(int.parse(b.toJson()[key].toString())));
      }
      return sortedLocker;
    }
    return [];
  }

  List<Student> sortStudentBy(String key, bool value, List<Student> students) {
    List<Student> sortedStudent = students;
    if (key.isNotEmpty) {
      if (value) {
        sortedStudent.sort(
            (a, b) => a.toJson()[key].toString().compareTo(b.toJson()[key]));
      } else {
        sortedStudent.sort(
            (a, b) => -a.toJson()[key].toString().compareTo(b.toJson()[key]));
      }
      return sortedStudent;
    }
    return [];
  }

  Future<void> promoteStudent(List<Student> students) async {
    for (var element in students) {
      if (element.year != 4) {
        await updateStudent(element.copyWith(year: element.year + 1));
      } else {
        await updateStudent(element.copyWith(year: 0));
      }
    }
  }

  List<Student> searchStudents(value, {bool searchArchivedStudents = false}) {
    List<Student> filtredStudent = [];
    List<Student> students = [];
    if (value != "") {
      if (searchArchivedStudents) {
        students = _studentItems;
      } else {
        students = getNotArchivedStudent();
      }
      filtredStudent = students
          .where((element) =>
              ("${element.lastName} ${element.firstName}")
                  .toString()
                  .toLowerCase()
                  .trim()
                  .contains(value
                      .toString()
                      .toLowerCase()
                      .replaceAll(RegExp(r"\s+"), " ")) ||
              ("${element.firstName} ${element.lastName}")
                  .toString()
                  .toLowerCase()
                  .trim()
                  .contains(value
                      .toString()
                      .toLowerCase()
                      .replaceAll(RegExp(r"\s+"), " ")) ||
              element.login
                  .toString()
                  .toLowerCase()
                  .contains(value.toString().toLowerCase().trim()))
          .toList();
      return filtredStudent;
    }
    return [];
  }

  List<Locker> searchLockers(value, {bool searchUnAccessibleLocker = false}) {
    List<Locker> filtredLocker = [];
    List<Locker> lockers = [];
    if (value != "") {
      if (searchUnAccessibleLocker) {
        lockers = _lockerItems;
      } else {
        lockers = getAccessibleLocker();
      }
      filtredLocker = lockers
          .where((element) => element.lockerNumber
              .toString()
              .toLowerCase()
              .contains(value.toString().toLowerCase().trim()))
          .toList();
      return filtredLocker;
    }
    return [];
  }

  bool cancelHistory(History history) {
    switch (history.action) {
      case "add":
        if (history.student != null) {
          if (history.student!['lockerNumber'] != 0) {
            Locker locker =
                getLockerByLockerNumber(history.student!['lockerNumber']);
            dbService.updateLocker(locker.copyWith(idEleve: ""));
          }
          deleteStudent(
            history.student!['id'],
          );
          return true;
        } else {
          if (history.locker!['idEleve'] != 0) {
            Student student =
                getStudentByLocker(history.locker!['lockerNumber']);
            dbService.updateStudent(student.copyWith(lockerNumber: 0));
          }
          deleteLocker(
            history.locker!['id'],
          );
          return true;
        }

      case "delete":
        if (history.student != null) {
          insertStudent(
            Student.fromJson(history.student!),
          );
          // possibilité de pouvoir réattribuer le casier après sa son annulation de suppression
          // doit controller si le casier n'a pas été attribué à un  autre élève entre temps
          // if (history.student!['lockerNumber'] != 0) {
          //   Locker locker =
          //       getLockerByLockerNumber(history.student!['lockerNumber']);
          //   if (locker.idEleve == "") {
          //     dbService.updateLocker(locker.copyWith(
          //         idEleve: history.student!['id'], isAvailable: false));
          //   } else {
          //     // await fetchAndSetStudents();
          //     Student student = _studentItems.firstWhere((student) =>
          //         student.firstName == history.student!['firstName'] &&
          //         student.lastName == history.student!['lastName']);
          //     dbService.updateStudent(student.copyWith(lockerNumber: 0));
          //   }
          // }
          return true;
        } else {
          insertLocker(
            history.index!,
            Locker.fromJson(history.locker!),
          );
          return true;
        }

      case "update":
        if (history.locker == null) {
          updateStudent(Student.fromJson(history.oldStudent!), historic: false);
          return true;
        } else {
          updateLocker(Locker.fromJson(history.oldLocker!), historic: false);
          return true;
        }

      case "attribution":
        unAttributeLocker(Locker.fromJson(history.locker!),
            Student.fromJson(history.student!),
            historic: false);
        return true;
      case "unattribution":
        Locker locker = getLocker(history.locker!['id']);
        if (locker != Locker.error()) {
          if (locker.isAvailable != false && locker.isInaccessible == false) {
            attributeLocker(Locker.fromJson(history.locker!),
                Student.fromJson(history.student!),
                historic: false);
            return true;
          }
        } else {
          return false;
        }
    }
    return false;
  }

  Future<String?> importLockersWithCSV(FilePickerResult? result) async {
    try {
      if (result != null) {
        final file = result.files.first;
        final fileContent = utf8.decode(file.bytes!);
        final rows = fileContent.split('\n');
        final indexes = rows[0].split(';');

        indexes[indexes.length - 1] = indexes[indexes.length - 1]
            .substring(0, indexes[indexes.length - 1].length - 1);

        rows.removeAt(0);
        rows.removeLast();
        for (String row in rows) {
          final rowTable = row.split(';');
          Map<String, dynamic> jsonRow = {};
          for (int i = 0; i < indexes.length; i++) {
            jsonRow.addAll({indexes[i]: rowTable[i]});
          }

          if (jsonRow["Responsable"] == "JHI" ||
              jsonRow["Responsable"] == null) {
            final lockerExists = _lockerItems
                .where((locker) =>
                    int.parse(jsonRow['No Casier']) == locker.lockerNumber)
                .isEmpty;
            if (lockerExists) {
              final locker = Locker.fromCSV(jsonRow);
              // await addLocker(locker);
              if ((jsonRow['Nom'] != '' && jsonRow['Nom'] != null) &&
                  (jsonRow['Prénom'] != '' && jsonRow['Prénom'] != null)) {
                List<Student> studentInList = filterStudentsBy([
                  ["firstName"],
                  ["lastName"]
                ], [
                  [jsonRow['Prénom']],
                  [jsonRow['Nom']]
                ]);

                if (studentInList.isEmpty) {
                  var metier = (jsonRow['Métier'] as String).substring(0, 3);
                  final annee = (jsonRow['Métier'] as String).substring(4);
                  if (metier == "ICT" || metier == "ICH") {
                    metier =
                        "Informaticien-ne CFC dès ${int.parse(annee) >= 2021 ? 2021 : 2014}";
                  } else if (metier == "OIC") {
                    metier = "Opérateur-trice en informatique CFC";
                  }
                  final year = DateTime.now().year - int.parse(annee);
                  var caution = 0;
                  if (jsonRow['Caution'] != "") {
                    caution = int.parse(jsonRow['Caution']);
                  }
                  await addStudent(Student.base().copyWith(
                      firstName: jsonRow['Prénom'],
                      lastName: jsonRow['Nom'],
                      job: metier,
                      year: year,
                      caution: caution));

                  notifyListeners();

                  studentInList = filterStudentsBy([
                    ["firstName"],
                    ["lastName"]
                  ], [
                    [jsonRow['Prénom']],
                    [jsonRow['Nom']]
                  ]);

                  await addLocker(locker);
                  final newLocker = _lockerItems
                      .where((element) =>
                          element.lockerNumber == locker.lockerNumber)
                      .first;
                  final student = studentInList.first;
                  attributeLocker(newLocker, student);
                } else {
                  await addLocker(locker);
                  final newLocker = _lockerItems
                      .where((element) =>
                          element.lockerNumber == locker.lockerNumber)
                      .first;
                  final student = studentInList.first;
                  attributeLocker(newLocker, student);
                }
              } else {
                await addLocker(locker);
              }
            }
          }
        }
      } else {
        throw Exception('Fichier non trouvé');
      }
    } catch (e) {
      if (e.toString() ==
          "Expected a value of type 'String', but got one of type 'Null'") {
        return 'Vérifier le nom des colonnes. Colonnes obligatoires : "Nb clé", "No Casier", "Etage", "Métier" et "N° serrure"';
      } else if (e.toString() ==
          'Exception: Chaque casier doit contenir une valeur pour "Nb clé", "No Casier" et "N° serrure"') {
        return 'Chaque casier doit contenir une valeur pour "Nb clé", "No Casier" et "N° serrure"';
      } else if (e.toString().startsWith("FormatException:")) {
        return "verifier que le ficheir soit un csv et qu'il soit codé en utf-8";
      } else if (e.toString() == "Exception: Fichier non trouvé") {
        return null;
      }
      final exceptionString = e.toString();
      return exceptionString;
    }
    return null;
  }

  Future<String?> importStudentsWithCSV(FilePickerResult? result) async {
    try {
      if (result != null) {
        final file = result.files.first;
        final fileContent = utf8.decode(file.bytes!);
        final rows = fileContent.split('\n');
        final indexes = rows[0].split(';');

        indexes[indexes.length - 1] = indexes[indexes.length - 1]
            .substring(0, indexes[indexes.length - 1].length - 1);

        rows.removeAt(0);
        rows.removeLast();
        for (String row in rows) {
          final rowTable = row.split(';');
          Map<String, dynamic> jsonRow = {};
          for (int i = 0; i < indexes.length; i++) {
            jsonRow.addAll({indexes[i]: rowTable[i]});
          }
          final students = _studentItems.where((student) =>
              jsonRow['Nom'] == student.lastName &&
              jsonRow['Prénom'] == student.firstName);
          if (students.isEmpty) {
            addStudent(Student.fromCSV(jsonRow));
          } else {
            final student = students.first;
            updateStudent(Student.fromCSV(jsonRow).copyWith(
                id: student.id,
                caution: student.caution,
                lockerNumber: student.lockerNumber));
          }
        }
      } else {
        throw Exception('Fichier non trouvé');
      }
    } catch (e) {
      if (e.toString() ==
          "Expected a value of type 'String', but got one of type 'Null'") {
        return 'verifier le nom des colonnes. Colonnes obligatoires : "Prénom", "Nom", "Formation" et "Maître Classe"';
      } else if (e.toString().startsWith("FormatException:")) {
        return "verifier que le ficheir soit un csv et qu'il soit codé en utf-8";
      } else if (e.toString() == "Exception: Fichier non trouvé") {
        return null;
      }
      final exceptionString = e.toString();
      return exceptionString;
    }
    return null;
  }

  Future<String> importAllWithXLSX(FilePickerResult? result) async {
    bool importOnlyStudents = false;
    if (result != null) {
      var bytes = result.files.single.bytes;
      var excel = Excel.decodeBytes(bytes!);

      if (excel.tables.keys.contains("Total")) {
        excel.delete("Total");
      }

      for (var table in excel.tables.keys) {
        // Cela permet de vérifier si l'on importe uniquement des élèves ou pas
        excel.tables[table]!.rows[0].forEach((element) {
          if (element != null) {
            if (element.value.toString().trim() == "Login") {
              importOnlyStudents = true;
            }
          }
        });

        for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
          List<Data?> data = excel.tables[table]!.rows[i];

          if (importOnlyStudents) {
            await addStudent(
              Student.base().copyWith(
                firstName: data[_getIndexXLSX(excel.tables[table]!, "Prénom")]!
                    .value
                    .toString(),
                lastName: data[_getIndexXLSX(excel.tables[table]!, "Nom")]!
                    .value
                    .toString(),
                login: data[_getIndexXLSX(excel.tables[table]!, "Login")]!
                    .value
                    .toString(),
                job: data[_getIndexXLSX(excel.tables[table]!, "Formation")]!
                    .value
                    .toString(),
                responsable:
                    data[_getIndexXLSX(excel.tables[table]!, "Maître Classe")]!
                        .value
                        .toString(),
                year: data[_getIndexXLSX(excel.tables[table]!, "Année")]!.value,
                classe: data[_getIndexXLSX(excel.tables[table]!, "Classe")]!
                    .value
                    .toString(),
              ),
            );
          } else {
            if (data[_getIndexXLSX(excel.tables[table]!, "Etage")] != null &&
                data[_getIndexXLSX(excel.tables[table]!, "No Casier")] !=
                    null &&
                data[_getIndexXLSX(excel.tables[table]!, "Responsable")] !=
                    null &&
                data[_getIndexXLSX(excel.tables[table]!, "Nb clé")] != null &&
                data[_getIndexXLSX(excel.tables[table]!, "N° serrure")] !=
                    null) {
              if (data[_getIndexXLSX(excel.tables[table]!, "Responsable")]!
                      .value
                      .toString() ==
                  "JHI") {
                // Récupération de l'élève du casier
                Student student = Student.base();
                if (data[_getIndexXLSX(excel.tables[table]!, "Nom")] != null &&
                    data[_getIndexXLSX(excel.tables[table]!, "Prénom")] !=
                        null) {
                  student = await studentItems.firstWhere(
                    (element) =>
                        element.firstName ==
                            data[_getIndexXLSX(excel.tables[table]!, "Prénom")]!
                                .value
                                .toString() &&
                        element.lastName ==
                            data[_getIndexXLSX(excel.tables[table]!, "Nom")]!
                                .value
                                .toString(),
                  );
                }

                await addLocker(
                  Locker.base().copyWith(
                    lockerNumber: int.parse(
                        data[_getIndexXLSX(excel.tables[table]!, "No Casier")]!
                            .value
                            .toString()),
                    lockNumber: int.parse(
                        data[_getIndexXLSX(excel.tables[table]!, "N° serrure")]!
                            .value
                            .toString()),
                    floor: data[_getIndexXLSX(excel.tables[table]!, "Etage")]!
                        .value
                        .toString(),
                    idEleve: student.id ?? "",
                    job: data[_getIndexXLSX(excel.tables[table]!, "Métier")] ==
                            null
                        ? ""
                        : data[_getIndexXLSX(excel.tables[table]!, "Métier")]!
                            .value
                            .toString(),
                    nbKey: int.parse(
                        data[_getIndexXLSX(excel.tables[table]!, "Nb clé")]!
                            .value
                            .toString()),
                  ),
                );
              }
            }
          }
        }
      }
    }

    return '';
  }

  int _getIndexXLSX(Sheet sheet, String item) {
    int colIndex = 0;

    sheet.rows[0].forEach((element) {
      if (element != null) {
        if (element.value.toString() == item) {
          colIndex = element.colIndex;
        }
      }
    });

    return colIndex;
  }

  Future<String?> importAllWithCSV(FilePickerResult? result) async {
    try {
      if (result != null) {
        final file = result.files.first;
        final fileContent = utf8.decode(file.bytes!);
        final rows = fileContent.split('\n');

        final indexes = rows[0].split(';');

        indexes[indexes.length - 1] = indexes[indexes.length - 1]
            .substring(0, indexes[indexes.length - 1].length - 1);

        rows.removeAt(0);
        rows.removeLast();
        for (String row in rows) {
          final rowTable = row.split(';');
          Map<String, dynamic> jsonRow = {};
          for (int i = 0; i < indexes.length; i++) {
            jsonRow.addAll({indexes[i]: rowTable[i]});
          }
          if (jsonRow["Nb clé"] != null &&
              jsonRow["No Casier"] != null &&
              jsonRow["Etage"] != null &&
              // jsonRow["Métier"] != null &&
              jsonRow["N° serrure"] != null &&
              jsonRow["Nb clé"] != "" &&
              jsonRow["No Casier"] != "" &&
              jsonRow["Etage"] != "" &&
              // jsonRow["Métier"] != "" &&
              jsonRow["N° serrure"] != "") {
            if (jsonRow["Responsable"] == "JHI" ||
                jsonRow["Responsable"] == null) {
              final lockerExists = _lockerItems
                  .where((locker) =>
                      int.parse(jsonRow['No Casier']) == locker.lockerNumber)
                  .isEmpty;
              if (lockerExists) {
                final locker = Locker.fromCSV(jsonRow);
                // await addLocker(locker);
                if ((jsonRow['Nom'] != '' && jsonRow['Nom'] != null) &&
                    (jsonRow['Prénom'] != '' && jsonRow['Prénom'] != null)) {
                  List<Student> studentInList = filterStudentsBy([
                    ["firstName"],
                    ["lastName"]
                  ], [
                    [jsonRow['Prénom']],
                    [jsonRow['Nom']]
                  ]);

                  if (studentInList.isEmpty) {
                    var metier = (jsonRow['Métier'] as String).substring(0, 3);
                    final annee = (jsonRow['Métier'] as String).substring(4);
                    if (metier == "ICT" || metier == "ICH") {
                      metier =
                          "Informaticien-ne CFC dès ${int.parse(annee) >= 2021 ? 2021 : 2014}";
                    } else if (metier == "OIC") {
                      metier = "Opérateur-trice en informatique CFC";
                    }
                    final year = DateTime.now().year - int.parse(annee);
                    var caution = 0;
                    if (jsonRow['Caution'] != "") {
                      caution = int.parse(jsonRow['Caution']);
                    }
                    await addStudent(Student.base().copyWith(
                        firstName: jsonRow['Prénom'],
                        lastName: jsonRow['Nom'],
                        job: metier,
                        year: year,
                        responsable: jsonRow['Responsable'],
                        caution: caution));

                    notifyListeners();

                    studentInList = filterStudentsBy([
                      ["firstName"],
                      ["lastName"]
                    ], [
                      [jsonRow['Prénom']],
                      [jsonRow['Nom']]
                    ]);

                    await addLocker(locker);
                    final newLocker = _lockerItems
                        .where((element) =>
                            element.lockerNumber == locker.lockerNumber)
                        .first;
                    final student = studentInList.first;
                    attributeLocker(newLocker, student);
                  } else {
                    await addLocker(locker);
                    final newLocker = _lockerItems
                        .where((element) =>
                            element.lockerNumber == locker.lockerNumber)
                        .first;
                    final student = studentInList.first;
                    attributeLocker(newLocker, student);
                  }
                } else {
                  await addLocker(locker);
                }
              }
            }
          }
          if (jsonRow["Prénom"] != null &&
              jsonRow["Nom"] != null &&
              jsonRow["Formation"] != null &&
              jsonRow["Maître Classe"] != null &&
              jsonRow["Prénom"] != "" &&
              jsonRow["Nom"] != "" &&
              jsonRow["Formation"] != "" &&
              jsonRow["Maître Classe"] != "") {
            final students = _studentItems.where((student) =>
                jsonRow['Nom'] == student.lastName &&
                jsonRow['Prénom'] == student.firstName);
            if (students.isEmpty) {
              addStudent(Student.fromCSV(jsonRow));
            } else {
              final student = students.first;
              updateStudent(Student.fromCSV(jsonRow).copyWith(
                  id: student.id,
                  caution: student.caution,
                  lockerNumber: student.lockerNumber));
            }
          }
        }
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }
}
