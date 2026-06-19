import 'package:flutter/material.dart';
import '../colores_app.dart';

class TemaInputs {

  // =========================
  // CLARO
  // =========================

  static final InputDecorationTheme claro =
      InputDecorationTheme(

    filled: true,

    fillColor: Colors.white,

    contentPadding:
        const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 18,
    ),

    prefixIconColor:
        ColoresApp.primario,

    labelStyle: const TextStyle(
      color: ColoresApp.textoClaro,
    ),

    hintStyle: const TextStyle(
      color: ColoresApp.textoHint,
    ),

    enabledBorder:
        OutlineInputBorder(

      borderRadius:
          BorderRadius.circular(14),

      borderSide: const BorderSide(
        color: ColoresApp.borde,
      ),
    ),

    focusedBorder:
        OutlineInputBorder(

      borderRadius:
          BorderRadius.circular(14),

      borderSide: const BorderSide(
        color: ColoresApp.primario,
        width: 2,
      ),
    ),
  );

  // =========================
  // OSCURO
  // =========================

  static final InputDecorationTheme oscuro =
    InputDecorationTheme(

    filled: true,

    fillColor:
        ColoresApp.superficieOscura,

    contentPadding:
        const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 18,
    ),

    prefixIconColor:
        ColoresApp.primario,

    labelStyle: const TextStyle(
      color: ColoresApp.textoBlanco,
    ),

    hintStyle: TextStyle(
      color: ColoresApp.textoGrisClaro.withValues(alpha: 0.5),
    ),

    enabledBorder:
        OutlineInputBorder(

      borderRadius:
          BorderRadius.circular(14),

      borderSide: const BorderSide(
        color:
            ColoresApp.bordeOscuro,
      ),
    ),

    focusedBorder:
        OutlineInputBorder(

      borderRadius:
          BorderRadius.circular(14),

      borderSide: const BorderSide(
        color: ColoresApp.primario,
        width: 2,
      ),
    ),
  );
}