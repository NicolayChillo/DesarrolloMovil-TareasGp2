import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controlador/turismo_controlador.dart';
import 'vista/turismo_vista.dart';
import 'tema/tema_general.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TurismoControlador(),
      child: const TurismoApp(),
    ),
  );
}

class TurismoApp extends StatelessWidget {
  const TurismoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turismo Ecuador',
      debugShowCheckedModeBanner: false,
      theme: TemaGeneral.temaOscuro,
      home: const TurismoVista(),
    );
  }
}
