// domain/usecases/solicitudes_usecases/actualizar_solicitud_usecase.dart
import '../../entities/solicitud_adopcion.dart';
import '../../repositories/solicitud_repository.dart';

class ActualizarSolicitudUseCase {
  final SolicitudRepository repository;
  
  ActualizarSolicitudUseCase(this.repository);
  
  Future<SolicitudAdopcion> call({
    required int id,
    String? nombreSolicitante,
    String? telefono,
    String? comentario,
    String? estado,
  }) {
    return repository.actualizarSolicitud(
      id: id,
      nombreSolicitante: nombreSolicitante,
      telefono: telefono,
      comentario: comentario,
      estado: estado,
    );
  }
}