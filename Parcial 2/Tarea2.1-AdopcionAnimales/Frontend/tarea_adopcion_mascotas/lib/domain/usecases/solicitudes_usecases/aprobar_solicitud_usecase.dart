// domain/usecases/solicitudes_usecases/aprobar_solicitud_usecase.dart
import '../../repositories/solicitud_repository.dart';

class AprobarSolicitudUseCase {
  final SolicitudRepository repository;
  
  AprobarSolicitudUseCase(this.repository);
  
  Future<void> call(int id) {
    return repository.aprobarSolicitud(id);
  }
}
