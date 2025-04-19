class User {
  final String username;
  final String password;
  final String role;

  User({required this.username, required this.password, required this.role});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'role': role
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
      role: map['role']
    );
  }
}