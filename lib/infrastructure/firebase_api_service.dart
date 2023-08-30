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

String studentsEndpoint = '/students';
String lockersEndpoint = '/lockers';
String historiesEndpoint = '/histories';
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
      final response =
          await http.get(Uri.parse("$baseUrl$lockersEndpoint.json"));
      final data = json.decode(response.body);
      if (data != null) {
        final lockers = <Locker>[];

        data.forEach((lockerId, lockerData) {
          lockers.add(Locker.fromJson(lockerData).copyWith(id: lockerId));
        });

        return lockers;
      }
    } catch (e) {
      developer.log(e.toString());
    }
    return [];
  }

  @override
  Future<History> addHistory(History history) async {
    var response = await http.post(Uri.parse("$baseUrl$historiesEndpoint.json"),
        body: jsonEncode(history.toJson()));
    if (response.statusCode == 200) {
      return history.copyWith(id: jsonDecode(response.body)['name']);
    } else {
      return History.error();
    }
  }

  @override
  Future<Locker> addLocker(Locker locker) async {
    var response = await http.post(Uri.parse("$baseUrl$lockersEndpoint.json"),
        body: jsonEncode(locker.toJson()));
    if (response.statusCode == 200) {
      return locker.copyWith(id: jsonDecode(response.body)['name']);
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
    var response = await http.post(Uri.parse("$baseUrl$studentsEndpoint.json"),
        body: jsonEncode(student.toJson()));
    if (response.statusCode == 200) {
      return student.copyWith(id: jsonDecode(response.body)['name']);
    } else {
      return Student.error();
    }
  }

  @override
  Future<void> deleteHistory(String id) async {
    http.delete(Uri.parse("$baseUrl$historiesEndpoint.json"));
  }

  @override
  Future<void> deleteLocker(String id) async {
    http.delete(Uri.parse("$baseUrl$lockersEndpoint.json"));
  }

  @override
  Future<void> deleteProblem(String id) {
    // TODO: implement deleteProblem
    throw UnimplementedError();
  }

  @override
  Future<void> deleteStudent(String id) async {
    http.delete(Uri.parse("$baseUrl$studentsEndpoint.json"));
  }

  @override
  Future<List<History>> getAllHistory() async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl$historiesEndpoint.json"));
      final data = json.decode(response.body);
      if (data != null) {
        final histories = <History>[];

        var data = json.decode(response.body);
        data.forEach((lockerId, lockerData) {
          histories.add(History.fromJson(lockerData).copyWith(id: lockerId));
        });

        return histories;
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
      final response =
          await http.get(Uri.parse("$baseUrl$studentsEndpoint.json"));
      final data = json.decode(response.body);
      if (data != null) {
        final students = <Student>[];

        data.forEach((lockerId, lockerData) {
          students.add(Student.fromJson(lockerData).copyWith(id: lockerId));
        });

        return students;
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
    http.patch(
      Uri.parse("$baseUrl$historiesEndpoint/${history.id}.json"),
      body: jsonEncode(
        history.toJson(),
      ),
    );
    return history;
  }

  @override
  Future<Locker> updateLocker(Locker locker) async {
    http.patch(
      Uri.parse("$baseUrl$lockersEndpoint/${locker.id}.json"),
      body: jsonEncode(
        locker.toJson(),
      ),
    );
    return locker;
  }

  @override
  Future<Problem> updateProblem(Problem problem) {
    // TODO: implement updateProblem
    throw UnimplementedError();
  }

  @override
  Future<Student> updateStudent(Student student) async {
    http.patch(
      Uri.parse("$baseUrl$studentsEndpoint/${student.id}.json"),
      body: jsonEncode(
        student.toJson(),
      ),
    );
    return student;
  }
}
