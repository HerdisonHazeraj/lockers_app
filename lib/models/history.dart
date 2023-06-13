import 'package:lockers_app/models/IHistory.dart';

class History extends IHistory {
  final String? id;
  final String title;
  final String action;
  final String date;
  // final int lockerNumber;

  History({
    this.id,
    required this.title,
    required this.date,
    required this.action,
    // required this.lockerNumber,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      title: json['title'],
      date: json['date'],
      action: json['action'],
      // lockerNumber: json['lockerNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date.toString(),
        'action': action,
        // 'lockerNumber': lockerNumber,
      };

  factory History.base() {
    return History(
      title: "", date: "", action: "",
      // lockerNumber: 0,
    );
  }

  factory History.error() {
    return History(
      title: "Erreur", date: "", action: "Erreur",
      // lockerNumber: -1,
    );
  }

  History copyWith({
    String? id,
    String? title,
    String? date,
    String? action,
    // int? lockerNumber,
  }) {
    return History(
        id: id ?? this.id,
        title: title ?? this.title,
        date: date ?? this.date,
        action: action ?? this.action
        // lockerNumber: lockerNumber ?? this.lockerNumber,
        );
  }

  @override
  bool operator ==(Object other) {
    return other is History &&
        id == other.id &&
        title == other.title &&
        date == other.date &&
        action == other.action;
    // lockerNumber == other.lockerNumber;
  }
}
