import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  static final String baseUrl = kIsWeb 
    ? 'http://localhost:8080/auth'   
    : 'http://10.0.2.2:8080/auth';  

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': _usernameController.text.trim(),
            'password': _passwordController.text.trim(),
          }),
        );

        setState(() => _isLoading = false);

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          final role = result['role'];

          switch (role) {
            case 'student':
              Navigator.pushReplacementNamed(context, AppRoutes.studentHome);
              break;
            case 'teacher':
              Navigator.pushReplacementNamed(context, AppRoutes.login);
              break;
            case 'admin':
              Navigator.pushReplacementNamed(context, AppRoutes.login);
              break;
            default:
              _showMessage('Không xác định được vai trò!');
          }
        } else {
          final error = jsonDecode(response.body)['message'];
          _showMessage(error);
        }
      } catch (e) {
        setState(() => _isLoading = false);
        _showMessage('Lỗi kết nối đến máy chủ');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'ClassMate',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên đăng nhập',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person), 
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Nhập tên đăng nhập' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock)
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Nhập mật khẩu' : null,
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _login,
                          child: const Text('Đăng nhập'),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
