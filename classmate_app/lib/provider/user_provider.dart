import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _userId;
  String? _username;
  String? _role;
  String? _fullName;
  String? _token;
  String? _classId;
  bool _rememberMe = false;

  String? get userId => _userId;
  String? get username => _username;
  String? get role => _role;
  String? get fullName => _fullName;
  String? get token => _token;
  String? get classId => _classId;
  bool get rememberMe => _rememberMe;
  bool get isLoggedIn => _token != null;

  String? get studentClassId => _role == 'student' ? _classId : null;

  void setUserData({
    required String userId,
    required String username,
    required String role,
    String? fullName,
    String? token,
    String? classId,
    bool rememberMe = false,
  }) {
    _userId = userId;
    _username = username;
    _role = role;
    _fullName = fullName;
    _token = token;
    _classId = classId;
    _rememberMe = rememberMe;
    notifyListeners();
  }

  void clearUser() {
    _userId = null;
    _username = null;
    _role = null;
    _fullName = null;
    _token = null;
    _classId = null;
    _rememberMe = false;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }
}
