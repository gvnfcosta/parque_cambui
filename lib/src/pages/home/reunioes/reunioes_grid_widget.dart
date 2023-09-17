import 'package:flutter/material.dart';
import 'package:parquecambui/src/pages/home/reunioes/rpub_tile.dart';
import 'package:parquecambui/src/pages/home/reunioes/rvmc_tile.dart';
import '../../../models/reuniao_publica_model.dart';
import '../../../models/reuniao_rvmc_model.dart';

class RpubGridWidget extends StatelessWidget {
  const RpubGridWidget(
      this.quantidadeItemsTela, this.reuniaoPublica, this.isAdmin,
      {Key? key})
      : super(key: key);

  final bool isAdmin;
  final int quantidadeItemsTela;
  final List<ReuniaoPublica> reuniaoPublica;

  @override
  Widget build(BuildContext context) {
    int itemQtde = reuniaoPublica.length;
    return Column(
      children: [
        (itemQtde > 0)
            ? Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: quantidadeItemsTela,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 10 / 11,
                  ),
                  itemCount: itemQtde,
                  itemBuilder: (ctx, i) {
                    return ReuniaoPublicaTile(reuniaoPublica[i]);
                  },
                ),
              )
            : const Center(child: Text('NENHUMA REUNIÃO DEFINIDA')),
      ],
    );
  }
}

class RvmcGridWidget extends StatelessWidget {
  const RvmcGridWidget(this.quantidadeItemsTela, this.reuniaoRvmc, this.isAdmin,
      {Key? key})
      : super(key: key);

  final bool isAdmin;
  final int quantidadeItemsTela;
  final List<ReuniaoRvmc> reuniaoRvmc;

  @override
  Widget build(BuildContext context) {
    int itemQtde = reuniaoRvmc.length;
    return Column(
      children: [
        (itemQtde > 0)
            ? Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: quantidadeItemsTela,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 10 / 11,
                  ),
                  itemCount: itemQtde,
                  itemBuilder: (ctx, i) {
                    return RvmcTile(reuniaoRvmc[i]);
                  },
                ),
              )
            : const Center(child: Text('NENHUMA REUNIÃO DEFINIDA')),
      ],
    );
  }
}
