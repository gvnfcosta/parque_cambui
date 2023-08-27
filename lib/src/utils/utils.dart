String codificador(texto, codifica) {
  String textoCodificado = '';
  int tamanhoTexto = texto.length;

  String encripta = chaveString;

  for (int i = 0; i < tamanhoTexto; i++) {
    String num1 = encripta[i * 3 + 1];
    String num2 = encripta[i * 3 + 2];
    String num3 = encripta[i * 3 + 3];

    int num = int.parse('$num1$num2$num3');

    String letraCodificada = codifica
        ? String.fromCharCode(texto.codeUnitAt(i) + num)
        : String.fromCharCode(texto.codeUnitAt(i) - num);
    textoCodificado = textoCodificado + letraCodificada;
  }
  return textoCodificado;
}

const String chaveString =
    'A012034023045057035084071063056075069041011042033026047015034023046017039026045028030005008010045063045057063056041011015034022031045057063056041011015034022031046017039026045028030005008010045063069041011042033026047015034023012034023045057035084071063056075';
