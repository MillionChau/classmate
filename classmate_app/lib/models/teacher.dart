class Teacher {
  final String id;
  final String name;
  final String subject;
  final String password;
  
  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'password': password,
      'role': 'teacher',
    };
  }

  static Teacher fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'],
      name: map['name'],
      subject: map['subject'],
      password: map['password'],
    );
  }
}