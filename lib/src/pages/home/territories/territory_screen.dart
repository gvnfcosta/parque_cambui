import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';
import 'mapa_screen.dart';
import '../../../config/app_routes.dart';
import '../../../constants/app_customs.dart';
import '../../../models/territories_model.dart';
import '../../common_widgets/custom_text_field.dart';

bool isAdmin = false;

class TerritoryScreen extends StatelessWidget {
  const TerritoryScreen(
      {super.key, required this.territories, required this.tipoTela});

  final Territories territories;
  final int tipoTela;

  @override
  Widget build(BuildContext context) {
    List<Publicador> usuario = Provider.of<PublicadorList>(context).usuario;

    if (usuario.isNotEmpty) {
      isAdmin = (usuario.first.nivel == 4 || usuario.first.nivel > 7);
    }
    bool readOnly = true;

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      appBar: AppBar(
        backgroundColor: CustomColors.editAppBarBackgroundColor,
        title: const Text('Transferir Território'),
        actions: isAdmin && tipoTela == 2
            ? [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.territoriesForm,
                      arguments: territories,
                    );
                  },
                  child: SizedBox(width: 60, child: CustomIcons.editIcon),
                )
              ]
            : null,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (c) {
                          return MapaScreen(territories: territories);
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Hero(
                      tag: territories.url,
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: Image.network(territories.url)),
                    ),
                  ),
                ),
              ),
              Container(
                height: 350,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade600,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 18, 6, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                                label: 'Território ${territories.numero}',
                                initialValue: territories.nome,
                                icon: Icons.map,
                                readOnly: readOnly),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: SizedBox(
                              width: 140,
                              child: TextFormField(
                                // style: const TextStyle(fontSize: 12),
                                initialValue: tipoTela == 0
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(territories.dataInicio)
                                    : DateFormat('dd/MM/yyyy')
                                        .format(territories.dataConclusao),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.calendar_month),
                                  labelText:
                                      tipoTela == 0 ? 'Início' : 'Trabalhado',
                                  labelStyle: (TextStyle(
                                      color: CustomColors.customContrastColor)),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // CustomTextField(
                      //     label: 'Publicador',
                      //     initialValue: territories.publicador,
                      //     readOnly: readOnly),
                      CustomTextField(
                          label: 'Observações',
                          icon: Icons.visibility_rounded,
                          initialValue: territories.observacoes,
                          readOnly: readOnly),
                      CustomTextField(
                          label: 'Anotações',
                          icon: Icons.note_alt,
                          initialValue: territories.anotacoes,
                          readOnly: readOnly),
                      GestureDetector(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                              child: tipoTela == 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          width: 250,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.red.shade800)),
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                AppRoutes.territoriesBack,
                                                arguments: territories,
                                              );
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'DEVOLVER TERRITÓRIO',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      letterSpacing: 2),
                                                ),
                                                Icon(Icons.turn_left),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : tipoTela == 1
                                      ? isAdmin
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 40,
                                                  width: 260,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors.blue
                                                                    .shade800)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                        AppRoutes
                                                            .territoriesSend,
                                                        arguments: territories,
                                                      );
                                                    },
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          'ENVIAR TERRITÓRIO ',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              letterSpacing: 2),
                                                        ),
                                                        Icon(Icons
                                                            .arrow_forward),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 40,
                                                  width: 260,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors.blue
                                                                    .shade800)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                        AppRoutes
                                                            .territoriesSend,
                                                        arguments: territories,
                                                      );
                                                    },
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          'SOLICITAR TERRITÓRIO ',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              letterSpacing: 2),
                                                        ),
                                                        Icon(Icons.add_alert),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              width: 260,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.blue
                                                                .shade800)),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                    AppRoutes.territoriesSend,
                                                    arguments: territories,
                                                  );
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      'ENVIAR TERRITÓRIO ',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          letterSpacing: 2),
                                                    ),
                                                    Icon(Icons.arrow_forward),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
