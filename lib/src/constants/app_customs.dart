import 'package:flutter/material.dart';

int red = 26;
int green = 34;
int blue = 126;

Map<int, Color> _swatchOpacity = {
  50: Color.fromRGBO(red, green, blue, .1),
  100: Color.fromRGBO(red, green, blue, .2),
  200: Color.fromRGBO(red, green, blue, .3),
  300: Color.fromRGBO(red, green, blue, .4),
  400: Color.fromRGBO(red, green, blue, .5),
  500: Color.fromRGBO(red, green, blue, .6),
  600: Color.fromRGBO(red, green, blue, .7),
  700: Color.fromRGBO(red, green, blue, .8),
  800: Color.fromRGBO(red, green, blue, .9),
  900: Color.fromRGBO(red, green, blue, 1),
};

abstract class CustomColors {
  static Color customContrastColor = Colors.blueGrey.shade800;
  static MaterialColor customSwatchColor =
      MaterialColor(0xFF1a227e, _swatchOpacity);
  static const backColor = Colors.grey;
  static Color editColor = Colors.orange;
  static Color messageColor = Colors.grey;
  static Color buttomAlertColor = Colors.orange.shade800;
  static Color deleteColor = Colors.red;
  static Color softEditColor =
      Colors.grey.withAlpha(200); // Colors.orangeAccent.withAlpha(200);
  static Color softDeleteColor =
      Colors.grey.withAlpha(200); // Colors.redAccent.withAlpha(250);
  static Color scaffoldBackgroundColor = Colors.white.withAlpha(220);
  static Color cardBackgroundColor = Colors.white.withAlpha(200);
  static Color appBarBackgroundColor = Colors.blueGrey.shade600;
  static Color mainAppBarBackgroundColor = Colors.blueGrey.shade800;
  static Color editAppBarBackgroundColor = Colors.indigo;
  static Color containerBacgroundColor = Colors.white;
  static Color tileBacgroundColor = Colors.white;
  static Color appBarIndicatorColor = Colors.grey;
}

abstract class CustomIcons {
  static Icon checkIcon = const Icon(Icons.check_outlined,
      color: Colors.yellow); // Colors.orangeAccent);
  static Icon editIcon = Icon(Icons.edit_outlined,
      color: Colors.grey.withAlpha(200)); // Colors.orangeAccent);
  static Icon editIconMini = Icon(Icons.edit_outlined,
      size: 20, color: Colors.grey.withAlpha(200)); // Colors.orangeAccent);
  static Icon addIconMini = Icon(Icons.add,
      size: 20, color: Colors.grey.withAlpha(200)); // Colors.orangeAccent);
  static Icon deleteIcon = Icon(Icons.delete_outlined,
      color: Colors.grey.withAlpha(200)); // Colors.redAccent);
  static Icon deleteIconMini = Icon(Icons.delete_outline,
      size: 20, color: Colors.grey.withAlpha(200)); // Colors.redAccent);
  static Icon addIcon = Icon(Icons.add, color: Colors.white.withAlpha(50));
}

abstract class CustomFonts {
  static const appBarFontSize = 12.0;
  static const appBarEditFontSize = 15.0;
}

abstract class CustomPadding {
  static const double reunionPadding = 15;
}

abstract class UserLevel {
  static const int padrao = 0;
  static const int publicador = 1;
  static const int testemunhoPublico = 2;
  static const int dirigente = 3;
  static const int territories = 4;
  static const int reuniaoVidaMinisterio = 5;
  static const int reuniaoPublica = 6;
  static const int auxiliarDeDesignacoes = 7;
  static const int ministerio = 8;
  static const int administrador = 10;
}
