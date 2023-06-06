import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
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

  Future<void> fetchAndSetLockers() async {
    _lockerItems.clear();
    final data = await dbService.getAllLockers();
    _lockerItems.addAll(data);
    notifyListeners();
  }

  Future<void> addLocker(Locker locker) async {
    final data = await dbService.addLocker(locker);
    _lockerItems.add(data);
    notifyListeners();
  }

  Future<void> updateLocker(Locker updatedLocker) async {
    final lockerIndex = findIndexOfLockerById(updatedLocker.id!);
    if (lockerIndex >= 0) {
      final newLocker = await dbService.updateLocker(updatedLocker);
      _lockerItems[lockerIndex] = newLocker;
      notifyListeners();
    }
  }

  Future<void> deleteLocker(String id) async {
    await dbService.deleteLocker(id);
    Locker item = _lockerItems.firstWhere((locker) => locker.id == id);

    _lockerItems.remove(item);
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

  List<Locker> getAvailableLockers() {
    List<Locker> availableItem =
        lockerItems.where((element) => element.isAvailable == true).toList();
    return availableItem;
  }

  List<Locker> getUnAvailableLockers() {
    List<Locker> unavailableItem =
        lockerItems.where((element) => element.isAvailable == false).toList();
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
    notifyListeners();
  }

  Future<void> updateStudent(Student updatedStudent) async {
    final studentIndex = findIndexOfStudentById(updatedStudent.id!);
    if (studentIndex >= 0) {
      final newStudent = await dbService.updateStudent(updatedStudent);
      _studentItems[studentIndex] = newStudent;
      notifyListeners();
    }
  }

  Future<void> deleteStudent(String id) async {
    await dbService.deleteStudent(id);
    _studentItems.removeWhere((student) => student.id == id);
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

  List<Student> getAvailableStudents() {
    List<Student> availableItem =
        studentItems.where((element) => element.lockerNumber == 0).toList();
    return availableItem;
  }

  Map<String, List<Student>> getStudentByYear() {
    Map<String, List<Student>> map = {};
    map['1'] = studentItems.where((element) => element.year == 1).toList();
    map['2'] = studentItems.where((element) => element.year == 2).toList();
    map['3'] = studentItems.where((element) => element.year == 3).toList();
    map['4'] = studentItems.where((element) => element.year == 4).toList();
    return map;
  }

  List<Student> getUnavailableStudents() {
    List<Student> unavailableItem =
        studentItems.where((element) => element.lockerNumber != 0).toList();
    return unavailableItem;
  }

  int findIndexOfStudentById(String id) {
    final studentIndex =
        _studentItems.indexWhere((student) => student.id == id);
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
    final _random = Random();
    Map<String, int> index = {
      "d": 1,
      "c": 2,
      "b": 3,
      "e": 4,
      "f": 5,
    };
    final lockers = getAvailableLockers();
    lockers.sort(
      (a, b) => index[a.floor.toLowerCase()]!
          .compareTo(index[b.floor.toLowerCase()]!),
    );
    for (var i = 0; i < students.length; i++) {
      if (i >= lockers.length) {
        break;
      }
      // students.forEach((student) {
      attributeLocker(lockers[i], students[i]);
      // });
    }
  }

  void autoAttributeLockerV2(List<Student> students) {
    final _random = Random();
    final lockersFloorD = getAvailableLockers()
        .where((element) => element.floor.toLowerCase() == "d")
        .toList();
    final lockersFloorC = getAvailableLockers()
        .where((element) => element.floor.toLowerCase() == "c")
        .toList();
    final lockersFloorB = getAvailableLockers()
        .where((element) => element.floor.toLowerCase() == "b")
        .toList();
    final lockersFloorE = getAvailableLockers()
        .where((element) => element.floor.toLowerCase() == "e")
        .toList();
    students.forEach((student) {
      if (lockersFloorD.isNotEmpty) {
        int number = _random.nextInt(lockersFloorD.length);
        attributeLocker(lockersFloorD[number], student);
        lockersFloorD.remove(lockersFloorD[number]);
      } else if (lockersFloorC.isNotEmpty) {
        int number = _random.nextInt(lockersFloorC.length);
        attributeLocker(lockersFloorC[number], student);
        lockersFloorC.remove(lockersFloorC[number]);
      } else if (lockersFloorB.isNotEmpty) {
        int number = _random.nextInt(lockersFloorB.length);
        attributeLocker(lockersFloorB[number], student);
        lockersFloorB.remove(lockersFloorB[number]);
      } else if (lockersFloorE.isNotEmpty) {
        int number = _random.nextInt(lockersFloorE.length);
        attributeLocker(lockersFloorE[number], student);
        lockersFloorE.remove(lockersFloorE[number]);
      }
    });
  }

  List<Locker> getLockerLessThen2Key() {
    List<Locker> lockers =
        lockerItems.where((element) => element.nbKey < 2).toList();
    return lockers;
  }

  List<Locker> getLockerbyFloor(String floor) {
    List<Locker> lockers = lockerItems
        .where((element) => element.floor.toLowerCase() == floor.toLowerCase())
        .toList();
    return lockers;
  }

  List<Locker> getDefectiveLockers() {
    List<Locker> lockers =
        lockerItems.where((element) => element.isDefective == true).toList();
    return lockers;
  }

  List<Locker> getNonDefectiveLockers() {
    List<Locker> lockers =
        lockerItems.where((element) => element.isDefective == true).toList();
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

  List<Student> filterStudentsBy(List<List> key, List<List> value,
      {List<Student> startList = const []}) {
    List<Student> students = [];
    List<Student> filtredStudent = [];
    if (key != [] && value != []) {
      students = getAvailableStudents();
      for (var i = 0; i < key.length; i++) {
        for (var j = 0; j < key[i].length; j++) {
          filtredStudent += students
              .where((element) => element.toJson()[key[i][j]] == value[i][j])
              .toList();
        }
        students = filtredStudent;
      }
      if (filtredStudent.isEmpty) return startList;
      return filtredStudent;
    }
    return [];
  }

  Future<void> promoteStudent(List<Student> students) async {
    students.forEach(
      (element) async {
        if (element.year != 4) {
          await updateStudent(element.copyWith(year: element.year + 1));
        } else {
          await updateStudent(element.copyWith(year: 0));
        }
      },
    );
  }

  List<Student> searchStudents(value) {
    List<Student> filtredStudent = [];
    List<Student> students = [];
    if (value != "") {
      students = _studentItems;
      filtredStudent = students
          .where((element) =>
              element.lastName
                  .toString()
                  .toLowerCase()
                  .contains(value.toString().toLowerCase().trim()) ||
              element.firstName
                  .toString()
                  .toLowerCase()
                  .contains(value.toString().toLowerCase().trim()) ||
              element.login
                  .toString()
                  .toLowerCase()
                  .contains(value.toString().toLowerCase().trim()))
          .toList();
      return filtredStudent;
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
              await addLocker(locker);
              if ((jsonRow['Nom'] != '' && jsonRow['Nom'] != null) &&
                  (jsonRow['Prénom'] != '' && jsonRow['Prénom'] != null)) {
                List<Student> studentInList = filterStudentsBy([
                  ["firstName"],
                  ["lastName"]
                ], [
                  jsonRow['Prénom'],
                  jsonRow['Nom']
                ]);
                final newLocker = _lockerItems
                    .where((element) =>
                        element.lockerNumber == locker.lockerNumber)
                    .first;
                if (studentInList.isEmpty) {
                  deleteLocker(newLocker.id!);
                  throw Exception(
                      "L'élève ${jsonRow['Prénom']} ${jsonRow['Nom']} est introuvable, veuillez vous assurer qu'il existe et qu'il n'ait pas de casier déjà attribué");
                }
                final student = studentInList.first;
                attributeLocker(newLocker, student);
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
