// presentation/providers/solicitud_form_provider.dart
import 'package:flutter/foundation.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/mascota.dart';
import '../../domain/usecases/crear_solicitud_usecase.dart';

enum EstadoEnvio { inicial, enviando, exito, error }

class SolicitudFormProvider extends ChangeNotifier {
  final CrearSolicitudUseCase crearSolicitudUseCase;
  SolicitudFormProvider(this.crearSolicitudUseCase);

  EstadoEnvio _estado = EstadoEnvio.inicial;
  String? _errorMessage;

  EstadoEnvio get estado => _estado;
  String? get errorMessage => _errorMessage;

  Future<bool> enviarSolicitud({
    required Mascota mascota,
    required String nombre,
    required String telefono,
    String? comentario,
  }) async {
    _estado = EstadoEnvio.enviando;
    _errorMessage = null;
    notifyListeners();

    try {
      await crearSolicitudUseCase(
        mascota: mascota,
        nombreSolicitante: nombre,
        telefono: telefono,
        comentario: comentario,
      );
      _estado = EstadoEnvio.exito;
      notifyListeners();
      return true;
    } on SolicitudInvalidaException catch (e) {
      _errorMessage = e.message; // mensaje específico de la regla violada
    } catch (_) {
      _errorMessage = 'No se pudo enviar la solicitud. Intenta de nuevo.';
    }
    _estado = EstadoEnvio.error;
    notifyListeners();
    return false;
  }

  void reset() {
    _estado = EstadoEnvio.inicial;
    _errorMessage = null;
    notifyListeners();
  }
}