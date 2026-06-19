import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../modelo/lugar_modelo.dart';

class TurismoControlador extends ChangeNotifier {
  Position? _ubicacionActual;
  double? _brujula;
  bool _cargando = false;
  String? _error;
  int _paginaActual = 0;
  StreamSubscription<CompassEvent>? _brujulaSub;

  final List<LugarModelo> _lugares = [
    LugarModelo(
        nombre: 'Mitad del Mundo',
        descripcion: 'Monumento en el Ecuador Geografico',
        latitud: -0.0023,
        longitud: -78.4556,
        categoria: 'Historico',
        emoji: '🌐'),
    LugarModelo(
        nombre: 'Parque La Carolina',
        descripcion: 'El parque mas grande de Quito',
        latitud: -0.1785,
        longitud: -78.4852,
        categoria: 'Parque',
        emoji: '🌳'),
    LugarModelo(
        nombre: 'Teleferico de Quito',
        descripcion: 'Vista panoramica de la ciudad a 4100m',
        latitud: -0.2111,
        longitud: -78.5161,
        categoria: 'Turistico',
        emoji: '🚡'),
    LugarModelo(
        nombre: 'Mercado La Mariscal',
        descripcion: 'Artesanias y cultura ecuatoriana',
        latitud: -0.2111,
        longitud: -78.4897,
        categoria: 'Compras',
        emoji: '🛍️'),
    LugarModelo(
        nombre: 'Basilica del Voto Nacional',
        descripcion: 'Iglesia neogotica mas grande de America',
        latitud: -0.2202,
        longitud: -78.5046,
        categoria: 'Religioso',
        emoji: '⛪'),
    LugarModelo(
        nombre: 'Plaza de la Independencia',
        descripcion: 'Corazon historico de Quito',
        latitud: -0.2205,
        longitud: -78.5124,
        categoria: 'Historico',
        emoji: '🏛️'),
  ];

  Position? get ubicacionActual => _ubicacionActual;
  double? get brujula => _brujula;
  bool get cargando => _cargando;
  String? get error => _error;
  int get paginaActual => _paginaActual;
  List<LugarModelo> get lugares => _lugares;

  String get direccionBrujula {
    if (_brujula == null) return 'N/A';
    final grados = _brujula! < 0 ? _brujula! + 360 : _brujula!;
    if (grados < 22.5 || grados >= 337.5) return 'Norte';
    if (grados < 67.5) return 'Noreste';
    if (grados < 112.5) return 'Este';
    if (grados < 157.5) return 'Sureste';
    if (grados < 202.5) return 'Sur';
    if (grados < 247.5) return 'Suroeste';
    if (grados < 292.5) return 'Oeste';
    return 'Noroeste';
  }

  void cambiarPagina(int pagina) {
    _paginaActual = pagina;
    notifyListeners();
  }

  Future<void> iniciar() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _ubicacionActual = await _obtenerUbicacion();
      _calcularDistancias();

      _brujulaSub = FlutterCompass.events?.listen((CompassEvent event) {
        _brujula = event.heading;
        notifyListeners();
      });
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<Position> _obtenerUbicacion() async {
    bool habilitado = await Geolocator.isLocationServiceEnabled();
    if (!habilitado) throw Exception('GPS deshabilitado');

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        throw Exception('Permiso de ubicacion denegado');
      }
    }

    return Geolocator.getCurrentPosition(
      locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  void _calcularDistancias() {
    if (_ubicacionActual == null) return;

    for (final lugar in _lugares) {
      lugar.distanciaKm = _haversine(
        _ubicacionActual!.latitude,
        _ubicacionActual!.longitude,
        lugar.latitud,
        lugar.longitud,
      );
    }
    _lugares.sort((a, b) => (a.distanciaKm ?? 0).compareTo(b.distanciaKm ?? 0));
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(lat1)) * cos(_rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _rad(double grados) => grados * pi / 180;

  @override
  void dispose() {
    _brujulaSub?.cancel();
    super.dispose();
  }
}
