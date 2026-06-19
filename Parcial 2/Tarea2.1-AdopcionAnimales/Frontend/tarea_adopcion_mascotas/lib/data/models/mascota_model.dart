
import '../../domain/entities/mascota.dart';

class MascotaModel extends Mascota {
  const MascotaModel({
    required super.id,
    required super.nombre,
    required super.especie,
    super.raza,
    super.sexo,
    super.edad,
    super.descripcion,
    super.imagenUrl,
    required super.estado,
  });

  factory MascotaModel.fromJson(Map<String, dynamic> json) {
    return MascotaModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      especie: json['especie'] as String,
      raza: json['raza'] as String?,
      sexo: json['sexo'] as String?,
      edad: json['edad'] as int?,
      descripcion: json['descripcion'] as String?,
      imagenUrl: json['imagen_url'] as String?,
      estado: json['estado'] as String,
    );
  }
}