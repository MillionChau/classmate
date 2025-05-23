import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
      return {
        'success': true,
        'data': data,
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Đăng nhập thất bại',
      };
    }
  }
}
