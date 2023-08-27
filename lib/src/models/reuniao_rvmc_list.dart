import 'dart:convert';
import 'dart:math';
import '/src/config/app_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../exceptions/http_exception.dart';
import '../utils/utils.dart';
import 'reuniao_rvmc_model.dart';

class ReuniaoRvmcList with ChangeNotifier {
  final String _token;
  final List<ReuniaoRvmc> _items2;
  List<ReuniaoRvmc> get items => [..._items2];

  ReuniaoRvmcList(this._token, this._items2);

  List<ReuniaoRvmc> get reunioesAtuais => _items2
      .where((element) => element.date
          .isAfter(DateTime.now().subtract(const Duration(days: 1))))
      .toList();

  int get itemsCount => _items2.length;

  Future<void> loadReuniaoRvmc() async {
    _items2.clear();

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/rvmc.json?auth=$_token'));

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((dataId, dataDados) async {
      _items2.add(
        ReuniaoRvmc(
          id: dataId,
          date: DateTime.parse(dataDados['date']),
          presidente: codificador(dataDados['presidente'], false),
          tesouros: codificador(dataDados['tesouros'], false),
          joias: codificador(dataDados['joias'], false),
          leituraBiblia: codificador(dataDados['leituraBiblia'], false),
          primeiraMinisterioTema: dataDados['primeiraMinisterioTema'],
          primeiraMinisterioDesignado1:
              codificador(dataDados['primeiraMinisterioDesignado1'], false),
          primeiraMinisterioDesignado2:
              codificador(dataDados['primeiraMinisterioDesignado2'], false),
          segundaMinisterioTema: dataDados['segundaMinisterioTema'],
          segundaMinisterioDesignado1:
              codificador(dataDados['segundaMinisterioDesignado1'], false),
          segundaMinisterioDesignado2:
              codificador(dataDados['segundaMinisterioDesignado2'], false),
          terceiraMinisterioTema: dataDados['terceiraMinisterioTema'],
          terceiraMinisterioDesignado1:
              codificador(dataDados['terceiraMinisterioDesignado1'], false),
          terceiraMinisterioDesignado2:
              codificador(dataDados['terceiraMinisterioDesignado2'], false),
          primeiraVidaCristaTema: dataDados['primeiraVidaCristaTema'],
          primeiraVidaCristaDesignado:
              codificador(dataDados['primeiraVidaCristaDesignado'], false),
          segundaVidaCristaTema: dataDados['segundaVidaCristaTema'],
          segundaVidaCristaDesignado:
              codificador(dataDados['segundaVidaCristaDesignado'], false),
          estudoBiblico: codificador(dataDados['estudoBiblico'], false),
          leituraEstudoBiblico:
              codificador(dataDados['leituraEstudoBiblico'], false),
          oracaoFinal: codificador(dataDados['oracaoFinal'], false),
          indicador1: codificador(dataDados['indicador1'], false),
          indicador2: codificador(dataDados['indicador2'], false),
          volante1: codificador(dataDados['volante1'], false),
          volante2: codificador(dataDados['volante2'], false),
          midias: codificador(dataDados['midias'], false),
          rvmcUrl: dataDados['rvmcUrl'],
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveReuniaoRvmc(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final reuniaoRvmc = ReuniaoRvmc(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      date: data['date'] as DateTime,
      presidente: data['presidente'] as String,
      tesouros: data['tesouros'] as String,
      joias: data['joias'] as String,
      leituraBiblia: data['leituraBiblia'] as String,
      primeiraMinisterioTema: data['primeiraMinisterioTema'] as String,
      primeiraMinisterioDesignado1:
          data['primeiraMinisterioDesignado1'] as String,
      primeiraMinisterioDesignado2:
          data['primeiraMinisterioDesignado2'] as String,
      segundaMinisterioTema: data['segundaMinisterioTema'] as String,
      segundaMinisterioDesignado1:
          data['segundaMinisterioDesignado1'] as String,
      segundaMinisterioDesignado2:
          data['segundaMinisterioDesignado2'] as String,
      terceiraMinisterioTema: data['terceiraMinisterioTema'] as String,
      terceiraMinisterioDesignado1:
          data['terceiraMinisterioDesignado1'] as String,
      terceiraMinisterioDesignado2:
          data['terceiraMinisterioDesignado2'] as String,
      primeiraVidaCristaTema: data['primeiraVidaCristaTema'] as String,
      primeiraVidaCristaDesignado:
          data['primeiraVidaCristaDesignado'] as String,
      segundaVidaCristaTema: data['segundaVidaCristaTema'] as String,
      segundaVidaCristaDesignado: data['segundaVidaCristaDesignado'] as String,
      estudoBiblico: data['estudoBiblico'] as String,
      leituraEstudoBiblico: data['leituraEstudoBiblico'] as String,
      oracaoFinal: data['oracaoFinal'] as String,
      indicador1: data['indicador1'] as String,
      indicador2: data['indicador2'] as String,
      volante1: data['volante1'] as String,
      volante2: data['volante2'] as String,
      midias: data['midias'] as String,
      rvmcUrl: testemunhoImage,
      //rvmcUrl: data['rvmcUrl'] as String,
    );

    if (hasId) {
      return _updateDados(reuniaoRvmc);
    } else {
      return _addDados(reuniaoRvmc);
    }
  }

  Future<void> _addDados(ReuniaoRvmc reuniaoRvmc) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/rvmc.json?auth=$_token'),
      body: jsonEncode({
        'id': reuniaoRvmc.id,
        'date': reuniaoRvmc.date.toIso8601String(),
        'presidente': codificador(reuniaoRvmc.presidente, true),
        'tesouros': codificador(reuniaoRvmc.tesouros, true),
        'joias': codificador(reuniaoRvmc.joias, true),
        'leituraBiblia': codificador(reuniaoRvmc.leituraBiblia, true),
        'primeiraMinisterioTema': reuniaoRvmc.primeiraMinisterioTema,
        'primeiraMinisterioDesignado1':
            codificador(reuniaoRvmc.primeiraMinisterioDesignado1, true),
        'primeiraMinisterioDesignado2':
            codificador(reuniaoRvmc.primeiraMinisterioDesignado2, true),
        'segundaMinisterioTema': reuniaoRvmc.segundaMinisterioTema,
        'segundaMinisterioDesignado1':
            codificador(reuniaoRvmc.segundaMinisterioDesignado1, true),
        'segundaMinisterioDesignado2':
            codificador(reuniaoRvmc.segundaMinisterioDesignado2, true),
        'terceiraMinisterioTema': reuniaoRvmc.terceiraMinisterioTema,
        'terceiraMinisterioDesignado1':
            codificador(reuniaoRvmc.terceiraMinisterioDesignado1, true),
        'terceiraMinisterioDesignado2':
            codificador(reuniaoRvmc.terceiraMinisterioDesignado2, true),
        'primeiraVidaCristaTema': reuniaoRvmc.primeiraVidaCristaTema,
        'primeiraVidaCristaDesignado':
            codificador(reuniaoRvmc.primeiraVidaCristaDesignado, true),
        'segundaVidaCristaTema': reuniaoRvmc.segundaVidaCristaTema,
        'segundaVidaCristaDesignado':
            codificador(reuniaoRvmc.segundaVidaCristaDesignado, true),
        'estudoBiblico': codificador(reuniaoRvmc.estudoBiblico, true),
        'leituraEstudoBiblico':
            codificador(reuniaoRvmc.leituraEstudoBiblico, true),
        'oracaoFinal': codificador(reuniaoRvmc.oracaoFinal, true),
        'indicador1': codificador(reuniaoRvmc.indicador1, true),
        'indicador2': codificador(reuniaoRvmc.indicador2, true),
        'volante1': codificador(reuniaoRvmc.volante1, true),
        'volante2': codificador(reuniaoRvmc.volante2, true),
        'midias': codificador(reuniaoRvmc.midias, true),
        'rvmcUrl': reuniaoRvmc.rvmcUrl,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    _items2.add(ReuniaoRvmc(
      id: id,
      date: reuniaoRvmc.date,
      presidente: reuniaoRvmc.presidente,
      tesouros: reuniaoRvmc.tesouros,
      joias: reuniaoRvmc.joias,
      leituraBiblia: reuniaoRvmc.leituraBiblia,
      primeiraMinisterioTema: reuniaoRvmc.primeiraMinisterioTema,
      primeiraMinisterioDesignado1: reuniaoRvmc.primeiraMinisterioDesignado1,
      primeiraMinisterioDesignado2: reuniaoRvmc.primeiraMinisterioDesignado2,
      segundaMinisterioTema: reuniaoRvmc.segundaMinisterioTema,
      segundaMinisterioDesignado1: reuniaoRvmc.segundaMinisterioDesignado1,
      segundaMinisterioDesignado2: reuniaoRvmc.segundaMinisterioDesignado2,
      terceiraMinisterioTema: reuniaoRvmc.terceiraMinisterioTema,
      terceiraMinisterioDesignado1: reuniaoRvmc.terceiraMinisterioDesignado1,
      terceiraMinisterioDesignado2: reuniaoRvmc.terceiraMinisterioDesignado2,
      primeiraVidaCristaTema: reuniaoRvmc.primeiraVidaCristaTema,
      primeiraVidaCristaDesignado: reuniaoRvmc.primeiraVidaCristaDesignado,
      segundaVidaCristaTema: reuniaoRvmc.segundaVidaCristaTema,
      segundaVidaCristaDesignado: reuniaoRvmc.segundaVidaCristaDesignado,
      estudoBiblico: reuniaoRvmc.estudoBiblico,
      leituraEstudoBiblico: reuniaoRvmc.leituraEstudoBiblico,
      oracaoFinal: reuniaoRvmc.oracaoFinal,
      indicador1: reuniaoRvmc.indicador1,
      indicador2: reuniaoRvmc.indicador2,
      volante1: reuniaoRvmc.volante1,
      volante2: reuniaoRvmc.volante2,
      midias: reuniaoRvmc.midias,
      rvmcUrl: reuniaoRvmc.rvmcUrl,
    ));
    notifyListeners();
  }

  Future<void> _updateDados(ReuniaoRvmc reuniaoRvmc) async {
    int index = _items2.indexWhere((element) => element.id == reuniaoRvmc.id);

    if (index >= 0) {
      http.patch(
        Uri.parse(
            '${Constants.baseUrl}/rvmc/${reuniaoRvmc.id}.json?auth=$_token'),
        body: jsonEncode({
          'presidente': codificador(reuniaoRvmc.presidente, true),
          'tesouros': codificador(reuniaoRvmc.tesouros, true),
          'joias': codificador(reuniaoRvmc.joias, true),
          'leituraBiblia': codificador(reuniaoRvmc.leituraBiblia, true),

          'primeiraMinisterioTema': reuniaoRvmc.primeiraMinisterioTema,
          'primeiraMinisterioDesignado1':
              codificador(reuniaoRvmc.primeiraMinisterioDesignado1, true),
          'primeiraMinisterioDesignado2':
              codificador(reuniaoRvmc.primeiraMinisterioDesignado2, true),

          'segundaMinisterioTema': reuniaoRvmc.segundaMinisterioTema,
          'segundaMinisterioDesignado1':
              codificador(reuniaoRvmc.segundaMinisterioDesignado1, true),
          'segundaMinisterioDesignado2':
              codificador(reuniaoRvmc.segundaMinisterioDesignado2, true),

          'terceiraMinisterioTema': reuniaoRvmc.terceiraMinisterioTema,
          'terceiraMinisterioDesignado1':
              codificador(reuniaoRvmc.terceiraMinisterioDesignado1, true),
          'terceiraMinisterioDesignado2':
              codificador(reuniaoRvmc.terceiraMinisterioDesignado2, true),

          'primeiraVidaCristaTema': reuniaoRvmc.primeiraVidaCristaTema,
          'primeiraVidaCristaDesignado':
              codificador(reuniaoRvmc.primeiraVidaCristaDesignado, true),

          'segundaVidaCristaTema': reuniaoRvmc.segundaVidaCristaTema,
          'segundaVidaCristaDesignado':
              codificador(reuniaoRvmc.segundaVidaCristaDesignado, true),

          'estudoBiblico': codificador(reuniaoRvmc.estudoBiblico, true),
          'leituraEstudoBiblico':
              codificador(reuniaoRvmc.leituraEstudoBiblico, true),
          'oracaoFinal': codificador(reuniaoRvmc.oracaoFinal, true),

          'indicador1': codificador(reuniaoRvmc.indicador1, true),
          'indicador2': codificador(reuniaoRvmc.indicador2, true),

          'volante1': codificador(reuniaoRvmc.volante1, true),
          'volante2': codificador(reuniaoRvmc.volante2, true),

          'midias': codificador(reuniaoRvmc.midias, true),
          //'rvmcUrl': reuniaoRvmc.rvmcUrl,
        }),
      );

      _items2[index] = reuniaoRvmc;
      notifyListeners();
    }
  }

  Future<void> removeRvmc(ReuniaoRvmc reuniaoRvmc) async {
    int index = _items2.indexWhere((p) => p.id == reuniaoRvmc.id);

    if (index >= 0) {
      final reuniaoRvmc = _items2[index];
      _items2.remove(reuniaoRvmc);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/rvmc/${reuniaoRvmc.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items2.insert(index, reuniaoRvmc);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir essa reunião.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
