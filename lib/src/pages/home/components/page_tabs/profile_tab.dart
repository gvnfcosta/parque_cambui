import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parquecambui/src/pages/common_widgets/common_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../models/auth.dart';
import '../../../../models/publicador_list.dart';
import '../app_drawer.dart';
import '/src/pages/common_widgets/custom_text_field.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

bool _isLoading = true;
bool _isObscure = false;

String? _oldPassword = '';
String? _newPassword = '';
String? _confirmPassword = '';

class _ProfileTabState extends State<ProfileTab> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    String? userName = Provider.of<PublicadorList>(context).namePub;

    return Scaffold(
      appBar: AppBar(
        // actions: const [ThemeCustomWidget()],
        title: const Text('Perfil do Usuário'),
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: userName!.isEmpty
          ? semRegistro(context)
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              children: [
                //Email
                CustomTextField(
                    readOnly: true,
                    initialValue: userName,
                    icon: Icons.person,
                    label: 'Usuário'),
                // Nome

                const SizedBox(height: 5),
                CustomTextField(
                  readOnly: true,
                  initialValue: auth.email,
                  icon: Icons.email,
                  label: 'Email',
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  readOnly: true,
                  initialValue: '2.3.0',
                  icon: CupertinoIcons.bars,
                  label: 'Versão',
                ),

                const SizedBox(height: 50),
                //Botão para atualizar a senha
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          updatePassword();
                        },
                        child: const Text('Atualizar Senha'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
      drawer: const AppDrawer(),
    );
  }

  updatePassword() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        // Título
                        child: Text('Atualização de Senha',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      // Senha atual
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Senha Atual',
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Colors.pink,
                          ),
                          suffixIcon: IconButton(
                              onPressed: (() {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }),
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.pink,
                              )),
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: _isObscure,
                        controller: oldPasswordController,
                        onSaved: (password) => _oldPassword = password ?? '',
                        validator: (password_) {
                          final password = password_ ?? '';
                          if (password.isEmpty || password.length < 5) {
                            return 'Informe uma senha válida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      // Nova senha
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nova Senha',
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Colors.pink,
                          ),
                          suffixIcon: IconButton(
                              onPressed: (() {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }),
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.pink,
                              )),
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: _isObscure,
                        controller: newPasswordController,
                        onSaved: (password) => _newPassword = password ?? '',
                        validator: (value) {
                          if (value!.length < 6) {
                            return "A senha não deve ter menos que 6 caracteres";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 5),
                      //Confirmação nova senha
                      TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Confirmar Senha',
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            prefixIcon: const Icon(
                              Icons.password,
                              color: Colors.pink,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          obscureText: _isObscure,
                          controller: confirmPasswordController,
                          onSaved: (password) =>
                              _confirmPassword = password ?? '',
                          validator: (value) {
                            if (value != newPasswordController.text) {
                              return 'Senhas informadas não conferem.';
                            }
                            return null;
                          }),
                      const SizedBox(height: 10),
                      // Botão de confirmação
                      SizedBox(
                        height: 45,
                        width: 80,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed:
                              // authController.isLoading.value
                              //       ? null
                              //       :
                              () {
                            if (_formKey.currentState!.validate()) {
                              // authController.changePassword(
                              //   currentPassword:
                              //       oldPasswordController.text,
                              //   newPassword:
                              //       newPasswordController.text,
                              // );
                            }
                          },
                          child: const Text('ATUALIZAR'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
