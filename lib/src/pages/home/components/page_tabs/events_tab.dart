import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parquecambui/src/models/eventos/eventos.dart';
import 'package:parquecambui/src/models/eventos/eventos_list.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_customs.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

DateTime assembleiaDataViajante = DateTime(2024, 2, 17, 0, 0, 0);
DateTime assembleiaDataRepresentante = DateTime(2024, 2, 17, 0, 0, 0);
DateTime congressoData = DateTime(2024, 7, 12, 0, 0, 0);
DateTime celebracaoData = DateTime(2024, 3, 24, 0, 0, 0);
DateTime visitaData = DateTime(2024, 4, 16, 0, 0, 0);

bool _isLoading = true;
Eventos? evento;

// final evento = Eventos(
//   id: '1',
//   assembleiaDataViajante: assembleiaDataViajante,
//   assembleiaDataRepresentante: assembleiaDataRepresentante,
//   congressoData: congressoData,
//   celebracaoData: celebracaoData,
//   visitaData: visitaData,
// );

class _EventsTabState extends State<EventsTab> {
  String selectedCategory = 'Celebração';

  @override
  void initState() {
    super.initState();
    Provider.of<EventoList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  void _submitClass(Eventos data) async {
    await Provider.of<EventoList>(context, listen: false).saveClass(data);
  }

  String? dataAssembleiaDataRepresentante;
  String? dataAssembleiaDataViajante;
  String? dataCongresso;
  String? dataVisita;

  @override
  Widget build(BuildContext context) {
    List<Eventos> eventos = Provider.of<EventoList>(context).items;
    // _submitClass(evento);
    if (eventos.isNotEmpty) {
      evento = Eventos(
        id: '1',
        assembleiaDataViajante: eventos.first.assembleiaDataViajante,
        assembleiaDataRepresentante: eventos.first.assembleiaDataRepresentante,
        congressoData: eventos.first.congressoData,
        celebracaoData: eventos.first.celebracaoData,
        visitaData: eventos.first.visitaData,
        conventionImage: eventos.first.conventionImage,
      );
      dataAssembleiaDataRepresentante =
          evento!.assembleiaDataRepresentante.isBefore(DateTime.now())
              ? 'Sem Data'
              : DateFormat("dd 'de' MMMM 'de' yyy", 'pt_BR')
                  .format(evento!.assembleiaDataRepresentante);
      dataAssembleiaDataViajante =
          evento!.assembleiaDataRepresentante.isBefore(DateTime.now())
              ? 'Sem Data'
              : DateFormat("dd 'de' MMMM 'de' yyy", 'pt_BR')
                  .format(evento!.assembleiaDataViajante);
      dataVisita = evento!.visitaData.isBefore(DateTime.now())
          ? 'Sem Data'
          : '${DateFormat("d", 'pt_BR').format(evento!.visitaData)} a ${DateFormat("d 'de' MMMM 'de' yyy", 'pt_BR').format(evento!.visitaData.add(const Duration(days: 5)))}';
      dataCongresso = evento!.congressoData.isBefore(DateTime.now())
          ? 'Sem Data'
          : '${DateFormat("d", 'pt_BR').format(evento!.congressoData)}, ${DateFormat("d", 'pt_BR').format(evento!.congressoData.add(const Duration(days: 1)))} e ${DateFormat("dd 'de' MMMM 'de' yyy", 'pt_BR').format(evento!.congressoData.add(const Duration(days: 2)))}';
    }

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
        body: eventos.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _EventsGridWidget(evento!.conventionImage,
                      '${'Congresso Regional'.toUpperCase()}\n$dataCongresso'),
                  _EventsGridWidget(
                      'https://firebasestorage.googleapis.com/v0/b/pqcambui-41a18.appspot.com/o/images%2FAssembleias_2024.jpg?alt=media&token=d115111d-e482-4d6a-b42f-2a70add09f56',
                      '${'Assembléias de Circuito'.toUpperCase()}\nCom Representante de Betel - $dataAssembleiaDataRepresentante\nCom Superintendente de Circuito - $dataAssembleiaDataViajante'),
                  _EventsGridWidget(
                      'https://publicdomainvectors.org/photos/1534903384.png',
                      '${'Visita do casal viajante'.toUpperCase()}\nde $dataVisita'),
                  _EventsGridWidget(
                      'https://assetsnffrgf-a.akamaihd.net/assets/m/202023101/univ/art/202023101_univ_lsr_lg.jpg',
                      '${'Celebração da Morte de Jesus Cristo'.toUpperCase()}\n${DateFormat("dd 'de' MMMM 'de' yyy", 'pt_BR').format(evento!.celebracaoData)}'),
                ],
              ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     _submitClass(evento);
        //   },
        //   backgroundColor: CustomColors.appBarBackgroundColor,
        //   tooltip: 'Grava',
        //   child: const Icon(Icons.add),
        // )
      ),
    );
  }
}

class _EventsGridWidget extends StatelessWidget {
  const _EventsGridWidget(this.imagem, this.texto, {Key? key})
      : super(key: key);

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
              fontSize: 14,
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
