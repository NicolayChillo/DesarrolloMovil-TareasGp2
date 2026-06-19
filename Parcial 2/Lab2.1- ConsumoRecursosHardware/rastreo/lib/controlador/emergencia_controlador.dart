import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modelo/emergencia_modelo.dart';

class EmergenciaControlador extends ChangeNotifier {
  EmergenciaModelo _modelo = const EmergenciaModelo();
  bool _cargando = false;
  bool _sosActivado = false;
  String? _error;

  EmergenciaModelo get modelo => _modelo;
  bool get cargando => _cargando;
  bool get sosActivado => _sosActivado;
  String? get error => _error;

  Future<void> obtenerUbicacion() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final pos = await _pedirUbicacion();
      _modelo = _modelo.copyWith(
        latitud: pos.latitude,
        longitud: pos.longitude,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> tomarFoto() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final imagen = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (imagen != null) {
        _modelo = _modelo.copyWith(imagenPath: imagen.path);
      }
    } catch (e) {
      _error = 'Error al tomar foto: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> activarSOS() async {
    _sosActivado = true;
    _error = null;
    notifyListeners();

    try {
      // Obtener ubicación si aún no se tiene
      if (!_modelo.tieneUbicacion) {
        final pos = await _pedirUbicacion();
        _modelo = _modelo.copyWith(
          latitud: pos.latitude,
          longitud: pos.longitude,
          timestamp: DateTime.now(),
        );
        notifyListeners();
      }

      // Abrir ubicación en Maps
      if (_modelo.tieneUbicacion) {
        await abrirEnMaps();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      _sosActivado = false;
      notifyListeners();
    }
  }

  Future<void> abrirEnMaps() async {
    if (!_modelo.tieneUbicacion) return;
    final uri = Uri.parse(_modelo.urlMaps);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<Position> _pedirUbicacion() async {
    bool habilitado = await Geolocator.isLocationServiceEnabled();
    if (!habilitado) throw Exception('GPS deshabilitado. Actívalo en ajustes.');

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        throw Exception('Permiso de ubicación denegado.');
      }
    }
    if (permiso == LocationPermission.deniedForever) {
      throw Exception('Permiso de ubicación denegado permanentemente.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
