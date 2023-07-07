class Problem {
  final String? id;
  final String firstName;
  final int priority;
  final int lockerNumber;

  Problem({
    this.id,
    required this.firstName,
    required this.priority,
    required this.lockerNumber,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json["id"],
      firstName: json['firstName'],
      priority: json['priority'],
      lockerNumber: json['lockerNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': firstName,
        'firstName': firstName,
        'priority': priority,
        'lockerNumber': lockerNumber,
      };

  factory Problem.base() {
    return Problem(
      firstName: "",
      priority: 0,
      lockerNumber: 0,
    );
  }

  factory Problem.error() {
    return Problem(
      firstName: "Erreur",
      priority: -1,
      lockerNumber: -1,
    );
  }

  Problem copyWith({
    String? id,
    String? firstName,
    int? priority,
    int? lockerNumber,
  }) {
    return Problem(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      priority: priority ?? this.priority,
      lockerNumber: lockerNumber ?? this.lockerNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Problem &&
        id == other.id &&
        firstName == other.firstName &&
        priority == other.priority &&
        lockerNumber == other.lockerNumber;
  }
}
