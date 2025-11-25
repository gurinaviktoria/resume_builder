class Person {
  final int? id;
  final String name;
  final int age;
  final String email;
  final String about;
  final List<String> skills;

  Person({
    this.id,
    required this.name,
    required this.age,
    required this.email,
    required this.about,
    required this.skills,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'email': email,
      'about': about,
      'skills': skills.join(','),
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      email: map['email'],
      about: map['about'],
      skills: map['skills'] != null ? (map['skills'] as String).split(',') : [],
    );
  }

  Person copyWith({
    int? id,
    String? name,
    int? age,
    String? email,
    String? about,
    List<String>? skills,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      email: email ?? this.email,
      about: about ?? this.about,
      skills: skills ?? List.from(this.skills),
    );
  }
}
