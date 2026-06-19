
import '../entities/solicitud_adopcion.dart';

abstract class SolicitudRepository {
  Future<SolicitudAdopcion> crearSolicitud(SolicitudAdopcion solicitud);
  Future<List<SolicitudAdopcion>> obtenerSolicitudes({int? mascotaId, String? estado});
  Future<void> aprobarSolicitud(int id);
  Future<void> rechazarSolicitud(int id);
}