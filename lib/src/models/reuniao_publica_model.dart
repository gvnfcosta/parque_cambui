import 'package:flutter/material.dart';

class ReuniaoPublica with ChangeNotifier {
  final String id;
  final DateTime date;
  final String presidente;
  final String discursoTema;
  final String orador;
  final String congregacao;
  final String leitorASentinela;
  final String indicador1;
  final String indicador2;
  final String volante1;
  final String volante2;
  final String midias;
  final String wUrl;

  ReuniaoPublica({
    required this.id,
    required this.date,
    required this.presidente,
    required this.discursoTema,
    required this.orador,
    required this.congregacao,
    required this.leitorASentinela,
    required this.indicador1,
    required this.indicador2,
    required this.volante1,
    required this.volante2,
    required this.midias,
    required this.wUrl,
  });
}
