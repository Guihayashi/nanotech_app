//import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nanotech_app/database/dao/reclamacao_dao.dart';
import 'package:nanotech_app/funcoes/logicas_adicionais.dart';
import 'package:nanotech_app/models/reclamacao.dart';
import 'dashboard.dart';
import 'package:open_file/open_file.dart';

class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _cpf = TextEditingController();
  final TextEditingController _endereco = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _celular = TextEditingController();
  final TextEditingController _telefone = TextEditingController();
  String? _selectedSubject;
  final List<String> _subjects = [
    'Pagamento',
    'Envio-Entrega',
    'Compra Protegida',
    'Outros'
  ];
  final TextEditingController _descricao = TextEditingController();
  TextEditingController _dataIncidente = TextEditingController();
  final TextEditingController _numPedido = TextEditingController();
  final TextEditingController _numRec = TextEditingController();
  String? _status;
  final List<String> _statusList = [
    'Novo',
    'Criado',
    'Em andamento',
    'Fechado'
  ];
  String? _anexos;
  final ReclamacaoDao _reclamacaoDao = ReclamacaoDao();

  //List<FilePickerResult>? _files = [];
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
  }

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
                    _selectedSubject = value;
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
                decoration: const InputDecoration(
                  labelText: 'Data do incidente*:',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                controller: _dataIncidente,
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));
                  if (null != selectedDate) {
                    setState(() {
                      _dataIncidente.text =
                          DateFormat('dd/MM/yyyy').format(selectedDate);
                    });
                  }
                },
                validator: (_dataIncidente) {
                  if (_dataIncidente == null || _dataIncidente.isEmpty) {
                    return 'Por favor, preencha a data do incidente.';
                  }

                  try {
                    DateFormat('dd/MM/yyyy').parseStrict(_dataIncidente);
                  } catch (e) {
                    return 'Data inválida.';
                  }
                  return null;
                },
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
                        _status = 'Novo';
                      });
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
                onPressed: pickMultipleFiles,
                child: Text('Anexar arquivo'),
              ),
              SizedBox(height: 16.0),
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
                    final String? assunto = _selectedSubject;
                    final String dataIncidente = _dataIncidente.text;
                    final String numPedido = _numPedido.text;
                    final String numRec = _numRec.text;
                    final String? status = _status;
                    final String? fileNames = _anexos;
                    final Reclamacao novaReclamacao = Reclamacao(
                        0,
                        fullName,
                        cpf,
                        endereco,
                        email,
                        celular,
                        telefone,
                        descricao,
                        assunto!,
                        dataIncidente,
                        numPedido,
                        numRec,
                        status!,
                        fileNames!);
                    _reclamacaoDao
                        .save(novaReclamacao)
                        .then((id) => Navigator.pop(context));
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
                    print('Anexos: $_anexos');
                    Navigator.push(context,
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

  void pickMultipleFiles() async {
    FilePickerResult? result;
    String? _fileName;
    PlatformFile? pickedfile;
    bool isLoading = false;
    File? fileToDisplay;
    try {
      setState(() {
        isLoading = true;
      });
      result = await FilePicker.platform.pickFiles(
          allowMultiple: true);

      if (result != null) {
        _fileName = result.files.first.name;
        pickedfile = result.files.first;
        fileToDisplay = File(pickedfile.path.toString());


        setState(() {
          _anexos = _anexos;
        });
      } else {
      return;  // User canceled the picker
      }
    } catch (e) {
      print(e);
    }
  }
}
