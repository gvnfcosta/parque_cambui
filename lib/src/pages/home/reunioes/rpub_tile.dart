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
              builder: (c) => ReuniaoPublicaScreen(reuniaoPublica.date),
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
              Container(
                margin: const EdgeInsets.only(left: 5, top: 5),
                child: Row(
                  children: [
                    Text(DateFormat("dd").format((reuniaoPublica.date)),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.blue)),
                    Text(
                        DateFormat(" MMMM", 'pt_BR')
                            .format((reuniaoPublica.date)),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.blue)),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.network(oradorImage),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
