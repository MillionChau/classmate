import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';

class EnterMarksScreen extends StatefulWidget {
  const EnterMarksScreen({super.key});

  @override
  State<EnterMarksScreen> createState() => _EnterMarksScreenState();
}

class _EnterMarksScreenState extends State<EnterMarksScreen> {
  List<Map<String, String>> teachingSubjects = [];
  String? selectedClass;
  String? selectedSubject;
  List<dynamic> students = [];
  bool isLoadingStudents = false;

  final TextEditingController studentIdCtrl = TextEditingController();
  final TextEditingController scoreCtrl = TextEditingController();
  final FocusNode _scoreFocusNode = FocusNode();

  @override
  void dispose() {
    _scoreFocusNode.dispose();
    studentIdCtrl.dispose();
    scoreCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTeachingSubjects();
    });
  }

  Future<void> fetchTeachingSubjects() async {
    final teacherId = Provider.of<UserProvider>(context, listen: false).userId;
    if (teacherId == null) {
      showMessage('Không xác định được giáo viên');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/mark/teacher/$teacherId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          teachingSubjects = data.map<Map<String, String>>((e) {
            return {
              'classId': e['classId'],
              'subject': e['subject'],
            };
          }).toList();
        });
      } else {
        showMessage('Lỗi khi tải dữ liệu lớp dạy');
      }
    } catch (e) {
      showMessage('Lỗi kết nối: $e');
    }
  }

  Future<void> fetchStudentsByClass(String className) async {
    setState(() {
      isLoadingStudents = true;
      students = [];
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/students/class/${Uri.encodeComponent(className)}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          students = responseData;
        });
      } else {
        showMessage('Lỗi khi tải danh sách học sinh');
      }
    } catch (e) {
      showMessage('Lỗi kết nối: $e');
    } finally {
      setState(() {
        isLoadingStudents = false;
      });
    }
  }

  Future<void> submitMark() async {
    final teacherId = Provider.of<UserProvider>(context, listen: false).userId;
    final studentId = studentIdCtrl.text.trim();
    final score = double.tryParse(scoreCtrl.text.trim());

    if (teacherId == null ||
        studentId.isEmpty ||
        score == null ||
        selectedClass == null ||
        selectedSubject == null) {
      showMessage('Vui lòng nhập đầy đủ thông tin');
      return;
    }

    final body = jsonEncode({
      'studentId': studentId,
      'classId': selectedClass,
      'subject': selectedSubject,
      'teacherId': teacherId,
      'score': score,
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/mark/add'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);
      showMessage(data['message'] ?? 'Đã gửi');

      if (response.statusCode == 200) {
        studentIdCtrl.clear();
        scoreCtrl.clear();
      }
    } catch (e) {
      showMessage('Lỗi gửi điểm: $e');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void onClassSelected(String? value) {
    setState(() {
      selectedClass = value;
      selectedSubject = null;
      students = [];
    });

    if (value != null) {
      fetchStudentsByClass(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableClasses = teachingSubjects.map((e) => e['classId']!).toSet().toList();
    final availableSubjects = teachingSubjects
        .where((e) => e['classId'] == selectedClass)
        .map((e) => e['subject']!)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Nhập điểm')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                hint: const Text('Chọn lớp'),
                value: selectedClass,
                items: availableClasses
                    .map((classId) => DropdownMenuItem(value: classId, child: Text(classId)))
                    .toList(),
                onChanged: onClassSelected,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                hint: const Text('Chọn môn'),
                value: selectedSubject,
                items: availableSubjects
                    .map((subject) => DropdownMenuItem(value: subject, child: Text(subject)))
                    .toList(),
                onChanged: (value) => setState(() => selectedSubject = value),
              ),
              const SizedBox(height: 20),
              const Text('Nhập điểm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: studentIdCtrl,
                decoration: const InputDecoration(labelText: 'Mã học sinh'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: scoreCtrl,
                focusNode: _scoreFocusNode,
                decoration: const InputDecoration(labelText: 'Điểm'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitMark,
                child: const Text('Gửi điểm'),
              ),
              const SizedBox(height: 30),
              const Text('Danh sách học sinh', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (selectedClass != null)
                isLoadingStudents
                    ? const CircularProgressIndicator()
                    : students.isEmpty
                        ? const Text('Không có học sinh nào trong lớp này')
                        : SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: students.length,
                              itemBuilder: (context, index) {
                                final student = students[index];
                                return ListTile(
                                  title: Text(student['name'] ?? 'Không có tên'),
                                  subtitle: Text('Mã: ${student['id'] ?? 'N/A'}'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.arrow_upward),
                                    onPressed: () {
                                      studentIdCtrl.text = student['id'] ?? '';
                                      scoreCtrl.text = '';
                                      FocusScope.of(context).requestFocus(_scoreFocusNode);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
            ],
          ),
        ),
      ),
    );
  }
}
