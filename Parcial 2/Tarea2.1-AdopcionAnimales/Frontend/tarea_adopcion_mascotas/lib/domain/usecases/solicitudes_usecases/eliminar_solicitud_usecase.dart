// domain/usecases/solicitudes_usecases/eliminar_solicitud_usecase.dart
import '../../repositories/solicitud_repository.dart';

class EliminarSolicitudUseCase {
  final SolicitudRepository repository;
  
  EliminarSolicitudUseCase(this.repository);
  
  Future<void> call(int id) {
    return repository.eliminarSolicitud(id);
  }
}