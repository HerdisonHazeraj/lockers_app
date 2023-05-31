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

  // Future<Student> addProblem(Student student);
  // Future<List<Student>> getAllProblems();
  // Future<Student> updateProblem(Student student);
  // Future<void> deleteProblem(String id);
}
