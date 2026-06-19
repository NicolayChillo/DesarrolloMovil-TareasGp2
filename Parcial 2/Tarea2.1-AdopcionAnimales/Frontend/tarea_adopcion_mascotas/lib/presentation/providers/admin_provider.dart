
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/solicitud_adopcion.dart';
import '../../domain/usecases/obtener_solicitudes_usecase.dart';

class AdminProvider extends ChangeNotifier {
  final ObtenerSolicitudesUseCase obtenerSolicitudesUseCase;
  final AprobarSolicitudUseCase aprobarSolicitudUseCase;
  final RechazarSolicitudUseCase rechazarSolicitudUseCase;

  AdminProvider({
    required this.obtenerSolicitudesUseCase,
    required this.aprobarSolicitudUseCase,
    required this.rechazarSolicitudUseCase,
  });

  bool _autenticado = false;
  bool get autenticado => _autenticado;

  bool validarPin(String pin) {
    _autenticado = pin == AppConstants.adminPin;
    notifyListeners();
    return _autenticado;
  }

  void cerrarSesion() {
    _autenticado = false;
    notifyListeners();
  }

  List<SolicitudAdopcion> _solicitudes = [];
  bool _cargando = false;
  String? _error;

  List<SolicitudAdopcion> get solicitudes => _solicitudes;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargarPendientes() async {
    _cargando = true;
    notifyListeners();
    try {
      _solicitudes = await obtenerSolicitudesUseCase(estado: 'Pendiente');
      _error = null;
    } catch (_) {
      _error = 'No se pudieron cargar las solicitudes.';
    }
    _cargando = false;
    notifyListeners();
  }

  Future<bool> aprobar(int id) async {
    try {
      await aprobarSolicitudUseCase(id);
      await cargarPendientes();
      return true;
    } catch (_) {
      _error = 'No se pudo aprobar la solicitud.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> rechazar(int id) async {
    try {
      await rechazarSolicitudUseCase(id);
      await cargarPendientes();
      return true;
    } catch (_) {
      _error = 'No se pudo rechazar la solicitud.';
      notifyListeners();
      return false;
    }
  }
}