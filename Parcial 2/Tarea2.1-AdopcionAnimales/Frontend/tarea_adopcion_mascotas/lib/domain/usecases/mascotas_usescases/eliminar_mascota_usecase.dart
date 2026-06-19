// domain/usecases/eliminar_mascota_usecase.dart
import '../../repositories/mascota_repository.dart';

class EliminarMascotaUseCase {
  final MascotaRepository repository;
  
  EliminarMascotaUseCase(this.repository);
  
  Future<void> call(int id) {
    return repository.eliminarMascota(id);
  }
}