import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parquecambui/src/models/anuncios_locais_list.dart';
import 'package:parquecambui/src/models/anuncios_locais_model.dart';
import 'package:provider/provider.dart';
import '../../../config/app_routes.dart';
import '../../../constants/app_customs.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';

bool isAdmin = false;

class AnunciosLocaisTile extends StatelessWidget {
  const AnunciosLocaisTile(this.anuncio, {Key? key}) : super(key: key);
  final AnunciosLocais anuncio;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    List<Publicador> usuario = Provider.of<PublicadorList>(context).usuario;

    if (usuario.isNotEmpty) {
      isAdmin = usuario.first.nivel >= 5;
    }
    return Card(
      color: CustomColors.tileBacgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: deviceSize.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat("dd/MM", 'pt_BR').format(anuncio.validade),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  anuncio.textoAnuncio,
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          isAdmin
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //Botão Editar
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.anunciosLocaisForm,
                            arguments: anuncio,
                          );
                        },
                        child: CustomIcons.editIcon),

                    //Botão Excluir
                    IconButton(
                        icon: CustomIcons.deleteIcon,
                        color: CustomColors.deleteColor,
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
                                              Provider.of<AnunciosLocaisList>(
                                                      context,
                                                      listen: false)
                                                  .removeData(anuncio);
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
