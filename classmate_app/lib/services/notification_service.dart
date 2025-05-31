import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class NotificationService {
  static final String baseUrl = kIsWeb 
    ? 'http://localhost:8080'   
    : 'http://10.0.2.2:8080';

    
}