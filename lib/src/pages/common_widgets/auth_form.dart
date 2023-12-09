import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parquecambui/src/pages/home/components/controllers/admin_controller.dart';
import 'package:provider/provider.dart';
import '../../exceptions/auth_exception.dart';
import '../../models/auth.dart';

enum AuthMode { signup, login }

bool _isWeb = AdminController().isWeb;

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _authData = {'email': '', 'password': ''};

  AuthMode _authMode = AuthMode.login;

  bool _isLoading = false;
  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;
  bool _isObscure = false;

  bool isChecked = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late Box box;

  @override
  void initState() {
    super.initState();
    _isObscure = true;

    if (!_isWeb) createOpenBox();
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
      emailController.text = '';
      passwordController.text = '';
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        // Login
        await auth.login(_authData['email']!, _authData['password']!);
      } else {
        // Registrar
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
      if (!_isWeb) login();
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.indigo,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (email) => _authData['email'] = email ?? '',
                    validator: (email_) {
                      final email = email_ ?? '';
                      if (email.trim().isEmpty || !email.contains('@')) {
                        return 'Informe um e-mail válido.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.indigo,
                        ),
                        suffixIcon: IconButton(
                            onPressed: (() =>
                                setState(() => _isObscure = !_isObscure)),
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.indigo,
                            )),
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: _isObscure,
                      controller: passwordController,
                      onSaved: (password) =>
                          _authData['password'] = password ?? '',
                      validator: (value) {
                        if (value!.length < 6) {
                          return "A senha não deve ter menos que 6 caracteres";
                        }
                        return null;
                      }),
                  const SizedBox(height: 5),
                  if (_isSignup())
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        prefixIcon: const Icon(
                          Icons.password_sharp,
                          color: Colors.indigo,
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: _isObscure,
                      validator: (password_) {
                        final password = password_ ?? '';
                        if (password != passwordController.text) {
                          return 'Senhas informadas não conferem.';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 180,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: Text(
                              _authMode == AuthMode.login
                                  ? 'ENTRAR'
                                  : 'REGISTRAR',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _switchAuthMode,
                        child: Text(
                          _isLogin() ? 'Não tenho conta' : 'Já tenho conta',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createOpenBox() async {
    box = await Hive.openBox('cambui_user_data');
    getdata();
  }

  void getdata() async {
    if (box.get('email') != null) {
      emailController.text = box.get('email');
      setState(() {});
    }
    if (box.get('pass') != null) {
      passwordController.text = box.get('pass');
      setState(() {});
    }
  }

  void login() {
    if (emailController.value.text != box.get('email') ||
        passwordController.value.text != box.get('password')) {
      box.put('email', emailController.value.text);
      box.put('pass', passwordController.value.text);
    }
  }
}
