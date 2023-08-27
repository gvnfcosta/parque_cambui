import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user_model.dart';
import '../config/app_data.dart';

class UserList with ChangeNotifier {
  final String _token;
  List<UserModel> items2 = [];
  List<UserModel> get items => [...items2];

  UserList(this._token, this.items2);

  Future<void> loadData() async {
    items2.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/users.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) {
      items2.add(
        UserModel(
          name: dataDados['name'],
          email: dataDados['email'],
          level: dataDados['level'],
        ),
      );
    });
  }

  Future<void> saveData(Map<String, Object> data) async {
    final user = UserModel(
      name: data['name'] as String,
      email: data['email'] as String,
      level: data['level'] as String,
    );

    return _addData(user);
  }

  Future<void> _addData(UserModel user) async {
    // final response = await http.post(
    //   Uri.parse('${Constants.baseUrl}/users.json?auth=$_token'),
    //   body: jsonEncode({
    //     'name': user.name,
    //     'email': user.email,
    //     'level': user.level,
    //   }),
    // );

    //final id = jsonDecode(response.body)['name'];
    items2.add(UserModel(
      name: user.name,
      email: user.email,
      level: user.level,
    ));
  }
}
