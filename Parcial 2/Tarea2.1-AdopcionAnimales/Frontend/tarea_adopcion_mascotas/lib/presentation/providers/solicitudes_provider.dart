// presentation/providers/solicitudes_provider.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/solicitud_adopcion.dart';
import '../../domain/usecases/solicitudes_usecases/obtener_solicitudes_usecase.dart';

enum EstadoSolicitudes { inicial, cargando, listo, error }

class SolicitudesProvider extends ChangeNotifier {
  final ObtenerSolicitudesUseCase obtenerSolicitudesUseCase;

  SolicitudesProvider({required this.obtenerSolicitudesUseCase});

  // ============================================================
  // ESTADO
  // ============================================================
  
  EstadoSolicitudes _estado = EstadoSolicitudes.inicial;
  List<SolicitudAdopcion> _solicitudes = [];
  String? _errorMessage;

  EstadoSolicitudes get estado => _estado;
  List<SolicitudAdopcion> get solicitudes => _solicitudes;
  String? get errorMessage => _errorMessage;
  bool get cargando => _estado == EstadoSolicitudes.cargando;

  // ============================================================
  // FILTROS POR ESTADO
  // ============================================================
  
  List<SolicitudAdopcion> get solicitudesPendientes {
    return _solicitudes.where((s) => s.estado == 'Pendiente').toList();
  }

  List<SolicitudAdopcion> get solicitudesAprobadas {
    return _solicitudes.where((s) => s.estado == 'Aprobada').toList();
  }

  List<SolicitudAdopcion> get solicitudesRechazadas {
    return _solicitudes.where((s) => s.estado == 'Rechazada').toList();
  }

  // ============================================================
  // 📋 CARGAR SOLICITUDES (SIN AUTENTICACIÓN)
  // ============================================================
  
  Future<void> cargarTodasLasSolicitudes() async {
    _setLoading();
    try {
      _solicitudes = await obtenerSolicitudesUseCase();
      _setReady();
      print('✅ Solicitudes cargadas: ${_solicitudes.length}');
    } catch (e) {
      print('❌ Error al cargar solicitudes: $e');
      _setError('No se pudieron cargar las solicitudes: ${e.toString()}');
    }
  }

  Future<void> cargarSolicitudesPorEstado(String estado) async {
    _setLoading();
    try {
      _solicitudes = await obtenerSolicitudesUseCase(estado: estado);
      _setReady();
      print('✅ Solicitudes con estado "$estado" cargadas: ${_solicitudes.length}');
    } catch (e) {
      print('❌ Error al cargar solicitudes: $e');
      _setError('No se pudieron cargar las solicitudes');
    }
  }

  // ============================================================
  // MÉTODOS PRIVADOS
  // ============================================================
  
  void _setLoading() {
    _estado = EstadoSolicitudes.cargando;
    _errorMessage = null;
    notifyListeners();
  }

  void _setReady() {
    _estado = EstadoSolicitudes.listo;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _estado = EstadoSolicitudes.error;
    _errorMessage = message;
    notifyListeners();
  }

  // ============================================================
  // MÉTODOS DE UTILIDAD
  // ============================================================
  
  void reset() {
    _estado = EstadoSolicitudes.inicial;
    _solicitudes = [];
    _errorMessage = null;
    notifyListeners();
  }
}