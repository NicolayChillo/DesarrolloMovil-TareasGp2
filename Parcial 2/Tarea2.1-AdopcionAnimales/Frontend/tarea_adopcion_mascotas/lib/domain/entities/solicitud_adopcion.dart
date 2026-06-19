
class SolicitudAdopcion {
  final int id;
  final int mascotaId;
  final String? mascotaNombre;
  final String nombreSolicitante;
  final String telefono;
  final DateTime fechaSolicitud;
  final String estado;
  final String? comentario;

  const SolicitudAdopcion({
    required this.id,
    required this.mascotaId,
    this.mascotaNombre,
    required this.nombreSolicitante,
    required this.telefono,
    required this.fechaSolicitud,
    required this.estado,
    this.comentario,
  });
}