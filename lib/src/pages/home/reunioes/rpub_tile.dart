import '/src/config/app_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/reuniao_publica_model.dart';
import 'rpub_screen.dart';

class ReuniaoPublicaTile extends StatelessWidget {
  const ReuniaoPublicaTile(this.reuniaoPublica, {super.key});
  final ReuniaoPublica reuniaoPublica;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      //Conteúdo
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (c) {
                return ReuniaoPublicaScreen(reuniaoPublica.date);
              },
            ),
          );
        },
        child: Card(
          color: Colors.grey[200],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Imagem
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.network(oradorImage),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat('dd/MM/yyyy').format((reuniaoPublica.date)),
                        style: TextStyle(
                            fontSize: 16, color: Colors.blue.shade900)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
