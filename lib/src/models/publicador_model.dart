// ignore_for_file: public_member_api_docs, sort_constructors_first
class Publicador {
  String id;
  int nivel;
  String nome;
  String email;
  String privilegio;
  String grupo;
  bool leitorASentinela;
  bool leituraBiblia;
  bool conversaRevisita;
  bool discursoEstBiblico;
  bool leitorEstBiblico;
  bool indicador;
  bool volante;
  bool midias;

  Publicador({
    required this.id,
    required this.nivel,
    required this.nome,
    required this.email,
    required this.privilegio,
    required this.grupo,
    required this.leitorASentinela,
    required this.leituraBiblia,
    required this.conversaRevisita,
    required this.discursoEstBiblico,
    required this.leitorEstBiblico,
    required this.indicador,
    required this.volante,
    required this.midias,
  });
}
