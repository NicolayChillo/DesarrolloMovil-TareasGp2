import 'package:flutter/material.dart';
import 'colores_app.dart';

class TipografiaApp {

  // =====================================
  // TEMA CLARO
  // =====================================

  static const TextTheme claro =
      TextTheme(

    // TITULO PRINCIPAL
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: ColoresApp.textoOscuro,
    ),

    // TITULOS
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: ColoresApp.textoOscuro,
    ),

    // TEXTO NORMAL
    bodyMedium: TextStyle(
      fontSize: 16,
      color: ColoresApp.textoOscuro,
      height: 1.5,
    ),

    // TEXTO SECUNDARIO
    bodySmall: TextStyle(
      fontSize: 14,
      color: ColoresApp.textoClaro,
    ),

    // LABELS
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: ColoresApp.textoOscuro,
    ),
  );

  // =====================================
  // TEMA OSCURO
  // =====================================

  static const TextTheme oscuro =
      TextTheme(

    // TITULO PRINCIPAL
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: ColoresApp.textoBlanco,
    ),

    // TITULOS
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: ColoresApp.textoBlanco,
    ),

    // TEXTO NORMAL
    bodyMedium: TextStyle(
      fontSize: 16,
      color: ColoresApp.textoGrisClaro,
      height: 1.5,
    ),

    // TEXTO SECUNDARIO
    bodySmall: TextStyle(
      fontSize: 14,
      color: ColoresApp.textoGrisClaro,
    ),

    // LABELS
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: ColoresApp.textoBlanco,
    ),
  );
}