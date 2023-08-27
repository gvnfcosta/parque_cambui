import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:parquecambui/src/models/grupos_models.dart';
import 'package:provider/provider.dart';
import '../../../../models/grupos_list.dart';
import '../../../../models/publicador_list.dart';
import '../../../../models/publicador_model.dart';
import '../publicador_item.dart';

class GruposTab extends StatefulWidget {
  const GruposTab({super.key});

  @override
  State<GruposTab> createState() => _GruposTabState();
}

String? selectedGrupo;

class _GruposTabState extends State<GruposTab> {
  @override
  void initState() {
    super.initState();
    Provider.of<GruposList>(context, listen: false).loadGrupos();
  }

  @override
  Widget build(BuildContext context) {
    List<Grupos> grupos = Provider.of<GruposList>(context).items2;

    if (grupos.isNotEmpty) selectedGrupo = selectedGrupo ?? grupos.first.nome;

    final double deviceSize = MediaQuery.of(context).size.width;
    final axisCount = deviceSize ~/ 160;

    final List<Publicador> publicadores = Provider.of<PublicadorList>(context)
        .publicadores
      ..sort(
          ((a, b) => a.nome.split(' ').last.compareTo(b.nome.split(' ').last)));

    List<Publicador> designados = publicadores
        .where((publicador) =>
            publicador.grupo == selectedGrupo &&
            publicador.privilegio != 'Inativo')
        .toList();

    return Scaffold(
      body: (grupos.isNotEmpty)
          ? Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 1,
                        spreadRadius: 1,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  height: 40,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Grupo: ',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        DropdownButtonHideUnderline(
                          child: SizedBox(
                            width: 150,
                            child: DropdownButton2(
                              dropdownElevation: 12,
                              hint: Text('Selecione',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor)),
                              items: grupos
                                  .toList()
                                  .where(
                                      (element) => element.nome != 'sem grupo')
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.nome,
                                        child: Text(item.nome,
                                            style:
                                                const TextStyle(fontSize: 14)),
                                      ))
                                  .toList(),
                              value: selectedGrupo,
                              isDense: true,
                              onChanged: (value) => setState(
                                  () => selectedGrupo = value as String),
                              buttonHeight: 30,
                              buttonWidth: 10,
                              itemHeight: 30,
                              autofocus: true,
                            ),
                          ),
                        ),
                        Text(
                          '${designados.length} Publicadores',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: axisCount,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 0,
                          childAspectRatio: 3 / 1,
                        ),
                        itemCount: designados.length,
                        itemBuilder: (_, index) =>
                            PublicadorItem(designados[index])),
                  ),
                ),
              ],
            )
          : const Center(child: SizedBox.shrink()),
    );
  }
}
