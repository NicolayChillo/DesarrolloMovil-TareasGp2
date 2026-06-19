import 'package:flutter/material.dart';
import '../colores_app.dart';

class TemaFloating {

  // =====================================
  // TEMA CLARO
  // =====================================

  static const FloatingActionButtonThemeData
      claro =
      FloatingActionButtonThemeData(

    backgroundColor:
        ColoresApp.primario,

    foregroundColor:
        Colors.white,

    elevation: 4,
  );

  // =====================================
  // TEMA OSCURO
  // =====================================

  static const FloatingActionButtonThemeData
      oscuro =
      FloatingActionButtonThemeData(

    backgroundColor:
        ColoresApp.acento,

    foregroundColor:
        Colors.white,

    elevation: 4,
  );
}