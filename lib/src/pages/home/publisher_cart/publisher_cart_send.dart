import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parquecambui/src/config/app_data.dart';
import 'package:parquecambui/src/models/publisher_cart_list.dart';
import 'package:parquecambui/src/models/publisher_cart_model.dart';
import 'package:provider/provider.dart';
import '../../../../services/utils_services.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';

class PublisherCartSendPage extends StatefulWidget {
  const PublisherCartSendPage({super.key});

  @override
  State<PublisherCartSendPage> createState() => _PublisherCartSendPageState();
}

bool isAdmin = false;

class _PublisherCartSendPageState extends State<PublisherCartSendPage> {
  final utilsServices = UtilsServices();
  final cartNameFocus = FocusNode();
  final publisherFocus = FocusNode();
  final initialDateFocus = FocusNode();
  final finalDateFocus = FocusNode();
  final observationsFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  DateTime setDate = DateTime.now();

  final formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<PublisherCartList>(context, listen: false)
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

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;

    return isValidUrl;
  }

  Future<void> _submitForm() async {
    print(_formData['publisher']);
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
    List<Publicador> usuario = Provider.of<PublicadorList>(context).usuario;

    if (usuario.isNotEmpty) {
      isAdmin = (usuario.first.nivel == 4 || usuario.first.nivel > 7);
    }

    final PublicadorList publicador = Provider.of(context);

    List<Publicador> publicadores = publicador.items2.toList()
      ..sort(((a, b) => a.nome.compareTo(b.nome)));

    Publicador salaoDoReino = Publicador(
        id: '0.000000',
        nivel: 1,
        nome: "Salão do Reino",
        email: '',
        privilegio: '',
        grupo: '',
        leitorASentinela: false,
        leituraBiblia: false,
        conversaRevisita: false,
        discursoEstBiblico: false,
        leitorEstBiblico: false,
        indicador: false,
        volante: false,
        midias: false);

    // publicadores.add(salaoDoReino);

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
        title: const Text('Solicitar Carrinho'),
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
                      child: Image.network(publisherCartImage)),
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
                          //NOME
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: SizedBox(
                                height: 40,
                                child: TextFormField(
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 1,
                                  readOnly: true,
                                  initialValue:
                                      _formData['cartName']?.toString(),
                                  decoration: InputDecoration(
                                      labelText: 'Carrinho',
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
                                ? const Text(' Publicador: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600))
                                : Text('Publicador: ${usuario.first.nome}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                            isAdmin
                                ? Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: SizedBox(
                                        height: 40,
                                        child: DropdownButton2(
                                          focusColor: Colors.white,
                                          focusNode: publisherFocus,
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
                                          value: _formData['publisher'],
                                          isDense: true,
                                          onChanged: (value) {
                                            setState(() {
                                              _formData['publisher'] =
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
                                  ? _formData['publisher'] = usuario.first.nome
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
