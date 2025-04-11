import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/mongo_service.dart';

class AuthController {
  static Future<Response> login(Request req) async {
    final payload = await req.readAsString();
    final data = jsonDecode(payload);

    final collection = MongoService.db.collection('users');
    final user = await collection.findOne({
      'username': data['username'],
      'password': data['password']
    });

    if(user != null) {
      return Response.ok(jsonEncode({
        'message': 'Login success',
        'role': user['role']
      }));
    } else {
      return Response.forbidden(jsonEncode({'message': 'Invalid credentials'}));
    }
  }
}