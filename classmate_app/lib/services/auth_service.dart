import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final String _baseUrl = kIsWeb
      ? 'http://localhost:8080/auth'
      : 'http://10.0.2.2:8080/auth';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username.trim(), 'password': password.trim()}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
<<<<<<< HEAD
      final data = jsonDecode(response.body);
      // Lưu thông tin user vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode({
        'name': data['name'],
        'role': data['role']
      }));
      return {
        'message': data['message'],
        'role': data['role'],
        'name': data['name'],
=======
      return {
        'success': true,
        'data': data,
>>>>>>> 8bd2927b1d48cdb2771c0909822b43e2f65919d4
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Đăng nhập thất bại',
      };
    }
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData');
      if (userDataString != null) {
        return jsonDecode(userDataString);
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy thông tin user: $e');
      return null;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }
}
