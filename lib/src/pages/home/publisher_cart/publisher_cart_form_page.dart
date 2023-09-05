import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:parquecambui/src/config/app_data.dart';
import 'package:parquecambui/src/constants/app_customs.dart';
import 'package:parquecambui/src/models/publisher_cart_list.dart';
import 'package:parquecambui/src/models/publisher_cart_model.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../services/utils_services.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';

class PublisherCartFormPage extends StatefulWidget {
  const PublisherCartFormPage({super.key});

  @override
  State<PublisherCartFormPage> createState() => _PublisherCartFormPageState();
}

class _PublisherCartFormPageState extends State<PublisherCartFormPage> {
  final utilsServices = UtilsServices();

  final cartNameFocus = FocusNode();
  final publisherFocus = FocusNode();
  final initialDateFocus = FocusNode();
  final finalDateFocus = FocusNode();
  final observationsFocus = FocusNode();

  DateTime setDate = DateTime.now();

  final formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<PublisherCartList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => isLoading = false));
    Provider.of<PublicadorList>(context, listen: false)
        .loadPublicador()
        .then((value) => setState(() => isLoading = false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      _formData['cartName'] = _formData['cartName'] ?? '';
      _formData['publisher'] = _formData['publisher'] ?? '';
      _formData['initialDate'] = (_formData['initialDate'] ?? DateTime.now());
      _formData['finalDate'] = (_formData['finalDate'] ?? DateTime.now());
      _formData['observations'] = _formData['observations'] ?? '';

      if (arg != null) {
        final cart = arg as PublisherCart;
        _formData['id'] = cart.id;
        _formData['cartName'] = cart.cartName;
        _formData['publisher'] = cart.publisher;
        _formData['initialDate'] = cart.initialDate;
        _formData['finalDate'] = cart.finalDate;
        _formData['observations'] = cart.observations;
        setDate = DateTime.now();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    cartNameFocus.dispose();
    publisherFocus.dispose();
    initialDateFocus.dispose();
    finalDateFocus.dispose();
    observationsFocus.dispose();
  }

  Future<void> _submitForm() async {
    _formData['initialDate'] = setDate;
    final isValid = formKey.currentState?.validate() ?? false;

    formKey.currentState?.save();
    setState(() => isLoading = true);

    if (!isValid) return;

    try {
      await Provider.of<PublisherCartList>(context, listen: false)
          .saveData(_formData);
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
      setState(() => isLoading = false);

      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    final PublicadorList publicador = Provider.of(context);

    List<Publicador> publicadores = publicador.items2.toList();

    publicadores = publicadores..sort(((a, b) => a.nome.compareTo(b.nome)));

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text('Edição de Equipamentos'),
        actions: [
          GestureDetector(
            onTap: () => _submitForm(),
            child: SizedBox(width: 60, child: CustomIcons.checkIcon),
          ),
        ],
      ),
      body: SizedBox(
        height: deviceSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                //   child: Hero(
                //   tag: _imageUrlController.text,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Card(child: Image.network(publisherCartImage))),
                //),
              ),
            ),
            Container(
              height: 280,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade600, offset: const Offset(0, 2)),
                ],
              ),
              child: Form(
                key: formKey,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            child: Text(' Data de Início: ',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: ElevatedButton(
                                onPressed: () {
                                  _showDatePicker();
                                },
                                child: Text(
                                  DateFormat("d 'de' MMMM (EEEE)", 'pt_BR')
                                      .format(setDate),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // NÚMERO
                      Row(
                        children: [
                          //NOME DO CARRINHO
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: TextFormField(
                                style: const TextStyle(fontSize: 16),
                                //maxLines: 1,
                                readOnly: false,
                                initialValue: _formData['cartName']?.toString(),
                                decoration: InputDecoration(
                                    //      labelText: 'Nome do Equipamento',
                                    labelStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // DIRIGENTE
                      Card(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            style: BorderStyle.solid,
                            width: 1,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 80,
                              height: 40,
                              child: const Text('Publicador: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            ),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: SizedBox(
                                  height: 40,
                                  child: DropdownButton2(
                                    focusNode: publisherFocus,
                                    dropdownElevation: 12,
                                    hint: Text('Selecione',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Theme.of(context).hintColor)),
                                    items: publicadores
                                        .toList()
                                        .map((item) => DropdownMenuItem<String>(
                                            value: item.nome,
                                            child: Text(item.nome,
                                                style: const TextStyle(
                                                    fontSize: 14))))
                                        .toList(),
                                    value: _formData['publisher'],
                                    isDense: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _formData['publisher'] =
                                            value as String;

                                        publicadores.removeWhere((publicador) =>
                                            publicador.nome == value);
                                      });
                                    },
                                    buttonHeight: 30,
                                    buttonWidth: 10,
                                    itemHeight: 30,
                                    autofocus: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // OBSERVAÇÕES
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          // height: 40,
                          //width: 200,
                          child: TextFormField(
                            style: const TextStyle(fontSize: 14),
                            maxLines: 3,
                            initialValue: _formData['observations']?.toString(),
                            decoration: InputDecoration(
                                labelText: 'Observações',
                                labelStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            textInputAction: TextInputAction.next,
                            focusNode: observationsFocus,
                            onFieldSubmitted: (_) {
                              //    FocusScope.of(context).requestFocus(urlFocus);
                            },
                            onSaved: (observacoes) =>
                                _formData['observacoes'] = observacoes ?? '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
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
