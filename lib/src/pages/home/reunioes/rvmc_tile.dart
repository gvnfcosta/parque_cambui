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
              Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.network(testemunhoImage),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat("d/MM/yyyy", 'pt_BR').format((reuniaoRvmc.date)),
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xFF12202F)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
