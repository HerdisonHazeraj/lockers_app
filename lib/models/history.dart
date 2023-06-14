import 'package:lockers_app/models/IHistory.dart';

class History extends IHistory {
  final String? id;
  final String action;
  final String date;
  final String? lockerNumber;
  final String? studentName;
  // final int lockerNumber;

  History(
      {this.id,
      required this.date,
      required this.action,
      this.lockerNumber,
      this.studentName
      // required this.lockerNumber,
      });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
        date: json['date'],
        action: json['action'],
        lockerNumber: json['lockerNumber'],
        studentName: json['studentName']
        // lockerNumber: json['lockerNumber'],
        );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toString(),
        'action': action,
        'lockerNumber': lockerNumber,
        'studentName': studentName,
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
    String? lockerNumber,
    String? studentName,
    // int? lockerNumber,
  }) {
    return History(
        id: id ?? this.id,
        date: date ?? this.date,
        action: action ?? this.action,
        lockerNumber: lockerNumber ?? this.lockerNumber,
        studentName: studentName ?? this.studentName
        // lockerNumber: lockerNumber ?? this.lockerNumber,
        );
  }

  @override
  bool operator ==(Object other) {
    return other is History &&
        id == other.id &&
        date == other.date &&
        action == other.action &&
        lockerNumber == other.lockerNumber &&
        studentName == other.studentName;
    // lockerNumber == other.lockerNumber;
  }
}
