import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/servico_campo_list.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';
import '../../../models/servico_campo_model.dart';
import 'campo_tile.dart';

class CampoTab extends StatefulWidget {
  const CampoTab({super.key});

  @override
  State<CampoTab> createState() => _CampoTabState();
}

class _CampoTabState extends State<CampoTab> {
  bool _isLoading = true;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    Provider.of<PublicadorList>(context, listen: false)
        .loadPublicador()
        .then((value) => setState(() {
              _isLoading = false;
            }));

    Provider.of<CampoList>(context, listen: false).loadData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CampoList>(context);
    final double deviceSize = MediaQuery.of(context).size.width;
    final axisCount = deviceSize ~/ 200;

    final List<ServicoCampo> campo = provider.saidasAtuais;
    int qtdeItems = campo.length;

    List<Publicador> usuario = Provider.of<PublicadorList>(context).usuario;

    if (usuario.isNotEmpty) {
      _isAdmin = usuario.first.nivel >= 5;
    }

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Horários ',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey),
                      textAlign: TextAlign.center),
                  IconButton(
                      icon: const Icon(Icons.av_timer),
                      iconSize: 45,
                      color: Colors.blueGrey,
                      onPressed: () {
                        _myShowDialog();
                      }),
                  const SizedBox(width: 20),
                ],
              ),
              (qtdeItems > 0)
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: axisCount,
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 0,
                            childAspectRatio: _isAdmin ? 9 / 6 : 8 / 3,
                          ),
                          itemCount: qtdeItems,
                          itemBuilder: (_, index) {
                            return CampoTile(campo[index], _isAdmin);
                          },
                        ),
                      ),
                    )
                  : const Center(child: Text('NENHUMA ATIVIDADE ENCONTRADA')),
            ],
          );
  }

  _myShowDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          title: const Text(
            'Horários de Campo',
            style: TextStyle(color: Colors.black54),
          ),
          content: Container(
            height: 290,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                diaSemana(' Terças-feira', '9:00', 'NEY', Colors.grey.shade200),
                diaSemana(
                    'Quartas-feira', '9:00', 'CELSO', Colors.blueGrey.shade100),
                diaSemana(
                    'Quintas-feira', '9:00', 'VALDIR', Colors.grey.shade200),
                diaSemana(
                    'Quintas-feira', '15:30', 'ALEX', Colors.blueGrey.shade100),
                separator,
                diaSemana('Sábados', '9:15', 'SALÃO', Colors.grey.shade200),
                diaSemana(
                    'Domingos', '9:15', 'GRUPOS', Colors.blueGrey.shade100),
                separator,
                diaSemana('2º Domingo', '8:30', 'RURAL', Colors.grey.shade200),
                diaSemana(
                    'Feriados', '9:15', 'SALÃO', Colors.blueGrey.shade100),
              ],
            ),
          ),
          actions: [
            TextButton(
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => Navigator.of(ctx).pop()),
          ]),
    );
  }

  SizedBox separator = const SizedBox(height: 5);

  Container diaSemana(
      String dia, String hora, String dirigente, Color widgetColor) {
    return Container(
      color: widgetColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                dia,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              width: 50,
              child: Text(
                hora,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(
                dirigente,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
