import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modelo/acelerometro_modelo.dart';

class AcelerometroControlador extends ChangeNotifier {
  AcelerometroModelo _modelo = const AcelerometroModelo();
  StreamSubscription<AccelerometerEvent>? _suscripcion;

  bool _youtubeEnCooldown = false;
  bool _chromeEnCooldown = false;
  bool _wordEnCooldown = false;

  String? _ultimaAccion;

  AcelerometroModelo get modelo => _modelo;
  String? get ultimaAccion => _ultimaAccion;

  void iniciar() {
    _suscripcion =
        accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval)
            .listen((AccelerometerEvent event) {
      _modelo = _modelo.copyWith(x: event.x, y: event.y, z: event.z);
      notifyListeners();
      _verificarUmbrales(event);
    });
  }

  void _verificarUmbrales(AccelerometerEvent event) {
    // Eje X: YouTube (inclinación derecha/izquierda fuerte)
    if (event.x.abs() > 8.5 && !_youtubeEnCooldown) {
      _youtubeEnCooldown = true;
      _ultimaAccion = 'Abriendo YouTube...';
      notifyListeners();
      _abrirUrl('https://www.youtube.com');
      Future.delayed(const Duration(seconds: 4), () {
        _youtubeEnCooldown = false;
      });
    }

    // Eje Y: Google Chrome (inclinación adelante/atrás fuerte)
    if (event.y.abs() > 8.5 && !_chromeEnCooldown) {
      _chromeEnCooldown = true;
      _ultimaAccion = 'Abriendo Chrome...';
      notifyListeners();
      _abrirUrl('https://www.google.com');
      Future.delayed(const Duration(seconds: 4), () {
        _chromeEnCooldown = false;
      });
    }

    // Eje Z: Word/Office (sacudida vertical fuerte)
    if (event.z.abs() > 14.0 && !_wordEnCooldown) {
      _wordEnCooldown = true;
      _ultimaAccion = 'Abriendo Word Online...';
      notifyListeners();
      _abrirUrl('https://www.office.com/launch/word');
      Future.delayed(const Duration(seconds: 4), () {
        _wordEnCooldown = false;
      });
    }
  }

  Future<void> _abrirUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
