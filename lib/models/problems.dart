class Problem {
  final String? id;
  final String firstName;
  final int priority;

  Problem({
    this.id,
    required this.firstName,
    required this.priority,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      firstName: json['firstName'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'priority': priority,
      };

  factory Problem.base() {
    return Problem(
      firstName: "",
      priority: 0,
    );
  }

  factory Problem.error() {
    return Problem(
      firstName: "Erreur",
      priority: -1,
    );
  }

  Problem copyWith({
    String? id,
    String? firstName,
    int? priority,
  }) {
    return Problem(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      priority: priority ?? this.priority,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Problem &&
        id == other.id &&
        firstName == other.firstName &&
        priority == other.priority;
  }
}
