import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:lockers_app/infrastructure/db_service.dart';
import 'package:lockers_app/models/student.dart';

import '../models/locker.dart';

class JsonFileDBService implements DBService {
  static final instance = JsonFileDBService._();
  JsonFileDBService._() {}

  @override
  Future<List<Locker>> getAllLockers() async {
    final dataString = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> json = jsonDecode(dataString);
    if (json['lockers'] != null) {
      final lockers = <Locker>[];
      for (var v in json['lockers']) {
        lockers.add(Locker.fromJson(v));
      }
      return lockers;
    }
    return [];
  }

  @override
  Future<List<Student>> getAllStudents() async {
    final dataString = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> json = jsonDecode(dataString);
    if (json['students'] != null) {
      final students = <Student>[];
      for (var v in json['students']) {
        students.add(Student.fromJson(v));
      }
      return students;
    }
    return [];
  }

  @override
  Future<Locker> addLocker(Locker locker) {
    // TODO: implement addLocker
    throw UnimplementedError();
  }

  @override
  Future<Student> addStudent(Student student) {
    // TODO: implement addStudent
    throw UnimplementedError();
  }

  @override
  Future<Locker> deleteLocker(String id) {
    // TODO: implement deleteLocker
    throw UnimplementedError();
  }

  @override
  Future<Student> deleteStudent(String id) {
    // TODO: implement deleteStudent
    throw UnimplementedError();
  }

  @override
  void prepareDataBase() {
    // TODO: implement prepareDataBase
  }

  @override
  Future<Locker> updateLocker(Locker locker) {
    // TODO: implement updateLocker
    throw UnimplementedError();
  }

  @override
  Future<Student> updateStudent(Student student) {
    // TODO: implement updateStudent
    throw UnimplementedError();
  }
}
