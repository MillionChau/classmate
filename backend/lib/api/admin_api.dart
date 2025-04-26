import 'package:shelf_router/shelf_router.dart';
import '../controllers/admin_controller.dart';

Router get adminApi {
  final router = Router();

  router.post('/add', AdminController.addAdmin);
  router.get('/all', AdminController.getAdmin);
  router.put('/update/<id>', AdminController.updateAdmin);
  router.delete('/remove/<id>', AdminController.deleteAdmin);
  router.get('/count', AdminController.getAdminCount);

  return router;
}