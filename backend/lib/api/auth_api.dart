import 'package:shelf_router/shelf_router.dart';
import '../controllers/auth_controller.dart';

Router get authApi {
  final router = Router();

  router.post('/login', AuthController.login);

  return router;
}