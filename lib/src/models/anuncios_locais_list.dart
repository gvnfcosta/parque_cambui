import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'anuncios_locais_model.dart';
import '../config/app_data.dart';
import '../exceptions/http_exception.dart';

class AnunciosLocaisList with ChangeNotifier {
  final String _token;

  List<AnunciosLocais> items2 = [];
  List<AnunciosLocais> get items => [...items2];

  AnunciosLocaisList(this._token, this.items2);

  List<AnunciosLocais> get anunciosAtuais => items2
      .where((element) => element.validade
          .isAfter(DateTime.now().subtract(const Duration(days: 30))))
      .toList()
    ..sort(((b, a) => a.validade.compareTo(b.validade)));

  int get itemsCount => items2.length;

  Future<void> loadData() async {
    items2.clear();

    final response = await http.get(
        Uri.parse('${Constants.baseUrl}/anunciosLocais.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items2.add(
        AnunciosLocais(
          id: dataId,
          textoAnuncio: dataDados['textoAnuncio'],
          validade: DateTime.parse(dataDados['validade']),
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveData(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final anuncio = AnunciosLocais(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      textoAnuncio: data['textoAnuncio'] as String,
      validade: data['validade'] as DateTime,
    );

    if (hasId) {
      return _updateData(anuncio);
    } else {
      return _addData(anuncio);
    }
  }

  Future<void> _addData(AnunciosLocais anuncio) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/anunciosLocais.json?auth=$_token'),
      body: jsonEncode({
        'id': anuncio.id,
        'textoAnuncio': anuncio.textoAnuncio,
        'validade': anuncio.validade.toIso8601String(),
      }),
    );

    final id = jsonDecode(response.body)['name'];
    items2.add(AnunciosLocais(
      id: id,
      textoAnuncio: anuncio.textoAnuncio,
      validade: anuncio.validade,
    ));

    notifyListeners();
  }

  Future<void> _updateData(AnunciosLocais anuncio) async {
    int index = items2.indexWhere((element) => element.id == anuncio.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.baseUrl}/anunciosLocais/${anuncio.id}.json?auth=$_token'),
        body: jsonEncode({
          'textoAnuncio': anuncio.textoAnuncio,
          // 'validade': anuncio.validade.toIso8601String(),
        }),
      );

      items2[index] = anuncio;
      notifyListeners();
    }
  }

  Future<void> removeData(AnunciosLocais anuncio) async {
    int index = items2.indexWhere((p) => p.id == anuncio.id);

    if (index >= 0) {
      final anuncio = items2[index];
      items2.remove(anuncio);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/anunciosLocais/${anuncio.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        items2.insert(index, anuncio);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir registro.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
