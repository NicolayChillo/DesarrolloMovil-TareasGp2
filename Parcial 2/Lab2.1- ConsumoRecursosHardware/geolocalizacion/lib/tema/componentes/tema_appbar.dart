import 'package:flutter/material.dart';
import '../colores_app.dart';

class TemaAppBar {

  // =========================
  // CLARO
  // =========================

  static const AppBarTheme claro =
      AppBarTheme(

    backgroundColor:
        Color.fromARGB(255, 8, 65, 73),

    foregroundColor:
        Colors.white,

    centerTitle: true,

    elevation: 3,

    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  // =========================
  // OSCURO
  // =========================

  static const AppBarTheme oscuro =
      AppBarTheme(

    backgroundColor:
        ColoresApp.superficieOscura,

    foregroundColor:
        ColoresApp.textoBlanco,

    centerTitle: true,

    elevation: 2,

    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: ColoresApp.textoBlanco,
    ),
  );
}