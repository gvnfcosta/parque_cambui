import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_data.dart';
import '../utils/utils.dart';
import 'territories_model.dart';

class TerritoriesList with ChangeNotifier {
  final String _token;
  List<Territories> items2 = [];
  List<Territories> get items => [...items2];
  TerritoriesList(this._token, this.items2);

  // List<Territories> get territories =>
  //     items2..sort(((a, b) => a.dataConclusao.compareTo(a.dataConclusao)));

  int get itemsCount => items2.length;

  Future<void> loadData() async {
    items2.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/territories.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items2.add(
        Territories(
            id: dataId,
            numero: dataDados['numero'],
            nome: dataDados['nome'],
            url: dataDados['url'],
            publicador: codificador(dataDados['publicador'], false),
            dataInicio: DateTime.parse(dataDados['dataInicio']),
            dataConclusao: DateTime.parse(dataDados['dataConclusao']),
            observacoes: dataDados['observacoes'],
            anotacoes: dataDados['anotacoes']),
      );
    });
    notifyListeners();
  }

  Future<void> saveData(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final territories = Territories(
        id: hasId ? data['id'] as String : (Random().nextDouble()).toString(),
        numero: data['numero'] as String,
        nome: data['nome'] as String,
        url: data['url'] as String,
        publicador: data['publicador'] as String,
        dataInicio: data['dataInicio'] as DateTime,
        dataConclusao: data['dataConclusao'] as DateTime,
        observacoes: data['observacoes'] as String,
        anotacoes: data['anotacoes'] as String);

    if (hasId) {
      return updateData(territories);
    } else {
      return _addData(territories);
    }
  }

  Future<void> _addData(Territories territories) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/territories.json?auth=$_token'),
      body: jsonEncode({
        'id': territories.id,
        'numero': territories.numero,
        'nome': territories.nome,
        'url': territories.url,
        'publicador': codificador(territories.publicador, true),
        'dataInicio': territories.dataInicio.toIso8601String(),
        'dataConclusao': territories.dataConclusao.toIso8601String(),
        'observacoes': territories.observacoes,
        'anotacoes': territories.anotacoes
      }),
    );

    final id = jsonDecode(response.body)['name'];
    items2.add(Territories(
        id: id,
        numero: territories.numero,
        nome: territories.nome,
        url: territories.url,
        publicador: territories.publicador,
        dataInicio: territories.dataInicio,
        dataConclusao: territories.dataConclusao,
        observacoes: territories.observacoes,
        anotacoes: territories.anotacoes));

    notifyListeners();
  }

  Future<void> updateData(Territories territories) async {
    int index = items2.indexWhere((p) => p.numero == territories.numero);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.baseUrl}/territories/${territories.id}.json?auth=$_token'),
        body: jsonEncode({
          'id': territories.id,
          'numero': territories.numero,
          'nome': territories.nome,
          'url': territories.url,
          'publicador': codificador(territories.publicador, true),
          'dataInicio': territories.dataInicio.toIso8601String(),
          'dataConclusao': territories.dataConclusao.toIso8601String(),
          'observacoes': territories.observacoes,
          'anotacoes': territories.anotacoes
        }),
      );

      items2[index] = territories;
      notifyListeners();
    }
  }
}
