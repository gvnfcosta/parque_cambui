import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/territories_model.dart';
import '../../../../services/utils_services.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';
import '../../../models/territories_list.dart';

class TerritorieSendPage extends StatefulWidget {
  const TerritorieSendPage({super.key});

  @override
  State<TerritorieSendPage> createState() => _TerritorieSendPageState();
}

bool isAdmin = false;

class _TerritorieSendPageState extends State<TerritorieSendPage> {
  final utilsServices = UtilsServices();
  final numeroFocus = FocusNode();
  final nomeFocus = FocusNode();
  final urlFocus = FocusNode();
  final publicadorFocus = FocusNode();
  final dataInicioFocus = FocusNode();
  final dataConclusaoFocus = FocusNode();
  final observacoesFocus = FocusNode();
  final anotacoesFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  DateTime setDate = DateTime.now();

  final formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<TerritoriesList>(context, listen: false)
        .loadData()
        .then((value) => setState(() {
              isLoading = false;
              _imageUrlFocus.addListener(updateImage);
            }));
    Provider.of<PublicadorList>(context, listen: false)
        .loadPublicador()
        .then((value) => setState(() => isLoading = false));
  }

  void updateImage() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      _formData['dataInicio'] = DateTime.now();
      _formData['dataConclusao'] =
          (_formData['dataConclusao'] ?? DateTime.now());
      _formData['publicador'] = _formData['publicador'] ?? '';
      _formData['observacoes'] = _formData['observacoes'] ?? '';
      _formData['anotacoes'] = _formData['anotacoes'] ?? '';

      if (arg != null) {
        final territories = arg as Territories;
        _formData['id'] = territories.id;
        _formData['numero'] = territories.numero;
        _formData['nome'] = territories.nome;
        _formData['url'] = territories.url;
        _formData['publicador'] = territories.publicador;
        _formData['observacoes'] = territories.observacoes;
        _formData['anotacoes'] = territories.anotacoes;
        _imageUrlController.text = territories.url;
        setDate = DateTime.now();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    numeroFocus.dispose();
    nomeFocus.dispose();
    urlFocus.dispose();
    publicadorFocus.dispose();
    dataInicioFocus.dispose();
    dataConclusaoFocus.dispose();
    observacoesFocus.dispose();
    anotacoesFocus.dispose();
    _imageUrlFocus.dispose();
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;

    return isValidUrl;
  }

  Future<void> _submitForm() async {
    _formData['dataInicio'] = setDate;
    final isValid = formKey.currentState?.validate() ?? false;

    formKey.currentState?.save();
    setState(() => isLoading = true);

    if (!isValid) return;

    try {
      await Provider.of<TerritoriesList>(context, listen: false)
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
    List<Publicador> usuario = Provider.of<PublicadorList>(context).usuario;

    if (usuario.isNotEmpty) {
      isAdmin = (usuario.first.nivel == 4 || usuario.first.nivel > 7);
    }

    final PublicadorList publicador = Provider.of(context);

    List<Publicador> publicadores = publicador.items2.toList()
      ..sort(((a, b) => a.nome.compareTo(b.nome)));

    if (publicadores.isEmpty) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade800,
        elevation: 0,
        centerTitle: true,
        title: const Text('Solicitar Território'),
      ),
      body: SizedBox(
        height: deviceSize.height,
        width: deviceSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Hero(
                  tag: _imageUrlController.text,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Image.network(
                        _imageUrlController.text,
                      )),
                ),
              ),
            ),
            Container(
              height: 260,
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(50),
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
                            child: Text('Data de Início: ',
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

                      // NÚMERO
                      Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 100,
                            child: TextFormField(
                              style: const TextStyle(fontSize: 14),
                              readOnly: true,
                              initialValue: _formData['numero']?.toString(),
                              decoration: InputDecoration(
                                  labelText: 'Número',
                                  labelStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),

                          //NOME DO MAPA
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: SizedBox(
                                height: 40,
                                child: TextFormField(
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 1,
                                  readOnly: true,
                                  initialValue: _formData['nome']?.toString(),
                                  decoration: InputDecoration(
                                      labelText: 'Nome do Mapa',
                                      labelStyle: const TextStyle(fontSize: 12),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                ),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            isAdmin
                                ? const Text(' Dirigente: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600))
                                : Text('Dirigente: ${usuario.first.nome}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                            isAdmin
                                ? Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: SizedBox(
                                        height: 40,
                                        child: DropdownButton2(
                                          focusColor: Colors.white,
                                          focusNode: publicadorFocus,
                                          dropdownElevation: 12,
                                          hint: Text('Selecione',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .hintColor)),
                                          items: publicadores
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
                                          value: _formData['publicador'],
                                          isDense: true,
                                          onChanged: (value) {
                                            setState(() {
                                              _formData['publicador'] =
                                                  value as String;

                                              publicadores.removeWhere(
                                                  (publicador) =>
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
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: SizedBox(
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.blue.shade800)),
                            onPressed: () {
                              !isAdmin
                                  ? _formData['publicador'] = usuario.first.nome
                                  : null;
                              _submitForm();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  isAdmin ? 'ENVIAR' : 'SOLICITAR',
                                  style: const TextStyle(
                                      fontSize: 14, letterSpacing: 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // // OBSERVAÇÕES
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 8.0),
                      //   child: SizedBox(
                      //     height: 40,
                      //     //width: 200,
                      //     child: TextFormField(
                      //         style: const TextStyle(fontSize: 14),
                      //         maxLines: 3,
                      //         initialValue:
                      //             _formData['observacoes']?.toString(),
                      //         decoration: InputDecoration(
                      //             labelText: 'Observações',
                      //             labelStyle:
                      //                 const TextStyle(fontSize: 12),
                      //             border: OutlineInputBorder(
                      //                 borderRadius:
                      //                     BorderRadius.circular(8))),
                      //         textInputAction: TextInputAction.next,
                      //         focusNode: observacoesFocus,
                      //         onFieldSubmitted: (_) {
                      //           FocusScope.of(context)
                      //               .requestFocus(urlFocus);
                      //         },
                      //         onSaved: (observacoes) =>
                      //             _formData['observacoes'] =
                      //                 observacoes ?? '',
                      //         validator: (obs) {
                      //           final observacoes = obs ?? '';

                      //           return null;
                      //         }),
                      //   ),
                      // ),

                      // // ANOTAÇÕES
                      // SizedBox(
                      //   height: 40,
                      //   //width: 200,
                      //   child: TextFormField(
                      //       style: const TextStyle(fontSize: 14),
                      //       maxLines: 3,
                      //       initialValue:
                      //           _formData['anotacoes']?.toString(),
                      //       decoration: InputDecoration(
                      //           labelText: 'Anotações',
                      //           labelStyle:
                      //               const TextStyle(fontSize: 12),
                      //           border: OutlineInputBorder(
                      //               borderRadius:
                      //                   BorderRadius.circular(8))),
                      //       textInputAction: TextInputAction.next,
                      //       focusNode: anotacoesFocus,
                      //       onFieldSubmitted: (_) {
                      //         FocusScope.of(context)
                      //             .requestFocus(urlFocus);
                      //       },
                      //       onSaved: (anotacoes) =>
                      //           _formData['anotacoes'] =
                      //               anotacoes ?? '',
                      //       validator: (anot) {
                      //         final anotacoes = anot ?? '';

                      //         return null;
                      //       }),
                      // ),
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
      firstDate: DateTime.now().subtract(const Duration(days: 3)),
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
