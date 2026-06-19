import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controlador/acelerometro_controlador.dart';
import 'vista/nivel_vista.dart';
import 'tema/tema_general.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AcelerometroControlador(),
      child: const AcelerometroApp(),
    ),
  );
}

class AcelerometroApp extends StatelessWidget {
  const AcelerometroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nivelador Digital',
      debugShowCheckedModeBanner: false,
      theme: TemaGeneral.temaOscuro,
      home: const NivelVista(),
    );
  }
}
