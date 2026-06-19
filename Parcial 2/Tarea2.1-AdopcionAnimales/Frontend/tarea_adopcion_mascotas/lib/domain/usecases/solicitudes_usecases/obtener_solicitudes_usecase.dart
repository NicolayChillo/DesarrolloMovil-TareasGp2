// domain/usecases/solicitudes_usecases/obtener_solicitudes_usecase.dart
import '../../entities/solicitud_adopcion.dart';
import '../../repositories/solicitud_repository.dart';

class ObtenerSolicitudesUseCase {
  final SolicitudRepository repository;
  
  ObtenerSolicitudesUseCase(this.repository);
  
  Future<List<SolicitudAdopcion>> call({int? mascotaId, String? estado}) {
    return repository.obtenerSolicitudes(mascotaId: mascotaId, estado: estado);
  }
}