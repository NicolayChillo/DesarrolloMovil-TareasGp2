import 'package:flutter/material.dart';
import '../colores_app.dart';

class TemaBotones {

  // =========================
  // CLARO
  // =========================

  static final ElevatedButtonThemeData claro =
      ElevatedButtonThemeData(

    style: ElevatedButton.styleFrom(

      backgroundColor:
          ColoresApp.primario,

      foregroundColor:
          Colors.white,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(14),
      ),
    ),
  );

  // =========================
  // OSCURO
  // =========================

  static final ElevatedButtonThemeData oscuro =
      ElevatedButtonThemeData(

    style: ElevatedButton.styleFrom(

      backgroundColor:
          ColoresApp.primario,

      foregroundColor:
          Colors.white,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(14),
      ),
    ),
  );
}