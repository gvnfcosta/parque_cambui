import 'package:flutter/material.dart';
import '../../../../constants/app_customs.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  String selectedCategory = 'Celebração';

  @override
  Widget build(BuildContext context) {
    double tamanhoTela = MediaQuery.of(context).size.width;
    int quantidadeItemsTela = tamanhoTela ~/ 150; // divisão por inteiro

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          toolbarHeight: 40,
          backgroundColor: Colors.white,
          title: TabBar(
            isScrollable: true,
            labelColor: Colors.indigo.shade900,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Congresso'),
              Tab(text: 'Assembléias'),
              Tab(text: 'Visita do Viajante'),
              Tab(text: 'Celebração'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _EventsGridWidget(
                quantidadeItemsTela,
                'https://firebasestorage.googleapis.com/v0/b/pqcambui-41a18.appspot.com/o/images%2FCongresso_2023.jpg?alt=media&token=c4ca7bae-11d2-42cc-9575-f517fee79428',
                'Congresso Regional\ndias 28, 29 e 30 de julho'),
            _EventsGridWidget(
                quantidadeItemsTela,
                'https://firebasestorage.googleapis.com/v0/b/pqcambui-41a18.appspot.com/o/images%2FAssembleias_2024.jpg?alt=media&token=d115111d-e482-4d6a-b42f-2a70add09f56',
                'Assembléias de Circuito'),
            // 'Assembléias de Circuito\nCom Representante de Betel - 3 de dezembro de 2023\nCom Superintendente de Circuito - 17 de fevereiro de 2024'),
            _EventsGridWidget(
                quantidadeItemsTela,
                'https://publicdomainvectors.org/photos/1534903384.png',
                'Visita do casal viajante\nIrmãos Almir e Rose\n '),
            _EventsGridWidget(
                quantidadeItemsTela,
                'https://assetsnffrgf-a.akamaihd.net/assets/m/202023101/univ/art/202023101_univ_lsr_lg.jpg',
                '\nCelebração da Morte de Jesus Cristo\nDomingo, 24 de março de 2024'),
          ],
        ),
      ),
    );
  }
}

class _EventsGridWidget extends StatelessWidget {
  const _EventsGridWidget(this.quantidadeItemsTela, this.imagem, this.texto,
      {Key? key})
      : super(key: key);

  final int quantidadeItemsTela;
  final String imagem;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          Text(
            texto,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: CustomColors.customContrastColor,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              child: Image.network(imagem, fit: BoxFit.contain),
            ),
          )),
        ],
      ),
    );
  }
}
