import 'package:flutter/material.dart';

separator() {
  return const SizedBox(height: 15);
}

emptyBox() {
  return const SizedBox.shrink();
}

Center anuncioText(context) {
  return Center(
    child:
        Text('(em breve...)', style: Theme.of(context).textTheme.displayMedium),
  );
}

semRegistro(context) {
  return Center(
      child: Text(
    'Nenhum registro encontrado',
    style: Theme.of(context).textTheme.headlineSmall,
    textAlign: TextAlign.center,
  ));
}
