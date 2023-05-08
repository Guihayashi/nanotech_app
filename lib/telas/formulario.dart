import 'dart:io';

//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:nanotech_app/classes/reclamacao.dart';
import 'package:nanotech_app/database/dao/reclamacao_dao.dart';
import 'package:nanotech_app/funcoes/logicas_adicionais.dart';
import 'package:nanotech_app/models/reclamacao.dart';

import 'dashboard.dart';

class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullName = TextEditingController();
  TextEditingController _cpf = TextEditingController();
  TextEditingController _endereco = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _celular = TextEditingController();
  TextEditingController _telefone = TextEditingController();
  TextEditingController _selectedSubject = TextEditingController();
  List<String> _subjects = [
    'Pagamento',
    'Envio-Entrega',
    'Compra Protegida',
    'Outros'
  ];
  TextEditingController _descricao = TextEditingController();
  TextEditingController _dataIncidente = TextEditingController();
  TextEditingController _numPedido = TextEditingController();
  TextEditingController _numRec = TextEditingController();
  TextEditingController _status = TextEditingController();
  List<String> _statusList = ['Novo', 'Criado', 'Em andamento', 'Fechado'];
  List<String>? _fileNames = [];
  List<String>? _anexos;
  ReclamacaoDao _reclamacaoDao = ReclamacaoDao();
  //List<FilePickerResult>? _files = [];


  @override
  void initState() {
    super.initState();
    _anexos = [];
  }

  // Future<void> _showFileDialog() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
  //   );
  //   if (result != null) {
  //     final file = File(result.files.single.path!);
  //     if (file.lengthSync() > 10485760) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('O tamanho do arquivo deve ser de no máximo 10MB.'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     } else {
  //       setState() {
  //         _anexos!.add(file.path);
  //         _fileNames!.add(result.files.single.name);
  //       };
  // }
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: getNumeroReclamacao(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Text('# da Reclamação: ${snapshot.data}');
            } else {
              return Text('Novo atendimento');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome Completo*:',
                ),
                controller: _fullName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha seu nome completo.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'CPF*:',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                  CpfInputFormatter(),
                ],
                keyboardType: TextInputType.number,
                controller: _cpf,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha seu CPF.';
                  }
                  if (value.length < 14) {
                    return 'Por favor, preencha seu CPF completo.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _endereco,
                decoration: InputDecoration(
                  labelText: 'Endereço:',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'E-mail*:',
                ),
                controller: _email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha seu e-mail.';
                  }
                  bool isEmailValid(value) {
                    final RegExp regex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'); // Expressão regular para validar o formato de email
                    return regex.hasMatch(
                        value); // Retorna verdadeiro se o email é válido
                  }

                  if (!isEmailValid(value)) {
                    return 'Por favor, preencha com um e-mail válido.';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.phone,
                inputFormatters: [CellphoneTextInputFormatter()],
                decoration: InputDecoration(
                  labelText: 'Celular*:',
                ),
                controller: _celular,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha seu celular.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.phone,
                inputFormatters: [PhoneTextInputFormatter()],
                decoration: InputDecoration(
                  labelText: 'Telefone:',
                ),
                controller: _telefone,
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Assunto*:',
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value as TextEditingController;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um assunto.';
                  }
                  return null;
                },
                items: _subjects.map((subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Descrição*:',
                ),
                controller: _descricao,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha a descrição da reclamação.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.datetime,
                inputFormatters: [],
                decoration: InputDecoration(
                  labelText: 'Data do incidente*:',
                  prefixIcon: Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _dataIncidente.clear();
                    },
                  ),
                ),
                controller: _dataIncidente,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha a data do incidente.';
                  }

                  try {
                       DateFormat('dd/MM/yyyy').parseStrict(value);
                  } catch (e) {
                    return 'Data inválida.';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número do pedido:',
                ),
                controller: _numPedido,
              ),
              SizedBox(height: 16.0),
              Container(
                color: Colors.grey.shade200,
                child: AbsorbPointer(
                  absorbing: true,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Status:',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _status = value as TextEditingController;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione um assunto.';
                      }
                      return null;
                    },
                    items: _statusList.map((subject) {
                      return DropdownMenuItem<String>(
                        value: subject,
                        child: Text(subject),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  //_showFileDialog();
                },
                child: Text('Anexar arquivo'),
              ),

              SizedBox(height: 16.0),
              if (_fileNames != null && _fileNames!.isNotEmpty) ...[
                Text('Arquivos selecionados:'),
                SizedBox(height: 8.0),
                for (final name in _fileNames!) ...[
                  Text(name),
                  SizedBox(height: 8.0),
                ],
              ],
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final String fullName = _fullName.text;
                    final String cpf = _cpf.text;
                    final String endereco = _endereco.text;
                    final String email = _email.text;
                    final String celular = _celular.text;
                    final String telefone = _telefone.text;
                    final String descricao = _descricao.text;
                    final String assunto = _selectedSubject.text;
                    final String dataIncidente = _dataIncidente.text;
                    final String numPedido = _numPedido.text;
                    final String numRec = _numRec.text;
                    final String status = _status.text;
                    final List<String> fileNames = _fileNames?.iterator as List<String>;
                    final Reclamacao novaReclamacao = Reclamacao(
                        0,
                        fullName,
                        cpf,
                        endereco,
                        email,
                        celular,
                        telefone,
                        descricao,
                        assunto,
                        dataIncidente,
                        numPedido,
                        numRec,
                        status,
                        fileNames);
                    _reclamacaoDao.save(novaReclamacao).then((id) => Navigator.pop(context));
                    // do something with the form data
                    print('Nome completo: $_fullName');
                    print('CPF: $_cpf');
                    print('Endereço: $_endereco');
                    print('Celular: $_celular');
                    print('Telefone: $_telefone');
                    print('Assunto: $_selectedSubject');
                    print('Descrição: $_descricao');
                    print('Data do incidente: $_dataIncidente');
                    print('Número do Pedido: $_numPedido');
                    print('Número da reclamação: $_numRec');
                    print('Status: $_status');
                    print('Anexos: $_fileNames');
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()));
                  }
                },
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
