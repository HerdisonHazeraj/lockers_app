import 'package:lockers_app/models/IStudent.dart';

class Student extends IStudent {
  final String? id;
  final String firstName;
  final String lastName;
  final String job;
  final String manager;
  final int caution;
  final int lockerNumber;

  Student(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.job,
      required this.manager,
      required this.caution,
      required this.lockerNumber});

  factory Student.fromCSV(Map<String, dynamic> csv) {
    return Student(
      firstName: csv['Prénom'],
      lastName: csv['Nom'],
      job: csv['Formation'] + csv['Année'],
      manager: csv['Maître Classe'],
      caution: 0,
      lockerNumber: 0,
      //csv['Titre']
      //csv['_EnvoiMail]
    );
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        firstName: json['firstName'],
        lastName: json['lastName'],
        job: json['job'],
        manager: json['manager'],
        caution: json['caution'],
        lockerNumber: json['lockerNumber']);
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'job': job,
        'manager': manager,
        'caution': caution,
        'lockerNumber': lockerNumber,
      };

  factory Student.base() {
    return Student(
      firstName: "",
      lastName: "",
      job: "",
      manager: "",
      caution: 0,
      lockerNumber: 0,
    );
  }

  factory Student.error() {
    return Student(
      firstName: "Erreur",
      lastName: "Erreur",
      job: "Erreur",
      manager: "Erreur",
      caution: 0,
      lockerNumber: -1,
    );
  }

  Student copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? job,
    String? manager,
    int? caution,
    int? lockerNumber,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      job: job ?? this.job,
      manager: manager ?? this.manager,
      caution: caution ?? this.caution,
      lockerNumber: lockerNumber ?? this.lockerNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Student &&
        id == other.id &&
        firstName == other.firstName &&
        lockerNumber == other.lockerNumber &&
        lastName == other.lastName &&
        job == other.job &&
        manager == other.manager &&
        caution == other.caution;
  }
}
