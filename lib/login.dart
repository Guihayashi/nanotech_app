import 'package:flutter/material.dart';
import 'formulario.dart';

class LoginPage extends StatelessWidget {
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
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'CPF',
                ),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyForm()),
                );
                print('Botão pressionado!');
              },
            ),
          ],
        ),
      ]),
    );
  }
}
