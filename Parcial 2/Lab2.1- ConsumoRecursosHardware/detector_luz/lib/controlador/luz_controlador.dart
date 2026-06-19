import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../modelo/luz_modelo.dart';

class LuzControlador extends ChangeNotifier {
  static const _canal = EventChannel('com.example.detector_luz/light_sensor');

  LuzModelo _modelo = const LuzModelo();
  StreamSubscription? _suscripcion;
  bool _activo = false;
  bool _sensorDisponible = true;
  String? _error;

  LuzModelo get modelo => _modelo;
  bool get activo => _activo;
  bool get sensorDisponible => _sensorDisponible;
  String? get error => _error;

  void iniciar() {
    _activo = true;
    _error = null;
    _suscripcion?.cancel();

    _suscripcion = _canal.receiveBroadcastStream().listen(
      (dynamic valor) {
        _sensorDisponible = true;
        _modelo = _modelo.copyWith(lux: (valor as double));
        notifyListeners();
      },
      onError: (dynamic e) {
        _sensorDisponible = false;
        _error = 'Sensor de luz no disponible en este dispositivo.';
        notifyListeners();
      },
    );

    notifyListeners();
  }

  void detener() {
    _activo = false;
    _suscripcion?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
