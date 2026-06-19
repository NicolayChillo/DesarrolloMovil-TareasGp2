// domain/usecases/solicitudes_usecases/rechazar_solicitud_usecase.dart
import '../../repositories/solicitud_repository.dart';

class RechazarSolicitudUseCase {
  final SolicitudRepository repository;
  
  RechazarSolicitudUseCase(this.repository);
  
  Future<void> call(int id) {
    return repository.rechazarSolicitud(id);
  }
}