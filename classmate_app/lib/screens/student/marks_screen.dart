import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';

class DiemSoScreen extends StatefulWidget {
  const DiemSoScreen({super.key});

  @override
  State<DiemSoScreen> createState() => _DiemSoScreenState();
}

class _DiemSoScreenState extends State<DiemSoScreen> {
  List<dynamic> scores = [];
  String? selectedSubject;
  bool isLoading = false;

  final List<String> availableSubjects = [
    'Toán', 'Ngữ Văn', 'Vật Lý', 'Hoá Học', 'Sinh Học',
    'Lịch Sử', 'Địa Lý', 'GDCD', 'Tin Học', 'Thể Dục', 'GDQP-AN'
  ];

  Future<void> fetchScoresBySubject(String studentId, String subject) async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(
        Uri.parse('http://localhost:8080/mark/student/$studentId/subject/$subject'),
      );

      if (res.statusCode == 200) {
        setState(() => scores = jsonDecode(res.body));
      } else {
        setState(() => scores = []);
      }
    } catch (e) {
      print('Lỗi lấy điểm theo môn: $e');
      setState(() => scores = []);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final studentId = userProvider.userId;
    final role = userProvider.role;

    if (studentId == null || role != 'student') {
      return const Scaffold(
        body: Center(
          child: Text('Chỉ học sinh mới có thể xem điểm của mình'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xem điểm theo môn'),
        backgroundColor: Colors.deepPurple.shade100,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedSubject,
              hint: const Text('Chọn môn học'),
              items: availableSubjects
                  .map((subject) => DropdownMenuItem(value: subject, child: Text(subject)))
                  .toList(),
              onChanged: (subject) {
                if (subject != null) {
                  setState(() => selectedSubject = subject);
                  fetchScoresBySubject(studentId, subject);
                }
              },
            ),
            const SizedBox(height: 16),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: scores.isEmpty
                        ? const Text('Không có điểm cho môn này')
                        : ListView.builder(
                            itemCount: scores.length,
                            itemBuilder: (context, index) {
                              final item = scores[index];
                              return ListTile(
                                leading: const Icon(Icons.grade),
                                title: Text('Lớp: ${item['classId']}'),
                                subtitle: Text('Điểm: ${item['score']}'),
                                trailing: Text(
                                  item['createdAt'].toString().split('T').first,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
