import 'package:nanotech_app/funcoes/logicas_adicionais.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nanotech_app/database/banco_usuarios.dart';
import 'package:nanotech_app/models/user.dart';

import '../../funcoes/session_manager.dart';

class UserDao {
  oSessionManager sessionManager = oSessionManager();
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_username TEXT, '
      '$_password TEXT, '
      '$_tipo TEXT, '
      ')';
  static const String _tableName = 'users';
  static const String _id = 'id';
  static const String _username = 'username';
  static const String _password = 'password';
  static const String _tipo = 'tipo';

  Future<int> save(User user) async {
    final Database db = await getDatabase();
    Map<String, dynamic> userMap = _toMap(user);
    return db.insert(_tableName, userMap);
  }

  Future<bool> loginUser(String username, String password) async {
    final db = await getDatabase();
    final result = await db.rawQuery(
      'SELECT * FROM users WHERE username = ? AND password = ?',
      [username, password],
    );
    if (result.isNotEmpty) {
      final userMap = result.first;
      final user = User.fromMap(userMap);
      await sessionManager.setLoggedIn(true);
      await sessionManager.setUsername(user.cpf);
      return true;
    } else {
      return false;
    }
  }


  Future<User?> findOne(String cpf, String password) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName,
        where: 'cpf = ? AND password = ?', whereArgs: [cpf, password]);
    if (result.isEmpty) {
      return null;
    }
    return User.fromMap(result.first);
  }

  Map<String, dynamic> _toMap(User user) {
    final Map<String, dynamic> userMap = {};
    userMap[_username] = user.cpf;
    userMap[_password] = user.password;
    userMap[_tipo] = user.tipo;
    return userMap;
  }
}
