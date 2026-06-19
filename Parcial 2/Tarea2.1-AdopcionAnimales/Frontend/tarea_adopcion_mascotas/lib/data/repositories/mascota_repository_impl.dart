// data/repositories/mascota_repository_impl.dart
import 'dart:io';
import '../../domain/entities/mascota.dart';
import '../../domain/repositories/mascota_repository.dart';
import '../datasources/mascota_remote_datasource.dart';

class MascotaRepositoryImpl implements MascotaRepository {
  final MascotaRemoteDataSource remoteDataSource;

  MascotaRepositoryImpl({required this.remoteDataSource});

  // 📋 READ
  @override
  Future<List<Mascota>> obtenerMascotas({String? estado}) {
    return remoteDataSource.obtenerMascotas(estado: estado);
  }

  @override
  Future<Mascota> obtenerMascotaPorId(int id) {
    return remoteDataSource.obtenerMascotaPorId(id);
  }

  // ➕ CREATE
  @override
  Future<Mascota> crearMascota({
    required String nombre,
    required String especie,
    required int edad,
    required String descripcion,
    String? raza,
    String? sexo,
    File? imagen,
  }) {
    return remoteDataSource.crearMascota(
      nombre: nombre,
      especie: especie,
      edad: edad,
      descripcion: descripcion,
      raza: raza,
      sexo: sexo,
      imagen: imagen,
    );
  }

  // ✏️ UPDATE
  @override
  Future<Mascota> actualizarMascota({
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
    return remoteDataSource.actualizarMascota(
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

  // 🗑️ DELETE
  @override
  Future<void> eliminarMascota(int id) {
    return remoteDataSource.eliminarMascota(id);
  }
}