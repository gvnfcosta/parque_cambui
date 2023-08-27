import 'package:flutter/material.dart';
import 'package:parquecambui/src/constants/app_customs.dart';
import '../../../models/publicador_model.dart';

class PublicadorItem extends StatelessWidget {
  final Publicador publicador;
  const PublicadorItem(this.publicador, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color corPublicador = CustomColors.tileBacgroundColor;

    if (publicador.privilegio == 'Ancião') {
      corPublicador = Colors.deepOrange.shade100;
    }
    if (publicador.privilegio == 'Servo Ministerial') {
      corPublicador = Colors.blue.shade100;
    }
    if (publicador.privilegio == 'Pioneiro Regular') {
      corPublicador = Colors.green.shade100;
    }

    return Card(
      color: corPublicador,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              publicador.nome,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
            Text(
              publicador.privilegio,
              style: const TextStyle(fontSize: 9),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
