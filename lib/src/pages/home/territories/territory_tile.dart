import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parquecambui/src/pages/home/territories/mapa_screen.dart';
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: isTile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10, top: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            territories.numero,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, top: 3),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            territories.nome,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Hero(
                          tag: territories.url,
                          child:
                              Image.network(territories.url, fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                territories.numero,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                territories.nome,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            height: 35,
                            child: territories.publicador != 'sem_designação'
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        territories.publicador,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        DateFormat("'Início em ' d 'de' MMMM",
                                                'pt_BR')
                                            .format(territories.dataInicio),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat(
                                                "'Concluído em ' d 'de' MMMM",
                                                'pt_BR')
                                            .format(territories.dataConclusao),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),

      !isTile
          ? Positioned(
              top: 5,
              right: 15,
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
