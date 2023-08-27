import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/limpeza_list.dart';
import '../../../models/limpeza_model.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';
import '../../../models/servico_campo_list.dart';
import 'limpeza_tile.dart';

class LimpezaTab extends StatefulWidget {
  const LimpezaTab({super.key});

  @override
  State<LimpezaTab> createState() => _LimpezaTabState();
}

bool _isAdmin = false;

class _LimpezaTabState extends State<LimpezaTab> {
  @override
  void initState() {
    super.initState();
    Provider.of<LimpezaList>(context, listen: false).loadData();
    Provider.of<CampoList>(context, listen: false).loadData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LimpezaList>(context);

    final List<Limpeza> limpezasVigentes = provider.vigentes;
    int itemsQtde = limpezasVigentes.length;

    List<Publicador> usuario = Provider.of<PublicadorList>(context).usuario;

    if (usuario.isNotEmpty) _isAdmin = usuario.first.nivel > 6;

    return (itemsQtde > 0)
        ? Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: itemsQtde,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return LimpezaTile(limpezasVigentes[index]);
                    },
                  ),
                ),
              ),
            ],
          )
        : const Center(child: SizedBox.shrink());
  }
}
