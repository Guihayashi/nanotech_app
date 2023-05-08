// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../database/banco_usuarios.dart';
//
// class ComplaintScreen extends StatelessWidget {
//   final int complaintNumber;
//
//   ComplaintScreen(this.complaintNumber);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reclamação #${complaintNumber.toString()}'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<Complaint>(
//           future: DatabaseHelper.instance.getComplaint(complaintNumber),
//           builder: (BuildContext context, AsyncSnapshot<Complaint> snapshot) {
//             if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
//               final complaint = snapshot.data!;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Nome Completo: ${complaint.fullName}'),
//                   SizedBox(height: 8.0),
//                   Text('CPF: ${complaint.cpf}'),
//                   SizedBox(height: 8.0),
//                   Text('Endereço: ${complaint.address}'),
//                   SizedBox(height: 8.0),
//                   Text('Email: ${complaint.email}'),
//                   SizedBox(height: 8.0),
//                   Text('Celular: ${complaint.phone}'),
//                   SizedBox(height: 8.0),
//                   Text('Telefone: ${complaint.telephone}'),
//                   SizedBox(height: 8.0),
//                   Text('Assunto: ${complaint.subject}'),
//                   SizedBox(height: 8.0),
//                   Text('Descrição: ${complaint.description}'),
//                   SizedBox(height: 8.0),
//                   Text('Data do Incidente: ${DateFormat('dd/MM/yyyy').format(complaint.incidentDate!)}'),
//                   SizedBox(height: 8.0),
//                   Text('Número do Pedido: ${complaint.orderNumber ?? 'Não informado'}'),
//                   SizedBox(height: 8.0),
//                   Text('Número da Reclamação: ${complaint.complaintNumber}'),
//                   SizedBox(height: 8.0),
//                   Text('Status: ${complaint.status}'),
//                   SizedBox(height: 8.0),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: complaint.attachments.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           leading: Icon(Icons.attach_file),
//                           title: Text(complaint.attachments[index]),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
// class _VerReclamacaoState extends State<VerReclamacao> {
//   late Reclamacao _reclamacao;
//
//   @override
//   void initState() {
//     super.initState();
//     _carregarReclamacao();
//   }
//
//   void _carregarReclamacao() async {
//     var db = await BancoDadosHelper.instance.database;
//     var reclamacao =
//     await db.query('reclamacoes', where: 'numero = ?', whereArgs: [widget.numReclamacao]);
//     setState(() {
//       _reclamacao = Reclamacao.fromMap(reclamacao.first);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reclamação #${widget.numReclamacao}'),
//       ),
//       body: _reclamacao == null
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Text('Assunto: ${_reclamacao.assunto}'),
//             Text('Data do incidente: ${DateFormat('dd/MM/yyyy').format(_reclamacao.dataIncidente)}'),
//             Text('Status: ${_reclamacao.status}'),
//             Text('Descrição: ${_reclamacao.descricao}'),
//             if (_reclamacao.anexos.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Anexos:'),
//                   for (var anexo in _reclamacao.anexos)
//                     Text(anexo),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
