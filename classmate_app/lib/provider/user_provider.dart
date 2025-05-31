import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _userId;
  String? _username;
  String? _role;
  String? _fullName; 
  String? _token;
  bool _rememberMe = false;

  // Getter methods
  String? get userId => _userId;
  String? get username => _username;
  String? get role => _role;
  String? get fullName => _fullName;
  String? get token => _token;
  bool get rememberMe => _rememberMe;
  bool get isLoggedIn => _token != null;

  // Set user data
  void setUserData({
    required String userId,
    required String username,
    required String role,
    String? fullName,
    String? token,
    bool rememberMe = false,
  }) {
    _userId = userId;
    _username = username;
    _role = role;
    _fullName = fullName;
    _token = token;
    _rememberMe = rememberMe;
    notifyListeners();
  }

  // Clear user data
  void clearUser() {
    _userId = null;
    _username = null;
    _role = null;
    _fullName = null;
    _token = null;
    _rememberMe = false;
    notifyListeners();
  }

  // Set remember me
  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }
}