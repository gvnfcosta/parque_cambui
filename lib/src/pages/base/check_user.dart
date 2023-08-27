import 'dart:async';

import 'package:flutter/material.dart';

import 'package:parquecambui/src/models/publicador_list.dart';
import 'package:parquecambui/src/pages/home/components/app_drawer.dart';
import 'package:provider/provider.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

bool _isLoading = true;

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    super.initState();
    Provider.of<PublicadorList>(context, listen: false).loadPublicador();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                      'Buscando Usuário...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const LinearProgressIndicator(
                      color: Colors.amberAccent,
                    ),

                    // Text(
                    //   'Você pode entrar em contato\ncom o Administrador',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     color: Colors.grey.shade400,
                    //   ),
                    // ),
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
