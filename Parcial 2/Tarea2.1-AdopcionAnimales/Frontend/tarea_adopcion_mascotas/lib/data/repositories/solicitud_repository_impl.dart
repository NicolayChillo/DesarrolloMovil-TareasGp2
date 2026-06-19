
import '../../domain/entities/solicitud_adopcion.dart';
import '../../domain/repositories/solicitud_repository.dart';
import '../datasources/solicitud_remote_datasource.dart';
import '../models/solicitud_adopcion_model.dart';

class SolicitudRepositoryImpl implements SolicitudRepository {
  final SolicitudRemoteDataSource remoteDataSource;
  SolicitudRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SolicitudAdopcion> crearSolicitud(SolicitudAdopcion solicitud) {
    final model = SolicitudAdopcionModel(
      id: 0,
      mascotaId: solicitud.mascotaId,
      nombreSolicitante: solicitud.nombreSolicitante,
      telefono: solicitud.telefono,
      fechaSolicitud: DateTime.now(),
      estado: 'Pendiente',
      comentario: solicitud.comentario,
    );
    return remoteDataSource.crearSolicitud(model);
  }

  @override
  Future<List<SolicitudAdopcion>> obtenerSolicitudes({int? mascotaId, String? estado}) =>
      remoteDataSource.obtenerSolicitudes(mascotaId: mascotaId, estado: estado);

  @override
  Future<void> aprobarSolicitud(int id) => remoteDataSource.aprobarSolicitud(id);

  @override
  Future<void> rechazarSolicitud(int id) => remoteDataSource.rechazarSolicitud(id);
}