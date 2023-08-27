import 'package:flutter/material.dart';
import '../../../models/territories_model.dart';
import 'package:provider/provider.dart';
import '../../../../services/utils_services.dart';
import '../../../models/publicador_list.dart';
import '../../../models/territories_list.dart';

class NewTerritoriesPage extends StatefulWidget {
  const NewTerritoriesPage({super.key});

  @override
  State<NewTerritoriesPage> createState() => _NewTerritoriesPageState();
}

class _NewTerritoriesPageState extends State<NewTerritoriesPage> {
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
        .then((value) {
      setState(() {
        isLoading = false;
        _imageUrlFocus.addListener(updateImage);
      });
    });
    Provider.of<PublicadorList>(context, listen: false).loadPublicador();
  }

  void updateImage() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      _formData['dataInicio'] = (_formData['dataInicio'] ?? DateTime.now());
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
        _formData['dataInicio'] = territories.dataInicio;
        _formData['dataConclusao'] = territories.dataConclusao;
        _formData['observacoes'] = territories.observacoes;
        _formData['anotacoes'] = territories.anotacoes;
        _imageUrlController.text = territories.url;
        setDate = territories.dataInicio;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        elevation: 0,
        centerTitle: true,
        title: const Text('Cadastro de Territórios'),
        actions: [
          IconButton(onPressed: _submitForm, icon: const Icon(Icons.check))
        ],
      ),
      body: SizedBox(
        height: deviceSize.height,
        width: deviceSize.width,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: _imageUrlController.text.isEmpty
                    ? const Center(
                        child: Text(
                          'Informe os dados',
                          style: TextStyle(fontSize: 25),
                        ),
                      )
                    : Image.network(_imageUrlController.text),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
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
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Form(
                      key: formKey,
                      child: Container(
                        color: Colors.white,
                        height: 250,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // NÚMERO
                            Row(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 100,
                                  child: TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      maxLines: 1,
                                      initialValue:
                                          _formData['numero']?.toString(),
                                      decoration: InputDecoration(
                                          labelText: 'Número',
                                          labelStyle:
                                              const TextStyle(fontSize: 12),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      textInputAction: TextInputAction.next,
                                      focusNode: numeroFocus,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(nomeFocus);
                                      },
                                      onSaved: (numero) =>
                                          _formData['numero'] = numero ?? '',
                                      validator: (number) {
                                        final numero = number ?? '';

                                        if (numero.trim().isEmpty) {
                                          return 'Número é obrigatório';
                                        }

                                        return null;
                                      }),
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
                                          initialValue:
                                              _formData['nome']?.toString(),
                                          decoration: InputDecoration(
                                              labelText: 'Nome do Mapa',
                                              labelStyle:
                                                  const TextStyle(fontSize: 12),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8))),
                                          textInputAction: TextInputAction.next,
                                          focusNode: nomeFocus,
                                          onFieldSubmitted: (_) {
                                            FocusScope.of(context)
                                                .requestFocus(publicadorFocus);
                                          },
                                          onSaved: (nome) =>
                                              _formData['nome'] = nome ?? '',
                                          validator: (nme) {
                                            final nome = nme ?? '';

                                            if (nome.trim().isEmpty) {
                                              return 'Nome é obrigatório';
                                            }

                                            return null;
                                          }),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // OBSERVAÇÕES
                            SizedBox(
                              height: 40,
                              //width: 200,
                              child: TextFormField(
                                style: const TextStyle(fontSize: 14),
                                maxLines: 1,
                                initialValue:
                                    _formData['observacoes']?.toString(),
                                decoration: InputDecoration(
                                    labelText: 'Observações',
                                    labelStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                textInputAction: TextInputAction.next,
                                focusNode: observacoesFocus,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(urlFocus);
                                },
                                onSaved: (observacoes) =>
                                    _formData['observacoes'] =
                                        observacoes ?? '',
                              ),
                            ),

                            //URL
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 42),
                              child: TextFormField(
                                  maxLines: 3,
                                  style: const TextStyle(fontSize: 14),
                                  initialValue: _formData['url']?.toString(),
                                  decoration: InputDecoration(
                                      labelText: 'Url do Mapa',
                                      labelStyle: const TextStyle(fontSize: 12),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  focusNode: _imageUrlFocus,
                                  controller: _imageUrlController,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_imageUrlFocus);
                                  },
                                  onSaved: (url) =>
                                      _formData['url'] = url ?? '',
                                  validator: (ur) {
                                    final url = ur ?? '';

                                    if (!isValidImageUrl(url)) {
                                      return 'Informe uma Url válida!';
                                    }

                                    return null;
                                  }),
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
}
