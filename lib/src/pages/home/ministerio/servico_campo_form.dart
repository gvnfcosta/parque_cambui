import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/servico_campo_list.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';
import '../../../models/servico_campo_model.dart';

class ServicoCampoForm extends StatefulWidget {
  const ServicoCampoForm({super.key});

  @override
  ServicoCampoFormState createState() => ServicoCampoFormState();
}

class ServicoCampoFormState extends State<ServicoCampoForm> {
  final _dateFocus = FocusNode();
  final _hourFocus = FocusNode();
  final _dirigenteNameFocus = FocusNode();
  final _territoriesNameFocus = FocusNode();

  DateTime? setDate;

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<CampoList>(context, listen: false)
        .loadData()
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
        final servicoCampo = arg as ServicoCampo;
        _formData['id'] = servicoCampo.id;
        _formData['date'] = servicoCampo.date;
        _formData['hour'] = servicoCampo.hour;
        _formData['dirigenteName'] = servicoCampo.dirigenteName;
        _formData['territoriesName'] = servicoCampo.territoriesName;

        setDate = servicoCampo.date;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dateFocus.dispose();
    _hourFocus.dispose();
    _dirigenteNameFocus.dispose();
    _territoriesNameFocus.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    _formData['date'] = (_formData['date'] ?? setDate)!;
    _formData['hour'] = DateTime.now();
    _formData['territoriesName'] = ' ';
    if (!isValid) return;

    // if (_formData['hour'] == null ||
    //     _formData['dirigenteName'] == null ||
    //     _formData['territoriesName'] == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Insira todas as informações!')));
    //   return;
    // }

    try {
      await Provider.of<CampoList>(context, listen: false).saveData(_formData);
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
    //final provider = Provider.of<PublicadorList>(context);
    final PublicadorList publicador = Provider.of(context);

    List<Publicador> publicadores = publicador.items.toList()
      ..sort(((a, b) => a.nome.compareTo(b.nome)));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Saídas de Campo'),
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
                                      const Text('Dirigente: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                      DropdownButtonHideUnderline(
                                        child: SizedBox(
                                          width: 250,
                                          child: DropdownButton2(
                                            focusNode: _dirigenteNameFocus,
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
                                            value: _formData['dirigenteName'],
                                            isDense: true,
                                            onChanged: (value) {
                                              setState(() {
                                                _formData['dirigenteName'] =
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
                                  // SizedBox(
                                  //   height: 100,
                                  //   child: TextFormField(
                                  //     initialValue: _formData['territoriesName']
                                  //         ?.toString(),
                                  //     decoration: const InputDecoration(
                                  //       labelText: 'Território',
                                  //     ),
                                  //     style: TextStyle(
                                  //         fontSize: 14,
                                  //         fontWeight: FontWeight.w600,
                                  //         color: Theme.of(context).hintColor),
                                  //     textInputAction: TextInputAction.next,
                                  //     focusNode: _territoriesNameFocus,
                                  //     maxLines: 2,
                                  //     onSaved: (territoriesName) =>
                                  //         _formData['territoriesName'] =
                                  //             territoriesName ?? '',
                                  //     // validator: (vld) {
                                  //     //   final territoriesName = vld ?? '';

                                  //     //   if (territoriesName.trim().isEmpty) {
                                  //     //     return 'Território é obrigatório';
                                  //     //   }

                                  //     //   return null;
                                  //     // },
                                  //   ),
                                  // ),
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
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
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
