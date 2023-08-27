import 'package:flutter/material.dart';
import 'package:parquecambui/src/config/app_data.dart';
import 'package:parquecambui/src/constants/app_customs.dart';
import 'package:parquecambui/src/models/publisher_cart_list.dart';
import 'package:parquecambui/src/models/publisher_cart_model.dart';
import 'package:provider/provider.dart';
import '../../../../services/utils_services.dart';
import '../../../models/publicador_list.dart';

class NewPublisherCartPage extends StatefulWidget {
  const NewPublisherCartPage({super.key});

  @override
  State<NewPublisherCartPage> createState() => _NewPublisherCartPageState();
}

class _NewPublisherCartPageState extends State<NewPublisherCartPage> {
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

      _formData['cartName'] = _formData['cartName'] ?? '';
      _formData['publisher'] = _formData['publisher'] ?? 'Salão do Reino';
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.appBarBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Cadastro de Carrinhos'),
        actions: [
          IconButton(onPressed: _submitForm, icon: CustomIcons.checkIcon)
        ],
      ),
      body: SizedBox(
        height: deviceSize.height,
        width: deviceSize.width,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                // child: Hero(
                // tag: publisherCartImage,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Image.network(
                      publisherCartImage,
                    )),
                //),
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
                        height: 100,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //NOME DO CARRINHO
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      maxLines: 1,
                                      initialValue:
                                          _formData['cartName']?.toString(),
                                      decoration: InputDecoration(
                                          labelText: 'Nome do Carrinho',
                                          labelStyle:
                                              const TextStyle(fontSize: 12),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      textInputAction: TextInputAction.next,
                                      focusNode: cartNameFocus,
                                      onSaved: (nome) =>
                                          _formData['cartName'] = nome ?? '',
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
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
