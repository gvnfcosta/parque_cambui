import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parquecambui/src/models/reuniao_rvmc_model.dart';
import 'package:provider/provider.dart';
import '/src/pages/common_widgets/card_divisor.dart';
import '/src/pages/common_widgets/custom_text_field.dart';
import '/src/models/reuniao_rvmc_list.dart';
import '../../../constants/app_customs.dart';
import '../../../config/app_routes.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';

bool isAdmin = false;
bool readOnly = true;

class RvmcScreen extends StatefulWidget {
  const RvmcScreen(this.reuniaoSelecionadaData, {Key? key}) : super(key: key);

  final DateTime reuniaoSelecionadaData;

  @override
  State<RvmcScreen> createState() => _RvmcScreenState();
}

class _RvmcScreenState extends State<RvmcScreen> {
  @override
  Widget build(BuildContext context) {
    List<Publicador> usuario = Provider.of<PublicadorList>(context).usuario;

    final reunioes = Provider.of<ReuniaoRvmcList>(context).items;
    final reuniaoSelecionada = reunioes.firstWhereOrNull(
        (element) => element.date == widget.reuniaoSelecionadaData);

    if (reuniaoSelecionada == null) return const SizedBox.shrink();

    if (usuario.isNotEmpty) {
      isAdmin = usuario.first.nivel == 5 || usuario.first.nivel >= 7;
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
              'Reunião Vida e Ministério Cristão',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
            Text(
              DateFormat("EEEE, d 'de' MMMM", 'pt_BR')
                      .format(reuniaoSelecionada.date)[0]
                      .toUpperCase() +
                  DateFormat("EEEE, d 'de' MMMM", 'pt_BR')
                      .format(reuniaoSelecionada.date)
                      .substring(1)
                      .toLowerCase(),
              style: TextStyle(
                  fontSize: 18,
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
                            AppRoutes.reuniaoRvmcForm,
                            arguments: reuniaoSelecionada);
                      },
                      icon: CustomIcons.editIcon,
                      color: CustomColors.softEditColor,
                    ),
                    IconButton(
                        icon: CustomIcons.deleteIcon,
                        color: CustomColors.softDeleteColor,
                        onPressed: () {
                          _removeDialog(reuniaoSelecionada);
                        }),
                  ],
                )
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardDivisor('TESOUROS DA PALAVRA DE DEUS',
                  backColor: Colors.grey.shade700),
              CustomTextField(
                  label: 'Presidente',
                  initialValue: reuniaoSelecionada.presidente,
                  readOnly: readOnly),
              CustomTextField(
                  label: 'Tesouros da Palavra de Deus',
                  initialValue: reuniaoSelecionada.tesouros,
                  readOnly: readOnly),
              CustomTextField(
                  label: 'Encontre Jóias Espirituais',
                  initialValue: reuniaoSelecionada.joias,
                  readOnly: readOnly),
              CustomTextField(
                  label: 'Leitura da Bíblia',
                  initialValue: reuniaoSelecionada.leituraBiblia,
                  readOnly: readOnly),
              const CardDivisor('FAÇA SEU MELHOR NO MINISTÉRIO',
                  backColor: Color.fromARGB(255, 150, 150, 0)),
              parteValid(
                  reuniaoSelecionada.primeiraMinisterioTema,
                  reuniaoSelecionada.primeiraMinisterioDesignado1,
                  reuniaoSelecionada.primeiraMinisterioDesignado2),
              parteValid(
                  reuniaoSelecionada.segundaMinisterioTema,
                  reuniaoSelecionada.segundaMinisterioDesignado1,
                  reuniaoSelecionada.segundaMinisterioDesignado2),
              parteValid(
                  reuniaoSelecionada.terceiraMinisterioTema,
                  reuniaoSelecionada.terceiraMinisterioDesignado1,
                  reuniaoSelecionada.terceiraMinisterioDesignado2),
              parteValid(
                  reuniaoSelecionada.quartaMinisterioTema,
                  reuniaoSelecionada.quartaMinisterioDesignado1,
                  reuniaoSelecionada.quartaMinisterioDesignado2),
              const CardDivisor('NOSSA VIDA CRISTÃ',
                  backColor: Color.fromARGB(255, 140, 0, 0)),
              CustomTextField(
                  label: reuniaoSelecionada.primeiraVidaCristaTema,
                  initialValue: reuniaoSelecionada.primeiraVidaCristaDesignado,
                  readOnly: readOnly),
              reuniaoSelecionada.segundaVidaCristaTema != ''
                  ? CustomTextField(
                      label: reuniaoSelecionada.segundaVidaCristaTema,
                      initialValue:
                          reuniaoSelecionada.segundaVidaCristaDesignado,
                      readOnly: readOnly)
                  : const SizedBox(),
              CustomTextField(
                  label: 'Estudo Bíblico de Congregação',
                  initialValue: reuniaoSelecionada.estudoBiblico,
                  readOnly: readOnly),
              CustomTextField(
                  label: 'Leitura do Estudo Bíblico',
                  initialValue: reuniaoSelecionada.leituraEstudoBiblico,
                  readOnly: readOnly),
              CustomTextField(
                  label: 'Oração Final',
                  initialValue: reuniaoSelecionada.oracaoFinal,
                  readOnly: readOnly),
              CardDivisor('DESIGNAÇÕES', backColor: Colors.indigo.shade900),
              CustomTextField(
                  icon: Icons.man,
                  label: 'Indicadores Externo e de Auditório',
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
                  label: 'Mídias',
                  icon: Icons.laptop_mac,
                  initialValue: reuniaoSelecionada.midias,
                  readOnly: readOnly),
            ],
          ),
        ),
      ),
    );
  }

  CustomTextField parteValid(
      String tema, String designado1, String designado2) {
    bool solo = designado2.contains('sem_designação');
    return CustomTextField(
        icon: solo ? Icons.person : Icons.people,
        label: tema,
        initialValue: solo ? designado1 : '$designado1  e  $designado2',
        readOnly: readOnly);
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
                  Provider.of<ReuniaoRvmcList>(context, listen: false)
                      .removeRvmc(dataField);
                  Navigator.of(ctx).pop();
                  Navigator.of(ctx).pop();
                })
          ]),
    );
  }
}
