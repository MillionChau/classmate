import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  static Future<int> fetchStudentCount() async {
    try {
      final res = await http.get(Uri.parse('http://10.0.2.2:8080/students/count'));
      
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
      final res = await http.get(Uri.parse('http://10.0.2.2:8080/teachers/count'));

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
      final res = await http.get(Uri.parse('http://l10.0.2.2:8080/admins/count'));

      if(res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['count'];
      }
      throw Exception('Lỗi khi lấy số lượng admin. Status code: ${res.statusCode}');
    } catch(e) {
      print('Lỗi kết nối');
      throw Exception('Lỗi khi lấy số lượng giáo viên');
    }
  }
}