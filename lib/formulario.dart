import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();

  String? _fullName;
  String? _cpf;
  String? _selectedSubject;
  List<String> _subjects = [    'Pagamento',    'Envio-Entrega',    'Compra Protegida',    'Outros'  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome Completo*',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha seu nome completo.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _fullName = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'CPF*',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                  CpfInputFormatter(),
                ],
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha seu CPF.';
                  }
                  if (value.length < 14) {
                    return 'Por favor, preencha seu CPF completo.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cpf = value;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Assunto*',
                ),
                value: _selectedSubject,
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // do something with the form data
                    print('Nome completo: $_fullName');
                    print('CPF: $_cpf');
                    print('Assunto: $_selectedSubject');
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

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = _removeNonNumeric(newValue.text);
    if (text.length <= 3) {
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
    if (text.length <= 6) {
      return TextEditingValue(
        text: '${text.substring(0, 3)}.${text.substring(3)}',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }
    if (text.length <= 9) {
      return TextEditingValue(
        text:
        '${text.substring(0, 3)}.${text.substring(3, 6)}.${text.substring(6)}',
        selection: TextSelection.collapsed(offset: text.length + 2),
      );
    }
    return TextEditingValue(
      text:
      '${text.substring(0, 3)}.${text.substring(3, 6)}.${text.substring(6, 9)}-${text.substring(9)}',
      selection: TextSelection.collapsed(offset: text.length + 3),
    );
  }

  String _removeNonNumeric(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
