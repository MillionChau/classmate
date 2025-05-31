import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class DashboardService {
<<<<<<< HEAD
   static final String baseUrl = kIsWeb 
    ? 'http://localhost:8080'   
    : 'http://10.0.2.2:8080';
=======
  static final String baseUrl = kIsWeb 
    ? 'http://localhost:8080'   
    : 'http://10.0.2.2:8080'; 
>>>>>>> 8bd2927b1d48cdb2771c0909822b43e2f65919d4

  static Future<int> fetchStudentCount() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/students/count'));
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['count'] ?? 0;
      }
      throw Exception('Lỗi khi lấy số lượng học sinh. Status code: ${res.statusCode}');
    } catch (e) {
      print('Error fetching student count: $e');
      throw Exception('Lỗi kết nối khi lấy số lượng học sinh');
    }
  }

  static Future<int> fetchTeacherCount() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/teachers/count'));

      if(res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['count'];
      }
      throw Exception('Lỗi khi lấy số lượng giáo viên. Status code: ${res.statusCode}');
    } catch(e) {
      print('Lỗi kết nối');
      throw Exception('Lỗi khi lấy số lượng giáo viên');
    }
  }

  static Future<int> fetchAdminCount() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/admins/count'));

      if(res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['count'];
      }
      throw Exception('Lỗi khi lấy số lượng admin. Status code: ${res.statusCode}');
    } catch(e) {
      throw Exception('Lỗi khi lấy số lượng admin');
    }
  }

  static Future<int> fetchNotificationsCount() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/notification/count'));

      if(res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['count'];
      }
      throw Exception('Lỗi khi lấy số lượng thông báo. Status code: ${res.statusCode}');
    } catch(e) {
      throw Exception('Lỗi khi lấy số lượng thông báo');
    }
  }
}