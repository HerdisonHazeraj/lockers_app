import 'package:lockers_app/models/history.dart';
import 'package:lockers_app/models/problems.dart';
import 'package:lockers_app/models/student.dart';

import '../models/locker.dart';

abstract class DBService {
  void prepareDataBase();

  Future<Locker> addLocker(Locker locker);
  Future<List<Locker>> getAllLockers();
  Future<Locker> updateLocker(Locker locker);
  Future<void> deleteLocker(String id);

  Future<Student> addStudent(Student student);
  Future<List<Student>> getAllStudents();
  Future<Student> updateStudent(Student student);
  Future<void> deleteStudent(String id);

  Future<Problem> addProblem(Problem problem);
  Future<List<Problem>> getAllProblems();
  Future<Problem> updateProblem(Problem problem);
  Future<void> deleteProblem(String id);

  Future<History> addHistory(History history);
  Future<List<History>> getAllHistory();
  Future<History> updateHistory(History history);
  Future<void> deleteHistory(String id);
}
