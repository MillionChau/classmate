import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../models/student.dart';
import '../../models/teacher.dart';
import '../../models/admin.dart';

class ManageAccountsScreen extends StatefulWidget {
  const ManageAccountsScreen({super.key});

  @override
  State<ManageAccountsScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedAccountType;
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _additionalFieldController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _nameController.dispose();
    _additionalFieldController.dispose();
    super.dispose();
  }

  Future<void> _addUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final baseUrl = kIsWeb 
        ? 'http://localhost:8080'   
        : 'http://10.0.2.2:8080';

      final password = _passwordController.text;
      final name = _nameController.text.trim();
      final additionalInfo = _additionalFieldController.text.trim();

      Map<String, dynamic> userData;
      String endpoint;

      switch (_selectedAccountType) {
        case 'student':
          userData = {
            'name': name,
            'class': additionalInfo, 
            'password': password,
            'role': 'student'
          };
          endpoint = '$baseUrl/students/add';
          break;
        case 'teacher':
          userData = {
            'name': name,
            'subject': additionalInfo,
            'password': password,
            'role': 'teacher'
          };
          endpoint = '$baseUrl/teachers/add';
          break;
        case 'admin':
          userData = {
            'name': name,
            'position': additionalInfo,
            'password': password,
            'role': 'admin'
          };
          endpoint = '$baseUrl/admins/add';
          break;
        default:
          throw Exception('Invalid account type');
      }

      final response = await _createUser(endpoint, userData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Thêm thành công')),
      );

      _formKey.currentState!.reset();
      _passwordController.clear();
      _nameController.clear();
      _additionalFieldController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>> _createUser(String url, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final responseBody = jsonDecode(response.body);
    
    switch (response.statusCode) {
      case 200:
      case 201:
        return responseBody;
      case 400:
        throw Exception(responseBody['message'] ?? 'Yêu cầu không hợp lệ');
      case 401:
      case 403:
        throw Exception(responseBody['message'] ?? 'Không có quyền truy cập');
      case 404:
        throw Exception(responseBody['message'] ?? 'Không tìm thấy tài nguyên');
      case 500:
      default:
        throw Exception(responseBody['message'] ?? 'Lỗi server');
    }
  }
  String? _getAdditionalFieldLabel() {
    switch (_selectedAccountType) {
      case 'student':
        return 'Tên lớp';
      case 'teacher':
        return 'Môn học';
      case 'admin':
        return 'Chức vụ';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm User'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Thêm User',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Loại tài khoản',
                  border: OutlineInputBorder(),
                ),
                value: _selectedAccountType,
                items: const [
                  DropdownMenuItem(value: 'student', child: Text('Học sinh')),
                  DropdownMenuItem(value: 'teacher', child: Text('Giáo viên')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                validator: (value) =>
                    value == null ? 'Vui lòng chọn loại tài khoản' : null,
                onChanged: (value) {
                  setState(() {
                    _selectedAccountType = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Vui lòng nhập họ và tên' : null,
              ),
              const SizedBox(height: 15),
              if (_selectedAccountType != null)
                TextFormField(
                  controller: _additionalFieldController,
                  decoration: InputDecoration(
                    labelText: _getAdditionalFieldLabel(),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Vui lòng nhập thông tin' : null,
                ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Vui lòng nhập mật khẩu' : null,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addUser,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Thêm User'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}