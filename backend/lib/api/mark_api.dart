import 'package:backend/controllers/mark_controller.dart';
import 'package:shelf_router/shelf_router.dart';

Router get markApi {
  final router = Router();

  router.post('/add', MarkController.addMark);
  router.get('/student/<studentId>', MarkController.getMarksByStudent);
  router.get('/teacher/<teacherId>', MarkController.getTeachingSubjects);
  router.get('/student/<studentId>/subject/<subject>', MarkController.getMarksByStudentAndSubject);

  return router;
}
