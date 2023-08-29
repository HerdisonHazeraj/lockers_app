import 'package:lockers_app/models/IStudent.dart';

class Student extends IStudent {
  final String? id;
  final String firstName;
  final String lastName;
  final String job;
  final String responsable;
  final int caution;
  final int lockerNumber;
  final String login;
  final String classe;
  final int year;
  bool? isArchived;

  Student({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.job,
    required this.responsable,
    required this.caution,
    required this.lockerNumber,
    required this.login,
    required this.classe,
    required this.year,
    this.isArchived = false,
  });

  factory Student.fromCSV(Map<String, dynamic> csv) {
    return Student(
      firstName: csv['Prénom'],
      lastName: csv['Nom'],
      job: csv['Formation'],
      responsable: csv['Maître Classe'],
      caution: 0,
      lockerNumber: 0,
      login: csv['Login'],
      classe: csv['Classe'],
      year: int.parse(csv['Année']),
    );
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json["id"],
      firstName: json['firstName'],
      lastName: json['lastName'],
      job: json['job'],
      responsable: json['manager'],
      caution: json['caution'],
      lockerNumber: json['lockerNumber'],
      login: json['login'],
      classe: json['classe'],
      year: json['year'],
      isArchived: json['isArchived'],
    );
  }

  // String getJob() {
  //   switch (job) {
  //     case String a when a.contains("Informaticien-ne CFC dès 2021"):
  //       return "ICT";
  //     case String a when a.contains("Informaticien-ne CFC dès 2014"):
  //       return "ICH";
  //     case String a when a.contains("Opérateur-trice"):
  //       return "OIC";

  //     default:
  //       return "";
  //   }
  // }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'job': job,
        'manager': responsable,
        'caution': caution,
        'lockerNumber': lockerNumber,
        'login': login,
        'classe': classe,
        'year': year,
        'isArchived': isArchived,
      };

  factory Student.base() {
    return Student(
      firstName: "",
      lastName: "",
      job: "",
      responsable: "",
      caution: 0,
      lockerNumber: 0,
      login: "",
      classe: "",
      year: 0,
    );
  }

  factory Student.error() {
    return Student(
      firstName: "Erreur",
      lastName: "Erreur",
      job: "Erreur",
      responsable: "Erreur",
      caution: 0,
      lockerNumber: -1,
      login: "Erreur",
      classe: "Erreur",
      year: -1,
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
    String? login,
    String? classe,
    int? year,
    bool? isArchived,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      job: job ?? this.job,
      responsable: manager ?? this.responsable,
      caution: caution ?? this.caution,
      lockerNumber: lockerNumber ?? this.lockerNumber,
      login: login ?? this.login,
      classe: classe ?? this.classe,
      year: year ?? this.year,
      isArchived: isArchived ?? this.isArchived,
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
        responsable == other.responsable &&
        caution == other.caution &&
        login == other.login &&
        classe == other.classe &&
        year == other.year &&
        isArchived == other.isArchived;
  }
}
