import 'package:flutter/material.dart';
import 'package:parquecambui/src/constants/app_customs.dart';
import 'package:parquecambui/src/pages/home/anuncios/anuncios_locais_form_page.dart';
import 'package:parquecambui/src/pages/home/anuncios/anuncios_locais_tab.dart';
import 'package:parquecambui/src/pages/home/limpeza/limpeza_form_page.dart';
import '/src/pages/home/limpeza/limpeza_tab.dart';
import 'package:provider/provider.dart';
import '../../../../models/publicador_list.dart';

bool isAdmin = false;

class AnunciosTab extends StatelessWidget {
  const AnunciosTab({super.key});

  @override
  Widget build(BuildContext context) {
    PublicadorList user = Provider.of<PublicadorList>(context);
    bool isAdmin = user.levelPub! >= 5;

    return DefaultTabController(
      length: 2,
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueGrey.shade800,
              title: const TabBar(
                tabs: [
                  //Tab(text: 'Cartas'),
                  Tab(text: 'Limpeza'),
                  Tab(text: 'Anúncios Locais'),
                ],
                indicatorColor: Colors.grey,
                labelStyle: TextStyle(fontSize: 13),
              ),
            ),
            body: const TabBarView(
              children: [
                LimpezaTab(),
                AnunciosLocaisTab(),
              ],
            ),
            floatingActionButton: isAdmin
                ? FloatingActionButton(
                    onPressed: () {
                      DefaultTabController.of(context).index == 0
                          ? Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) {
                                return const LimpezaForm();
                              },
                            ))
                          : Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) {
                                return const AnunciosLocaisForm();
                              },
                            ));
                    },
                    backgroundColor: CustomColors.appBarBackgroundColor,
                    tooltip: 'Nova',
                    child: const Icon(Icons.add))
                : null);
      }),
    );
  }
}
