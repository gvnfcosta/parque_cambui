import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_customs.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';
import '../../../models/reuniao_publica_list.dart';
import '../../../models/reuniao_publica_model.dart';

class ReuniaoPublicaForm extends StatefulWidget {
  const ReuniaoPublicaForm({super.key});

  @override
  ReuniaoPublicaFormState createState() => ReuniaoPublicaFormState();
}

class ReuniaoPublicaFormState extends State<ReuniaoPublicaForm> {
  final _dateFocus = FocusNode();
  final _presidenteFocus = FocusNode();
  final _discursoTemaFocus = FocusNode();
  final _oradorFocus = FocusNode();
  final _congregacaoFocus = FocusNode();
  final _leitorASentinelaFocus = FocusNode();
  final _indicador1Focus = FocusNode();
  final _indicador2Focus = FocusNode();
  final _volante1Focus = FocusNode();
  final _volante2Focus = FocusNode();
  final _midiasFocus = FocusNode();

  DateTime? setDate;

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ReuniaoPublicaList>(context, listen: false)
        .loadReuniaoPublica()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    Provider.of<PublicadorList>(context, listen: false)
        .loadPublicador()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final reuniaoPublica = arg as ReuniaoPublica;
        _formData['id'] = reuniaoPublica.id;
        _formData['date'] = reuniaoPublica.date;
        _formData['presidente'] = reuniaoPublica.presidente;
        _formData['discursoTema'] = reuniaoPublica.discursoTema;
        _formData['orador'] = reuniaoPublica.orador;
        _formData['congregacao'] = reuniaoPublica.congregacao;
        _formData['leitorASentinela'] = reuniaoPublica.leitorASentinela;
        _formData['indicador1'] = reuniaoPublica.indicador1;
        _formData['indicador2'] = reuniaoPublica.indicador2;
        _formData['volante1'] = reuniaoPublica.volante1;
        _formData['volante2'] = reuniaoPublica.volante2;
        _formData['midias'] = reuniaoPublica.midias;

        setDate = reuniaoPublica.date;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dateFocus.dispose();
    _presidenteFocus.dispose();
    _discursoTemaFocus.dispose();
    _oradorFocus.dispose();
    _congregacaoFocus.dispose();
    _leitorASentinelaFocus.dispose();
    _indicador1Focus.dispose();
    _indicador2Focus.dispose();
    _volante1Focus.dispose();
    _volante2Focus.dispose();
    _midiasFocus.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    _formData['date'] = (_formData['date'] ?? setDate)!;
    if (!isValid) return;

    if (_formData['presidente'] == null ||
        _formData['leitorASentinela'] == null ||
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
      await Provider.of<ReuniaoPublicaList>(context, listen: false)
          .saveReuniaoPublica(_formData);
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
                  ]));
    } finally {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
      //Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<PublicadorList>(context);
    final PublicadorList publicador = Provider.of(context);

    List<Publicador> publicadores = publicador.items.toList()
      ..sort(((a, b) => a.nome.compareTo(b.nome)));

    List<String> nomesUsados = [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reunião Pública'),
        backgroundColor: CustomColors.editAppBarBackgroundColor,
        actions: setDate != null
            ? [IconButton(onPressed: _submitForm, icon: CustomIcons.checkIcon)]
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            setDate == null
                                ? ElevatedButton(
                                    onPressed: () {
                                      _showDatePicker();
                                      // setState(() {
                                      //   setDate = customDatePicker(context);
                                      // });
                                    },
                                    child: const Text('Escolha uma data'))
                                : Text(
                                    DateFormat("d 'de' MMMM (EEEE)", 'pt_BR')
                                        .format(setDate!),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.indigo)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        setDate == null
                            ? const Center()
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text('Presidente: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                      DropdownButtonHideUnderline(
                                        child: SizedBox(
                                          width: 280,
                                          child: DropdownButton2(
                                            focusNode: _presidenteFocus,
                                            dropdownElevation: 12,
                                            hint: Text('Selecione',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .hintColor)),
                                            items: (publicadores.where(
                                                    (publicador) =>
                                                        publicador.privilegio ==
                                                            'Ancião' ||
                                                        publicador.privilegio ==
                                                            'Servo Ministerial'))
                                                .toList()
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style: const TextStyle(
                                                                fontSize: 14))))
                                                .toList(),
                                            value: _formData['presidente'],
                                            isDense: true,
                                            onChanged: (value) {
                                              setState(() {
                                                _formData['presidente'] =
                                                    value as String;

                                                publicadores.removeWhere(
                                                    (publicador) =>
                                                        publicador.nome ==
                                                        value);
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
                                  SizedBox(
                                    height: 100,
                                    child: TextFormField(
                                        initialValue: _formData['discursoTema']
                                            ?.toString(),
                                        decoration: const InputDecoration(
                                          labelText: 'Tema do Discurso',
                                        ),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context).hintColor),
                                        textInputAction: TextInputAction.next,
                                        focusNode: _discursoTemaFocus,
                                        maxLines: 2,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(_oradorFocus);
                                        },
                                        onSaved: (discursoTema) =>
                                            _formData['discursoTema'] =
                                                discursoTema ?? '',
                                        validator: (nme) {
                                          final discursoTema = nme ?? '';

                                          if (discursoTema.trim().isEmpty) {
                                            return 'Tema é obrigatório';
                                          }

                                          return null;
                                        }),
                                  ),
                                  SizedBox(
                                    height: 55,
                                    child: TextFormField(
                                        initialValue:
                                            _formData['orador']?.toString(),
                                        decoration: const InputDecoration(
                                            labelText: 'Orador'),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context).hintColor),
                                        textInputAction: TextInputAction.next,
                                        focusNode: _oradorFocus,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(_congregacaoFocus);
                                        },
                                        onSaved: (orador) =>
                                            _formData['orador'] = orador ?? '',
                                        validator: (nme) {
                                          final orador = nme ?? '';

                                          if (orador.trim().isEmpty) {
                                            return 'Orador é obrigatório';
                                          }

                                          return null;
                                        }),
                                  ),
                                  SizedBox(
                                    height: 55,
                                    child: TextFormField(
                                        initialValue: _formData['congregacao']
                                            ?.toString(),
                                        decoration: const InputDecoration(
                                            labelText: 'Congregação'),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context).hintColor),
                                        textInputAction: TextInputAction.next,
                                        focusNode: _congregacaoFocus,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context).requestFocus(
                                              _leitorASentinelaFocus);
                                        },
                                        onSaved: (congregacao) =>
                                            _formData['congregacao'] =
                                                congregacao ?? '',
                                        validator: (nme) {
                                          final congregacao = nme ?? '';

                                          if (congregacao.trim().isEmpty) {
                                            return 'Congregação é obrigatório';
                                          }

                                          return null;
                                        }),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width: 400,
                                    decoration: BoxDecoration(
                                        color: Colors.black12.withAlpha(20),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Leitor de A Sentinela: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: 350,
                                              child: DropdownButton2(
                                                focusNode:
                                                    _leitorASentinelaFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .where((publicador) =>
                                                        publicador
                                                            .leitorASentinela)
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14))))
                                                    .toList(),
                                                value: _formData[
                                                    'leitorASentinela'],
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      _formData[
                                                              'leitorASentinela'] =
                                                          value as String;
                                                      publicadores.removeWhere(
                                                          (publicador) =>
                                                              publicador.nome ==
                                                              value);
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
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Indicadores',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: 350,
                                              child: DropdownButton2(
                                                focusNode: _indicador1Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .where((publicador) =>
                                                        publicador.indicador)
                                                    .toList()
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
                                                      publicadores.removeWhere(
                                                          (publicador) =>
                                                              publicador.nome ==
                                                              value);
                                                      nomesUsados.add(value);
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
                                          const SizedBox(width: 30),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: 350,
                                              child: DropdownButton2(
                                                focusNode: _indicador2Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .where((publicador) =>
                                                        publicador.indicador)
                                                    .toList()
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
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Microfones Volante',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: 350,
                                              child: DropdownButton2(
                                                focusNode: _volante1Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .where((publicador) =>
                                                        publicador.volante)
                                                    .toList()
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
                                              width: 350,
                                              child: DropdownButton2(
                                                focusNode: _volante2Focus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .where((publicador) =>
                                                        publicador.volante)
                                                    .toList()
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
                                          const Text(
                                            'Mídias',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              width: 350,
                                              child: DropdownButton2(
                                                focusNode: _midiasFocus,
                                                dropdownElevation: 12,
                                                hint: Text('Selecione',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: publicadores
                                                    .where((publicador) =>
                                                        publicador.midias)
                                                    .toList()
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  _showDatePicker() {
    DateTime dateToday = DateTime.now();
    while (dateToday.weekday != 6) {
      dateToday = dateToday.add(const Duration(days: 1));
    }
    showDatePicker(
      context: context,
      selectableDayPredicate: (DateTime val) => val.weekday != 6 ? false : true,
      initialDate: dateToday,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 120)),
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
