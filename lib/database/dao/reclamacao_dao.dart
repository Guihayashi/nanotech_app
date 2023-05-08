import 'package:sqflite/sqflite.dart';
import 'package:nanotech_app/models/reclamacao.dart';

import '../banco_reclamacoes.dart';

class ReclamacaoDao{

  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
  '$_fullName TEXT, '
      '$_cpf TEXT, '
  '$_endereco TEXT, '
  '$_email TEXT, '
      '$_celular TEXT, '
  '$_telefone TEXT, '
      '$_assunto TEXT, '
  '$_descricao TEXT, '
      '$_dataIncidente TEXT, '
  '$_numPedido TEXT, '
      '$_numReclamacao TEXT, '
  '$_status TEXT, '
      '$_anexos TEXT, ';
  static const String _tableName = 'reclamacoes';
  static const String _id = 'id';
  static const String _fullName = 'fullName';
  static const String _cpf = 'cpf';
  static const String _endereco = 'endereco';
  static const String _email = 'email';
  static const String _celular = 'celular';
  static const String _telefone = 'telefone';
  static const String _assunto = 'assunto';
  static const String _descricao = 'descricao';
  static const String _dataIncidente = 'dataIncidente';
  static const String _numPedido = 'numPedido';
  static const String _numReclamacao = 'numReclamacao';
  static const String _status = 'status';
  static const String _anexos = 'anexos';


  Future<int> save(Reclamacao reclamacao) async {
    final Database db = await getReclamacaoDatabase();
    Map<String, dynamic> reclamacaoMap = _toMap(reclamacao);
    return db.insert(_tableName, reclamacaoMap);
  }

  Future<List<Reclamacao>> findAll() async {
    final Database db = await getReclamacaoDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Reclamacao> reclamacoes = _toList(result);
    return reclamacoes;
  }
  Future<List<Reclamacao>> findReclamacoesByNumRec(String numRec) async {
    final Database db = await getReclamacaoDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'numRec = ?',
      whereArgs: [numRec],
    );
    return List.generate(maps.length, (i) {
      return Reclamacao.fromMap(maps[i]);
    });
  }

  Future<List<Reclamacao>> findAllByUser(_cpf) async {
    final Database db = await getReclamacaoDatabase();
    final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM $_tableName WHERE cpf = ?', [_cpf]);
    List<Reclamacao> reclamacoes = _toList(result);
    return reclamacoes;
  }


  Map<String, dynamic> _toMap(Reclamacao reclamacao) {
    final Map<String, dynamic> reclamacaoMap = {};
    reclamacaoMap['fullName'] = reclamacao.fullName;
    reclamacaoMap['cpf'] = reclamacao.cpf;
    reclamacaoMap['endereco'] = reclamacao.endereco;
    reclamacaoMap['email'] = reclamacao.email;
    reclamacaoMap['celular'] = reclamacao.celular;
    reclamacaoMap['telefone'] = reclamacao.telefone;
    reclamacaoMap['assunto'] = reclamacao.assunto;
    reclamacaoMap['descricao'] = reclamacao.descricao;
    reclamacaoMap['dataIncidente'] = reclamacao.dataIncidente;
    reclamacaoMap['numPedido'] = reclamacao.numPedido;
    reclamacaoMap['numReclamacao'] = reclamacao.numRec;
    reclamacaoMap['status'] = reclamacao.status;
    reclamacaoMap['anexos'] = reclamacao.fileNames;
    return reclamacaoMap;
  }

  List<Reclamacao> _toList(List<Map<String, dynamic>> result) {
    final List<Reclamacao> reclamacoes = [];
    for (Map<String, dynamic> row in result) {
      final Reclamacao reclamacao = Reclamacao(
        row[_id],
        row[_fullName],
        row[_cpf],
        row[_endereco],
        row[_email],
        row[_celular],
        row[_telefone],
        row[_descricao],
        row[_assunto],
        row[_dataIncidente],
        row[_numPedido],
        row[_numReclamacao],
        row[_status],
        row[_anexos],
      );
      reclamacoes.add(reclamacao);
    }
    return reclamacoes;
  }
  Future<Reclamacao?> findOneReclamacao(_numPedido) async {
    final Database db = await getReclamacaoDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName, where: 'cpf = ? AND numReclamacao = ?', whereArgs: [_cpf, _numReclamacao]);
    if (result.isEmpty) {
      return null;
    }
    return Reclamacao.fromMap(result.first);
  }


}