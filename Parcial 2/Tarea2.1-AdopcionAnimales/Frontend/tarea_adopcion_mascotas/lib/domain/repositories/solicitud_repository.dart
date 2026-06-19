// domain/repositories/solicitud_repository.dart
import '../entities/solicitud_adopcion.dart';

abstract class SolicitudRepository {
  // 📋 READ
  Future<List<SolicitudAdopcion>> obtenerSolicitudes({int? mascotaId, String? estado});
  Future<SolicitudAdopcion> obtenerSolicitudPorId(int id);
  
  // ➕ CREATE
  Future<SolicitudAdopcion> crearSolicitud(SolicitudAdopcion solicitud);
  
  // ✏️ UPDATE
  Future<SolicitudAdopcion> actualizarSolicitud({
    required int id,
    String? nombreSolicitante,
    String? telefono,
    String? comentario,
    String? estado,
  });
  
  // 🗑️ DELETE
  Future<void> eliminarSolicitud(int id);
  
  // ✅ ACCIONES
  Future<void> aprobarSolicitud(int id);
  Future<void> rechazarSolicitud(int id);
}