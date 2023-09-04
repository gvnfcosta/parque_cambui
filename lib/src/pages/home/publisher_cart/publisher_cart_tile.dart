import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parquecambui/src/models/publisher_cart_model.dart';
import 'package:parquecambui/src/pages/home/publisher_cart/publisher_cart_screen.dart';
import '../../../constants/app_customs.dart';
import 'package:provider/provider.dart';

class PublisherCartTile extends StatelessWidget {
  const PublisherCartTile(
      {super.key, required this.isTile, required this.tipoTela});

  final bool isTile;
  final int tipoTela;

  @override
  Widget build(BuildContext context) {
    final carts = Provider.of<PublisherCart>(context);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) {
                  return PublisherCartScreen(
                    cart: carts,
                    tipoTela: tipoTela,
                  );
                },
              ),
            );
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: isTile
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Imagem
                        SizedBox(
                          height: 120,
                          child: Image.asset('assets/JwCart.png',
                              fit: BoxFit.contain),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(3, 0, 3, 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                carts.cartName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: (int.parse(carts.cartName.substring(
                                              carts.cartName.length - 1,
                                              carts.cartName.length)))
                                          .isOdd
                                      ? Colors.red
                                      : Colors.indigo,
                                ),
                              ),
                              Text(
                                carts.publisher == 'sem_designação'
                                    ? 'Salão do Reino'
                                    : carts.publisher,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.orange),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Hero(
                          //  tag: 'CartImage',
                          //child:
                          SizedBox(
                            height: 120,
                            child: Image.asset('assets/JwCart.png',
                                fit: BoxFit.contain),
                          ),
                          //   ),qq
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                carts.cartName,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: (int.parse(carts.cartName.substring(
                                              carts.cartName.length - 1,
                                              carts.cartName.length)))
                                          .isOdd
                                      ? Colors.red
                                      : Colors.indigo,
                                ),
                              ),
                              carts.publisher != 'sem_designação'
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          carts.publisher,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.orange,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          DateFormat(
                                                  "'Início em'\n d 'de' MMMM",
                                                  'pt_BR')
                                              .format(carts.initialDate),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                CustomColors.customSwatchColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Salão do Reino',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          DateFormat(
                                                  "'Concluído em'\n d 'de' MMMM",
                                                  'pt_BR')
                                              .format(carts.finalDate),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                CustomColors.customSwatchColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
