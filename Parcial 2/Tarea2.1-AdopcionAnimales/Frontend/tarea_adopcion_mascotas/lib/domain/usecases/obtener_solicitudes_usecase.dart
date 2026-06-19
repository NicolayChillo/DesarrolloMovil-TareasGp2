
import '../entities/solicitud_adopcion.dart';
import '../repositories/solicitud_repository.dart';

class ObtenerSolicitudesUseCase {
  final SolicitudRepository repository;
  ObtenerSolicitudesUseCase(this.repository);

  Future<List<SolicitudAdopcion>> call({int? mascotaId, String? estado}) =>
      repository.obtenerSolicitudes(mascotaId: mascotaId, estado: estado);
}

class AprobarSolicitudUseCase {
  final SolicitudRepository repository;
  AprobarSolicitudUseCase(this.repository);
  Future<void> call(int id) => repository.aprobarSolicitud(id);
}

class RechazarSolicitudUseCase {
  final SolicitudRepository repository;
  RechazarSolicitudUseCase(this.repository);
  Future<void> call(int id) => repository.rechazarSolicitud(id);
}