import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/mongo_service.dart';

class AuthController {
  static Future<Response> login(Request req) async {
    final payload = await req.readAsString();
    final data = jsonDecode(payload);

    final input = data['username'];
    final password = data['password'];

    if (input == null || password == null) {
      return Response.badRequest(body: jsonEncode({'message': 'Thiếu username hoặc password'}));
    }

    final collection = MongoService.db.collection('users');

    // Tìm theo username hoặc name (dùng $or)
    final user = await collection.findOne({
      r'$or': [
        {'username': input},
        {'name': input},
      ],
      'password': password,
    });

    if (user != null) {
      return Response.ok(jsonEncode({
        'message': 'Login success',
        'role': user['role'],
      }));
    } else {
      return Response.forbidden(jsonEncode({'message': 'Tài khoản hoặc mật khẩu sai'}));
    }
  }
}