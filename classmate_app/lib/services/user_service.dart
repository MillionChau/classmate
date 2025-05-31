import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/admin.dart';

class StudentService {
  static final String baseUrl = kIsWeb 
    ? 'http://localhost:8080'   
    : 'http://10.0.2.2:8080';

  final String studentPath = '/students';

  Future<List<Student>> getAllStudents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$studentPath/all'),
        headers: {'Content-Type': 'application/json'},
      );

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw UserServiceException('Network error: ${e.message}');
    } catch (e) {
      throw UserServiceException('Unexpected error: $e');
    }
  }

  Future<Student> createStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$studentPath/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(student.toMap()),
      );

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw UserServiceException('Network error: ${e.message}');
    } catch (e) {
      throw UserServiceException('Unexpected error: $e');
    }
  }

  Future<Student> updateStudent(Student student) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$studentPath/update/${student.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(student.toMap()),
      );

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw UserServiceException('Network error: ${e.message}');
    } catch (e) {
      throw UserServiceException('Unexpected error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        final dynamic data = jsonDecode(response.body);
        if (data is List) {
          return data.map((item) => Student.fromMap(item)).toList();
        }
        return Student.fromMap(data);
      case 400:
        throw BadRequestException('Invalid request: ${response.body}');
      case 401:
      case 403:
        throw UnauthorizedException('Authentication failed');
      case 404:
        throw NotFoundException('Resource not found');
      case 500:
      default:
        throw ServerException('Server error: ${response.statusCode}');
    }
  }
}

class TeacherService {
  static final String baseUrl = kIsWeb 
    ? 'http://localhost:8080'   
    : 'http://10.0.2.2:8080';

  final String teacherPath = '/teachers';

  Future<List<Teacher>> getAllTeachers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$teacherPath/all'), 
        headers: {'Content-Type': 'application/json'},
      );

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw UserServiceException('Network error: ${e.message}');
    } catch (e) {
      throw UserServiceException('Unexpected error: $e');
    }
  }

  Future<Teacher> createTeacher(Teacher teacher) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$teacherPath/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(teacher.toMap()),
      );

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw UserServiceException('Network error: ${e.message}');
    } catch (e) {
      throw UserServiceException('Unexpected error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        final dynamic data = jsonDecode(response.body);
        if (data is List) {
          return data.map((item) => Teacher.fromMap(item)).toList();
        }
        return Teacher.fromMap(data);
      case 400:
        throw BadRequestException('Invalid request: ${response.body}');
      case 401:
      case 403:
        throw UnauthorizedException('Authentication failed');
      case 404:
        throw NotFoundException('Resource not found');
      case 500:
      default:
        throw ServerException('Server error: ${response.statusCode}');
    }
  }
}

class AdminService {
  static final String baseUrl = kIsWeb 
    ? 'http://localhost:8080'   
    : 'http://10.0.2.2:8080';
  final adminPath = 'admins';

   Future<Admin> createAdmin(Admin admin) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$adminPath/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(admin.toMap()),
      );

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw UserServiceException('Network error: ${e.message}');
    } catch (e) {
      throw UserServiceException('Unexpected error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        final dynamic data = jsonDecode(response.body);
        if (data is List) {
          return data.map((item) => Teacher.fromMap(item)).toList();
        }
        return Teacher.fromMap(data);
      case 400:
        throw BadRequestException('Invalid request: ${response.body}');
      case 401:
      case 403:
        throw UnauthorizedException('Authentication failed');
      case 404:
        throw NotFoundException('Resource not found');
      case 500:
      default:
        throw ServerException('Server error: ${response.statusCode}');
    }
  }
}

// Custom exception classes
class UserServiceException implements Exception {
  final String message;
  UserServiceException(this.message);

  @override
  String toString() => message; // để tránh "Instance of..."
}

class BadRequestException extends UserServiceException {
  BadRequestException(super.message);
}

class UnauthorizedException extends UserServiceException {
  UnauthorizedException(super.message);
}

class NotFoundException extends UserServiceException {
  NotFoundException(super.message);
}

class ServerException extends UserServiceException {
  ServerException(super.message);
}
