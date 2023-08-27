import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_routes.dart';
import '../../../models/auth.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';

bool isAdmin = false;

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String nomeUsuario = 'Convidado';
    List<Publicador> usuario = Provider.of<PublicadorList>(context).usuario;

    if (usuario.isNotEmpty) {
      isAdmin = usuario.first.nivel >= 5;
      nomeUsuario = usuario.first.nome;
    }

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Bem vindo ${nomeUsuario.split(' ')[0]}!'),
            automaticallyImplyLeading: false,
          ),
          isAdmin
              ? Column(
                  children: [
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.person_2_outlined),
                      title: const Text('Administradores'),
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.userForm);
                      },
                    ),
                    const Divider(),
                  ],
                )
              : const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ajuda'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Provider.of<Auth>(
                context,
                listen: false,
              ).logout();
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.authOrHome,
              );
            },
          ),
        ],
      ),
    );
  }
}

// bool _isAdmin(BuildContext context) {
//   final Auth auth = Provider.of(context);
//   final providerPub = Provider.of<PublicadorList>(context);

//   final List<Publicador> usuario = providerPub.items2
//       .where((element) => element.email == auth.email)
//       .toList();

//   int nivel = usuario.first.nivel;
//   return nivel == 5 || nivel >= 7;
// }
