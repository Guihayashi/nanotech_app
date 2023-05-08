import 'package:flutter/material.dart';
import 'package:nanotech_app/database/dao/reclamacao_dao.dart';
import 'package:nanotech_app/database/dao/user_dao.dart';
import 'package:nanotech_app/funcoes/session_manager.dart';
import 'package:nanotech_app/models/reclamacao.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  final ReclamacaoDao _reclamacaoDao = ReclamacaoDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reclamações'),
      ),
      body: Consumer<SessionManager>(
        builder: (context, sessionManager, child) {
          return FutureBuilder<List<Reclamacao>>(
            future: _reclamacaoDao.findAllByUser(sessionManager.loggedInUser),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text('Carregando...'),
                    ],
                  ),
                );
              }
              final List<Reclamacao> reclamacoes =
                  snapshot.data! as List<Reclamacao>;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final Reclamacao reclamacao = reclamacoes[index];
                  return ReclamacaoCard(reclamacao);
                },
                itemCount: reclamacoes.length,
              );
            },
          );
        },
      ),
    );
  }
}

class ReclamacaoCard extends StatelessWidget {
  final Reclamacao reclamacao;

  ReclamacaoCard(this.reclamacao);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          reclamacao.numRec.toString(),
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          reclamacao.status.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
