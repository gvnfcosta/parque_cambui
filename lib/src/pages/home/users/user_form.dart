import 'package:flutter/material.dart';
import '/src/models/user_model.dart';
import 'package:provider/provider.dart';

import '../../../models/user_list.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _levelFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<UserList>(context, listen: false).loadData().then((value) {
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
        final user = arg as UserModel;

        _formData['name'] = user.name;
        _formData['email'] = user.email;
        _formData['level'] = user.level;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _levelFocus.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<UserList>(context, listen: false).saveData(_formData);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('ERRO!'),
          content: const Text('Erro na gravação dos dados'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastros de Usuários'),
        actions: [
          IconButton(onPressed: _submitForm, icon: const Icon(Icons.check)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 320,
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                            initialValue: _formData['name']?.toString(),
                            decoration:
                                const InputDecoration(labelText: 'Nome'),
                            textInputAction: TextInputAction.next,
                            focusNode: _nameFocus,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_emailFocus);
                            },
                            onSaved: (name) => _formData['name'] = name ?? '',
                            validator: (name2) {
                              final name = name2 ?? '';
                              if (name.trim().isEmpty) {
                                return 'Nome é obrigadtório';
                              }
                              return null;
                            }),

                        // E-mail
                        TextFormField(
                            initialValue: _formData['email']?.toString(),
                            decoration:
                                const InputDecoration(labelText: 'E-mail'),
                            textInputAction: TextInputAction.next,
                            focusNode: _emailFocus,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_levelFocus);
                            },
                            onSaved: (enail) =>
                                _formData['email'] = enail ?? '',
                            validator: (enail2) {
                              final enail = enail2 ?? '';
                              if (enail.trim().isEmpty) {
                                return 'E-mail é obrigadtório';
                              }
                              return null;
                            }),

                        // // Nível
                        TextFormField(
                            initialValue: _formData['level']?.toString(),
                            decoration:
                                const InputDecoration(labelText: 'Nível'),
                            textInputAction: TextInputAction.next,
                            focusNode: _levelFocus,
                            onSaved: (level) =>
                                _formData['level'] = level ?? '',
                            validator: (level2) {
                              final level = level2 ?? '';
                              if (level.trim().isEmpty) {
                                return 'Nível é obrigadtório';
                              }
                              return null;
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
