
import '../../domain/entities/solicitud_adopcion.dart';

class SolicitudAdopcionModel extends SolicitudAdopcion {
  const SolicitudAdopcionModel({
    required super.id,
    required super.mascotaId,
    super.mascotaNombre,
    required super.nombreSolicitante,
    required super.telefono,
    required super.fechaSolicitud,
    required super.estado,
    super.comentario,
  });

  factory SolicitudAdopcionModel.fromJson(Map<String, dynamic> json) {
    final mascotaJson = json['mascota'];
    return SolicitudAdopcionModel(
      id: json['id'] as int,
      mascotaId: json['mascota_id'] as int,
      mascotaNombre: (mascotaJson is Map) ? mascotaJson['nombre'] as String? : null,
      nombreSolicitante: json['nombre_solicitante'] as String,
      telefono: json['telefono'] as String,
      fechaSolicitud: DateTime.parse(json['fecha_solicitud'] as String),
      estado: json['estado'] as String,
      comentario: json['comentario'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'mascota_id': mascotaId,
    'nombre_solicitante': nombreSolicitante,
    'telefono': telefono,
    'comentario': comentario,
  };
}