import 'package:flutter/material.dart';
import '../colores_app.dart';

class TemaCards {

  // =====================================
  // TEMA CLARO
  // =====================================

  static final CardThemeData claro =
      CardThemeData(

    color: Colors.white,

    elevation: 2,

    margin:
        const EdgeInsets.all(10),

    shape: RoundedRectangleBorder(

      borderRadius:
          BorderRadius.circular(16),
    ),
  );

  // =====================================
  // TEMA OSCURO
  // =====================================

  static final CardThemeData oscuro =
      CardThemeData(

    color:
        ColoresApp.superficieOscura,

    elevation: 2,

    margin:
        const EdgeInsets.all(10),

    shape: RoundedRectangleBorder(

      borderRadius:
          BorderRadius.circular(16),
    ),
  );
}