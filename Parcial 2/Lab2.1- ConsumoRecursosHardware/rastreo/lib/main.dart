import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controlador/emergencia_controlador.dart';
import 'vista/emergencia_vista.dart';
import 'tema/tema_general.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => EmergenciaControlador(),
      child: const RastreoApp(),
    ),
  );
}

class RastreoApp extends StatelessWidget {
  const RastreoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Emergencia',
      debugShowCheckedModeBanner: false,
      theme: TemaGeneral.temaOscuro,
      home: const EmergenciaVista(),
    );
  }
}
