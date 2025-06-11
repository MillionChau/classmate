import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';
import '../../services/auth_service.dart';

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
        final result = await AuthService.login(
          _usernameController.text,
          _passwordController.text,
        );

        setState(() => _isLoading = false);

        if (result['success']) {
          final user = result['data']['user'];
          final token = result['data']['access_token'];

          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUserData(
            userId: user['id'],
            username: user['name'],
            role: user['role'],
            fullName: user['name'],
            token: token,
            classId: user['className'] ?? (user['role'] == 'student')
          );

          switch (user['role']) {
            case 'student':
              Navigator.pushReplacementNamed(context, AppRoutes.studentHome);
              break;
            case 'teacher':
              Navigator.pushReplacementNamed(context, AppRoutes.teacherHome);
              break;
            case 'admin':
              Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
              break;
            default:
              _showMessage('Không xác định được vai trò!');
          }
        } else {
          _showMessage(result['message']);
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
