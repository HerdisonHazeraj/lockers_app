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

  void autoAttributeLocker(List<Student> students) {
    final _random = Random();
    final lockers = getAvailableLockers();
    students.forEach((student) {
      attributeLocker(lockers[_random.nextInt(lockers.length)], student);
    });
  }

  List<Locker> getLockerLessThen2Key() {
    List<Locker> lockers =
        lockerItems.where((element) => element.nbKey < 2).toList();
    return lockers;
  }

  List<Locker> getDefectiveLockers() {
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

  List<Student> filterStudentsBy(List key, List value) {
    List<Student> filtredStudent = [];
    if (key != [] && value != []) {
      filtredStudent = getAvailableStudents();
      for (var i = 0; i < key.length; i++) {
        filtredStudent = filtredStudent
            .where((element) => element.toJson()[key[i]] == value[i])
            .toList();
      }
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
                List<Student> studentsByFirstName =
                    filterStudentsBy(["firstName"], jsonRow['Prénom']);
                List<Student> studentsByLastName =
                    filterStudentsBy(["lastName"], jsonRow['Nom']);
                Student student = Student.base();
                for (Student s in studentsByFirstName) {
                  student =
                      studentsByLastName.where((element) => element == s).first;
                }
                final newLocker = _lockerItems
                    .where((element) =>
                        element.lockerNumber == locker.lockerNumber)
                    .first;
                if (student == Student.base()) {
                  deleteLocker(newLocker.id!);
                  throw Exception(
                      "L'élève ${jsonRow['Prénom']} ${jsonRow['Nom']} est introuvable, veuillez vous assurer qu'il existe et qu'il n'ait pas de casier déjà attribué");
                }
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
        return 'verifier le nom des colones. Colones obligatoires : "Nb clé", "No Casier", "Etage", "Métier" et "N° serrure"';
      } else if (e.toString() ==
          'Exception: Chaque casier doit contenir une valeur pour "Nb clé", "No Casier" et "N° serrure"') {
        return 'Chaque casier doit contenir une valeur pour "Nb clé", "No Casier" et "N° serrure"';
      } else if (e.toString().startsWith("FormatException:")) {
        return "verifier que le ficheir soit en utf-8";
      } else if (e.toString() == "Exception: Fichier non trouvé") {
        return "vérifier que le fichier ait bien été séléction et que c'est un csv";
      }
      final exceptionString = e.toString().substring(11);
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
        return "verifier que le ficheir soit en utf-8";
      } else if (e.toString() == "Exception: Fichier non trouvé") {
        return "vérifier que le fichier ait bien été séléction et que c'est un csv";
      }
      final exceptionString = e.toString().substring(11);
      return exceptionString;
    }
    return null;
  }
}
