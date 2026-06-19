// domain/usecases/solicitudes_usecases/crear_solicitud_usecase.dart
import '../../entities/mascota.dart';
import '../../entities/solicitud_adopcion.dart';
import '../../repositories/solicitud_repository.dart';

class CrearSolicitudUseCase {
  final SolicitudRepository repository;
  
  CrearSolicitudUseCase(this.repository);
  
  Future<SolicitudAdopcion> call({
    required Mascota mascota,
    required String nombreSolicitante,
    required String telefono,
    String? comentario,
  }) {
    final solicitud = SolicitudAdopcion(
      id: 0,
      mascotaId: mascota.id,
      mascotaNombre: mascota.nombre,
      nombreSolicitante: nombreSolicitante,
      telefono: telefono,
      fechaSolicitud: DateTime.now(),
      estado: 'Pendiente',
      comentario: comentario,
    );
    
    return repository.crearSolicitud(solicitud);
  }
}