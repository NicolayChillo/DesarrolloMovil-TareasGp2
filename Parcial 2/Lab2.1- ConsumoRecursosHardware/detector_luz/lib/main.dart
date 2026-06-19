import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controlador/luz_controlador.dart';
import 'vista/luz_vista.dart';
import 'tema/tema_general.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LuzControlador(),
      child: const DetectorLuzApp(),
    ),
  );
}

class DetectorLuzApp extends StatelessWidget {
  const DetectorLuzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detector de Luz',
      debugShowCheckedModeBanner: false,
      theme: TemaGeneral.temaOscuro,
      home: const LuzVista(),
    );
  }
}
