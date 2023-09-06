import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_data.dart';
import '../models/publicador_model.dart';
import '../utils/utils.dart';

class PublicadorList with ChangeNotifier {
  final String _token;
  final String _email;

  List<Publicador> items2 = [];
  List<Publicador> get items => [...items2];
  List<Publicador> get publicadores => items2.toList();

  PublicadorList(this._token, this._email, this.items2);

  int get itemsCount => items2.length;

  List<Publicador> get usuario =>
      items2.where((element) => element.email == _email).toList();

  Publicador? get firstPub =>
      items2.firstWhereOrNull((element) => element.email == _email);

  String? get namePub => firstPub?.nome;
  int? get levelPub => firstPub?.nivel ?? 0;
  bool get isDirigente => (firstPub?.nivel ?? 0) == 3;
  bool get isPublisher => (firstPub?.nivel ?? 0) >= 2;

  Future<void> loadPublicador() async {
    items2.clear();

    final response =
        await http.get(Uri.parse('${Constants.baseUrl}/pub.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) async {
      items2.add(
        Publicador(
          id: dataId,
          nivel: dataDados['nivel'],
          nome: codificador(dataDados['nome'], false),
          email: codificador(dataDados['email'], false),
          privilegio: codificador(dataDados['privilegio'], false),
          grupo: dataDados['grupo'],
          leitorASentinela: dataDados['leitorASentinela'],
          leituraBiblia: dataDados['leituraBiblia'],
          conversaRevisita: dataDados['conversaRevisita'],
          discursoEstBiblico: dataDados['discursoEstBiblico'],
          leitorEstBiblico: dataDados['leitorEstBiblico'],
          indicador: dataDados['indicador'],
          volante: dataDados['volante'],
          midias: dataDados['midias'],
        ),
      );
    });
    notifyListeners();
  }
}
