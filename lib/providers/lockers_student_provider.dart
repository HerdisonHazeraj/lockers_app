import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
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
  late HistoryProvider histories = HistoryProvider(dbService);

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
    _lockerItems.clear();
    final data = await dbService.getAllLockers();
    _lockerItems.addAll(data);
    notifyListeners();
  }

  Future<void> addLocker(Locker locker) async {
    final data = await dbService.addLocker(locker);
    _lockerItems.add(data);
    histories.addHistory(History(
      date: DateTime.now().toString(),
      action: "add",
      lockerNumber: locker.lockerNumber.toString(),
    ));
    notifyListeners();
  }

  Future<void> updateLocker(Locker updatedLocker) async {
    final lockerIndex = findIndexOfLockerById(updatedLocker.id!);
    if (lockerIndex >= 0) {
      final newLocker = await dbService.updateLocker(updatedLocker);
      _lockerItems[lockerIndex] = newLocker;
      histories.addHistory(History(
        date: DateTime.now().toString(),
        action: "update",
        lockerNumber: updatedLocker.lockerNumber.toString(),
      ));
      notifyListeners();
    }
  }

  Future<void> deleteLocker(String id) async {
    await dbService.deleteLocker(id);
    Locker item = _lockerItems.firstWhere((locker) => locker.id == id);
    _lockerItems.remove(item);
    histories.addHistory(History(
      date: DateTime.now().toString(),
      action: "delete",
      lockerNumber: getLocker(id).lockerNumber.toString(),
    ));
    notifyListeners();
  }

  Future<void> insertLocker(int index, Locker locker) async {
    await dbService.updateLocker(locker);
    _lockerItems.insert(index, locker);
    notifyListeners();
  }

  Locker getLocker(String id) {
    final lockerIndex = lockerItems.indexWhere((locker) => locker.id == id);
    return _lockerItems[lockerIndex];
  }

  Locker getLockerByLockerNumber(int lockerNumber) {
    final lockerIndex =
        lockerItems.indexWhere((locker) => locker.lockerNumber == lockerNumber);
    return _lockerItems[lockerIndex];
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
    _studentItems.clear();
    final data = await dbService.getAllStudents();
    _studentItems.addAll(data);
    notifyListeners();
  }

  Future<void> addStudent(Student student) async {
    final data = await dbService.addStudent(student);
    _studentItems.add(data);
    histories.addHistory(History(
        date: DateTime.now().toString(),
        action: "add",
        studentName: "${student.firstName} ${student.lastName}"));
    notifyListeners();
  }

  Future<void> updateStudent(Student updatedStudent) async {
    final studentIndex = findIndexOfStudentById(updatedStudent.id!);
    if (studentIndex >= 0) {
      final newStudent = await dbService.updateStudent(updatedStudent);
      _studentItems[studentIndex] = newStudent;
      histories.addHistory(History(
          date: DateTime.now().toString(),
          action: "update",
          studentName:
              "${updatedStudent.firstName} ${updatedStudent.lastName}"));
      notifyListeners();
    }
  }

  Future<void> deleteStudent(String id) async {
    await dbService.deleteStudent(id);
    _studentItems.removeWhere((student) => student.id == id);
    histories.addHistory(History(
        date: DateTime.now().toString(),
        action: "delete",
        studentName: "${getStudent(id).firstName} ${getStudent(id).lastName}"));
    notifyListeners();
  }

  Future<void> insertStudent(int index, Student student) async {
    await dbService.updateStudent(student);
    _studentItems.insert(index, student);
    notifyListeners();
  }

  Student getStudent(String id) {
    if (id == "") return Student.base();

    final studentIndex = findIndexOfStudentById(id);
    return _studentItems[studentIndex];
  }

  Student getStudentByLocker(Locker locker) {
    if (locker.isNull) return Student.base();
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

  List<Student> getArchivedStudent() {
    List<Student> availableItem =
        studentItems.where((element) => element.year == -1).toList();
    return availableItem;
  }

  List<Student> getNotArchivedStudent() {
    List<Student> availableItem =
        studentItems.where((element) => element.year != -1).toList();
    return availableItem;
  }

  int findIndexOfStudentById(String id) {
    final studentIndex =
        getNotArchivedStudent().indexWhere((student) => student.id == id);
    return studentIndex;
  }

  Future<void> attributeLocker(Locker locker, Student student) async {
    await updateLocker(
      locker.copyWith(
        isAvailable: false,
        idEleve: student.id,
      ),
    );

    await updateStudent(
      student.copyWith(
        lockerNumber: locker.lockerNumber,
      ),
    );
  }

  Future<void> unAttributeLocker(Locker locker, Student student) async {
    await updateLocker(
      locker.copyWith(
        isAvailable: true,
        idEleve: "",
      ),
    );

    await updateStudent(
      student.copyWith(
        lockerNumber: 0,
      ),
    );
  }

  void autoAttributeLocker(List<Student> students) {
    final lockers = getAvailableLockers();
    lockers.sort(
      (a, b) => index[a.floor.toLowerCase()]!
          .compareTo(index[b.floor.toLowerCase()]!),
    );
    for (var i = 0; i < students.length; i++) {
      if (i >= lockers.length) {
        break;
      }
      attributeLocker(lockers[i], students[i]);
    }
  }

  Future<void> autoAttributeOneLocker(Student student) async {
    final lockers = getAvailableLockers();
    Locker firstLocker = lockers.firstWhere((element) =>
        element.floor == "d" ||
        element.floor == "c" ||
        element.floor == "b" ||
        element.floor == "e");
    await attributeLocker(firstLocker, student);
  }

  Map<String, List<Locker>> mapLockerByFloor() {
    Map<String, List<Locker>> map = {};
    map["d"] = getAccessibleLocker()
        .where((element) => element.floor.toLowerCase() == "d")
        .toList();
    map["c"] = getAccessibleLocker()
        .where((element) => element.floor.toLowerCase() == "c")
        .toList();
    map["b"] = getAccessibleLocker()
        .where((element) => element.floor.toLowerCase() == "b")
        .toList();
    map["e"] = getAccessibleLocker()
        .where((element) => element.floor.toLowerCase() == "e")
        .toList();
    return map;
  }

  List<Student> getPaidCaution() {
    List<Student> students = getNotArchivedStudent()
        .where((element) => element.caution == 20)
        .toList();
    return students;
  }

  List<Student> getNonPaidCaution() {
    List<Student> students = getNotArchivedStudent()
        .where((element) => element.caution == 0)
        .toList();
    return students;
  }

  List<Locker> getLockerLessThen2Key() {
    List<Locker> lockers =
        lockerItems.where((element) => element.nbKey < 2).toList();
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

  List<Locker> getDefectiveLockers() {
    List<Locker> lockers = getAccessibleLocker()
        .where((element) => element.isDefective == true)
        .toList();
    return lockers;
  }

  List<Locker> getInaccessibleLocker() {
    List<Locker> lockers =
        lockerItems.where((element) => element.isInaccessible == true).toList();
    return lockers;
  }

  List<Locker> getAccessibleLocker() {
    List<Locker> lockers = lockerItems
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

  Future<void> setLockerToDefective(Locker locker) async {
    await updateLocker(
      locker.copyWith(
        isDefective: true,
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
      ),
    );
  }

  Future<void> unSetLockerToAccessible(Locker locker) async {
    await updateLocker(
      locker.copyWith(
        isInaccessible: false,
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
    if (key.isNotEmpty && value.isDefinedAndNotNull) {
      if (value) {
        sortedLocker.sort((a, b) => int.tryParse(a.toJson()[key].toString())
                .isNull
            ? a.toJson()[key].toString().compareTo(b.toJson()[key].toString())
            : int.parse(a.toJson()[key].toString())
                .compareTo(int.parse(b.toJson()[key].toString())));
      } else {
        sortedLocker.sort((a, b) => int.tryParse(a.toJson()[key].toString())
                .isNull
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
    if (key.isNotEmpty && value.isDefinedAndNotNull) {
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

  List<Student> searchStudents(value) {
    List<Student> filtredStudent = [];
    List<Student> students = [];
    if (value != "") {
      students = _studentItems;
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

  List<Locker> searchLockers(value) {
    List<Locker> filtredLocker = [];
    List<Locker> lockers = [];
    if (value != "") {
      lockers = _lockerItems;
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
                    metier = "Informaticien-ne CFC dès ${annee}";
                  } else if (metier == "OIC") {
                    metier == "Opérateur-trice CFC dès ${annee}";
                  }
                  final year = DateTime.now().year - int.parse(annee);
                  await addStudent(Student.base().copyWith(
                      firstName: jsonRow['Prénom'],
                      lastName: jsonRow['Nom'],
                      job: metier,
                      year: year));

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
          final studentExists = _studentItems
              .where((student) =>
                  jsonRow['Nom'] == student.lastName &&
                  jsonRow['Prénom'] == student.firstName)
              .isEmpty;
          if (studentExists) {
            addStudent(Student.fromCSV(jsonRow));
          }
        }
      } else {
        throw Exception('Fichier non trouvé');
      }
    } catch (e) {
      if (e.toString() ==
          "Expected a value of type 'String', but got one of type 'Null'") {
        return 'verifier le nom des colones. Colones obligatoires : "Prénom", "Nom", "Formation" et "Maître Classe"';
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
}
