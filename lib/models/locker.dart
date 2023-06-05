import 'package:lockers_app/models/ILocker.dart';

class Locker extends ILocker {
  final String? id;
  final int nbKey;
  final int lockNumber;
  final int lockerNumber;
  final String floor;
  final String? idEleve;
  final String job;
  final String remark;
  bool? isAvailable;
  bool? isDefective;

  Locker(
      {this.id,
      required this.nbKey,
      required this.lockNumber,
      required this.lockerNumber,
      required this.floor,
      this.idEleve,
      required this.job,
      required this.remark,
      this.isAvailable,
      this.isDefective});

  factory Locker.fromCSV(Map<String, dynamic> csv) {
    if (csv['Nb clé'] != "" &&
        csv['No Casier'] != "" &&
        csv["N° serrure"] != "") {
      return Locker(
        nbKey: int.parse(csv['Nb clé']),
        lockerNumber: int.parse(csv['No Casier']),
        floor: csv['Etage'],
        idEleve: '',
        job: csv['Métier'],
        remark: "",
        isAvailable: true,
        lockNumber: int.parse(csv["N° serrure"]),
      );
    } else {
      throw Exception(
          'Chaque casier doit contenir une valeur pour "Nb clé", "No Casier" et "N° serrure"');
    }
  }

  factory Locker.fromJson(Map<String, dynamic> json) {
    return Locker(
        nbKey: json['nbKey'],
        lockNumber: json['lockNumber'],
        lockerNumber: json['lockerNumber'],
        floor: json['floor'],
        idEleve: json['idEleve'],
        job: json['job'],
        remark: json['remark'],
        isAvailable: json['isAvailable'],
        isDefective: json['isDefective']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nbKey': nbKey,
        'lockNumber': lockNumber,
        'lockerNumber': lockerNumber,
        'floor': floor,
        'idEleve': idEleve,
        'job': job,
        'remark': remark,
        'isAvailable': isAvailable,
        'isDefective': isDefective,
      };

  factory Locker.base() {
    return Locker(
      id: "",
      nbKey: 0,
      lockNumber: 0,
      lockerNumber: 0,
      floor: "",
      job: "",
      remark: "",
    );
  }

  factory Locker.error() {
    return Locker(
      id: "Erreur",
      nbKey: 0,
      lockNumber: 0,
      lockerNumber: 0,
      floor: "Erreur",
      job: "Erreur",
      remark: "Erreur",
    );
  }

  Locker copyWith({
    String? id,
    int? nbKey,
    int? lockNumber,
    int? lockerNumber,
    String? floor,
    String? idEleve,
    String? job,
    String? remark,
    bool? isAvailable,
    bool? isDefective,
  }) {
    return Locker(
        id: id ?? this.id,
        nbKey: nbKey ?? this.nbKey,
        lockNumber: lockNumber ?? this.lockNumber,
        lockerNumber: lockerNumber ?? this.lockerNumber,
        floor: floor ?? this.floor,
        idEleve: idEleve ?? this.idEleve,
        job: job ?? this.job,
        remark: remark ?? this.remark,
        isAvailable: isAvailable ?? this.isAvailable,
        isDefective: isDefective ?? this.isDefective);
  }

  @override
  bool operator ==(Object other) {
    return other is Locker &&
        id == other.id &&
        nbKey == other.nbKey &&
        lockNumber == other.lockNumber &&
        lockerNumber == other.lockerNumber &&
        floor == other.floor &&
        idEleve == other.idEleve &&
        job == other.job &&
        remark == other.remark &&
        isAvailable == other.isAvailable &&
        isDefective == other.isDefective;
  }
}
