// import 'dart:js_interop';

import 'package:lockers_app/models/IHistory.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/models/student.dart';

class History extends IHistory {
  final String? id;
  final String action;
  final String date;
  final Map<String, dynamic>? locker;
  final Map<String, dynamic>? student;
  final Map<String, dynamic>? oldLocker;
  final Map<String, dynamic>? oldStudent;
  final int? index;
  // final int lockerNumber;

  History({
    this.id,
    required this.date,
    required this.action,
    this.oldLocker,
    this.oldStudent,
    this.locker,
    this.student,
    this.index,
    // required this.lockerNumber,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
        id: json["id"],
        date: json['date'],
        action: json['action'],
        locker: json['locker'],
        student: json['student'],
        oldLocker: json['oldLocker'],
        oldStudent: json['oldStudent'],
        index: json['index']
        // lockerNumber: json['lockerNumber'],
        );
  }

  String getAction() {
    switch (action) {
      case "add":
        return "ajouté";
      case "update":
        return "modifié";
      case "delete":
        return "supprimé";
      case "attribution":
        return "attribué";
      case "unattribution":
        return "désattribué";
      default:
        return "";
    }
  }

  String getSentence() {
    switch (action) {
      case "attribution":
        return "L'élève ${student!["firstName"]} ${student!["lastName"]} à bien été ${getAction()} au casier n°${locker!["lockerNumber"]}";
      case "unattribution":
        return "L'élève ${student!["firstName"]} ${student!["lastName"]} a bien été ${getAction()} du casier n°${locker!["lockerNumber"]}";
      case "update":
      default:
        switch (locker == null) {
          case true:
            return "L'élève ${student!["firstName"]} ${student!["lastName"]} à été ${getAction()}";
          case false:
            return "Le casier n°${locker!["lockerNumber"]} à été ${getAction()}";
        }
    }
  }

  String getUpdateSentence() {
// if(locker==null){
//   switch(student){
//     case
//   }
// }else{

// }

    switch (action) {
      case "attribution" || "unattribution":
        return "L'élève ${student!["firstName"]} ${student!["lastName"]} à bien été ${getAction()} au casier n°${locker!["lockerNumber"]}";
      case "update":
      default:
        switch (locker == null) {
          case true:
            return "L'élève ${student!["firstName"]} ${student!["lastName"]} à été ${getAction()}";
          case false:
            return "Le casier n°${locker!["lockerNumber"]} à été ${getAction()}";
        }
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toString(),
        'action': action,
        'locker': locker,
        'student': student,
        'oldLocker': oldLocker,
        'oldStudent': oldStudent,
        'index': index,
        // 'lockerNumber': lockerNumber,
      };

  factory History.base() {
    return History(
      date: "", action: "",
      // lockerNumber: 0,
    );
  }

  factory History.error() {
    return History(
      date: "", action: "Erreur",
      // lockerNumber: -1,
    );
  }

  History copyWith({
    String? id,
    String? title,
    String? date,
    String? action,
    Map<String, dynamic>? locker,
    Map<String, dynamic>? student,
    Map<String, dynamic>? oldLocker,
    Map<String, dynamic>? oldStudent,
    int? index,
    // int? lockerNumber,
  }) {
    return History(
      id: id ?? this.id,
      date: date ?? this.date,
      action: action ?? this.action,
      locker: locker ?? this.locker,
      student: student ?? this.student,
      oldLocker: oldLocker ?? this.oldLocker,
      oldStudent: oldStudent ?? this.oldStudent,
      index: index ?? this.index,
      // lockerNumber: lockerNumber ?? this.lockerNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is History &&
        id == other.id &&
        date == other.date &&
        action == other.action &&
        locker == other.locker &&
        student == other.student &&
        oldLocker == other.oldLocker &&
        oldStudent == other.oldStudent &&
        index == other.index;
    // lockerNumber == other.lockerNumber;
  }
}
