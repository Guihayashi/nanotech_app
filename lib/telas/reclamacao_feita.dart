import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/banco_reclamacoes.dart';
import '../database/dao/reclamacao_dao.dart';
import '../models/reclamacao.dart';

class ReclamacoesScreen extends StatefulWidget {
  final String numReclamacao;

  ReclamacoesScreen({required this.numReclamacao});

  @override
  _ReclamacoesScreenState createState() => _ReclamacoesScreenState();
}

class _ReclamacoesScreenState extends State<ReclamacoesScreen> {
  List<Reclamacao> _reclamacoes = [];
  ReclamacaoDao _reclamacaoDao = ReclamacaoDao();
  late Reclamacao reclamacao;
  @override
  void initState() {
    super.initState();
    _loadReclamacoes();
  }

  Future<void> _loadReclamacoes() async {
    final Database db = await getReclamacaoDatabase();
    final results = await db.query('reclamacoes', where: 'num_reclamacao = ?', whereArgs: [widget.numReclamacao]);
    setState(() {
      _reclamacoes = _toList(results);
    });
  }

  List<Reclamacao> _toList(List<Map<String, dynamic>> result) {
    return result.map((e) => Reclamacao.fromMap(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reclamações'),
      ),
      body: ListView.builder(
        itemCount: _reclamacoes.length,
        itemBuilder: (context, index) {
          final reclamacao = _reclamacoes[index];
          return ListTile(
            title: Text('Número da reclamação: ${reclamacao.numRec}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome completo: ${reclamacao.fullName}'),
                Text('CPF: ${reclamacao.cpf}'),
                Text('Endereço: ${reclamacao.endereco}'),
                Text('E-mail: ${reclamacao.email}'),
                Text('Celular: ${reclamacao.celular}'),
                Text('Telefone: ${reclamacao.telefone}'),
                Text('Descrição: ${reclamacao.descricao}'),
                Text('Assunto: ${reclamacao.assunto}'),
                Text('Data do incidente: ${reclamacao.dataIncidente}'),
                Text('Número do pedido: ${reclamacao.numPedido}'),
                Text('Status: ${reclamacao.status}'),
                Text('Arquivos: ${reclamacao.fileNames}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
