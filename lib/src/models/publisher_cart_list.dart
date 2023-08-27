import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parquecambui/src/models/publisher_cart_model.dart';
import '../config/app_data.dart';
import '../utils/utils.dart';

class PublisherCartList with ChangeNotifier {
  final String _token;
  List<PublisherCart> items_;
  List<PublisherCart> get items => [...items_];
  PublisherCartList(this._token, this.items_);

  int get itemsCount => items_.length;
  final idAleatorio = Random().nextDouble().toString();

  Future<void> loadData() async {
    items_.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/carts.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items_.add(
        PublisherCart(
            id: dataId,
            cartName: dataDados['cartName'],
            publisher: codificador(dataDados['publisher'], false),
            initialDate: DateTime.parse(dataDados['initialDate']),
            finalDate: DateTime.parse(dataDados['finalDate']),
            observations: dataDados['observations']),
      );
    });
    notifyListeners();
  }

  Future<void> saveData(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final cart = PublisherCart(
        id: hasId ? data['id'] as String : (Random().nextDouble()).toString(),
        cartName: data['cartName'] as String,
        publisher: data['publisher'] as String,
        initialDate: data['initialDate'] as DateTime,
        finalDate: data['finalDate'] as DateTime,
        observations: data['observations'] as String);

    if (hasId) {
      return updateData(cart);
    } else {
      return _addData(cart);
    }
  }

  Future<void> _addData(PublisherCart cart) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/carts.json?auth=$_token'),
      body: jsonEncode({
        'id': cart.id,
        'cartName': cart.cartName,
        'publisher': codificador(cart.publisher, true),
        'initialDate': cart.initialDate.toIso8601String(),
        'finalDate': cart.finalDate.toIso8601String(),
        'observations': cart.observations,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    items_.add(PublisherCart(
      id: id,
      cartName: cart.cartName,
      publisher: cart.publisher,
      initialDate: cart.initialDate,
      finalDate: cart.finalDate,
      observations: cart.observations,
    ));
    notifyListeners();
  }

  Future<void> updateData(PublisherCart cart) async {
    int index = items_.indexWhere((p) => p.cartName == cart.cartName);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.baseUrl}/carts/${cart.id}.json?auth=$_token'),
        body: jsonEncode({
          'id': cart.id,
          'cartName': cart.cartName,
          'publisher': codificador(cart.publisher, true),
          'initialDate': cart.initialDate.toIso8601String(),
          'finalDate': cart.finalDate.toIso8601String(),
          'observations': cart.observations,
        }),
      );

      items_[index] = cart;
      notifyListeners();
    }
  }
}
