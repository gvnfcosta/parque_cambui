import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_data.dart';
import '../exceptions/http_exception.dart';
import '../utils/utils.dart';
import 'reuniao_publica_model.dart';

class ReuniaoPublicaList with ChangeNotifier {
  final String _token;
  final List<ReuniaoPublica> _items2;
  List<ReuniaoPublica> get items => [..._items2];

  ReuniaoPublicaList(this._token, this._items2);

  List<ReuniaoPublica> get reunioesAtuais => _items2
      .where((element) => element.date
          .isAfter(DateTime.now().subtract(const Duration(days: 1))))
      .toList()
    ..sort(((a, b) => a.date.compareTo(b.date)));

  int get itemsCount => _items2.length;

  Future<void> loadReuniaoPublica() async {
    _items2.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/rpub.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      _items2.add(
        ReuniaoPublica(
          id: dataId,
          date: DateTime.parse(dataDados['date']),
          presidente: codificador(dataDados['presidente'], false),
          discursoTema: dataDados['discursoTema'],
          orador: codificador(dataDados['orador'], false),
          congregacao: dataDados['congregacao'],
          leitorASentinela: codificador(dataDados['leitorASentinela'], false),
          indicador1: codificador(dataDados['indicador1'], false),
          indicador2: codificador(dataDados['indicador2'], false),
          volante1: codificador(dataDados['volante1'], false),
          volante2: codificador(dataDados['volante2'], false),
          midias: codificador(dataDados['midias'], false),
          wUrl: dataDados['wUrl'],
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveReuniaoPublica(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final reuniaoPublica = ReuniaoPublica(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      date: data['date'] as DateTime,
      presidente: data['presidente'] as String,
      discursoTema: data['discursoTema'] as String,
      orador: data['orador'] as String,
      congregacao: data['congregacao'] as String,
      leitorASentinela: data['leitorASentinela'] as String,
      indicador1: data['indicador1'] as String,
      indicador2: data['indicador2'] as String,
      volante1: data['volante1'] as String,
      volante2: data['volante2'] as String,
      midias: data['midias'] as String,
      wUrl: testemunhoImage,
      //wUrl: data['wUrl'] as String,
    );

    if (hasId) {
      return _updateDados(reuniaoPublica);
    } else {
      return _addDados(reuniaoPublica);
    }
  }

  Future<void> _addDados(ReuniaoPublica reuniaoPublica) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/rpub.json?auth=$_token'),
      body: jsonEncode({
        'id': reuniaoPublica.id,
        'date': reuniaoPublica.date.toIso8601String(),
        'presidente': codificador(reuniaoPublica.presidente, true),
        'discursoTema': reuniaoPublica.discursoTema,
        'orador': codificador(reuniaoPublica.orador, true),
        'congregacao': reuniaoPublica.congregacao,
        'leitorASentinela': codificador(reuniaoPublica.leitorASentinela, true),
        'indicador1': codificador(reuniaoPublica.indicador1, true),
        'indicador2': codificador(reuniaoPublica.indicador2, true),
        'volante1': codificador(reuniaoPublica.volante1, true),
        'volante2': codificador(reuniaoPublica.volante2, true),
        'midias': codificador(reuniaoPublica.midias, true),
        'wUrl': reuniaoPublica.wUrl,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    _items2.add(ReuniaoPublica(
      id: id,
      date: reuniaoPublica.date,
      presidente: reuniaoPublica.presidente,
      discursoTema: reuniaoPublica.discursoTema,
      orador: reuniaoPublica.orador,
      congregacao: reuniaoPublica.congregacao,
      leitorASentinela: reuniaoPublica.leitorASentinela,
      indicador1: reuniaoPublica.indicador1,
      indicador2: reuniaoPublica.indicador2,
      volante1: reuniaoPublica.volante1,
      volante2: reuniaoPublica.volante2,
      midias: reuniaoPublica.midias,
      wUrl: reuniaoPublica.wUrl,
    ));

    notifyListeners();
  }

  Future<void> _updateDados(ReuniaoPublica reuniaoPublica) async {
    int index =
        _items2.indexWhere((element) => element.id == reuniaoPublica.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.baseUrl}/rpub/${reuniaoPublica.id}.json?auth=$_token'),
        body: jsonEncode({
          // 'date': reuniaoPublica.date.toIso8601String(),
          'presidente': codificador(reuniaoPublica.presidente, true),
          'discursoTema': reuniaoPublica.discursoTema,
          'orador': codificador(reuniaoPublica.orador, true),
          'congregacao': reuniaoPublica.congregacao,
          'leitorASentinela':
              codificador(reuniaoPublica.leitorASentinela, true),
          'indicador1': codificador(reuniaoPublica.indicador1, true),
          'indicador2': codificador(reuniaoPublica.indicador2, true),
          'volante1': codificador(reuniaoPublica.volante1, true),
          'volante2': codificador(reuniaoPublica.volante2, true),
          'midias': codificador(reuniaoPublica.midias, true),
          // 'wUrl': reuniaoPublica.wUrl,
        }),
      );

      _items2[index] = reuniaoPublica;
      notifyListeners();
    }
  }

  Future<void> removeRPub(ReuniaoPublica reuniaoPublica) async {
    int index = _items2.indexWhere((p) => p.id == reuniaoPublica.id);

    if (index >= 0) {
      final reuniaoPublica = _items2[index];
      _items2.remove(reuniaoPublica);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/rpub/${reuniaoPublica.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items2.insert(index, reuniaoPublica);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir essa reunião.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
