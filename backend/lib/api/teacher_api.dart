import 'package:shelf_router/shelf_router.dart';
import '../controllers/teacher_controller.dart';

Router get teacherApi {
  final router = Router();

  router.post('/add', TeacherController.addTeacher);
  router.get('/all', TeacherController.getTeacher);
  router.put('/update/<id>', TeacherController.updateTeacher);
  router.delete('/remove/<id>', TeacherController.deleteTeacher);
  router.get('/count', TeacherController.getTeacherCount);

  return router;
}