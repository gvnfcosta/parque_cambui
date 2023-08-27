import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_data.dart';
import 'grupos_models.dart';

class GruposList with ChangeNotifier {
  final String _token;

  List<Grupos> items2 = [];
  List<Grupos> get items => [...items2];

  GruposList(this._token, this.items2);

  int get itemsCount => items2.length;

  Grupos? get firstGroup => items2.first;

  Future<void> loadGrupos() async {
    items2.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/grupos.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items2.add(
        Grupos(
          id: dataId,
          nome: dataDados['nome'],
        ),
      );
    });
    notifyListeners();
  }
}
