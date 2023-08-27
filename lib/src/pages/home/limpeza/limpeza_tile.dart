import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../config/app_routes.dart';
import '../../../constants/app_customs.dart';
import '../../../models/limpeza_list.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';
import '/src/models/limpeza_model.dart';

bool isAdmin = false;

class LimpezaTile extends StatelessWidget {
  const LimpezaTile(this.limpeza, {Key? key}) : super(key: key);
  final Limpeza limpeza;

  @override
  Widget build(BuildContext context) {
    List<Publicador> usuario = Provider.of<PublicadorList>(context).usuario;

    if (usuario.isNotEmpty) {
      isAdmin = usuario.first.nivel >= 5;
    }
    DateTime dataFinal = limpeza.date.add(const Duration(days: 4));
    return Card(
      margin: const EdgeInsets.all(5),
      color: CustomColors.tileBacgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            width: 90,
            child: Column(children: [
              Text(DateFormat("d 'de' MMMM", 'pt_BR').format(limpeza.date),
                  style: const TextStyle(fontSize: 12, color: Colors.indigo),
                  textAlign: TextAlign.center),
              Text(DateFormat("'e' d 'de' MMMM", 'pt_BR').format(dataFinal),
                  style: const TextStyle(fontSize: 12, color: Colors.indigo),
                  textAlign: TextAlign.center),
            ]),
          ),
          SizedBox(
            width: 180,
            child: Column(children: [
              Text(
                'Grupo ${limpeza.grupoName}',
                textAlign: TextAlign.center,
              ),
              Text(limpeza.descricaoAtividade,
                  style: const TextStyle(fontSize: 12, color: Colors.indigo),
                  textAlign: TextAlign.center),
            ]),
          ),
          isAdmin
              ? Column(
                  children: [
                    //Botão Editar
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.limpezaForm,
                              arguments: limpeza,
                            );
                          },
                          child: CustomIcons.editIconMini),
                    ),

                    //Botão Excluir
                    IconButton(
                        icon: CustomIcons.deleteIconMini,
                        color: CustomColors.softDeleteColor,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                      title: const Text('Excluir Registro'),
                                      content: const Text('Tem certeza?'),
                                      actions: [
                                        TextButton(
                                            child: const Text('NÃO'),
                                            onPressed: () =>
                                                Navigator.of(ctx).pop()),
                                        TextButton(
                                            child: const Text('SIM'),
                                            onPressed: () {
                                              Provider.of<LimpezaList>(context,
                                                      listen: false)
                                                  .removeData(limpeza);
                                              Navigator.of(ctx).pop();
                                            })
                                      ]));
                        }),
                  ],
                )
              : const SizedBox(),
        ]),
      ),
    );
  }
}
