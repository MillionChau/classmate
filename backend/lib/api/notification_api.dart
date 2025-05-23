import 'package:shelf_router/shelf_router.dart';
import '../controllers/notification_controller.dart';

Router get notificationApi {
  final router = Router();

  router.post('/add', NotificationController.sendNotification);
  router.get('/read', NotificationController.getAllNotifications);
  router.patch('/approve/<id>', NotificationController.approveNotification);
  router.delete('/delete/<id>', NotificationController.removedNotification);
  router.get('/count', NotificationController.getAllNotificationCount);

  return router;
}