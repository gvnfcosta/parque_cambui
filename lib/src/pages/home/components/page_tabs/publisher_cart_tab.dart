import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parquecambui/src/constants/app_customs.dart';
import 'package:parquecambui/src/models/publicador_list.dart';
import 'package:parquecambui/src/models/publicador_model.dart';
import 'package:parquecambui/src/models/publisher_cart_list.dart';
import 'package:parquecambui/src/models/publisher_cart_model.dart';
import 'package:parquecambui/src/pages/home/publisher_cart/new_publisher_cart_page.dart';
import 'package:parquecambui/src/pages/home/publisher_cart/publisher_cart_tile.dart';
import 'package:provider/provider.dart';

class PublisherCartTab extends StatefulWidget {
  const PublisherCartTab({super.key});

  @override
  State<PublisherCartTab> createState() => _PublisherCartTabState();
}

bool isAdmin = false;
bool isPublisher = false;
String nomeUsuario = '';
int tipoTela = 0;

class _PublisherCartTabState extends State<PublisherCartTab> {
  @override
  void initState() {
    super.initState();
    Provider.of<PublisherCartList>(context, listen: false).loadData();
  }

  final List<Widget> adminTab = [
    const Tab(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Meu'), Text('Carrinho')])),
    const Tab(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Carrinho'), Text('Disponível')])),
    const Tab(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Todos os'), Text('Carrinhos')])),
  ];

  final List<Widget> dirigenteTab = [
    const Tab(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Meu'), Text('Carrinho')])),
    const Tab(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Carrinho'), Text('Disponível')])),
  ];

  @override
  Widget build(BuildContext context) {
    List<PublisherCart> cart = Provider.of<PublisherCartList>(context).items_;
    List<Publicador> usuario = Provider.of<PublicadorList>(context).usuario;

    if (usuario.isNotEmpty) {
      isAdmin = (usuario.first.nivel == 4 || usuario.first.nivel >= 6);
      isPublisher = (usuario.first.nivel == 3 || usuario.first.nivel >= 6);
      nomeUsuario = usuario.first.nome;
    }

    final List<PublisherCart> myCart = cart
        .where((element) => element.publisher == nomeUsuario)
        .toList()
      ..sort(((a, b) => b.finalDate.compareTo(a.finalDate)));

    final List<PublisherCart> availableCart = cart
        .where((element) => element.publisher == 'Salão do Reino')
        .toList()
      ..sort(((a, b) => a.finalDate.compareTo(b.finalDate)));

    double tamanhoTela = MediaQuery.of(context).size.width;
    int quantidadeItemsTela = tamanhoTela ~/ 150; // divisão por inteiro

    final List<Widget> adminTabBarView = [
      Column(
        children: [
          Expanded(
            child: CartsGridWidget(
              carts: myCart,
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
            child: CartsGridWidget(
              carts: availableCart,
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
                  height: 30,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) => const NewPublisherCartPage()));
                      },
                      icon: CustomIcons.addIconMini),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: CartsGridWidget(
              carts: cart,
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
            child: CartsGridWidget(
              carts: myCart,
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
            child: CartsGridWidget(
              carts: availableCart,
              quantidadeItemsTela: quantidadeItemsTela,
              isTile: true,
              tipoTela: 1,
            ),
          ),
        ],
      ),
    ];

    return DefaultTabController(
      length: isAdmin
          ? 3
          : isPublisher
              ? 2
              : 1,
      child: Scaffold(
        //App bar
        appBar: AppBar(
          titleSpacing: 2,
          backgroundColor: Colors.blueGrey.shade800,
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
                  : isPublisher
                      ? Expanded(
                          child: TabBar(
                          tabs: dirigenteTab,
                          indicatorColor: Colors.grey,
                        ))
                      : const Expanded(
                          child: TabBar(
                            tabs: [
                              Tab(text: 'Meu Carrinho'),
                            ],
                            indicatorWeight: 0.1,
                            indicatorColor: Colors.grey,
                            labelStyle:
                                TextStyle(fontSize: CustomFonts.appBarFontSize),
                          ),
                        ),
            ],
          ),
        ),
        // Categorias
        body: isAdmin
            ? TabBarView(children: adminTabBarView)
            : isPublisher
                ? TabBarView(children: dirigenteTabBarView)
                : TabBarView(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: CartsGridWidget(
                              carts: myCart,
                              quantidadeItemsTela: quantidadeItemsTela,
                              isTile: true,
                              tipoTela: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}

class CartsGridWidget extends StatelessWidget {
  const CartsGridWidget({
    Key? key,
    required this.carts,
    required this.quantidadeItemsTela,
    required this.isTile,
    required this.tipoTela,
  }) : super(key: key);

  final List<PublisherCart> carts;
  final int quantidadeItemsTela;
  final bool isTile;
  final int tipoTela;

  @override
  Widget build(BuildContext context) {
    return carts.isEmpty
        ? Center(
            child: Text(
            'Você não tem nenhum carrinho',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ))
        : Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RefreshIndicator(
              onRefresh: () => _refreshData(context),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(8, 0, 16, 8),
                physics: const BouncingScrollPhysics(),
                itemCount: carts.length,
                itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                  value: carts[index],
                  child: PublisherCartTile(
                    isTile: isTile,
                    tipoTela: tipoTela,
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> _refreshData(BuildContext context) {
    return Provider.of<PublisherCartList>(context, listen: false).loadData();
  }
}
