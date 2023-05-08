import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
//import 'package:file_picker/file_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

class oSessionManager {
  static final String _loggedInKey = "logged_in";
  static final String _usernameKey = "username";

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool isLoggedIn() {
    return _prefs.getBool(_loggedInKey) ?? false;
  }

  Future<void> setLoggedIn(bool loggedIn) async {
    await _prefs.setBool(_loggedInKey, loggedIn);
  }

  String getUsername() {
    return _prefs.getString(_usernameKey) ?? '';
  }

  Future<void> setUsername(String username) async {
    await _prefs.setString(_usernameKey, username);
  }

  Future<void> clearSession() async {
    await _prefs.clear();
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

class PhoneTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    // Remove tudo exceto números
    text = text.replaceAll(RegExp(r'[^\d]'), '');

    // Adiciona o DDD (xx) se o usuário já digitou o número do telefone
    if (text.length > 2 && text.length <= 10) {
      text = '(${text.substring(0, 2)}) ${text.substring(2)}';
    } else if (text.length > 10) {
      text =
      '(${text.substring(0, 2)}) ${text.substring(2, 6)}-${text.substring(6, 10)}';
    } else if (text.length == 10) {
      text =
      '(${text.substring(0, 2)}) ${text.substring(2, 6)}-${text.substring(6, 10)}';
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class CellphoneTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    // Remove tudo exceto números
    text = text.replaceAll(RegExp(r'[^\d]'), '');

    // Adiciona o DDD (xx) se o usuário já digitou o número do celular
    if (text.length > 2 && text.length <= 11) {
      text = '(${text.substring(0, 2)}) ${text.substring(2)}';
    } else if (text.length > 11) {
      text =
      '(${text.substring(0, 2)}) ${text.substring(2, 7)}-${text.substring(7, 11)}';
    } else if (text.length == 11) {
      text =
      '(${text.substring(0, 2)}) ${text.substring(2, 3)} ${text.substring(3, 7)}-${text.substring(7, 11)}';
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

TextEditingController _dataIncidenteController = TextEditingController();

String? formatarData(TextEditingController controller, String value) {
  final text = value;
  final newText = text.replaceAll(RegExp(r'[^0-9]'), '');
  final length = newText.length;

  if (length > 0 && length <= 2) {
    controller.text = newText.substring(0, length) + '/';
  } else if (length > 2 && length <= 4) {
    controller.text = newText.substring(0, 2) + '/' + newText.substring(2, length) + '/';
  } else if (length > 4 && length <= 8) {
    controller.text = newText.substring(0, 2) + '/' + newText.substring(2, 4) + '/' + newText.substring(4, length);
  } else if (length > 8) {
    controller.text = newText.substring(0, 2) + '/' + newText.substring(2, 4) + '/' + newText.substring(4, 8);
  }
  else{return '';}
}
Future<String> getNumeroReclamacao() async {
  final db = await openDatabase('my_db.db');
  final result = await db.query('reclamacoes', orderBy: 'id DESC', limit: 1);
  return result.isNotEmpty ? '#${result.first['id']}' : '';
}


