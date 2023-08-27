import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/grupos_list.dart';
import '../../../models/grupos_models.dart';
import '../../../models/limpeza_list.dart';
import '../../../models/limpeza_model.dart';

class LimpezaForm extends StatefulWidget {
  const LimpezaForm({super.key});

  @override
  LimpezaFormState createState() => LimpezaFormState();
}

class LimpezaFormState extends State<LimpezaForm> {
  final _dateFocus = FocusNode();
  final _grupoNameFocus = FocusNode();
  final _descricaoAtividadeFocus = FocusNode();

  DateTime? setDate;

  final _formKey = GlobalKey<FormState>();
  final _data = <String, Object>{};

  bool _isLoading = true;
  String selectedGrupo = '';

  @override
  void initState() {
    super.initState();
    Provider.of<LimpezaList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
    Provider.of<GruposList>(context, listen: false)
        .loadGrupos()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_data.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final limpeza = arg as Limpeza;
        _data['id'] = limpeza.id;
        _data['date'] = limpeza.date;
        _data['grupoName'] = limpeza.grupoName;
        _data['descricaoAtividade'] = limpeza.descricaoAtividade;

        setDate = limpeza.date;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dateFocus.dispose();
    _grupoNameFocus.dispose();
    _descricaoAtividadeFocus.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    _data['date'] = (_data['date'] ?? setDate)!;
    if (!isValid) return;

    try {
      await Provider.of<LimpezaList>(context, listen: false).saveData(_data);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Grupos> grupos = Provider.of<GruposList>(context)
        .items
        .toList()
        .where((element) => element.nome != 'sem grupo')
        .toList();

    if (grupos.isEmpty) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }

    if (selectedGrupo.isEmpty) selectedGrupo = grupos.first.nome;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Limpeza'),
        actions: setDate != null
            ? [
                IconButton(
                    onPressed: _submitForm, icon: const Icon(Icons.check))
              ]
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
                                    },
                                    child: const Text(
                                        'Escolha uma data de terça-feira'))
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
                                      const Text('Grupo: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                      DropdownButtonHideUnderline(
                                        child: SizedBox(
                                          width: 250,
                                          child: DropdownButton2(
                                            focusNode: _descricaoAtividadeFocus,
                                            dropdownElevation: 12,
                                            hint: Text('Selecione',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .hintColor)),
                                            items: grupos
                                                .toList()
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14))))
                                                .toList(),
                                            value: _data['grupoName'],
                                            isDense: true,
                                            onChanged: (value) {
                                              setState(() {
                                                _data['grupoName'] =
                                                    value as String;

                                                grupos.removeWhere((grupo) =>
                                                    grupo.nome == value);
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
                                      initialValue: _data['descricaoAtividade']
                                          ?.toString(),
                                      decoration: const InputDecoration(
                                        labelText: 'Atividades',
                                      ),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).hintColor),
                                      textInputAction: TextInputAction.next,
                                      focusNode: _descricaoAtividadeFocus,
                                      maxLines: 2,
                                      onSaved: (descricaoAtividade) =>
                                          _data['descricaoAtividade'] =
                                              descricaoAtividade ?? '',
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
    while ((DateFormat('EEEE', 'pt_BR').format(dateToday)) != 'terça-feira') {
      dateToday = dateToday.add(const Duration(days: 1));
    }
    showDatePicker(
      context: context,
      selectableDayPredicate: (DateTime val) => val.weekday != 2 ? false : true,
      initialDate: dateToday,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
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
