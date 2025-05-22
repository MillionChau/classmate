import 'dart:convert';
<<<<<<< HEAD
// ignore: depend_on_referenced_packages
=======
import 'package:flutter/foundation.dart';
>>>>>>> adb3a119d92a5467da51201f413a2b96da69b4bb
import 'package:http/http.dart' as http;

class AuthService {
  static final String baseUrl = kIsWeb 
    ? 'http://localhost:8080/auth'   
    : 'http://10.0.2.2:8080/auth';  

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Đăng nhập thất bại');
    }
  }
}
