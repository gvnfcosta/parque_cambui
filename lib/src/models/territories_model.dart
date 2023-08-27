import 'package:flutter/material.dart';

class Territories with ChangeNotifier {
  String id;
  String numero;
  String nome;
  String url;
  String publicador;
  DateTime dataInicio;
  DateTime dataConclusao;
  String observacoes;
  String anotacoes;

  Territories({
    required this.id,
    required this.numero,
    required this.nome,
    required this.url,
    required this.publicador,
    required this.dataInicio,
    required this.dataConclusao,
    required this.observacoes,
    required this.anotacoes,
  });

  void onSaved() {
    notifyListeners();
  }
}
