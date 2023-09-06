import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_customs.dart';
import '/src/models/reuniao_publica_list.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';
import '../../common_widgets/card_divisor.dart';
import '../../common_widgets/custom_text_field.dart';
import '../../../config/app_routes.dart';

bool isAdmin = false;
bool readOnly = true;

class ReuniaoPublicaScreen extends StatefulWidget {
  const ReuniaoPublicaScreen(this.reuniaoSelecionadaData, {Key? key})
      : super(key: key);
  final DateTime reuniaoSelecionadaData;

  @override
  State<ReuniaoPublicaScreen> createState() => _ReuniaoPublicaScreenState();
}

class _ReuniaoPublicaScreenState extends State<ReuniaoPublicaScreen> {
  @override
  Widget build(BuildContext context) {
    List<Publicador> usuario = Provider.of<PublicadorList>(context).usuario;

    final reunioes = Provider.of<ReuniaoPublicaList>(context).items;
    final reuniaoSelecionada = reunioes.firstWhereOrNull(
        (element) => element.date == widget.reuniaoSelecionadaData);

    if (reuniaoSelecionada == null) return const SizedBox.shrink();

    if (usuario.isNotEmpty) {
      isAdmin = usuario.first.nivel == 6 || usuario.first.nivel >= 7;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: CustomColors.appBarBackgroundColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reunião Pública',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              DateFormat("EEEE, d 'de' MMMM", 'pt_BR')
                      .format(reuniaoSelecionada.date)[0]
                      .toUpperCase() +
                  DateFormat("EEEE, d 'de' MMMM", 'pt_BR')
                      .format(reuniaoSelecionada.date)
                      .substring(1)
                      .toLowerCase(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[300]),
            ),
          ],
        ),
        actions: isAdmin
            ? [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.reuniaoPubForm,
                          arguments: reuniaoSelecionada,
                        );
                      },
                      icon: CustomIcons.editIcon,
                      color: CustomColors.softEditColor,
                    ),
                    IconButton(
                        icon: CustomIcons.deleteIcon,
                        color: CustomColors.softDeleteColor,
                        onPressed: () {
                          _removeDialog(reuniaoSelecionada);
                        })
                  ],
                )
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CardDivisor('DISCURSO PÚBLICO',
                  backColor: Color.fromARGB(255, 195, 91, 0)),
              CustomTextField(
                  label: 'Presidente',
                  initialValue: reuniaoSelecionada.presidente,
                  readOnly: readOnly),
              CustomTextField(
                  icon: Icons.book,
                  label: 'Tema',
                  initialValue: reuniaoSelecionada.discursoTema,
                  readOnly: readOnly),
              CustomTextField(
                  label: 'Orador',
                  initialValue: reuniaoSelecionada.orador,
                  readOnly: readOnly),
              CustomTextField(
                  icon: Icons.home,
                  label: 'Congregação',
                  initialValue: reuniaoSelecionada.congregacao,
                  readOnly: readOnly),
              const CardDivisor(
                'ESTUDO DE A SENTINELA',
                backColor: Color.fromARGB(255, 139, 6, 64),
              ),
              CustomTextField(
                  label: 'Leitura de A Sentinela',
                  initialValue: reuniaoSelecionada.leitorASentinela,
                  readOnly: readOnly),
              CardDivisor('DESIGNAÇÕES', backColor: Colors.indigo.shade900),
              CustomTextField(
                  icon: Icons.man,
                  label: 'Indicadores de Entrada e Auditório',
                  initialValue:
                      '${reuniaoSelecionada.indicador1}  e  ${reuniaoSelecionada.indicador2}',
                  readOnly: readOnly),
              CustomTextField(
                  icon: Icons.mic,
                  label: 'Microfones Volante',
                  initialValue:
                      '${reuniaoSelecionada.volante1}  e  ${reuniaoSelecionada.volante2}',
                  readOnly: readOnly),
              CustomTextField(
                  icon: Icons.laptop_mac,
                  label: 'Mídias',
                  initialValue: reuniaoSelecionada.midias,
                  readOnly: readOnly),
            ],
          ),
        ),
      ),
    );
  }

  _removeDialog(dataField) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          title: const Text('Excluir Registro'),
          content: const Text('Tem certeza?'),
          actions: [
            TextButton(
                child: const Text('NÃO'),
                onPressed: () => Navigator.of(ctx).pop()),
            TextButton(
                child: const Text('SIM'),
                onPressed: () {
                  Provider.of<ReuniaoPublicaList>(context, listen: false)
                      .removeRPub(dataField);
                  Navigator.of(ctx).pop();
                  Navigator.of(ctx).pop();
                })
          ]),
    );
  }
}
