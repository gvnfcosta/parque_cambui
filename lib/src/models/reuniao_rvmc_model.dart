import 'package:flutter/material.dart';

class ReuniaoRvmc with ChangeNotifier {
  final String id;
  final DateTime date;
  final String presidente;
  final String tesouros;
  final String joias;

  final String leituraBiblia;
  final String primeiraMinisterioTema;
  final String primeiraMinisterioDesignado1;
  final String primeiraMinisterioDesignado2;
  final String segundaMinisterioTema;
  final String segundaMinisterioDesignado1;
  final String segundaMinisterioDesignado2;
  final String terceiraMinisterioTema;
  final String terceiraMinisterioDesignado1;
  final String terceiraMinisterioDesignado2;

  final String primeiraVidaCristaTema;
  final String primeiraVidaCristaDesignado;
  final String segundaVidaCristaTema;
  final String segundaVidaCristaDesignado;
  final String estudoBiblico;
  final String leituraEstudoBiblico;
  final String oracaoFinal;

  final String indicador1;
  final String indicador2;
  final String volante1;
  final String volante2;
  final String midias;
  final String rvmcUrl;

  ReuniaoRvmc({
    required this.id,
    required this.date,
    required this.presidente,
    required this.tesouros,
    required this.joias,
    required this.leituraBiblia,
    required this.primeiraMinisterioTema,
    required this.primeiraMinisterioDesignado1,
    required this.primeiraMinisterioDesignado2,
    required this.segundaMinisterioTema,
    required this.segundaMinisterioDesignado1,
    required this.segundaMinisterioDesignado2,
    required this.terceiraMinisterioTema,
    required this.terceiraMinisterioDesignado1,
    required this.terceiraMinisterioDesignado2,
    required this.primeiraVidaCristaTema,
    required this.primeiraVidaCristaDesignado,
    required this.segundaVidaCristaTema,
    required this.segundaVidaCristaDesignado,
    required this.estudoBiblico,
    required this.leituraEstudoBiblico,
    required this.oracaoFinal,
    required this.indicador1,
    required this.indicador2,
    required this.volante1,
    required this.volante2,
    required this.midias,
    required this.rvmcUrl,
  });
}
