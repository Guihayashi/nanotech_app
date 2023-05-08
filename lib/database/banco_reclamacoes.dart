import 'package:nanotech_app/database/dao/reclamacao_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


  Future<Database> getReclamacaoDatabase() async {
    final String path = join(await getDatabasesPath(), 'nanotech.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(ReclamacaoDao.tableSql);
      },
      version: 1,
    );
  }

