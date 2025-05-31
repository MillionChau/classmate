class Student {
  final String? id;
  final String? name;
  final String? className;
  final String? password;

  Student({
    required this.id,
    required this.name,
    required this.className,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'className': className,
      'password': password,
      'role': 'student'
    };
  }

  static Student fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'], 
      name: map['name'], 
      className: map['className'], 
      password: map['password']
    );
  }
}