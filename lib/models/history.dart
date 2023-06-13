class History {
  final String? id;
  final String title;
  final DateTime date;
  // final int lockerNumber;

  History({
    this.id,
    required this.title,
    required this.date,
    // required this.lockerNumber,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      title: json['title'],
      date: json['priority'],
      // lockerNumber: json['lockerNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date,
        // 'lockerNumber': lockerNumber,
      };

  factory History.base() {
    return History(
      title: "",
      date: DateTime.now(),
      // lockerNumber: 0,
    );
  }

  factory History.error() {
    return History(
      title: "Erreur",
      date: DateTime.now(),
      // lockerNumber: -1,
    );
  }

  History copyWith({
    String? id,
    String? title,
    DateTime? date,
    // int? lockerNumber,
  }) {
    return History(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      // lockerNumber: lockerNumber ?? this.lockerNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is History &&
        id == other.id &&
        title == other.title &&
        date == other.date;
    // lockerNumber == other.lockerNumber;
  }
}
