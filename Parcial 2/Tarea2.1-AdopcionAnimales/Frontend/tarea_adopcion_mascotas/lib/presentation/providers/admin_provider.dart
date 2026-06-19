// presentation/providers/admin_provider.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/solicitud_adopcion.dart';
import '../../domain/usecases/solicitudes_usecases/obtener_solicitudes_usecase.dart';
import '../../domain/usecases/solicitudes_usecases/aprobar_solicitud_usecase.dart';
import '../../domain/usecases/solicitudes_usecases/rechazar_solicitud_usecase.dart';

enum EstadoAdmin { inicial, cargando, listo, error }

class AdminProvider extends ChangeNotifier {
  final ObtenerSolicitudesUseCase obtenerSolicitudesUseCase;
  final AprobarSolicitudUseCase aprobarSolicitudUseCase;
  final RechazarSolicitudUseCase rechazarSolicitudUseCase;

  static const String _pinAdmin = '1234';

  AdminProvider({
    required this.obtenerSolicitudesUseCase,
    required this.aprobarSolicitudUseCase,
    required this.rechazarSolicitudUseCase,
  });

  // ============================================================
  // ESTADO
  // ============================================================
  
  EstadoAdmin _estado = EstadoAdmin.inicial;
  List<SolicitudAdopcion> _solicitudes = [];
  String? _errorMessage;
  bool _isAuthenticated = false;

  EstadoAdmin get estado => _estado;
  List<SolicitudAdopcion> get solicitudes => _solicitudes;
  String? get error => _errorMessage;
  bool get cargando => _estado == EstadoAdmin.cargando;
  bool get isAuthenticated => _isAuthenticated;

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
  // 🔐 AUTENTICACIÓN
  // ============================================================
  
  bool validarPin(String pin) {
    if (pin == _pinAdmin) {
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void cerrarSesion() {
    _isAuthenticated = false;
    _solicitudes = [];
    _estado = EstadoAdmin.inicial;
    _errorMessage = null;
    notifyListeners();
  }

  // ============================================================
  // 📋 CARGAR SOLICITUDES
  // ============================================================
  
  Future<void> cargarTodasLasSolicitudes() async {
    if (!_isAuthenticated) return;
    _setLoading();
    try {
      _solicitudes = await obtenerSolicitudesUseCase();
      _setReady();
    } catch (e) {
      _setError('No se pudieron cargar las solicitudes');
    }
  }

  Future<void> cargarPendientes() async {
    if (!_isAuthenticated) return;
    _setLoading();
    try {
      _solicitudes = await obtenerSolicitudesUseCase(estado: 'Pendiente');
      _setReady();
    } catch (e) {
      _setError('No se pudieron cargar las solicitudes pendientes');
    }
  }

  // ============================================================
  // ✅ APROBAR / ❌ RECHAZAR
  // ============================================================
  
  Future<void> aprobar(int id) async {
    if (!_isAuthenticated) return;
    try {
      await aprobarSolicitudUseCase(id);
      await cargarTodasLasSolicitudes();
    } catch (e) {
      _setError('No se pudo aprobar la solicitud');
    }
  }

  Future<void> rechazar(int id) async {
    if (!_isAuthenticated) return;
    try {
      await rechazarSolicitudUseCase(id);
      await cargarTodasLasSolicitudes();
    } catch (e) {
      _setError('No se pudo rechazar la solicitud');
    }
  }

  // ============================================================
  // MÉTODOS PRIVADOS
  // ============================================================
  
  void _setLoading() {
    _estado = EstadoAdmin.cargando;
    _errorMessage = null;
    notifyListeners();
  }

  void _setReady() {
    _estado = EstadoAdmin.listo;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _estado = EstadoAdmin.error;
    _errorMessage = message;
    notifyListeners();
  }
}