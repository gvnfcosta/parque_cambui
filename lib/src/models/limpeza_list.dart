import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'limpeza_model.dart';
import '../config/app_data.dart';
import '../exceptions/http_exception.dart';

class LimpezaList with ChangeNotifier {
  final String _token;

  List<Limpeza> items2 = [];
  List<Limpeza> get items => [...items2];

  LimpezaList(this._token, this.items2);

  List<Limpeza> get vigentes => items2
      .where((element) => element.date
          .isAfter(DateTime.now().subtract(const Duration(days: 7))))
      .toList()
    ..sort(((a, b) => a.date.compareTo(b.date)));

  int get itemsCount => items2.length;

  Future<void> loadData() async {
    items2.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/limpeza.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items2.add(
        Limpeza(
          id: dataId,
          date: DateTime.parse(dataDados['date']),
          grupoName: dataDados['grupoName'],
          descricaoAtividade: dataDados['descricaoAtividade'],
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveData(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final limpeza = Limpeza(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      date: data['date'] as DateTime,
      grupoName: data['grupoName'] as String,
      descricaoAtividade: data['descricaoAtividade'] as String,
    );

    if (hasId) {
      return _updateData(limpeza);
    } else {
      return _addData(limpeza);
    }
  }

  Future<void> _addData(Limpeza limpeza) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/limpeza.json?auth=$_token'),
      body: jsonEncode({
        'id': limpeza.id,
        'date': limpeza.date.toIso8601String(),
        'grupoName': limpeza.grupoName,
        'descricaoAtividade': limpeza.descricaoAtividade,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    items2.add(Limpeza(
      id: id,
      date: limpeza.date,
      grupoName: limpeza.grupoName,
      descricaoAtividade: limpeza.descricaoAtividade,
    ));

    notifyListeners();
  }

  Future<void> _updateData(Limpeza limpeza) async {
    int index = items2.indexWhere((element) => element.id == limpeza.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.baseUrl}/limpeza/${limpeza.id}.json?auth=$_token'),
        body: jsonEncode({
          'date': limpeza.date.toIso8601String(),
          'grupoName': limpeza.grupoName,
          'descricaoAtividade': limpeza.descricaoAtividade,
        }),
      );

      items2[index] = limpeza;
      notifyListeners();
    }
  }

  Future<void> removeData(Limpeza limpeza) async {
    int index = items2.indexWhere((p) => p.id == limpeza.id);

    if (index >= 0) {
      final limpeza = items2[index];
      items2.remove(limpeza);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/limpeza/${limpeza.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        items2.insert(index, limpeza);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir registro.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
