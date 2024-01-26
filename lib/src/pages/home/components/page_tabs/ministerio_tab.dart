import 'package:flutter/material.dart';
import 'package:parquecambui/src/constants/app_customs.dart';
import 'package:parquecambui/src/pages/home/ministerio/servico_campo_form.dart';
import 'package:provider/provider.dart';
import '../../../../models/publicador_list.dart';
import '../../ministerio/campo_tab.dart';
import 'grupos_tab.dart';

final List<Widget> _tabs = [
  const Tab(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Serviço'), Text('de Campo')])),
  const Tab(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Grupos'), Text('de Campo')])),
];

class MinisterioTab extends StatelessWidget {
  const MinisterioTab({super.key});

  @override
  Widget build(BuildContext context) {
    PublicadorList user = Provider.of<PublicadorList>(context);
    bool isAdmin = user.levelPub! >= UserLevel.auxiliarDeDesignacoes;

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              titleSpacing: 2,
              backgroundColor: Colors.blueGrey.shade800,
              title: TabBar(
                tabs: _tabs,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.grey,
                dividerColor: Colors.blueGrey.shade800,
              ),
            ),
            body: const TabBarView(
              children: [
                CampoTab(),
                GruposTab(),
              ],
            ),
            floatingActionButton: isAdmin
                ? FloatingActionButton(
                    onPressed: () {
                      DefaultTabController.of(context).index == 0
                          ? Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) => const ServicoCampoForm(),
                            ))
                          : DefaultTabController.of(context).index == 1
                              ? null
                              : null;
                    },
                    backgroundColor: CustomColors.appBarBackgroundColor,
                    tooltip: 'Nova',
                    child: const Icon(Icons.add))
                : null);
      }),
    );
  }
}
