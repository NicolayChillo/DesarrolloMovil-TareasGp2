import 'package:flutter/material.dart';
import '../colores_app.dart';

class TemaCheckbox {

  // =====================================
  // TEMA CLARO
  // =====================================

  static CheckboxThemeData claro =
      CheckboxThemeData(

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),

    fillColor:
        WidgetStateProperty.resolveWith(

      (states) {

        if(states.contains(
            WidgetState.selected)) {

          return ColoresApp.primario;
        }

        return Colors.white;
      },
    ),

    checkColor:
        WidgetStateProperty.all(
      Colors.white,
    ),
  );

  // =====================================
  // TEMA OSCURO
  // =====================================

  static CheckboxThemeData oscuro =
      CheckboxThemeData(

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),

    fillColor:
        WidgetStateProperty.resolveWith(

      (states) {

        if(states.contains(
            WidgetState.selected)) {

          return ColoresApp.primario;
        }

        return ColoresApp.superficieOscura;
      },
    ),

    checkColor:
        WidgetStateProperty.all(
      Colors.white,
    ),
  );
}