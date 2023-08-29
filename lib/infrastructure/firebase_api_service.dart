import 'dart:convert';
import 'dart:developer' as developer;
import 'package:firedart/firedart.dart';
import 'package:http/http.dart' as http;
import 'package:lockers_app/models/history.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/models/problems.dart';
import 'package:lockers_app/models/student.dart';
import 'db_service.dart';

String baseUrl =
    'https://lockerapp-3b54f-default-rtdb.europe-west1.firebasedatabase.app';
String studentsEndpoint = '/students.json';
String lockersEndpoint = '/lockers.json';
String historiesEndpoint = '/histories.json';
const projectId = "lockerapp-3b54f";

// const apiKey = "AIzaSyAzJgXs2mdisqAxOxWU8Q_32WqqIVOl_H8";

class ApiService implements DBService {
  static final instance = ApiService._();
  ApiService._() {
    Firestore.initialize(projectId);
  }
  @override
  Future<List<Locker>> getAllLockers() async {
    try {
      var url = Uri.parse(baseUrl + lockersEndpoint);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<Locker> _lockers = <Locker>[];

        var data = json.decode(response.body);
        data.forEach((lockerId, lockerData) {
          _lockers.add(Locker.fromJson(lockerData).copyWith(id: lockerId));
        });

        return _lockers;
      }
    } catch (e) {
      developer.log(e.toString());
    }
    return [];
  }

  @override
  Future<History> addHistory(History history) async {
    var response = await http.post(Uri.parse(baseUrl + historiesEndpoint),
        body: jsonEncode(history.toJson()));
    if (response.statusCode == 200) {
      return history;
    } else {
      return History.error();
    }
  }

  @override
  Future<Locker> addLocker(Locker locker) async {
    var response = await http.post(Uri.parse(baseUrl + lockersEndpoint),
        body: jsonEncode(locker.toJson()));
    if (response.statusCode == 200) {
      return locker;
    } else {
      return Locker.error();
    }
  }

  @override
  Future<Problem> addProblem(Problem problem) {
    // TODO: implement addProblem
    throw UnimplementedError();
  }

  @override
  Future<Student> addStudent(Student student) async {
    var response = await http.post(Uri.parse(baseUrl + studentsEndpoint),
        body: jsonEncode(student.toJson()));
    if (response.statusCode == 200) {
      return student;
    } else {
      return Student.error();
    }
  }

  @override
  Future<void> deleteHistory(String id) async {
    final response = await http.delete(Uri.parse(baseUrl + historiesEndpoint));
    developer.log(response.statusCode.toString());
  }

  @override
  Future<void> deleteLocker(String id) async {
    final response = await http.delete(Uri.parse(baseUrl + lockersEndpoint));
    developer.log(response.statusCode.toString());
  }

  @override
  Future<void> deleteProblem(String id) {
    // TODO: implement deleteProblem
    throw UnimplementedError();
  }

  @override
  Future<void> deleteStudent(String id) async {
    final response = await http.delete(Uri.parse(baseUrl + studentsEndpoint));
    developer.log(response.statusCode.toString());
  }

  @override
  Future<List<History>> getAllHistory() async {
    try {
      var url = Uri.parse(baseUrl + historiesEndpoint);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<History> _histories = <History>[];

        var data = json.decode(response.body);
        data.forEach((lockerId, lockerData) {
          _histories.add(History.fromJson(lockerData).copyWith(id: lockerId));
        });

        return _histories;
      }
    } catch (e) {
      developer.log(e.toString());
    }
    return [];
  }

  @override
  Future<List<Problem>> getAllProblems() {
    // TODO: implement getAllProblems
    throw UnimplementedError();
  }

  @override
  Future<List<Student>> getAllStudents() async {
    try {
      var url = Uri.parse(baseUrl + studentsEndpoint);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<Student> _students = <Student>[];

        var data = json.decode(response.body);
        data.forEach((lockerId, lockerData) {
          _students.add(Student.fromJson(lockerData).copyWith(id: lockerId));
        });

        return _students;
      }
    } catch (e) {
      developer.log(e.toString());
    }
    return [];
  }

  @override
  void prepareDataBase() {
    // TODO: implement prepareDataBase
  }

  @override
  Future<History> updateHistory(History history) async {
    final response = await http.patch(
      Uri.parse(baseUrl + historiesEndpoint),
      body: jsonEncode(
        history.toJson(),
      ),
    );
    if (response.statusCode / 100 == 2) {
      return history;
    }
    return History.error();
  }

  @override
  Future<Locker> updateLocker(Locker locker) async {
    final response = await http.patch(
      Uri.parse(baseUrl + lockersEndpoint),
      body: jsonEncode(
        locker.toJson(),
      ),
    );
    if (response.statusCode / 100 == 2) {
      return locker;
    }
    return Locker.error();
  }

  @override
  Future<Problem> updateProblem(Problem problem) {
    // TODO: implement updateProblem
    throw UnimplementedError();
  }

  @override
  Future<Student> updateStudent(Student student) async {
    final response = await http.patch(
      Uri.parse(baseUrl + studentsEndpoint),
      body: jsonEncode(
        student.toJson(),
      ),
    );
    if (response.statusCode / 100 == 2) {
      return student;
    }
    return Student.error();
  }
}
