// domain/usecases/crear_mascota_usecase.dart
import 'dart:io';
import '../../entities/mascota.dart';
import '../../repositories/mascota_repository.dart';

class CrearMascotaUseCase {
  final MascotaRepository repository;
  
  CrearMascotaUseCase(this.repository);
  
  Future<Mascota> call({
    required String nombre,
    required String especie,
    required int edad,
    required String descripcion,
    String? raza,
    String? sexo,
    File? imagen,
  }) {
    return repository.crearMascota(
      nombre: nombre,
      especie: especie,
      edad: edad,
      descripcion: descripcion,
      raza: raza,
      sexo: sexo,
      imagen: imagen,
    );
  }
}