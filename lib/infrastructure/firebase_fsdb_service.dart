import 'package:firedart/firedart.dart';
import 'package:lockers_app/infrastructure/db_service.dart';
import 'package:lockers_app/models/history.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/models/problems.dart';
import 'package:lockers_app/models/student.dart';

const apiKey = "AIzaSyBxEm-Uue1yUdhOIqvcNHIeebF2ZUCP0kg";
const projectId = "lockerapp-3b54f";

class FirebaseFSDBService implements DBService {
  static final instance = FirebaseFSDBService._();
  FirebaseFSDBService._() {
    Firestore.initialize(projectId);
  }

  @override
  void prepareDataBase() {
    // TODO: implement prepareDataBase
  }

  @override
  Future<List<Locker>> getAllLockers() async {
    final snapshot = await Firestore.instance.collection("lockers").get();

    if (snapshot.isEmpty) {
      return [];
    } else {
      final lockers = <Locker>[];
      for (final v in snapshot) {
        final id = v.id;
        final locker = Locker.fromJson(v.map);
        lockers.add(locker.copyWith(id: id));
      }
      return lockers;
    }
  }

  @override
  Future<History> addHistory(History history) async {
    final snapshot =
        await Firestore.instance.collection("histories").add(history.toJson());
    if (snapshot.id.isEmpty) {
      return History.base();
    } else {
      return history.copyWith(id: snapshot.id);
    }
  }

  @override
  Future<Locker> addLocker(Locker locker) async {
    final snapshot =
        await Firestore.instance.collection("lockers").add(locker.toJson());
    if (snapshot.id.isEmpty) {
      return Locker.base();
    } else {
      return locker.copyWith(id: snapshot.id);
    }
  }

  @override
  Future<Problem> addProblem(Problem problem) async {
    final snapshot =
        await Firestore.instance.collection("problems").add(problem.toJson());
    if (snapshot.id.isEmpty) {
      return Problem.base();
    } else {
      return problem.copyWith(id: snapshot.id);
    }
  }

  @override
  Future<Student> addStudent(Student student) async {
    final snapshot =
        await Firestore.instance.collection("students").add(student.toJson());
    if (snapshot.id.isEmpty) {
      return Student.base();
    } else {
      return student.copyWith(id: snapshot.id);
    }
  }

  @override
  Future<void> deleteHistory(String id) async {
    return await Firestore.instance
        .collection("histories")
        .document(id)
        .delete();
  }

  @override
  Future<void> deleteLocker(String id) async {
    return await Firestore.instance.collection("lockers").document(id).delete();
  }

  @override
  Future<void> deleteProblem(String id) async {
    return await Firestore.instance
        .collection("problems")
        .document(id)
        .delete();
  }

  @override
  Future<void> deleteStudent(String id) async {
    return await Firestore.instance
        .collection("students")
        .document(id)
        .delete();
  }

  @override
  Future<List<History>> getAllHistory() async {
    final snapshot = await Firestore.instance.collection("histories").get();

    if (snapshot.isEmpty) {
      return [];
    } else {
      final histories = <History>[];
      for (final v in snapshot) {
        final id = v.id;
        final history = History.fromJson(v.map);
        histories.add(history.copyWith(id: id));
      }
      return histories;
    }
  }

  @override
  Future<List<Problem>> getAllProblems() async {
    final snapshot = await Firestore.instance.collection("problems").get();

    if (snapshot.isEmpty) {
      return [];
    } else {
      final problems = <Problem>[];
      for (final v in snapshot) {
        final id = v.id;
        final problem = Problem.fromJson(v.map);
        problems.add(problem.copyWith(id: id));
      }
      return problems;
    }
  }

  @override
  Future<List<Student>> getAllStudents() async {
    final snapshot = await Firestore.instance.collection("students").get();
    if (snapshot.isEmpty) {
      return [];
    } else {
      final students = <Student>[];
      for (final v in snapshot) {
        final id = v.id;
        final student = Student.fromJson(v.map);
        students.add(student.copyWith(id: id));
      }
      return students;
    }
  }

  @override
  Future<History> updateHistory(History history) async {
    await Firestore.instance
        .collection("histories")
        .document(history.id.toString())
        .update(history.toJson());

    return history;
  }

  @override
  Future<Locker> updateLocker(Locker locker) async {
    await Firestore.instance
        .collection("lockers")
        .document(locker.id.toString())
        .update(locker.toJson());

    return locker;
  }

  @override
  Future<Problem> updateProblem(Problem problem) async {
    await Firestore.instance
        .collection("problems")
        .document(problem.id.toString())
        .update(problem.toJson());

    return problem;
  }

  @override
  Future<Student> updateStudent(Student student) async {
    await Firestore.instance
        .collection("students")
        .document(student.id.toString())
        .update(student.toJson());

    return student;
  }
}
