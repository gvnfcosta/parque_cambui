import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parquecambui/src/models/territories_model.dart';
import 'package:parquecambui/src/models/territories_list.dart';
import 'package:provider/provider.dart';
import '../../../config/app_routes.dart';
import '../../../constants/app_customs.dart';
import '../../../models/servico_campo_list.dart';
import '../../../models/servico_campo_model.dart';

class CampoTile extends StatefulWidget {
  final ServicoCampo campo;
  const CampoTile(this.campo, this._isAdmin, {Key? key}) : super(key: key);
  final bool _isAdmin;

  @override
  State<CampoTile> createState() => _CampoTileState();
}

String? territoryName;
//final bool _isLoading = false;

class _CampoTileState extends State<CampoTile> {
  @override
  void initState() {
    super.initState();

    Provider.of<TerritoriesList>(context, listen: false).loadData();
  }

  @override
  Widget build(BuildContext context) {
    List<Territories> territories =
        Provider.of<TerritoriesList>(context).items2;

    String territory = '';
    final List<Territories> territoriesPublicador = territories
        .where((element) => element.publicador == widget.campo.dirigenteName)
        .toList();

    if (territoriesPublicador.isNotEmpty) {
      territory = territoriesPublicador.first.nome;
    }

    DateFormat("EEEE", 'pt_BR').format(widget.campo.date) == 'domingo'
        ? territoryName = 'R U R A L'
        : territoryName = territory;

    return Card(
      color: CustomColors.tileBacgroundColor,
      elevation: 2,
      child:
          // _isLoading          ? const Center(child: CircularProgressIndicator())          :
          Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DateFormat('EEEE', 'pt_BR').format(widget.campo.date) ==
                          'domingo'
                      ? Text(
                          DateFormat("EEEE", 'pt_BR')
                                  .format(widget.campo.date)[0]
                                  .toUpperCase() +
                              DateFormat("EEEE", 'pt_BR')
                                  .format(widget.campo.date)
                                  .substring(1)
                                  .toLowerCase(),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.red),
                          textAlign: TextAlign.center)
                      : Text(
                          DateFormat("EEEE", 'pt_BR')
                                  .format(widget.campo.date)[0]
                                  .toUpperCase() +
                              DateFormat("EEEE", 'pt_BR')
                                  .format(widget.campo.date)
                                  .substring(1)
                                  .toLowerCase(),
                          style:
                              const TextStyle(fontSize: 11, color: Colors.blue),
                          textAlign: TextAlign.center),
                  Text(
                    DateFormat(", d 'de' MMMM", 'pt_BR')
                        .format(widget.campo.date),
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Text(
              widget.campo.dirigenteName.split(' ')[0],
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            Text(
              territoryName!,
              style: const TextStyle(fontSize: 11, color: Colors.orange),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: widget._isAdmin
                  ? [
                      Row(
                        children: [
                          //Botão Editar
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.campoForm,
                                  arguments: widget.campo,
                                );
                              },
                              child: CustomIcons.editIconMini),

                          //Botão Excluir
                          IconButton(
                              icon: CustomIcons.deleteIconMini,
                              onPressed: () {
                                _removeDialog(context);
                              }),
                        ],
                      )
                    ]
                  : [],
            ),
          ],
        ),
      ),
    );
  }

  _removeDialog(context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          title: const Text('Excluir Registro'),
          content: const Text('Tem certeza?'),
          actions: [
            TextButton(
                child: const Text('NÃO'),
                onPressed: () => Navigator.of(ctx).pop()),
            TextButton(
                child: const Text('SIM'),
                onPressed: () {
                  Provider.of<CampoList>(context, listen: false)
                      .removeData(widget.campo);
                  Navigator.of(ctx).pop();
                })
          ]),
    );
  }
}
