import 'package:shelf_router/shelf_router.dart';
import '../controllers/schedule_controller.dart';

Router get scheduleApi {
  final router = Router();

  router.post('/add', ScheduleController.addSchedule);
  router.patch('/update/<classId>/<week>', ScheduleController.updateSchedule);
  router.delete('/delete/<classId>/<week>', ScheduleController.deleteSchedule);

  router.get('/class/<classId>', ScheduleController.getScheduleByClass);
  router.get('/class/<classId>/week/<week>', ScheduleController.getScheduleByClassAndWeek);
  router.get('/teacher/<teacherId>', ScheduleController.getScheduleByTeacher);
  router.get('/schedules', ScheduleController.getAllSchedules);

  return router;
}
