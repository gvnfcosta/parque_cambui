import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'servico_campo_model.dart';
import '../config/app_data.dart';
import '../exceptions/http_exception.dart';
import '../utils/utils.dart';

class CampoList with ChangeNotifier {
  final String _token;
  List<ServicoCampo> items2 = [];

  List<ServicoCampo> get items => [...items2];

  CampoList(this._token, this.items2);

  List<ServicoCampo> get saidasAtuais => items2
      .where((element) => element.date
          .isAfter(DateTime.now().subtract(const Duration(days: 2))))
      .toList()
    ..sort(((a, b) => a.date.compareTo(b.date)));

  int get itemsCount => items2.length;

  Future<void> loadData() async {
    items2.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/field.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items2.add(
        ServicoCampo(
          id: dataId,
          date: DateTime.parse(dataDados['date']),
          hour: DateTime.parse(dataDados['hour']),
          dirigenteName: codificador(dataDados['dirigenteName'], false),
          territoriesName: dataDados['territoriesName'],
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveData(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final servicoCampo = ServicoCampo(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      date: data['date'] as DateTime,
      hour: data['hour'] as DateTime,
      dirigenteName: data['dirigenteName'] as String,
      territoriesName: data['territoriesName'] as String,
    );

    if (hasId) {
      return _updateData(servicoCampo);
    } else {
      return _addData(servicoCampo);
    }
  }

  Future<void> _addData(ServicoCampo servicoCampo) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/field.json?auth=$_token'),
      body: jsonEncode({
        'id': servicoCampo.id,
        'date': servicoCampo.date.toIso8601String(),
        'hour': servicoCampo.hour.toIso8601String(),
        'dirigenteName': codificador(servicoCampo.dirigenteName, true),
        'territoriesName': servicoCampo.territoriesName,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    items2.add(ServicoCampo(
      id: id,
      date: servicoCampo.date,
      hour: servicoCampo.hour,
      dirigenteName: servicoCampo.dirigenteName,
      territoriesName: servicoCampo.territoriesName,
    ));

    notifyListeners();
  }

  Future<void> _updateData(ServicoCampo servicoCampo) async {
    int index = items2.indexWhere((element) => element.id == servicoCampo.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.baseUrl}/field/${servicoCampo.id}.json?auth=$_token'),
        body: jsonEncode({
          'hour': servicoCampo.date.toIso8601String(),
          'dirigenteName': codificador(servicoCampo.dirigenteName, true),
          'territoriesName': servicoCampo.territoriesName,
        }),
      );

      items2[index] = servicoCampo;
      notifyListeners();
    }
  }

  Future<void> removeData(ServicoCampo servicoCampo) async {
    int index = items2.indexWhere((p) => p.id == servicoCampo.id);

    if (index >= 0) {
      final servicoCampo = items2[index];
      items2.remove(servicoCampo);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/field/${servicoCampo.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        items2.insert(index, servicoCampo);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir essa saída.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
