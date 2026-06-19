// domain/usecases/actualizar_mascota_usecase.dart
import 'dart:io';
import '../../entities/mascota.dart';
import '../../repositories/mascota_repository.dart';

class ActualizarMascotaUseCase {
  final MascotaRepository repository;
  
  ActualizarMascotaUseCase(this.repository);
  
  Future<Mascota> call({
    required int id,
    String? nombre,
    String? especie,
    String? raza,
    String? sexo,
    int? edad,
    String? descripcion,
    String? estado,
    File? imagen,
  }) {
    return repository.actualizarMascota(
      id: id,
      nombre: nombre,
      especie: especie,
      raza: raza,
      sexo: sexo,
      edad: edad,
      descripcion: descripcion,
      estado: estado,
      imagen: imagen,
    );
  }
}