import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parquecambui/src/config/app_data.dart';
import 'package:parquecambui/src/config/app_routes.dart';
import 'package:parquecambui/src/models/publisher_cart_model.dart';
import 'package:provider/provider.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';
import '../../../constants/app_customs.dart';
import '../../common_widgets/custom_text_field.dart';

bool isAdmin = false;

class PublisherCartScreen extends StatelessWidget {
  const PublisherCartScreen(
      {super.key, required this.cart, required this.tipoTela});

  final PublisherCart cart;
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
        title: const Text('Transferir Equipamento'),
        actions: isAdmin && tipoTela == 2
            ? [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.publisherCartForm,
                      arguments: cart,
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
                          return PublisherCartScreen(
                            cart: cart,
                            tipoTela: tipoTela,
                          );
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    //  child: Hero(
                    //   tag: 'CartImage',
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: Image.network(publisherCartImage)),
                    //   ),
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
                                label: 'Equipamento',
                                initialValue: cart.cartName,
                                icon: Icons.kitchen_outlined,
                                readOnly: readOnly),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: SizedBox(
                              width: 160,
                              child: TextFormField(
                                initialValue: tipoTela == 0
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(cart.initialDate)
                                    : DateFormat('dd/MM/yyyy')
                                        .format(cart.finalDate),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.calendar_month),
                                  labelText: tipoTela == 0
                                      ? 'Data de Início'
                                      : 'Data Conclusão',
                                  labelStyle: (TextStyle(
                                    color: CustomColors.customContrastColor,
                                  )),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CustomTextField(
                          label: 'Observações',
                          icon: Icons.visibility_rounded,
                          initialValue: cart.observations,
                          readOnly: readOnly),
                      CustomTextField(
                          label: 'Anotações',
                          icon: Icons.note_alt,
                          initialValue: cart.observations,
                          readOnly: readOnly),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                          child: tipoTela == 0
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            AppRoutes.publisherCartBack,
                                            arguments: cart,
                                          );
                                        },
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'DEVOLVER EQUIPAMENTO',
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
                                                    AppRoutes.publisherCartSend,
                                                    arguments: cart,
                                                  );
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      'ENVIAR EQUIPAMENTO ',
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
                                                    AppRoutes.publisherCartSend,
                                                    arguments: cart,
                                                  );
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      'SOLICITAR EQUIPAMENTO ',
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
                                                        Colors.blue.shade800)),
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                AppRoutes.publisherCartSend,
                                                arguments: cart,
                                              );
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'ENVIAR EQUIPAMENTO ',
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
                                    ),
                        ),
                      ),
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
