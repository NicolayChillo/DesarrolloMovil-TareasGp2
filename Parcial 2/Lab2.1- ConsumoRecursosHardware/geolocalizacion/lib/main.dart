import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controlador/camara_controlador.dart';
import 'vista/camara_vista.dart';
import 'tema/tema_general.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CamaraControlador(),
      child: const GeolocalizacionApp(),
    ),
  );
}

class GeolocalizacionApp extends StatelessWidget {
  const GeolocalizacionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camara Turistica',
      debugShowCheckedModeBanner: false,
      theme: TemaGeneral.temaOscuro,
      home: const CamaraVista(),
    );
  }
}
