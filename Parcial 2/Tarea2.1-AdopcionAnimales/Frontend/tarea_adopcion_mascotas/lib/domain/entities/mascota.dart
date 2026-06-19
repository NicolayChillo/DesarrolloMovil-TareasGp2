// domain/entities/mascota.dart
class Mascota {
  final int id;
  final String nombre;
  final String especie;
  final String? raza;
  final String? sexo;
  final int? edad;
  final String? descripcion;
  final String? imagenUrl;
  final String estado;

  const Mascota({
    required this.id,
    required this.nombre,
    required this.especie,
    this.raza,
    this.sexo,
    this.edad,
    this.descripcion,
    this.imagenUrl,
    required this.estado,
  });

  bool get estaDisponible => estado == 'Disponible';
}