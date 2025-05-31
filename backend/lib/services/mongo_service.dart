import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static Db? _db;

  static Future<void> connect() async {
  _db = await Db.create("mongodb+srv://shopee-sentiment:MChau2506@cluster0.qlbix.mongodb.net/classmate_db");
  await _db!.open();
  print('MongoDB connected');
  }
  static Db get db => _db!;
}