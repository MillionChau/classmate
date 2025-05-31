// user_provider.dart
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  String? _name;
  String? _role;

  String? get name => _name;
  String? get role => _role;

  Future<void> loadUserData() async {
    try {
      final userData = await AuthService.getCurrentUser();
      if (userData != null) {
        _name = userData['name'];
        _role = userData['role'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Lỗi khi load user data: $e');
    }
  }

  void setUser(String name, String role) {
    _name = name;
    _role = role;
    notifyListeners();
  }

  void clear() {
    _name = null;
    _role = null;
    notifyListeners();
  }
}