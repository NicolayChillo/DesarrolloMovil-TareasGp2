import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../modelo/foto_modelo.dart';

class CamaraControlador extends ChangeNotifier {
  final List<FotoModelo> _fotos = [];
  bool _cargando = false;
  String? _error;
  FotoModelo? _fotoSeleccionada;

  List<FotoModelo> get fotos => List.unmodifiable(_fotos);
  bool get cargando => _cargando;
  String? get error => _error;
  FotoModelo? get fotoSeleccionada => _fotoSeleccionada;

  void seleccionarFoto(FotoModelo foto) {
    _fotoSeleccionada = foto;
    notifyListeners();
  }

  void cerrarDetalle() {
    _fotoSeleccionada = null;
    notifyListeners();
  }

  Future<void> tomarFoto() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final picker = ImagePicker();
      final imagen = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (imagen == null) {
        _cargando = false;
        notifyListeners();
        return;
      }

      final posicion = await _obtenerUbicacion();

      final foto = FotoModelo(
        imagenPath: imagen.path,
        latitud: posicion.latitude,
        longitud: posicion.longitude,
        timestamp: DateTime.now(),
      );

      _fotos.insert(0, foto);
      _fotoSeleccionada = foto;
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> seleccionarDeGaleria() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final picker = ImagePicker();
      final imagen = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (imagen == null) {
        _cargando = false;
        notifyListeners();
        return;
      }

      final posicion = await _obtenerUbicacion();

      final foto = FotoModelo(
        imagenPath: imagen.path,
        latitud: posicion.latitude,
        longitud: posicion.longitude,
        timestamp: DateTime.now(),
      );

      _fotos.insert(0, foto);
      _fotoSeleccionada = foto;
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<Position> _obtenerUbicacion() async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      throw Exception('Servicio GPS deshabilitado. Activa el GPS.');
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        throw Exception('Permiso de ubicacion denegado.');
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      throw Exception(
          'Permiso de ubicacion denegado permanentemente. Ve a Configuracion.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  void eliminarFoto(int index) {
    _fotos.removeAt(index);
    _fotoSeleccionada = null;
    notifyListeners();
  }
}
