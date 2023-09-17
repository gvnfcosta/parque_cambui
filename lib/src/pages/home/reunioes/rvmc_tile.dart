import '/src/models/reuniao_rvmc_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/src/pages/home/reunioes/rvmc_screen.dart';
import '../../../config/app_data.dart';

class RvmcTile extends StatelessWidget {
  const RvmcTile(this.reuniaoRvmc, {super.key});

  final ReuniaoRvmc reuniaoRvmc;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      //Conteúdo
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (c) {
                return RvmcScreen(reuniaoRvmc.date);
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
              Container(
                margin: const EdgeInsets.only(left: 5, top: 5),
                child: Row(
                  children: [
                    Text(DateFormat("dd").format((reuniaoRvmc.date)),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.blue)),
                    Text(
                        DateFormat(" MMMM", 'pt_BR').format((reuniaoRvmc.date)),
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
                child: Image.network(testemunhoImage),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
