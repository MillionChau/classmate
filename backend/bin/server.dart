import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../lib/middlewares/cors_middleware.dart';
import '../lib/api/auth_api.dart';
import '../lib/api/student_api.dart';
import '../lib/api/teacher_api.dart';
import '../lib/api/admin_api.dart';
import '../lib/api/notification_api.dart';
import '../lib/api/schedule_api.dart';

import '../lib/services/mongo_service.dart';


void main() async {
  await MongoService.connect();

  final router = Router()
    ..mount('/auth/', authApi)
    ..mount('/students/', studentApi)
    ..mount('/teachers/', teacherApi)
    ..mount('/admins/', adminApi)
    ..mount('/notification/', notificationApi)
    ..mount('/schedule/', scheduleApi);


  final handler = Pipeline()
    .addMiddleware(logRequests())
    .addMiddleware(corsMiddleware())
    .addHandler(router);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Server running at http://${server.address.host}:${server.port}');
}
