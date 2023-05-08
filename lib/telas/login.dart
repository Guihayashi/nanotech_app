import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanotech_app/telas/formulario.dart';
import 'package:nanotech_app/funcoes/logicas_adicionais.dart';
import 'package:provider/provider.dart';

import '../funcoes/session_manager.dart';

class LoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login(BuildContext context) {
    // Here, you would normally make an API request to check the credentials
    // and retrieve the user data, but for this example we'll just assume the
    // user data is correct.
    String username = _usernameController.text;
    Provider.of<SessionManager>(context, listen: false).login(username);
    Navigator.pushReplacementNamed(context, 'LoginPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Stack(children: [
        Column(
          children: <Widget>[
            Container(
              color: Colors.blue,
              width: 130,
            ),
            Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  'assets/logo.jpeg',
                  height: 200,
                  width: 300,
                )),
            Container(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'CPF*',
                ),
                controller: _usernameController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                  CpfInputFormatter(),
                ],
                keyboardType: TextInputType.number,
                validator: (username) {
                  if (username == null || username.isEmpty) {
                    return 'Por favor, preencha seu CPF.';
                  }
                  if (username.length < 14) {
                    return 'Por favor, preencha seu CPF completo.';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Senha',
                ),
              ),
            ),
            ElevatedButton(
                child: Text('Login'),
                onPressed: () async {
                  _login(context);
                  if (_login == null)
                    {}
                },
                onLongPress: () {
                  print('Easter egg encontrado!');
                  print('passou aqui');

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyForm()),
                  );
                }),
          ],
        ),
      ]),
    );
  }
}
