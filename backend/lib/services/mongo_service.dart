import 'package:mongo_dart/mongo_dart.dart';
import 'package:dotenv/dotenv.dart';

class MongoService {
  static Db? _db;
  static final DotEnv _env = DotEnv()..load(); // Tạo và load .env

  static Future<void> connect() async {
    final uri = _env['MONGO_URI'];

    if (uri == null || uri.isEmpty) {
      throw Exception('Không tìm thấy MONGO_URL trong .env');
    }

    _db = await Db.create(uri);
    await _db!.open();
    print('MongoDB connected');
  }

  static Db get db => _db!;
}
