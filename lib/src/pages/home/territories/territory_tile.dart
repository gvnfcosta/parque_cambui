import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parquecambui/src/pages/home/territories/mapa_screen.dart';
import '../../../constants/app_customs.dart';
import 'package:provider/provider.dart';
import '../../../models/territories_model.dart';
import 'territory_screen.dart';

class TerritoryTile extends StatelessWidget {
  const TerritoryTile(
      {super.key,
      required this.isTile,
      required this.tipoTela,
      required this.isPublicador});

  final bool isTile;
  final bool isPublicador;
  final int tipoTela;

  @override
  Widget build(BuildContext context) {
    final territories = Provider.of<Territories>(context);

    return Stack(children: [
      //Conteúdo
      GestureDetector(
        onTap: () {
          !isPublicador
              ? Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (c) {
                      return TerritoryScreen(
                        territories: territories,
                        tipoTela: tipoTela,
                      );
                    },
                  ),
                )
              : Navigator.of(context).push(MaterialPageRoute(
                  builder: (c) => MapaScreen(territories: territories)));
        },
        child: Card(
          elevation: 2,
          //shadowColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: isTile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //Imagem
                      Expanded(
                        child: Hero(
                          tag: territories.url,
                          child: Image.network(territories.url,
                              fit: BoxFit.contain),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3, 0, 3, 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              territories.numero,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              territories.nome,
                              style: TextStyle(
                                fontSize: 10,
                                color: CustomColors.customSwatchColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(3, 0, 3, 3),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                territories.numero,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.customSwatchColor,
                                ),
                              ),
                              Text(
                                territories.nome,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: CustomColors.customSwatchColor,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: territories.publicador != 'sem_designação'
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      territories.publicador,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      DateFormat("'Início em ' d 'de' MMMM",
                                              'pt_BR')
                                          .format(territories.dataInicio),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: CustomColors.customSwatchColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat("'Concluído em ' d 'de' MMMM",
                                              'pt_BR')
                                          .format(territories.dataConclusao),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: CustomColors.customSwatchColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),

      //Botão
      !isTile
          ? Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) => MapaScreen(territories: territories)));
                },
                child: SizedBox(
                  height: tipoTela < 2 ? 55 : 60,
                  child: Hero(
                      tag: territories.url,
                      child:
                          Image.network(territories.url, fit: BoxFit.contain)),
                ),
              ),
            )
          : const SizedBox.shrink(),
    ]);
  }
}
