import 'package:flutter/material.dart';
import 'package:parquecambui/src/models/anuncios_locais_list.dart';
import 'package:provider/provider.dart';
import '../../../models/anuncios_locais_model.dart';
import '../../../models/publicador_list.dart';
import '../../../models/publicador_model.dart';
import 'anuncios_locais_tile.dart';

class AnunciosLocaisTab extends StatefulWidget {
  const AnunciosLocaisTab({super.key});

  @override
  State<AnunciosLocaisTab> createState() => _AnunciosLocaisTabState();
}

class _AnunciosLocaisTabState extends State<AnunciosLocaisTab> {
  bool _isLoading = true;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    Provider.of<AnunciosLocaisList>(context, listen: false)
        .loadData()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnunciosLocaisList>(context);

    final List<AnunciosLocais> anuncios = provider.anunciosAtuais;
    int itemQtde = anuncios.length;

    List<Publicador> usuario = Provider.of<PublicadorList>(context).usuario;

    if (usuario.isNotEmpty) {
      _isAdmin = usuario.first.nivel > 6;
    }

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              ),
              (itemQtde > 0)
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: itemQtde,
                          itemBuilder: (_, index) {
                            return AnunciosLocaisTile(anuncios[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              thickness: 2,
                              height: 25,
                            );
                          },
                        ),
                      ),
                    )
                  : const Center(child: Text('SEM REGISTROS')),
            ],
          );
  }
}
