import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static Db? _db;

  static Future<void> connect() async {
  _db = await Db.create("mongodb://localhost:27017/classmate_db");
  await _db!.open();
  print('MongoDB connected');
  }
  static Db get db => _db!;
}