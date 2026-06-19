// domain/repositories/mascota_repository.dart
import 'dart:io';
import '../entities/mascota.dart';

abstract class MascotaRepository {
  // 📋 READ
  Future<List<Mascota>> obtenerMascotas({String? estado});
  Future<Mascota> obtenerMascotaPorId(int id);
  
  // ➕ CREATE
  Future<Mascota> crearMascota({
    required String nombre,
    required String especie,
    required int edad,
    required String descripcion,
    String? raza,
    String? sexo,
    File? imagen,
  });
  
  // ✏️ UPDATE
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
  });
  
  // 🗑️ DELETE
  Future<void> eliminarMascota(int id);
}