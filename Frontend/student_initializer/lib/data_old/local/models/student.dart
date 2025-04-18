class Student {
  final String name;
  final String surname;
  final int marticle;

  Student({
    required this.name,
    required this.surname,
    required this.marticle
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Student &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          surname == other.surname &&
          marticle == other.marticle;

  @override
  int get hashCode => name.hashCode ^ surname.hashCode ^ marticle.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'marticle': marticle
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        name: json['name'],
        surname: json['surname'],
        marticle: json['marticle']
    );
  }

  @override
  String toString() {
    return 'Student{name: $name, surname: $surname, marticle: $marticle}';
  }
}