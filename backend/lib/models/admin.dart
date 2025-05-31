class Admin {
  final String id;
  final String name;
  final String position;
  final String password;

  Admin({
    required this.id,
    required this.name,
    required this.position,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'password': password,
      'role': 'admin',
    };
  }

  static Admin fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      position: map['position'] ?? '',
      password: map['password'] ?? '',
    );
  }

}