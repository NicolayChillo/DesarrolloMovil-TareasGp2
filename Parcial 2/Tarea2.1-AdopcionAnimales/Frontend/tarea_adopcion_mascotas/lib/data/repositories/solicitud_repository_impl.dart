// data/repositories/solicitud_repository_impl.dart
import '../../domain/entities/solicitud_adopcion.dart';
import '../../domain/repositories/solicitud_repository.dart';
import '../datasources/solicitud_remote_datasource.dart';
import '../models/solicitud_adopcion_model.dart';

class SolicitudRepositoryImpl implements SolicitudRepository {
  final SolicitudRemoteDataSource remoteDataSource;
  SolicitudRepositoryImpl({required this.remoteDataSource});

  // ============================================================
  // 📋 READ
  // ============================================================
  
  @override
  Future<List<SolicitudAdopcion>> obtenerSolicitudes({int? mascotaId, String? estado}) {
    return remoteDataSource.obtenerSolicitudes(mascotaId: mascotaId, estado: estado);
  }

  @override
  Future<SolicitudAdopcion> obtenerSolicitudPorId(int id) {
    return remoteDataSource.obtenerSolicitudPorId(id);
  }

  // ============================================================
  // ➕ CREATE
  // ============================================================
  
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

  // ============================================================
  // ✏️ UPDATE
  // ============================================================
  
  @override
  Future<SolicitudAdopcion> actualizarSolicitud({
    required int id,
    String? nombreSolicitante,
    String? telefono,
    String? comentario,
    String? estado,
  }) {
    return remoteDataSource.actualizarSolicitud(
      id: id,
      nombreSolicitante: nombreSolicitante,
      telefono: telefono,
      comentario: comentario,
      estado: estado,
    );
  }

  // ============================================================
  // 🗑️ DELETE
  // ============================================================
  
  @override
  Future<void> eliminarSolicitud(int id) {
    return remoteDataSource.eliminarSolicitud(id);
  }

  // ============================================================
  // ✅ ACCIONES
  // ============================================================
  
  @override
  Future<void> aprobarSolicitud(int id) {
    return remoteDataSource.aprobarSolicitud(id);
  }

  @override
  Future<void> rechazarSolicitud(int id) {
    return remoteDataSource.rechazarSolicitud(id);
  }
}