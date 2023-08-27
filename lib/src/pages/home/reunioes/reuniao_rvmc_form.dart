import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parquecambui/src/constants/app_customs.dart';
import 'package:parquecambui/src/pages/common_widgets/card_divisor.dart';
import 'package:provider/provider.dart';
import '../../../models/publicador_list.dart';
import '../../../models/reuniao_rvmc_model.dart';
import '../../../models/publicador_model.dart';
import '../../../models/reuniao_rvmc_list.dart';
import '../../common_widgets/custom_widgets.dart';

class ReuniaoRvmcForm extends StatefulWidget {
  const ReuniaoRvmcForm({super.key});

  @override
  State<ReuniaoRvmcForm> createState() => _ReuniaoRvmcFormState();
}

class _ReuniaoRvmcFormState extends State<ReuniaoRvmcForm> {
  final _dateFocus = FocusNode();
  final _presidenteFocus = FocusNode();
  final _tesourosFocus = FocusNode();
  final _joiasFocus = FocusNode();
  final _leituraBibliaFocus = FocusNode();
  final _primeiraMinisterioTemaFocus = FocusNode();
  final _primeiraMinisterioDesignado1Focus = FocusNode();
  final _primeiraMinisterioDesignado2Focus = FocusNode();
  final _segundaMinisterioTemaFocus = FocusNode();
  final _segundaMinisterioDesignado1Focus = FocusNode();
  final _segundaMinisterioDesignado2Focus = FocusNode();
  final _terceiraMinisterioTemaFocus = FocusNode();
  final _terceiraMinisterioDesignado1Focus = FocusNode();
  final _terceiraMinisterioDesignado2Focus = FocusNode();
  final _primeiraVidaCristaTemaFocus = FocusNode();
  final _primeiraVidaCristaDesignadoFocus = FocusNode();
  final _segundaVidaCristaTemaFocus = FocusNode();
  final _segundaVidaCristaDesignadoFocus = FocusNode();
  final _estudoBiblicoFocus = FocusNode();
  final _leituraEstudoBiblicoFocus = FocusNode();
  final _oracaoFinalFocus = FocusNode();
  final _indicador1Focus = FocusNode();
  final _indicador2Focus = FocusNode();
  final _volante1Focus = FocusNode();
  final _volante2Focus = FocusNode();
  final _midiasFocus = FocusNode();

  DateTime? setDate;

  final List _temasPartes1 = [
    'Vídeo da primeira conversa',
    'Vídeo da revisita',
    'Primeira conversa',
    'Segunda conversa',
    'Revisita',
    'Primeira conversa - designação 1',
    'Primeira conversa - designação 2',
    'Revisita - designação 1',
    'Revisita - designação 2',
    'Vídeo do convite'
  ];

  final List _temasPartes2 = [
    'Primeira conversa',
    'Segunda conversa',
    'Revisita',
    'Primeira conversa - designação 1',
    'Primeira conversa - designação 2',
    'Revisita - designação 1',
    'Revisita - designação 2',
    'Convite',
  ];

  final List _temasPartes3 = [
    'Revisita',
    'Discurso',
    'Estudo Bíblico',
    'Primeira conversa - designação 1',
    'Primeira conversa - designação 2',
    'Revisita - designação 1',
    'Revisita - designação 2',
    'Convite',
  ];

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  final double _tamanhoFonte = 13;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ReuniaoRvmcList>(context, listen: false)
        .loadReuniaoRvmc()
        .then((value) => setState(() => _isLoading = false));
    Provider.of<PublicadorList>(context, listen: false)
        .loadPublicador()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final reuniaoRvmc = arg as ReuniaoRvmc;

        _formData['id'] = reuniaoRvmc.id;
        _formData['date'] = reuniaoRvmc.date;
        _formData['presidente'] = reuniaoRvmc.presidente;
        _formData['tesouros'] = reuniaoRvmc.tesouros;
        _formData['joias'] = reuniaoRvmc.joias;
        _formData['leituraBiblia'] = reuniaoRvmc.leituraBiblia;
        _formData['primeiraMinisterioTema'] =
            reuniaoRvmc.primeiraMinisterioTema;
        _formData['primeiraMinisterioDesignado1'] =
            reuniaoRvmc.primeiraMinisterioDesignado1;
        _formData['primeiraMinisterioDesignado2'] =
            reuniaoRvmc.primeiraMinisterioDesignado2;
        _formData['segundaMinisterioTema'] = reuniaoRvmc.segundaMinisterioTema;
        _formData['segundaMinisterioDesignado1'] =
            reuniaoRvmc.segundaMinisterioDesignado1;
        _formData['segundaMinisterioDesignado2'] =
            reuniaoRvmc.segundaMinisterioDesignado2;
        _formData['terceiraMinisterioTema'] =
            reuniaoRvmc.terceiraMinisterioTema;
        _formData['terceiraMinisterioDesignado1'] =
            reuniaoRvmc.terceiraMinisterioDesignado1;
        _formData['terceiraMinisterioDesignado2'] =
            reuniaoRvmc.terceiraMinisterioDesignado2;
        _formData['primeiraVidaCristaTema'] =
            reuniaoRvmc.primeiraVidaCristaTema;
        _formData['primeiraVidaCristaDesignado'] =
            reuniaoRvmc.primeiraVidaCristaDesignado;
        _formData['segundaVidaCristaTema'] = reuniaoRvmc.segundaVidaCristaTema;
        _formData['segundaVidaCristaDesignado'] =
            reuniaoRvmc.segundaVidaCristaDesignado;
        _formData['estudoBiblico'] = reuniaoRvmc.estudoBiblico;
        _formData['leituraEstudoBiblico'] = reuniaoRvmc.leituraEstudoBiblico;
        _formData['oracaoFinal'] = reuniaoRvmc.oracaoFinal;
        _formData['indicador1'] = reuniaoRvmc.indicador1;
        _formData['indicador2'] = reuniaoRvmc.indicador2;
        _formData['volante1'] = reuniaoRvmc.volante1;
        _formData['volante2'] = reuniaoRvmc.volante2;
        _formData['midias'] = reuniaoRvmc.midias;

        setDate = reuniaoRvmc.date;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    _dateFocus.dispose();
    _presidenteFocus.dispose();
    _tesourosFocus.dispose();
    _joiasFocus.dispose();
    _leituraBibliaFocus.dispose();
    _primeiraMinisterioTemaFocus.dispose();
    _primeiraMinisterioDesignado1Focus.dispose();
    _primeiraMinisterioDesignado2Focus.dispose();
    _segundaMinisterioTemaFocus.dispose();
    _segundaMinisterioDesignado1Focus.dispose();
    _segundaMinisterioDesignado2Focus.dispose();
    _terceiraMinisterioTemaFocus.dispose();
    _terceiraMinisterioDesignado1Focus.dispose();
    _terceiraMinisterioDesignado2Focus.dispose();
    _primeiraVidaCristaTemaFocus.dispose();
    _primeiraVidaCristaDesignadoFocus.dispose();
    _segundaVidaCristaTemaFocus.dispose();
    _segundaVidaCristaDesignadoFocus.dispose();
    _estudoBiblicoFocus.dispose();
    _leituraEstudoBiblicoFocus.dispose();
    _oracaoFinalFocus.dispose();
    _indicador1Focus.dispose();
    _indicador2Focus.dispose();
    _volante1Focus.dispose();
    _volante2Focus.dispose();
    _midiasFocus.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    _formData['date'] = (_formData['date'] ?? setDate)!;
    if (!isValid) return;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    if (_formData['presidente'] == null ||
        _formData['tesouros'] == null ||
        _formData['joias'] == null ||
        _formData['leituraBiblia'] == null ||
        _formData['primeiraMinisterioTema'] == null ||
        _formData['primeiraMinisterioDesignado1'] == null ||
        _formData['segundaMinisterioTema'] == null ||
        _formData['segundaMinisterioDesignado1'] == null ||
        _formData['terceiraMinisterioTema'] == null ||
        _formData['terceiraMinisterioDesignado1'] == null ||
        _formData['primeiraVidaCristaTema'] == null ||
        _formData['primeiraVidaCristaDesignado'] == null ||
        _formData['segundaVidaCristaTema'] == null ||
        _formData['segundaVidaCristaDesignado'] == null ||
        _formData['estudoBiblico'] == null ||
        _formData['leituraEstudoBiblico'] == null ||
        _formData['oracaoFinal'] == null ||
        _formData['indicador1'] == null ||
        _formData['indicador2'] == null ||
        _formData['volante1'] == null ||
        _formData['volante2'] == null ||
        _formData['midias'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insira todas as informações!')));
      return;
    }

    try {
      await Provider.of<ReuniaoRvmcList>(context, listen: false)
          .saveReuniaoRvmc(_formData);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
            title: const Text('ERRO!'),
            content: const Text('Erro na gravação dos dados'),
            actions: [
              TextButton(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.of(context).pop()),
            ]),
      );
    } finally {
      setState(() => _isLoading = false);

      Navigator.of(context).pop();
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<PublicadorList>(context);
    final PublicadorList publicador = Provider.of(context);

    final List<Publicador> publicadores = publicador.items.toList()
      ..sort(((a, b) => a.nome.compareTo(b.nome)));

    List<Publicador> anciaos = publicadores
        .where((publicador) => publicador.privilegio == 'Ancião')
        .toList();

    List<Publicador> dianteira = publicadores
        .where((publicador) =>
            publicador.privilegio == 'Ancião' ||
            publicador.privilegio == 'Servo Ministerial')
        .toList();

    List<Publicador> indicadores =
        publicadores.where((publicador) => publicador.indicador).toList();

    List<Publicador> volantes =
        publicadores.where((publicador) => publicador.volante).toList();

    List<Publicador> midias =
        publicadores.where((publicador) => publicador.midias).toList();

    final double larguraCampo = MediaQuery.of(context).size.width - 150;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const CustomAppBarEdit(
              'Reunião Vida e Ministério Cristão', 'Edição'),
          backgroundColor: CustomColors.editAppBarBackgroundColor,
          actions: setDate != null
              ? [
                  IconButton(
                      onPressed: _submitForm, icon: CustomIcons.checkIcon)
                ]
              : null),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      SingleChildScrollView(
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                setDate == null
                                    ? ElevatedButton(
                                        onPressed: () {
                                          _showDatePicker();
                                        },
                                        child: const Text('Escolha uma data'))
                                    : Text(
                                        DateFormat(
                                                "d 'de' MMMM (EEEE)", 'pt_BR')
                                            .format(setDate!),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.teal)),
                              ]),
                          const SizedBox(height: 20),
                          setDate == null
                              ? const Center()
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                      // PRESIDENTE DA REUNIÃO
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Presidente: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode: _presidenteFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: anciaos
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData['presidente'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData['presidente'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // TESOUROS DA PALAVRA DE DEUS
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 18.0, bottom: 8),
                                        child: CardDivisor(
                                            'TESOUROS DA PALAVRA DE DEUS',
                                            backColor: Colors.grey.shade600),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Tesouros Palavra: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode: _tesourosFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: dianteira
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData['tesouros'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData['tesouros'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // ENCONTRE JÓIAS ESPIRITUAIS
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Encontre Jóias: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode: _joiasFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: dianteira
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData['joias'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData['joias'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // LEITURA DA BÍBLIA
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Leitura da Bíblia:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode: _leituraBibliaFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .where((publicador) =>
                                                        publicador
                                                            .leituraBiblia)
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value:
                                                    _formData['leituraBiblia'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData['leituraBiblia'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // FAÇA SEU MELHOR NO MINISTÉRIO
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              top: 18.0, bottom: 8),
                                          child: CardDivisor(
                                              'FAÇA SEU MELHOR NO MINISTÉRIO',
                                              backColor: Color.fromARGB(
                                                  255, 160, 140, 0))),

                                      // TEMA PRIMEIRA PARTE FAÇA SEU MELHOR NO MINISTÉRIO
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Designação: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode:
                                                    _primeiraMinisterioTemaFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: _temasPartes1
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item,
                                                        child: Text(item,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData[
                                                    'primeiraMinisterioTema'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData[
                                                            'primeiraMinisterioTema'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // DESIGNADO1 PRIMEIRA PARTE FAÇA SEU MELHOR NO MINISTÉRIO
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Designado1: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode:
                                                    _primeiraMinisterioDesignado1Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .where((publicador) =>
                                                        publicador
                                                            .conversaRevisita ||
                                                        publicador.privilegio ==
                                                            'Ancião')
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData[
                                                    'primeiraMinisterioDesignado1'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData[
                                                            'primeiraMinisterioDesignado1'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // DESIGNADO2 PRIMEIRA PARTE FAÇA SEU MELHOR NO MINISTÉRIO
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Designado2: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode:
                                                    _primeiraMinisterioDesignado2Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .where((publicador) =>
                                                        publicador
                                                            .conversaRevisita)
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData[
                                                    'primeiraMinisterioDesignado2'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData[
                                                            'primeiraMinisterioDesignado2'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(thickness: 2),

                                      // TEMA SEGUNDA PARTE FAÇA SEU MELHOR NO MINISTÉRIO
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Designação: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode:
                                                    _segundaMinisterioTemaFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: _temasPartes2
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item,
                                                        child: Text(item,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData[
                                                    'segundaMinisterioTema'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData[
                                                            'segundaMinisterioTema'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // DESIGNADO1 SEGUNDA PARTE FAÇA SEU MELHOR NO MINISTÉRIO
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Designado1: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode:
                                                    _segundaMinisterioDesignado1Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .where((publicador) =>
                                                        publicador
                                                            .conversaRevisita)
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData[
                                                    'segundaMinisterioDesignado1'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData[
                                                            'segundaMinisterioDesignado1'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // DESIGNADO2 SEGUNDA PARTE FAÇA SEU MELHOR NO MINISTÉRIO
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Designado2: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode:
                                                    _segundaMinisterioDesignado2Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .where((publicador) =>
                                                        publicador
                                                            .conversaRevisita)
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData[
                                                    'segundaMinisterioDesignado2'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData[
                                                            'segundaMinisterioDesignado2'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(thickness: 2),

                                      // TEMA TERCEIRA PARTE FAÇA SEU MELHOR NO MINISTÉRIO
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Designação: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode:
                                                    _terceiraMinisterioTemaFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: _temasPartes3
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item,
                                                        child: Text(item,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData[
                                                    'terceiraMinisterioTema'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData[
                                                            'terceiraMinisterioTema'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // DESIGNADO1 TERCEIRA PARTE FAÇA SEU MELHOR NO MINISTÉRIO
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Designado1: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode:
                                                    _terceiraMinisterioDesignado1Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData[
                                                    'terceiraMinisterioDesignado1'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData[
                                                            'terceiraMinisterioDesignado1'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // DESIGNADO2 TERCEIRA PARTE FAÇA SEU MELHOR NO MINISTÉRIO
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Designado2: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode:
                                                    _terceiraMinisterioDesignado2Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData[
                                                    'terceiraMinisterioDesignado2'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData[
                                                            'terceiraMinisterioDesignado2'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // NOSSA VIDA CRISTÃ
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              top: 18.0, bottom: 8),
                                          child: CardDivisor(
                                              'NOSSA VIDA CRISTÃ',
                                              backColor: Color.fromARGB(
                                                  255, 140, 0, 0))),

                                      // TEMA PRIMEIRA PARTE FAÇA SEU MELHOR NO MINISTÉRIO
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Tema 1ª Parte:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            // height: 70,
                                            width: larguraCampo,
                                            child: TextFormField(
                                                initialValue: _formData[
                                                        'primeiraVidaCristaTema']
                                                    ?.toString(),
                                                style: TextStyle(
                                                    fontSize: _tamanhoFonte),
                                                //maxLines: 2,
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode:
                                                    _primeiraVidaCristaTemaFocus,
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _primeiraVidaCristaDesignadoFocus);
                                                },
                                                onSaved: (primeiraVidaCristaTema) =>
                                                    _formData[
                                                            'primeiraVidaCristaTema'] =
                                                        primeiraVidaCristaTema ??
                                                            '',
                                                validator: (nme) {
                                                  final primeiraVidaCristaTema =
                                                      nme ?? '';

                                                  if (primeiraVidaCristaTema
                                                      .trim()
                                                      .isEmpty) {
                                                    return 'Tema é obrigatório';
                                                  }

                                                  return null;
                                                }),
                                          ),
                                        ],
                                      ),

                                      // DESIGNADO PRIMEIRA PARTE NOSSA VIDA CRISTÃ
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Designado: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode:
                                                    _primeiraVidaCristaDesignadoFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: dianteira
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData[
                                                    'primeiraVidaCristaDesignado'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData[
                                                            'primeiraVidaCristaDesignado'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(thickness: 2),

                                      // TEMA SEGUNDA PARTE NOSSA VIDA CRISTÃ
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Tema 2ª Parte:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            //  height: 70,
                                            width: larguraCampo,
                                            child: TextFormField(
                                              initialValue: _formData[
                                                      'segundaVidaCristaTema']
                                                  ?.toString(),
                                              style: TextStyle(
                                                  fontSize: _tamanhoFonte),
                                              //  maxLines: 2,
                                              textInputAction:
                                                  TextInputAction.next,
                                              focusNode:
                                                  _segundaVidaCristaTemaFocus,
                                              onFieldSubmitted: (_) {
                                                FocusScope.of(context).requestFocus(
                                                    _segundaVidaCristaDesignadoFocus);
                                              },
                                              onSaved: (segundaVidaCristaTema) =>
                                                  _formData[
                                                          'segundaVidaCristaTema'] =
                                                      segundaVidaCristaTema ??
                                                          '',
                                            ),
                                          ),
                                        ],
                                      ),

                                      // DESIGNADO SEGUNDA PARTE NOSSA VIDA CRISTÃ
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Designado: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode:
                                                    _segundaVidaCristaDesignadoFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: dianteira
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData[
                                                    'segundaVidaCristaDesignado'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData[
                                                            'segundaVidaCristaDesignado'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(thickness: 2),

                                      // ESTUDO BÍBLICO DE CONGREGAÇÃO
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Estudo Bíblico: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode: _estudoBiblicoFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: anciaos
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value:
                                                    _formData['estudoBiblico'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData['estudoBiblico'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // LEITOR ESTUDO BÍBLICO DE CONGREGAÇÃO
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Leitor: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode:
                                                    _leituraEstudoBiblicoFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .where((publicador) =>
                                                        publicador
                                                            .leitorEstBiblico)
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData[
                                                    'leituraEstudoBiblico'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData[
                                                            'leituraEstudoBiblico'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // ORAÇÃO FINAL
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Text('Oração Final: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: _tamanhoFonte)),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: larguraCampo,
                                              child: DropdownButton2(
                                                focusNode: _oracaoFinalFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: _tamanhoFonte,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .where((publicador) =>
                                                        publicador.privilegio ==
                                                            'Anciao' ||
                                                        publicador
                                                            .leitorEstBiblico)
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    _tamanhoFonte))))
                                                    .toList(),
                                                value: _formData['oracaoFinal'],
                                                isDense: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _formData['oracaoFinal'] =
                                                        value as String;
                                                  });
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // DESIGNAÇÕES
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              top: 18.0, bottom: 8),
                                          child: CardDivisor('DESIGNAÇÕES',
                                              backColor: Colors.indigo)),

                                      const Text(
                                        'Indicadores',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: 180,
                                              child: DropdownButton2(
                                                focusNode: _indicador1Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: indicadores
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13))))
                                                    .toList(),
                                                value: _formData['indicador1'],
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      _formData['indicador1'] =
                                                          value as String;
                                                    },
                                                  );
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: 180,
                                              child: DropdownButton2(
                                                focusNode: _indicador2Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: indicadores
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13))))
                                                    .toList(),
                                                value: _formData['indicador2'],
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      _formData['indicador2'] =
                                                          value as String;
                                                    },
                                                  );
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(thickness: 2),
                                      const Text(
                                        'Microfones Volante',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: 180,
                                              child: DropdownButton2(
                                                focusNode: _volante1Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: volantes
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13))))
                                                    .toList(),
                                                value: _formData['volante1'],
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      _formData['volante1'] =
                                                          value as String;
                                                    },
                                                  );
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: 180,
                                              child: DropdownButton2(
                                                focusNode: _volante2Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: volantes
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13))))
                                                    .toList(),
                                                value: _formData['volante2'],
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      _formData['volante2'] =
                                                          value as String;
                                                    },
                                                  );
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(thickness: 2),
                                      const Text(
                                        'Mídias',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      DropdownButtonHideUnderline(
                                        child: SizedBox(
                                          width: 180,
                                          child: DropdownButton2(
                                            focusNode: _midiasFocus,
                                            dropdownElevation: 12,
                                            hint: Text('Selecione',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Theme.of(context)
                                                        .hintColor)),
                                            items: midias
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13))))
                                                .toList(),
                                            value: _formData['midias'],
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  _formData['midias'] =
                                                      value as String;
                                                },
                                              );
                                            },
                                            buttonHeight: 30,
                                            buttonWidth: 10,
                                            itemHeight: 30,
                                            autofocus: true,
                                          ),
                                        ),
                                      ),
                                    ]),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  _showDatePicker() {
    DateTime dateToday = DateTime.now();
    while (dateToday.weekday != 2) {
      dateToday = dateToday.add(const Duration(days: 1));
    }
    showDatePicker(
      context: context,
      selectableDayPredicate: (DateTime val) => val.weekday != 2 ? false : true,
      initialDate: dateToday,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return null;
      }

      setState(() {
        setDate = pickedDate;
      });
    });
  }
}
