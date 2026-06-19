import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../modelo/paso_modelo.dart';

class PasosControlador extends ChangeNotifier {
  PasoModelo _modelo = const PasoModelo();
  StreamSubscription<UserAccelerometerEvent>? _suscripcion;

  // userAccelerometer excluye la gravedad → magnitud ≈ 0 en reposo
  // Un paso normal produce un pico de 1.5–4 m/s²
  static const double _umbralAlto = 0.5;  // sube a esto → detecta paso
  static const double _umbralBajo = 0.2;  // baja a esto → listo para el siguiente
  static const int _minMsBetweenSteps = 300; // máximo ~3 pasos/seg

  static const double _pasoLongitudM = 0.762;
  static const double _caloriasXPaso = 0.04;

  bool _enPico = false;
  DateTime? _ultimoPaso;
  bool _activo = false;

  PasoModelo get modelo => _modelo;
  bool get activo => _activo;

  void iniciar() {
    _activo = true;
    _enPico = false;
    _suscripcion = userAccelerometerEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen((UserAccelerometerEvent event) {
      final magnitud =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      if (!_enPico && magnitud >= _umbralAlto) {
        // Subió al pico → posible paso
        _enPico = true;
        final ahora = DateTime.now();
        if (_ultimoPaso == null ||
            ahora.difference(_ultimoPaso!).inMilliseconds >= _minMsBetweenSteps) {
          _ultimoPaso = ahora;
          _contarPaso();
        }
      } else if (_enPico && magnitud < _umbralBajo) {
        // Bajó del pico → listo para detectar el siguiente
        _enPico = false;
      }
    });
    notifyListeners();
  }

  void pausar() {
    _activo = false;
    _suscripcion?.cancel();
    notifyListeners();
  }

  void reiniciar() {
    _suscripcion?.cancel();
    _activo = false;

    if (_modelo.pasos > 0) {
      final fecha = DateTime.now();
      final registro = RegistroDiario(
        fecha:
            '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}',
        pasos: _modelo.pasos,
        calorias: _modelo.calorias,
        distanciaKm: _modelo.distanciaKm,
      );
      final nuevoHistorial = [registro, ..._modelo.historial];
      _modelo = PasoModelo(historial: nuevoHistorial);
    } else {
      _modelo = PasoModelo(historial: _modelo.historial);
    }
    notifyListeners();
  }

  void _contarPaso() {
    final nuevosPasos = _modelo.pasos + 1;
    _modelo = _modelo.copyWith(
      pasos: nuevosPasos,
      calorias: double.parse((nuevosPasos * _caloriasXPaso).toStringAsFixed(1)),
      distanciaKm: double.parse(
          ((nuevosPasos * _pasoLongitudM) / 1000).toStringAsFixed(3)),
    );
    notifyListeners();
  }

  double get progresoMetaDiaria {
    const meta = 10000;
    return (_modelo.pasos / meta).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
