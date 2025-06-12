import 'package:shelf_router/shelf_router.dart';
import '../controllers/student_controller.dart';

Router get studentApi {
  final router = Router();

  router.post('/add', StudentController.addStudent);
  router.get('/all', StudentController.getStudent);
  router.get('/count', StudentController.getStudentCount);
  router.put('/update/<id>', StudentController.updateStudent);
  router.get('/class/<className>', StudentController.getStudentsByClass);

  return router;
}