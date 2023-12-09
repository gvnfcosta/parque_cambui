import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parquecambui/src/constants/app_customs.dart';
import 'package:parquecambui/src/models/user_list.dart';
import 'package:parquecambui/src/pages/home/territories/new_territories_page.dart';
import 'package:provider/provider.dart';

import '../../../../models/territories_model.dart';
import '../../../../models/publicador_list.dart';
import '../../../../models/territories_list.dart';
import '../../territories/territory_tile.dart';

class TerritoriesTab extends StatefulWidget {
  const TerritoriesTab({super.key});

  @override
  State<TerritoriesTab> createState() => _TerritoriesTabState();
}

bool isDirigente = false;
bool isPublicador = false;
int tipoTela = 0;

class _TerritoriesTabState extends State<TerritoriesTab> {
  @override
  void initState() {
    super.initState();
    Provider.of<TerritoriesList>(context, listen: false).loadData();
    Provider.of<UserList>(context, listen: false).loadData();
  }

  final List<Widget> adminTab = [
    const Tab(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Meus'), Text('Territórios')])),
    const Tab(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Territórios'), Text('Disponíveis')])),
    const Tab(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Todos os'), Text('Territórios')])),
  ];

  final List<Widget> dirigenteTab = [
    const Tab(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Meus'), Text('Territórios')])),
    const Tab(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Territórios'), Text('Disponíveis')])),
    const Tab(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Territórios'), Text('Designados')])),
  ];

  final List<Widget> publicadorTab = [
    const Column(children: [Tab(text: 'Meus Territórios')]),
    const Column(children: [Tab(text: 'Territórios Designados ')]),
  ];

  @override
  Widget build(BuildContext context) {
    List<Territories> territories =
        Provider.of<TerritoriesList>(context).items2;
    PublicadorList user = Provider.of<PublicadorList>(context);
    bool isAdmin = user.levelPub! == UserLevel.territories ||
        user.levelPub! >= UserLevel.ministerio;

    isDirigente = user.isDirigente;
    isPublicador = !isAdmin && !isDirigente;
    String nomeUsuario = user.namePub!;

    final List<Territories> meusTerritories = territories
        .where((element) => element.publicador == nomeUsuario)
        .toList()
      ..sort(((a, b) => b.dataConclusao.compareTo(a.dataConclusao)));

    final List<Territories> territoriesDisponiveis = territories
        .where((element) => element.publicador == 'sem_designação')
        .toList()
      ..sort(((a, b) => a.dataConclusao.compareTo(b.dataConclusao)));

    final List<Territories> territoriesInHands = territories
        .where((element) => element.publicador != 'sem_designação')
        .toList()
      ..sort(
          ((a, b) => a.numero.substring(1).compareTo(b.numero.substring(1))));

    double tamanhoTela = MediaQuery.of(context).size.width;
    int quantidadeItemsTela = tamanhoTela ~/ 150; // divisão por inteiro

    final List<Widget> adminTabBarView = [
      Column(
        children: [
          Expanded(
            child: _TerritoriesGridWidget(
              territories: meusTerritories,
              quantidadeItemsTela: quantidadeItemsTela,
              isTile: true,
              tipoTela: 0,
            ),
          ),
        ],
      ),
      Column(
        children: [
          Expanded(
            child: _TerritoriesGridWidget(
              territories: territoriesDisponiveis,
              quantidadeItemsTela: quantidadeItemsTela,
              isTile: true,
              tipoTela: 1,
            ),
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          isAdmin
              ? SizedBox(
                  height: 20,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) => const NewTerritoriesPage()));
                      },
                      icon: CustomIcons.addIconMini),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: _TerritoriesGridWidget(
              territories: territories,
              quantidadeItemsTela: 1,
              isTile: false,
              tipoTela: 2,
            ),
          ),
        ],
      ),
    ];

    final List<Widget> dirigenteTabBarView = [
      Column(
        children: [
          Expanded(
            child: _TerritoriesGridWidget(
              territories: meusTerritories,
              quantidadeItemsTela: quantidadeItemsTela,
              isTile: true,
              tipoTela: 0,
            ),
          ),
        ],
      ),
      Column(
        children: [
          Expanded(
            child: _TerritoriesGridWidget(
              territories: territoriesDisponiveis,
              quantidadeItemsTela: quantidadeItemsTela,
              isTile: true,
              tipoTela: 1,
            ),
          ),
        ],
      ),
      Column(
        children: [
          Expanded(
            child: _TerritoriesGridWidget(
              territories: territoriesInHands,
              quantidadeItemsTela: 1,
              isTile: false,
              tipoTela: 2,
            ),
          ),
        ],
      ),
    ];

    final List<Widget> publicadorTabBarView = [
      Column(
        children: [
          Expanded(
            child: _TerritoriesGridWidget(
              territories: meusTerritories,
              quantidadeItemsTela: quantidadeItemsTela,
              isTile: true,
              tipoTela: 0,
            ),
          ),
        ],
      ),
      Column(
        children: [
          Expanded(
            child: _TerritoriesGridWidget(
              territories: territoriesInHands,
              quantidadeItemsTela: 1,
              isTile: false,
              tipoTela: 1,
            ),
          ),
        ],
      ),
    ];

    return DefaultTabController(
      length: isPublicador ? 2 : 3,
      child: Scaffold(
        //App bar
        appBar: AppBar(
          titleSpacing: 2,
          backgroundColor: CustomColors.mainAppBarBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Row(
            children: [
              isAdmin
                  ? Expanded(
                      child: TabBar(
                      tabs: adminTab,
                      indicatorColor: Colors.grey,
                      labelStyle:
                          const TextStyle(fontSize: CustomFonts.appBarFontSize),
                    ))
                  : isDirigente
                      ? Expanded(
                          child: TabBar(
                          tabs: dirigenteTab,
                          indicatorColor: Colors.grey,
                        ))
                      : Expanded(
                          child: TabBar(
                            tabs: publicadorTab,
                            indicatorWeight: 0.1,
                            labelStyle: const TextStyle(
                                fontSize: CustomFonts.appBarFontSize),
                          ),
                        ),
            ],
          ),
        ),
        // Categorias
        body: isAdmin
            ? TabBarView(children: adminTabBarView)
            : isDirigente
                ? TabBarView(
                    children: dirigenteTabBarView,
                  )
                : TabBarView(
                    children: publicadorTabBarView,
                  ),
      ),
    );
  }
}

class _TerritoriesGridWidget extends StatelessWidget {
  const _TerritoriesGridWidget({
    Key? key,
    required this.territories,
    required this.quantidadeItemsTela,
    required this.isTile,
    required this.tipoTela,
  }) : super(key: key);

  final List<Territories> territories;
  final int quantidadeItemsTela;
  final bool isTile;
  final int tipoTela;

  @override
  Widget build(BuildContext context) {
    return territories.isEmpty
        ? Center(
            child: Text(
            'Não há nenhum território',
            style: Theme.of(context).textTheme.headlineSmall,
          ))
        : Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RefreshIndicator(
              onRefresh: () => _refreshData(context),
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(8, 0, 16, 8),
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: quantidadeItemsTela,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childAspectRatio: isTile ? 7 / 7 : 5,
                ),
                itemCount: territories.length,
                itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                  value: territories[index],
                  child: TerritoryTile(
                    isTile: isTile,
                    tipoTela: tipoTela,
                    isPublicador: isPublicador,
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> _refreshData(BuildContext context) {
    return Provider.of<TerritoriesList>(context, listen: false).loadData();
  }
}
