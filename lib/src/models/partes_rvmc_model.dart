class PartesRvmcModel {
  DateTime data;
  String presidente;
  String tesouros;
  String joias;
  String leituraBiblia;
  String primeiraMinisterio;
  String segundaMinisterio;
  String terceiraMinisterio;
  String quartaMinisterio;
  String primeiraVida;
  String segundaVida;
  String terceiraVida;
  String estudoBiblico;
  String leitorEstudoBiblico;
  String oracaoFinal;

  PartesRvmcModel({
    required this.data,
    required this.presidente,
    required this.tesouros,
    required this.joias,
    required this.leituraBiblia,
    required this.primeiraMinisterio,
    required this.segundaMinisterio,
    this.terceiraMinisterio = '',
    this.quartaMinisterio = '',
    required this.primeiraVida,
    required this.segundaVida,
    this.terceiraVida = '',
    required this.estudoBiblico,
    required this.leitorEstudoBiblico,
    required this.oracaoFinal,
  });
}
