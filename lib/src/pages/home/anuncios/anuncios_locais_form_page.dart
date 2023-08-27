import 'package:flutter/material.dart';
import 'package:parquecambui/src/models/anuncios_locais_list.dart';
import 'package:parquecambui/src/models/anuncios_locais_model.dart';
import 'package:provider/provider.dart';

class AnunciosLocaisForm extends StatefulWidget {
  const AnunciosLocaisForm({super.key});

  @override
  AnunciosLocaisFormState createState() => AnunciosLocaisFormState();
}

class AnunciosLocaisFormState extends State<AnunciosLocaisForm> {
  final _textoAnuncioFocus = FocusNode();
  final _validadeFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _data = <String, Object>{};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<AnunciosLocaisList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_data.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      _data['validade'] = DateTime.now();

      if (arg != null) {
        final anuncio = arg as AnunciosLocais;
        _data['id'] = anuncio.id;
        _data['textoAnuncio'] = anuncio.textoAnuncio;
        _data['validade'] = anuncio.validade;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textoAnuncioFocus.dispose();
    _validadeFocus.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    if (!isValid) return;

    try {
      await Provider.of<AnunciosLocaisList>(context, listen: false)
          .saveData(_data);
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Anúncios Locais'),
        actions: [
          IconButton(onPressed: _submitForm, icon: const Icon(Icons.check))
        ],
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
                        SizedBox(
                          // height: 100,
                          child: TextFormField(
                            initialValue: _data['textoAnuncio']?.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Anúncio',
                            ),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).hintColor),
                            textInputAction: TextInputAction.next,
                            focusNode: _textoAnuncioFocus,
                            maxLines: 20,
                            onSaved: (textoAnuncio) =>
                                _data['textoAnuncio'] = textoAnuncio ?? '',
                          ),
                        ),
                        // SizedBox(
                        //   height: 100,
                        //   child: TextFormField(
                        //     initialValue: _data['validade']?.toString() ?? '30',
                        //     decoration: const InputDecoration(
                        //       labelText: 'Data do Anúncio',
                        //     ),
                        //     style: TextStyle(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.w600,
                        //         color: Theme.of(context).hintColor),
                        //     textInputAction: TextInputAction.next,
                        //     keyboardType: const TextInputType.numberWithOptions(
                        //       decimal: false,
                        //       signed: false,
                        //     ),
                        //     focusNode: _validadeFocus,
                        //     maxLines: 1,
                        //     onSaved: (validade) =>
                        //         _data['validade'] = DateTime(validade ?? DateTime.now()).toString(),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
