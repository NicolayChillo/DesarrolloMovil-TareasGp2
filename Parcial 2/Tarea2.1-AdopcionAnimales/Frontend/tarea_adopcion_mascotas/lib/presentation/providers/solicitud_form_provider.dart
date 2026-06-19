// presentation/providers/solicitud_form_provider.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/mascota.dart';
import '../../domain/usecases/solicitudes_usecases/crear_solicitud_usecase.dart';

enum EstadoEnvio { inicial, enviando, exito, error }

class SolicitudFormProvider extends ChangeNotifier {
  final CrearSolicitudUseCase crearSolicitudUseCase;
  
  SolicitudFormProvider({required this.crearSolicitudUseCase});

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
      print('📤 Enviando solicitud...');
      print('📝 Mascota: ${mascota.nombre} (ID: ${mascota.id})');
      print('📝 Solicitante: $nombre');
      print('📝 Teléfono: $telefono');
      print('📝 Comentario: $comentario');
      
      final result = await crearSolicitudUseCase(
        mascota: mascota,
        nombreSolicitante: nombre,
        telefono: telefono,
        comentario: comentario,
      );
      
      print('✅ Solicitud creada: ${result.id}');
      _estado = EstadoEnvio.exito;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error: $e');
      _errorMessage = 'No se pudo enviar la solicitud: ${e.toString()}';
      _estado = EstadoEnvio.error;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _estado = EstadoEnvio.inicial;
    _errorMessage = null;
    notifyListeners();
  }
}