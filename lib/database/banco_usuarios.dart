import 'package:nanotech_app/database/dao/user_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

  Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), 'nanotech.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(UserDao.tableSql);
      },
      version: 1,
    );
  }

