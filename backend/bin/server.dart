import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:backend/middlewares/cors_middleware.dart';
import 'package:backend/api/auth_api.dart';
import 'package:backend/api/student_api.dart';
import 'package:backend/api/teacher_api.dart';
import 'package:backend/api/admin_api.dart';
import 'package:backend/api/notification_api.dart';
import 'package:backend/api/schedule_api.dart';

import 'package:backend/services/mongo_service.dart';


void main() async {
  await MongoService.connect();

  final router = Router()
    ..mount('/auth/', authApi.call)
    ..mount('/students/', studentApi.call)
    ..mount('/teachers/', teacherApi.call)
    ..mount('/admins/', adminApi.call)
    ..mount('/notification/', notificationApi.call)
    ..mount('/schedules/', scheduleApi.call);


  final handler = Pipeline()
    .addMiddleware(logRequests())
    .addMiddleware(corsMiddleware())
    .addHandler(router.call);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Server running at http://${server.address.host}:${server.port}');
}
