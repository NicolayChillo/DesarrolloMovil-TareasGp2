import 'package:flutter/material.dart';

class SombrasApp {

  // SOMBRA SUAVE
  static List<BoxShadow> sombraSuave = [

    BoxShadow(
      color: Colors.black12,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  // SOMBRA MEDIA
  static List<BoxShadow> sombraMedia = [

    BoxShadow(
      color: Colors.black26,
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];
}