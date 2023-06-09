import 'dart:convert';
import 'dart:developer' as developer;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:lockers_app/models/history.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/models/problems.dart';
import 'package:lockers_app/models/student.dart';
import 'db_service.dart';

class FirebaseRTDBService implements DBService {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  late DatabaseReference _db; //2
  final lockerNode = "lockers";
  final studentNode = 'students';
  final problemNode = 'problems';
  final historyNode = 'histories';
  static final instance = FirebaseRTDBService._();
  FirebaseRTDBService._() {
    db.useDatabaseEmulator("127.0.0.1", 9000);
    _db = db.ref();
  }

  @override
  Future<void> prepareDataBase() async {
    final dataString = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> json = jsonDecode(dataString);
    final Map<String, Map> updatesLockers = {};
    final Map<String, Map> updatesStudent = {};
    final Map<String, Map> updatesHistory = {};

    await json[lockerNode].forEach((v) {
      final newLockerKey = _db.child(lockerNode).push().key;
      updatesLockers['/$lockerNode/$newLockerKey'] = v;
    });
    await json[studentNode].forEach((v) {
      final newStudentKey = _db.child(studentNode).push().key;
      updatesStudent['/$studentNode/$newStudentKey'] = v;
    });
    await json[historyNode].forEach((v) {
      final newHistoryKey = _db.child(studentNode).push().key;
      updatesHistory['/$historyNode/$newHistoryKey'] = v;
    });

    updatesLockers.forEach((lockerKey, lockerValue) {
      updatesStudent.forEach((studentKey, studentValue) {
        if (lockerValue['lockerNumber'] == studentValue['lockerNumber']) {
          lockerValue['idEleve'] = studentKey.substring(10);
          lockerValue['isAvailable'] = false;
        }
      });
    });

    await _db.update(updatesLockers);
    await _db.update(updatesStudent);
  }

  @override
  Future<List<Locker>> getAllLockers() async {
    final snapshot = await _db.child(lockerNode).get();
    if (snapshot.exists) {
      final lockers = <Locker>[];
      for (dynamic v in snapshot.children) {
        final id = v.key.toString();
        final map = v.value as Map<String, dynamic>;
        lockers.add(Locker.fromJson(map).copyWith(id: id));
      }
      return lockers;
    }
    return [];
  }

  @override
  Future<Locker> addLocker(Locker locker) async {
    final id = _db.child(lockerNode).push().key;
    return _db.child('$lockerNode/$id').set(locker.toJson()).then((_) {
      developer.log("OK");
      return locker.copyWith(id: id);
    }).catchError((error) {
      developer.log(error);
      return Locker.base();
    });
  }

  @override
  Future<Locker> updateLocker(Locker locker) async {
    _db.child('$lockerNode/${locker.id}').update(locker.toJson()).then((_) {
      developer.log("OK");
    }).catchError((error) {
      developer.log(error);
    });
    return locker;
  }

  @override
  Future<void> deleteLocker(String id) async {
    return _db.child('$lockerNode/$id').remove();
  }

  @override
  Future<List<Student>> getAllStudents() async {
    final snapshot = await _db.child(studentNode).get();
    if (snapshot.exists) {
      final student = <Student>[];
      for (dynamic v in snapshot.children) {
        final id = v.key.toString();
        final map = v.value as Map<String, dynamic>;
        student.add(Student.fromJson(map).copyWith(id: id));
      }
      return student;
    }
    return [];
  }

  @override
  Future<Student> addStudent(Student student) {
    final id = _db.child(studentNode).push().key;
    return _db.child('$studentNode/$id').set(student.toJson()).then((_) {
      developer.log("OK");
      return student.copyWith(id: id);
    }).catchError((error) {
      developer.log(error);
      return Student.error();
    });
  }

  @override
  Future<Student> updateStudent(Student student) async {
    _db.child('$studentNode/${student.id}').update(student.toJson()).then((_) {
      developer.log("OK");
    }).catchError((error) {
      developer.log(error);
    });
    return student;
  }

  @override
  Future<void> deleteStudent(String id) {
    return _db.child('$studentNode/$id').remove();
  }

  @override
  Future<List<Problem>> getAllProblems() async {
    final snapshot = await _db.child(problemNode).get();
    if (snapshot.exists) {
      final problem = <Problem>[];
      for (dynamic v in snapshot.children) {
        final id = v.key.toString();
        final map = v.value as Map<String, dynamic>;
        problem.add(Problem.fromJson(map).copyWith(id: id));
      }
      return problem;
    }
    return [];
  }

  @override
  Future<Problem> addProblem(Problem problem) {
    final id = _db.child(problemNode).push().key;
    return _db.child('$problemNode/$id').set(problem.toJson()).then((_) {
      developer.log("OK");
      return problem.copyWith(id: id);
    }).catchError((error) {
      developer.log(error);
      return Problem.error();
    });
  }

  @override
  Future<Problem> updateProblem(Problem problem) async {
    _db.child('$problemNode/${problem.id}').update(problem.toJson()).then((_) {
      developer.log("OK");
    }).catchError((error) {
      developer.log(error);
    });
    return problem;
  }

  @override
  Future<void> deleteProblem(String id) {
    return _db.child('$problemNode/$id').remove();
  }

  @override
  Future<void> deleteHistory(String id) {
    return _db.child('$historyNode/$id').remove();
  }

  @override
  Future<List<History>> getAllHistory() async {
    final snapshot = await _db.child(historyNode).get();
    if (snapshot.exists) {
      final history = <History>[];
      for (dynamic v in snapshot.children) {
        final id = v.key.toString();
        final map = v.value as Map<String, dynamic>;
        history.add(History.fromJson(map).copyWith(id: id));
      }
      return history;
    }
    return [];
  }

  @override
  Future<History> updateHistory(History history) async {
    _db.child('$historyNode/${history.id}').update(history.toJson()).then((_) {
      developer.log("OK");
    }).catchError((error) {
      developer.log(error);
    });
    return history;
  }

  @override
  Future<History> addHistory(History history) {
    final id = _db.child(historyNode).push().key;
    return _db.child('$historyNode/$id').set(history.toJson()).then((_) {
      developer.log("OK");
      return history.copyWith(id: id);
    }).catchError((error) {
      developer.log(error);
      return History.error();
    });
  }
}
