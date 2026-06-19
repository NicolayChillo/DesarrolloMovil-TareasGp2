import 'package:flutter/material.dart';
import '../colores_app.dart';

class BordesApp {

  // BORDE NORMAL
  static Border bordeNormal = Border.all(
    color: ColoresApp.borde,
    width: 1,
  );

  // BORDE PRIMARIO
  static Border bordePrimario = Border.all(
    color: ColoresApp.primario,
    width: 2,
  );

  // BORDER RADIUS PEQUEÑO
  static BorderRadius radioPequeno =
      BorderRadius.circular(10);

  // BORDER RADIUS MEDIANO
  static BorderRadius radioMediano =
      BorderRadius.circular(14);

  // BORDER RADIUS GRANDE
  static BorderRadius radioGrande =
      BorderRadius.circular(20);
}