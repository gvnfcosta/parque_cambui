import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parquecambui/src/config/app_data.dart';
import 'package:parquecambui/src/models/eventos/eventos.dart';

class EventoList with ChangeNotifier {
  final String _token;
  List<Eventos> _items;

  List<Eventos> get items => [..._items];

  EventoList(this._token, this._items);

  int get itemsCount => _items.length;

  Future<void> loadData() async {
    _items.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/eventos.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    _items = data.entries.map<Eventos>((entry) {
      return Eventos.fromMap(entry.value as Map<String, dynamic>);
    }).toList();
    // notifyListeners();
  }

  Future<void> saveClass(Eventos data) async {
    await addData(data);
  }

  Future<void> addData(Eventos item) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/eventos.json?auth=$_token'),
      body: jsonEncode(item.toMap()),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(item.copyWith(id: id));

    await http.patch(
      Uri.parse('${Constants.baseUrl}/eventos/$id.json?auth=$_token'),
      body: jsonEncode({'id': id}),
    );

    notifyListeners();
  }

  Future<void> updateData(Eventos item) async {
    int index = _items.indexWhere((p) => p.id == item.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.baseUrl}/eventos/${item.id}.json?auth=$_token'),
        body: jsonEncode(item.toMap()),
      );

      _items[index] = item;
      notifyListeners();
    }
  }

  Future<void> removeData(Eventos data) async {
    int index = _items.indexWhere((p) => p.id == data.id);

    if (index >= 0) {
      final item = _items[index];
      _items.remove(item);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/eventos/${item.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, item);
        notifyListeners();

        throw const HttpException('Não foi possível excluir o registro.');
      }
    }
  }
}
