// domain/usecases/solicitudes_usecases/obtener_solicitud_por_id_usecase.dart
import '../../entities/solicitud_adopcion.dart';
import '../../repositories/solicitud_repository.dart';

class ObtenerSolicitudPorIdUseCase {
  final SolicitudRepository repository;
  
  ObtenerSolicitudPorIdUseCase(this.repository);
  
  Future<SolicitudAdopcion> call(int id) {
    return repository.obtenerSolicitudPorId(id);
  }
}