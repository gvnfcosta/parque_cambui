import 'package:flutter/material.dart';
import 'package:parquecambui/src/models/publicador_list.dart';
import 'package:parquecambui/src/pages/home/components/app_drawer.dart';
import 'package:provider/provider.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({Key? key}) : super(key: key);

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    super.initState();
    Provider.of<PublicadorList>(context, listen: false).loadPublicador();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icone.png'),
                    const SizedBox(height: 10),
                    Text(
                      'Buscando Usuário...\nContate o Administrador',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const LinearProgressIndicator(color: Colors.amberAccent),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
