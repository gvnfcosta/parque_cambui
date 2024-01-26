import 'package:parquecambui/src/constants/app_customs.dart';
import 'package:parquecambui/src/pages/home/reunioes/reuniao_publica_form.dart';
import 'package:parquecambui/src/pages/home/reunioes/reuniao_rvmc_form.dart';
import 'package:parquecambui/src/pages/home/reunioes/reunioes_grid_widget.dart';

import '/src/models/reuniao_rvmc_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/publicador_list.dart';
import '../../../../models/reuniao_publica_list.dart';
import '../../../../models/reuniao_publica_model.dart';
import '../../../../models/reuniao_rvmc_list.dart';
import 'events_tab.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

//bool _isLoading = false;
bool isAdmin = false;
bool allReunions = false;

class _HomeTabState extends State<HomeTab> {
  String selectedCategory = 'Reunião Pública';

  @override
  void initState() {
    super.initState();
    Provider.of<PublicadorList>(context, listen: false).loadPublicador();
    Provider.of<ReuniaoPublicaList>(context, listen: false)
        .loadReuniaoPublica();

    Provider.of<ReuniaoRvmcList>(context, listen: false).loadReuniaoRvmc();
  }

  @override
  Widget build(BuildContext context) {
    final providerRpub = Provider.of<ReuniaoPublicaList>(context);
    final providerRvmc = Provider.of<ReuniaoRvmcList>(context);

    if (providerRpub.items.isEmpty || providerRvmc.items.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<ReuniaoPublica> allRPub = providerRpub.items;
    final List<ReuniaoRvmc> allRvmc = providerRvmc.items;
    final List<ReuniaoPublica> reuniaoPublica = providerRpub.reunioesAtuais
      ..sort(((a, b) => a.date.compareTo(b.date)));
    final List<ReuniaoRvmc> reuniaoRvmc = providerRvmc.reunioesAtuais
      ..sort(((a, b) => a.date.compareTo(b.date)));

    PublicadorList user = Provider.of<PublicadorList>(context);
    bool isAdmin = user.levelPub! >= UserLevel.reuniaoVidaMinisterio;

    double tamanhoTela = MediaQuery.of(context).size.width;
    int quantidadeItemsTela = tamanhoTela ~/ 120; // divisão por inteiro

    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 2,
              backgroundColor: Colors.blueGrey.shade800,
              elevation: 1,
              title: TabBar(
                tabs: tabItems,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.grey,
                dividerColor: Colors.blueGrey.shade800,
              ),
              actions: [
                SizedBox(
                  height: 20,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          allReunions = !allReunions;
                        });
                      },
                      icon: const Icon(
                        Icons.timeline,
                        color: Colors.grey,
                      )),
                ),
              ],
            ),
            body:
                //  _isLoading                 ? const Center(child: CircularProgressIndicator())                :
                TabBarView(
              children: [
                RvmcGridWidget(quantidadeItemsTela,
                    allReunions ? allRvmc : reuniaoRvmc, isAdmin),
                RpubGridWidget(quantidadeItemsTela,
                    allReunions ? allRPub : reuniaoPublica, isAdmin),
                const EventsTab(),
              ],
            ),
            floatingActionButton: isAdmin
                ? FloatingActionButton(
                    onPressed: () {
                      DefaultTabController.of(context).index == 0
                          ? Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) {
                                return const ReuniaoRvmcForm();
                              },
                            ))
                          : DefaultTabController.of(context).index == 1
                              ? Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (c) {
                                      return const ReuniaoPublicaForm();
                                    },
                                  ),
                                )
                              : DefaultTabController.of(context).index == 2
                                  ? null
                                  : null;
                    },
                    backgroundColor: CustomColors.appBarBackgroundColor,
                    tooltip: 'Nova',
                    child: const Icon(Icons.add))
                : null,
          );
        },
      ),
    );
  }
}

List<Widget> tabItems = [
  const Tab(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Vida e'), Text('Ministério')])),
  const Tab(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Reunião'), Text('Pública')])),
  const Tab(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Eventos'), Text('Teocráticos')])),
];
