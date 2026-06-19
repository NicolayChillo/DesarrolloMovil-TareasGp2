import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controlador/pasos_controlador.dart';
import 'vista/pasos_vista.dart';
import 'tema/tema_general.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PasosControlador(),
      child: const ContadorPasosApp(),
    ),
  );
}

class ContadorPasosApp extends StatelessWidget {
  const ContadorPasosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador de Pasos',
      debugShowCheckedModeBanner: false,
      theme: TemaGeneral.temaOscuro,
      home: const PasosVista(),
    );
  }
}
